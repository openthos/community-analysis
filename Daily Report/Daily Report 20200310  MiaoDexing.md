# docker  push失败:denied: requested access to the resource is denied
push 之前需要使用 docker login登录自身账号，我的账号用户名是midysen，但是push时出现下面错误信息
```
linux@linux-THTF:~$ sudo docker push ubuntu:18.04
The push refers to repository [docker.io/library/ubuntu]
1852b2300972: Preparing 
03c9b9f537a4: Preparing 
8c98131d2d1d: Preparing 
cc4590d6a718: Preparing 
denied: requested access to the resource is denied

```
## 原因是本地镜像名无帐号信息
```
linux@linux-THTF:~$ sudo docker image ls 
sudo docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
kernel_env          v1                  924b0f6c44b4        3 hours ago         1.85GB
ubuntu              18.04               72300a873c2c        2 weeks ago         64.2MB
```
## 解决办法
```
linux@linux-THTF:~$ sudo docker tag 924b0f6c44b4 midysen/kernel_env:v1
linux@linux-THTF:~$ sudo docker image ls
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
kernel_env           v1                  924b0f6c44b4        3 hours ago         1.85GB
midysen/kernel_env   v1                  924b0f6c44b4        3 hours ago         1.85GB
ubuntu               18.04               72300a873c2c        2 weeks ago         64.2MB
linux@linux-THTF:~$ sudo docker push midysen/kernel_env:v1
The push refers to repository [docker.io/midysen/kernel_env]

```
