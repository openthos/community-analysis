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

## k8s之Volume存储数据卷
- 在Docker中就有数据卷的概念，当容器删除时，数据也一起会被删除，想要持久化使用数据，需要把主机上的目录挂载到Docker中去，在K8S中，数据卷是通过Pod实现持久化的，如果Pod删除，数据卷也会一起删除，k8s的数据卷是docker数据卷的扩展，K8S适配各种存储系统，包括本地存储EmptyDir,HostPath,网络存储NFS,GlusterFS,PV/PVC等，下面就详细介绍下K8S的存储如何实现。
- HostDir
  -  编辑EmptyDir配置文件
```
   apiVersion: v1
kind: Pod        #类型是Pod
metadata:
  labels:
    name: redis
    role: master        #定义为主redis
  name: redis-master
spec:
  containers:
    - name: master
      image: redis:latest
      env:        #定义环境变量
        - name: MASTER
          value: "true"
      ports:        #容器内端口
        - containerPort: 6379
      volumeMounts:        #容器内挂载点
        - mountPath: /data
          name: redis-data        #必须有名称
 volumes:
    - name: redis-data        #跟上面的名称对应
      hostPath: 
        path: /home/docker/data      #宿主机挂载点
```
创建pod
```
kubectl create -f emptydir.yaml
```
此时Emptydir已经创建成功，在宿主机(我这里是在minikube中)上的访问路径为/home/docker/data,如果在此目录中创建删除文件，都将对容器中的/data目录有影响，如果删除Pod，文件将全部删除，即使是在宿主机上创建的文件也是如此，在宿主机上删除容器则k8s会再自动创建一个容器，此时文件仍然存在。
