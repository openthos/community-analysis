# docker常用操作
##  一、镜像改名命令格式：
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

## 二、docker exec命令
在容器 mynginx 中以交互模式执行容器内 /root/runoob.sh 脚本:
```
runoob@runoob:~$ docker exec -it mynginx /bin/sh /root/runoob.sh
http://www.runoob.com/
```
在容器 mynginx 中开启一个交互模式的终端:
```
runoob@runoob:~$ docker exec -i -t  mynginx /bin/bash
root@b1a0703e41e7:/#
```
也可以通过 docker ps -a 命令查看已经在运行的容器，然后使用容器 ID 进入容器。

查看已经在运行的容器 ID：
```
# docker ps -a 
...
9df70f9a0714        openjdk             "/usercode/script.sh…" 
...
```
第一列的 9df70f9a0714 就是容器 ID。

通过 exec 命令对指定的容器执行 bash:
```
# docker exec -it 9df70f9a0714 /bin/bash
```

## docker cp
首先使用
```
# docker ps -a 
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS                        PORTS               NAMES
0e96c3f59af3        midysen/kernel_env:v1   "/bin/bash"         16 minutes ago      Up 16 minutes                                     recursing_hamilton
f13d2bb6d8f0        midysen/kernel_env:v1   "/bin/bash"         16 minutes ago      Exited (0) 16 minutes ago    

```
得到CONTAINER ID，此时不能退出docker；
将主机/www/runoob目录拷贝到容器0e96c3f59af3的/www目录下。
```
docker cp /www/runoob 0e96c3f59af3:/www/
```
将主机/www/runoob目录拷贝到容器0e96c3f59af3中，目录重命名为www。
```
docker cp /www/runoob 0e96c3f59af3:/www
```
将容器0e96c3f59af3的/www目录拷贝到主机的/tmp目录中。
```
docker cp  e761e012805a:/www /tmp/
```
## docker commit命令创建一个镜像
首先使用
```
# docker ps -a 
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS                        PORTS               NAMES
0e96c3f59af3        midysen/kernel_env:v1   "/bin/bash"         16 minutes ago      Up 16 minutes                                     recursing_hamilton
f13d2bb6d8f0        midysen/kernel_env:v1   "/bin/bash"         16 minutes ago      Exited (0) 16 minutes ago    

```
得到CONTAINER ID，此时不能退出docker；
其次，使用docker commit命令创建一个镜像
```
linux@linux-THTF:~$ sudo docker commit  -m "Add qemu and rootfs" 0e96c3f59af3 midysen/kernel_env:v1
sha256:690da9807a73a64b2b0450946f2293ca8b3e9e75314598d9a47a4622157f6718
linux@linux-THTF:~$ sudo docker images 
REPOSITORY           TAG                 IMAGE ID            CREATED              SIZE
midysen/kernel_env   v1                  690da9807a73        About a minute ago   6.65GB

```
