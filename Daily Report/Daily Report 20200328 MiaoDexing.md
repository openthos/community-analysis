# 一、为什么要搭建 docker 私有仓库

原因有几个：
- 项目需要，不希望将项目放到 docker hub 上。
- 环境需求，考虑网络、效率的问题，希望在私有服务器上建立自用的仓库，提高便利性和访问速度。
- 可以做更多的个性化配置。
# 二、用什么搭建 docker 私有仓库

docker 官方提供了 registry 的镜像，可以使用它来建私有仓库。

# 三、搭建过程
## 环境介绍
|  系统   |                         IP                         | 角色 |     
| :---------: | :----------------------------------------------------------: | :--: | 
| ubuntu-18.04 | 192.168.1.108 | 	docker 仓库服务器 | 
| ubuntu-18.04 |           192.168.1.106            | 	docker 客户端服务器 | 

## 安装docker

- 两台服务器，都安装docker
```
apt-get install -y docker.io

```
## 配置阿里云docker加速器
- 两台服务器都 编辑配置文件
```
vim /etc/docker/daemon.json 
```
内容如下：
```
{
   "registry-mirrors": [
      "https://kv3qfp85.mirror.aliyuncs.com"
    ]
}
```
 
- 两台服务器都 重启docker服务
```
systemctl restart docker

```
