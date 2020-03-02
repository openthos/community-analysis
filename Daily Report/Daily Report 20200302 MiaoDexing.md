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
 
