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
## 拉取registry仓库docker镜像

- 在仓库服务器 拉取镜像
```
docker pull registry

```
- 创建registry docker进程
```
docker run -d --name docker-registry --restart=always -p 9000:5000 registry
```
- 参数解释：
```
-d 后台运行

--name 镜像名称起别名

--restart=always 在容器退出时总是重启容器，注意：在生产环境中，要启用这个参数

-p 映射端口，规则是， 真实机端口：容器端口
```
# 四、测试上传镜像
- 下载测试镜像

登录到客户端服务器，下载一个镜像，比如alpine
```
docker pull alpine
```
 

将alpine镜像重命名为本地镜像格式与本地registry相匹配。

镜像名称由registry和tag两部分组成，registry完整格式：[registry_ip]:[registry:port]/[user]/[image_name:version]
```
docker tag alpine 192.168.1.108:5000/alpine

 ```
上传测试镜像
```
docker push 192.168.1.108:5000/alpine
```

输出：
```
The push refers to repository [192.168.1.108:5000/alpine]
Get https://192.168.1.108:5000/v2/: dial tcp 192.168.1.108:5000: connect: connection refused

```
- 因为Docker从1.3.X之后，与docker registry交互默认使用的是https，然而此处搭建的私有仓库只提供http服务，所以当与私有仓库交互时就会报上面的错误。
- 解决办法
修改daemon.json

注意：两台服务器都需要修改！
```
vim /etc/docker/daemon.json 
```
增加 insecure-registries，完整内容如下：
```
{
   "registry-mirrors": [
      "https://kv3qfp85.mirror.aliyuncs.com"
   ],
   "insecure-registries": [
      "192.168.1.108:5000"
    ]
}
```
insecure-registries 是一个列表，你可以增加多个。

- 重启docker服务
```
systemctl restart docker
```
 

再次执行
```
linux@ubuntu:~# docker push 192.168.1.108:5000/alpine
The push refers to a repository [192.168.1.108:5000/alpine]
df64d3292fd6: Pushed 
latest: digest: sha256:b6459ba7992adb5d76a7962e84909e1b3aaf029fbd8cb94131e8cbe464b6cd04 size: 528
```
 

登录到仓库服务器，查看镜像

注意：私有仓库中的镜像不是直接docker images查看的，而是访问url

比如：
```
curl -XGET http://registry地址:5000/v2/_catalog
curl -XGET http://registry地址:5000/v2/镜像名/tags/list

 ```

先执行第一个，查看现有的镜像
```
root@jqb-node129:~# curl -XGET http://192.168.1.108:5000/v2/_catalog
{"repositories":["alpine"]}

 ```

查看alpine镜像的信息
```
root@jqb-node129:~# curl -XGET http://192.168.1.108:5000/v2/alpine/tags/list
{"name":"alpine","tags":["latest"]}
```
 

docker 官方的 registry 仓库，默认是不支持从其他客户端拉取服务器仓库的镜像文件的，不过简单的办法，就是设置insecure-registry 参数。
