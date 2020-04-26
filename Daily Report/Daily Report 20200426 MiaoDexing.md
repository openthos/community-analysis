# 挂载问题
## host 与 minikube 挂载
```
minikube  mount tmp:/home/docker/aa
```
此时是将host主机上的 tmp 目录 挂载到 minikube 的 /home/docker/aa目录，成功如下：
```
linux@linux:~$ minikube  mount tmp:/home/docker/aa
📁  Mounting host path tmp into VM as /home/docker/aa ...
    ▪ Mount type:   <no value>
    ▪ User ID:      docker
    ▪ Group ID:     docker
    ▪ Version:      9p2000.L
    ▪ Message Size: 262144
    ▪ Permissions:  755 (-rwxr-xr-x)
    ▪ Options:      map[]
🚀  Userspace file server: ufs starting
✅  Successfully mounted tmp to /home/docker/aa

📌  NOTE: This process must stay alive for the mount to be accessible ...


```

## docker数据卷挂载
```
docker run -v $(pwd)/tmp:/root/tmp -it ubuntu:18.04

```
此时是将当前目录下的tmp 挂载 到 ubuntu:18.04的/root/tmp下
