# docker常用操作
- 1. 镜像改名命令格式：
```
    # 命令格式：
     docker  tag  镜像id  仓库：标签
     
    或：
     
     docker  tag  旧镜像名  新镜像名
```
如：

我有一个镜像，名为：midysen/kernel_env:v1
把它改名为  midysen/kernel_env:v2，命令为： 
```
docker tag midysen/kernel_env:v1   midysen/kernel_env:v2
```
此时会生成一个新的镜像，和原镜像同一个 ID 。
```
linux@linux-THTF:~$ sudo docker tag midysen/kernel_env:v1 midysen/kernel_env:v2
linux@linux-THTF:~$ sudo docker images
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
kernel_env           v1                  924b0f6c44b4        45 hours ago        1.85GB
midysen/kernel_env   v1                  924b0f6c44b4        45 hours ago        1.85GB
midysen/kernel_env   v2                  924b0f6c44b4        45 hours ago        1.85GB
ubuntu               18.04               72300a873c2c        2 weeks ago         64.2MB
```
我以后只打算使用新镜像,旧镜像没有容器引用，直接使用 "docker rmi midysen/kernel_env:v1" 删除就行了 。
