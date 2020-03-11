# Kubernetes 集群使用 Helm 搭建 GitLab
## 一、Helm 介绍
- Helm 是一个管理 Kubernetes Charts 的工具，Charts 可以理解为预先配置的 Kubernetes 资源包，
通过 Helm 可以轻松的安装和管理 Kubernetes 应用，类似我们平时使用的 apt、yum、homebrew 工具。
Helm 包含两部分：客户端 Helm 和服务端 Tiller，服务端 Tiller 运行在 Kubernetes 集群内部，
作为一个代理 Pod 管理安装我们的 Charts。 而 Charts 配置至少需要两样：
一是 Package 描述文件（Chart.yaml），主要用来针对该资源包进行一些必要的说明信息。
二是一个或多个包含应用需要安装的 Kubernetes 清单文件的模板文件。

- 1、 Helm的基本概念：
  -  Chart: 被Helm管理的安装包，里面包含需要部署的安装包资源。Chart之于Helm相当于yum rpm之于CentOS。
  -  每个Chart包里的内容：
     - (1) 包的基本描述文件Chart.yaml，这个就相当于nodejs项目里的package.json
     - (2) Release：Chart的部署实例，一个chart在一个Kubernetes集群上可以有多个release，即这个chart可以被安装多次
     - (3) Repository：Chart的仓库，用于发布和存储Chart, 相当于nodejs项目里package.json里的repository字段：
- 2、 Helm完成的功能：
   -  (1) 管理Kubernetes manifest files
   -  (2) 管理Helm安装包Charts
   -  (3) 基于Chart进行Kubernetes应用发布 <br>

Helm由两部分组成，客户端helm和服务端tiller，其中tiller运行在Kubernetes集群上，用于管理Chart安装的release。
而helm是一个命令行工具，可在本地运行，一般运行在持续集成(Continuous Integration-CI)/持续发布(Continues Delivery-CD)服务器上。
- 2、环境、软件准备
  -  以下是安装的软件及版本：
    Docker、
    Oracle VirtualBox、
    Minikube、
    Kuberctl、
    Helm。
    前四个在26号日志中已经介绍如何安装，本次主要介绍Helm安装。
 

    
- 3、 安装
在helm的github仓库上下载二进制可执行文件：
```
https://github.com/helm/helm/releases
```
下载完可执行文件helm后，拷贝到文件夹/usr/local/bin下，执行helm version, 如果看到版本信息，说明helm的客户端安装成功。
