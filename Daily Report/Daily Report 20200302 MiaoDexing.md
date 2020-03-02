# Kubernetes 集群部署之gitlab-runner安装与注册
- 其实部署到 k8s 上包含两种，一个是把 Gitlab 部署上去，另一个是把 CI 这部分部署上去（也就是 Gitlab Runner）。
其实 Gitlab 本身就是一个服务，部署在哪里都可以，可以选择 Docker 部署，也可以找一台服务器单独部署，作为代码仓库。
最关键的其实是后者，CI/CD 的流程复杂且消耗资源多，部署在集群上就能自动调度，达到资源利用最大化。
那么下面着重讲 Gitlab Runner 的 k8s 部署，想了解前者的可以看官方文档，通过 helm 安装。<br>
[GitLab cloud native Helm Chart](https://docs.gitlab.com/charts/)

- 假设 Gitlab 都已经部署成功了，那么下面开始安装 Gitlab Runner。具体的就是把 Runner 安装到某个节点的 pod 的上，
在处理具体的 CI 任务时，Runner 会启动新的 pod 来执行任务，由 k8s 进行节点间的调度。
一般来说，我们会使用 Helm 来进行安装，Helm 是类似 CentOS 里的 yum，是一种软件管理工具，
可以帮我们快速安装软件到 k8s 上。我们需要在其中一个主节点上安装好 Helm 的 client 和 server。具体可参考：

    [Helm User Guide - Helm 用户指南](https://whmzsu.github.io/helm-doc-zh-cn/quickstart/install-zh_cn.html)
    
    [Kubernetes Helm 初体验](https://zhuanlan.zhihu.com/p/33813367)
 
- 显示如下，证明安装成功。
```
# helm version
Client: &version.Version{SemVer:"v2.16.3", GitCommit:"1ee0254c86d4ed6887327dabed7aa7da29d7eb0d", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.16.3", GitCommit:"1ee0254c86d4ed6887327dabed7aa7da29d7eb0d", GitTreeState:"clean"}
```
添加 gitlab 源并更新。

```
[root@master ~]# helm repo add gitlab https://charts.gitlab.io
[root@master ~]# helm repo update
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "gitlab" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete.
[root@master ~]# helm search gitlab-runner
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
gitlab/gitlab-runner	0.14.0       	12.8.0     	GitLab Runner
```

这里看到有两个版本，一个是 chart version 一个是 app version。 chart 是 helm 中描述相关的一组 Kubernetes 资源的文件集合，里面包含了一个 value.yaml 配置文件和一系列模板（deployment.yaml、svc.yaml 等），而具体的 app 是通过需要单独去 Docker Hub 上拉取的。这两个字段分别就是描述了这两个版本号。

安装前先创建一个 gitlab 的 namespace，并为其配置相应的权限。
```
[root@master ~]# kubectl create namespace gitlab-runners
```
创建一个 rbac-runner-config.yaml

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab
  namespace: gitlab-runners
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: gitlab-runners
  name: gitlab
rules:
- apiGroups: [""] #"" indicates the core API group
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["*"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: gitlab
  namespace: gitlab-runners
subjects:
- kind: ServiceAccount
  name: gitlab # Name is case sensitive
  apiGroup: ""
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: gitlab # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io

```
然后执行以下。

```
[root@master ~]# kubectl create -f rbac-runner-config.yaml
```
接下来配置 runner 的注册信息。上一篇博客中，我们是先安装 gitlab runner 然后进入容器执行 gitlab-runner register 来进行注册的。在 k8s 可支持这么操作，但是同时 helm 也提供了一个配置文件可以在安装 runner 的时候为其注册一个默认的 runner。我们可以去 gitlab-runner 的项目源码 中获取到 values.yaml 这个配置文件。配置文件比较长，可以根据需要自己去配置，下面就贴下本文中需要配置的地方。

```
## 拉取策略， 先取本地镜像
imagePullPolicy: IfNotPresent

## 配置 gitlab 的 url 和注册令牌
## 可以在 gitlab 项目中设置 --CI/CD--Runner-- 手动设置 specific Runner 中查询
gitlabUrl: http://192.168.1.108:98/
runnerRegistrationToken: "qzxposxDstNnq5MMnPf"

## 和之前配置的 rbac name 对应
rbac:
  serviceAccountName: gitlab

## 指定关联 runner 的标签
tags: "maven,docker,k8s"

privileged: true

serviceAccountName: gitlab
```
然后通过 helm install 安装 runner 就可以了。


```
[root@master ~]# helm install --name gitlab-runner gitlab/gitlab-runner -f values.yaml --namespace gitlab-runners
NAME:   gitlab-runner
LAST DEPLOYED: Mon Mar  2 17:37:30 2020
NAMESPACE: gitlab-runners
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                         AGE
gitlab-runner-gitlab-runner  0s

==> v1/Deployment
NAME                         AGE
gitlab-runner-gitlab-runner  0s

==> v1/Pod(related)
NAME                                         AGE
gitlab-runner-gitlab-runner-7bfdb57f6-hrnb5  0s

==> v1/Secret
NAME                         AGE
gitlab-runner-gitlab-runner  0s


NOTES:

Your GitLab Runner should now be registered against the GitLab instance reachable at: "http://192.168.1.108:98/"

```
等待一段时间后就可以在 k8s 的 dashboard 上看到启动成功的 runner 的 pod 了。
