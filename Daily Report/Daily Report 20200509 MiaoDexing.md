# Kubernetes：如何解决从k8s.gcr.io拉取镜像失败问题
## 简介

新版本的Kubernetes在安装部署中，需要从k8s.grc.io仓库中拉取所需镜像文件，但由于国内网络防火墙问题导致无法正常拉取，本文将介绍如何绕过此问题，来完成业务的部署。
## 问题描述
使用Kubernetes V1.11.1版本部署集群业务，在进行kubeadm init时，需要从k8s.grc.io仓库拉取镜像：
```
[preflight/images] You can also perform this action in beforehand using 'kubeadm config images pull'
[preflight] Some fatal errors occurred:
	[ERROR ImagePull]: failed to pull image [k8s.gcr.io/kube-controller-manager-amd64:v1.11.1]: exit status 1
	[ERROR ImagePull]: failed to pull image [k8s.gcr.io/kube-scheduler-amd64:v1.11.1]: exit status 1
	[ERROR ImagePull]: failed to pull image [k8s.gcr.io/kube-proxy-amd64:v1.11.1]: exit status 1
	[ERROR ImagePull]: failed to pull image [k8s.gcr.io/pause:3.1]: exit status 1
	[ERROR ImagePull]: failed to pull image [k8s.gcr.io/etcd-amd64:3.2.18]: exit status 1
	[ERROR ImagePull]: failed to pull image [k8s.gcr.io/coredns:1.1.3]: exit status 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`

```
## 解决方案
docker.io仓库对google的容器做了镜像，可以通过下列命令下拉取相关镜像：
```
docker pull mirrorgooglecontainers/kube-apiserver-amd64:v1.11.1
docker pull mirrorgooglecontainers/kube-controller-manager-amd64:v1.11.1
docker pull mirrorgooglecontainers/kube-scheduler-amd64:v1.11.1
docker pull mirrorgooglecontainers/kube-proxy-amd64:v1.11.1
docker pull mirrorgooglecontainers/pause:3.1
docker pull mirrorgooglecontainers/etcd-amd64:3.2.18
docker pull coredns/coredns:1.1.3
```
版本信息需要根据实际情况进行相应的修改。通过docker tag命令来修改镜像的标签：
```
docker tag mirrorgooglecontainers/kube-proxy-amd64:v1.11.1 k8s.gcr.io/kube-proxy-amd64:v1.11.1
docker tag mirrorgooglecontainers/kube-scheduler-amd64:v1.11.1 k8s.gcr.io/kube-scheduler-amd64:v1.11.1
docker tag mirrorgooglecontainers/kube-apiserver-amd64:v1.11.1 k8s.gcr.io/kube-apiserver-amd64:v1.11.1
docker tag mirrorgooglecontainers/kube-controller-manager-amd64:v1.11.1 k8s.gcr.io/kube-controller-manager-amd64:v1.11.1
docker tag mirrorgooglecontainers/etcd-amd64:3.2.18  k8s.gcr.io/etcd-amd64:3.2.18
docker tag mirrorgooglecontainers/pause:3.1  k8s.gcr.io/pause:3.1
docker tag coredns/coredns:1.1.3  k8s.gcr.io/coredns:1.1.3

```
使用docker rmi删除不用镜像，通过docker images命令显示，已经有我们需要的镜像文件，可以继续部署工作了
