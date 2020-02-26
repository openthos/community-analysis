# Minikube - Kubernetes本地实验环境
为了方便大家开发和体验Kubernetes，社区提供了可以在本地部署的Minikube。由于网络访问原因，很多朋友无法直接使用minikube进行实验。
在最新的Minikube中，已经提供了配置化的方式，可以帮助大家利用阿里云的镜像地址来获取所需Docker镜像和配置。<br>
注意：Minikube 启动的单节点 k8s Node 实例是需要运行在本机的 VM 虚拟机里面，所以需要提前安装好 VM，
这里我选择 Oracle VirtualBox。k8s 运行底层使用 Docker 容器，所以本机需要安装好 Docker 环境

##  先决条件
### kubectl 安装
kubectl 是 Kubernetes 的命令行工具，我们可以使用该工具查看集群资源，创建、更新、删除各个组件等等，
同时提供了非常详细的使用文档，非常方便，本机安装如下。
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl && mv kubectl /usr/bin
```
## minikube 安装
minikube 是一个使我们很容易在本地运行 kubernetes 的工具，他是通过在本机 VM 里运行一个单节点 kubernetes 集群，
这对于新手想了解和学习 kubernetes 提供了很大的帮助。所以在安装 minikube 之前我们需要在本机先安装 VM。 <br>
- 安装minikube
```
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.7.3/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```
- 安装minikube缺省支持的Kubernetes版本
```
minikube start --image-mirror-country cn \
    --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.7.3.iso \
    --registry-mirror=https://xxxxxx.mirror.aliyuncs.com
```
- 参数配置说明
  -  --image-mirror-country cn 将缺省利用 registry.cn-hangzhou.aliyuncs.com/google_containers 作为安装Kubernetes的容器镜像仓库，
  -  --iso-url=*** 利用阿里云的镜像地址下载相应的 .iso 文件
  -  --cpus=2: 为minikube虚拟机分配CPU核数
  -  --memory=2000mb: 为minikube虚拟机分配内存数
  -  --kubernetes-version=***: minikube 虚拟机将使用的 kubernetes 版本
- 打开Kubernetes控制台
```
minikube dashboard
```
![avatar](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/2020-02-26%2018-08-33%20%E7%9A%84%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE.png)
