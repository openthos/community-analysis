# Kubernetes中，两种常见类型的Volume深度实践
## 一.背景
- 存储资源在所有计算资源中扮演着十分重要的角色，大部分业务场景下都有可能使用到各类存储资源。在Kubernetes中，系统通过Volume对集群中的容器动态或静态提供存储资源。通常情况下，我们可以认为容器或者Pod的生命周期时短暂的，
当容器被销毁时，容器内部的数据也同时被清除。为了持久化保存容器的数据，Kubernetes引入了Volume，类似于Docker的Volume(Docker also has a concept of volumes, though it is somewhat looser and less managed. In Docker, 
a volume is simply a directory on disk or in another Container. Lifetimes are not managed and until very recently there were onlylocal-disk-backed volumes. Docker now provides volume drivers, but the functionality is very limited for now)。
这个Volume被某个Pod挂载之后，这个Pod里面的所有容器都能使用这个Volume。Kubernetes目前支持的volume类型可以参考文末官方资料。
## 二.两种Volume使用举例
### 2.1 emptyDir
- emptyDir： emptyDir是最基础的Volume类型。每个emptyDir Volume是主机上的一个空目录,可以被Pod中所有的容器共享。它对于容器来说是持久的，对于Pod则不是。删除容器并不会对它造成影响，只有删除整个Pod时，它才会被删除，它的生命周期与所挂载的Pod一致。简而言之，emptyDir类型的Volume在Pod分配到Node上时被创建，Kubernetes会在Node主机上自动分配一个目录，因此无需指定Node主机上对应的目录文件。 这个目录的初始内容为空，当Pod从Node上移除时，emptyDir中的数据会被永久删除。emptyDir主要用于一些无需永久保留的数据，例如临时目录，多容器共享目录等。我们通过实际案例来理解一下，Pod gysl的yaml如下：
```
apiVersion: v1
kind: Pod
metadata:
  name: gysl
spec:
  containers:
  - image: busybox
    name: gysl-01
    volumeMounts:
    - mountPath: /gysl-01
      name: gysl-volume
    args:
    - /bin/sh
    - -c
    - echo "This is a test file.">/gysl-01/test.gysl;sleep 20000

  - image: busybox
    name: gysl-02
    volumeMounts:
    - mountPath: /gysl-02
      name: gysl-volume
    args:
    - /bin/sh
    - -c
    - cat /gysl-02/test.gysl;sleep 20000

  volumes:
  - name: gysl-volume
    emptyDir: {}
```

- 创建Pod gysl，并查看相关信息：
```
[root@k8s-m k8s-volumes]# kubectl apply -f emptyDir.yaml
pod/gysl created
[root@k8s-m k8s-volumes]# kubectl get pod
NAME   READY   STATUS    RESTARTS   AGE
gysl   2/2     Running   0          10m
[root@k8s-m k8s-volumes]# kubectl logs gysl gysl-02
This is a test file.
```

该例中，我们创建了一个名为gysl的Pod，这个pod里面包含gysl-01和gysl-02两个容器，这两个容器同时挂载了名为gysl-volume的emptyDir，gysl-01的挂载点为/gysl-01，gysl-02的挂载点为gysl-02，容器gysl-01创建了一个test.gysl的文件，内容为：“This is a test file.”在容器gysl-02中，成功显示了gysl-01创建的文件的内容。

### 2.2 hostPath

hostPath： hostPath的主要作用是将主机的文件或目录挂载给Pod的容器使用，使得容器能以较为良好的性能来存储数据。接下来我们以Pod gysl-hostpath为例来理解一下hostPath的相关概念，YAML文件如下：
```
apiVersion: v1
kind: Pod
metadata:
  name: gysl-hostpath
spec:
  nodeSelector: 
    role: test
  containers:
  - image: ubuntu:18.04
    name: gysl-hostpath-container
    volumeMounts:
    - mountPath: /etc/gysl-test-01
      name: gysl-02
    - mountPath: /etc/gysl-test-02
      name: gysl-01
    - mountPath: /gysl-test-dir
      name: gysl-dir
    args:
    - /bin/bash
    - -c 
    - cat /etc/gysl-test-01 /etc/gysl-test-02;ls -l /gysl-test-dir;sleep 3600
  volumes:
  - hostPath: 
      path: /root/gysl-01
    name: gysl-01
  - hostPath:
      path: /root/gysl-02
    name: gysl-02
  - hostPath:
      path: /root/gysl-dir
    name: gysl-dir

```

在Node k8s-n1的/root目录下创建如下文件和目录：
```
[root@k8s-n1 ~]# ll
总用量 8
-rw-r--r-- 1 root root 16 11月 21 20:31 gysl-01
-rw-r--r-- 1 root root 16 11月 21 20:31 gysl-02
drwxr-xr-x 2 root root 51 11月 21 20:32 gysl-dir

```

两个文件的内容如下：
```
[root@k8s-n1 ~]# cat gysl-01
This is gysl-01
[root@k8s-n1 ~]# cat gysl-02
This is gysl-02

```

目录gysl-dir的内容如下：
```
[root@k8s-n1 ~]# ll gysl-dir/
总用量 12
-rw-r--r-- 1 root root 16 11月 21 20:32 gysl-01
-rw-r--r-- 1 root root 16 11月 21 20:32 gysl-02
-rw-r--r-- 1 root root 16 11月 21 20:32 gysl-03

```

给Node k8s-n1指定一个标签，apply 该Pod：

```
[root@k8s-m k8s-Volumes]# kubectl label node k8s-n1 role=test
node/k8s-n1 labeled
[root@k8s-m k8s-Volumes]# kubectl apply -f hostPath.yaml
pod/gysl-hostpath created
[root@k8s-m k8s-Volumes]# kubectl get pod -o wide
NAME            READY   STATUS    RESTARTS   AGE   IP             NODE     NOMINATED NODE
gysl-hostpath   1/1     Running   0          17s   10.244.1.177   k8s-n1   <none>
[root@k8s-m k8s-Volumes]# kubectl logs gysl-hostpath
This is gysl-02
This is gysl-01
total 12
-rw-r--r-- 1 root root 16 Nov 21 12:32 gysl-01
-rw-r--r-- 1 root root 16 Nov 21 12:32 gysl-02
-rw-r--r-- 1 root root 16 Nov 21 12:32 gysl-03

```

这个例子中，我把名为gysl-02的hostPath文件挂载到了容器的文件/etc/gysl-test-01上，把名为gysl-01的hostPath文件挂载到了容器的文件/etc/gysl-test-02上，把名为gysl-dir的hostPath目录挂载到了/gysl-test-dir下。通过logs命令，我们不难发现，目标已经达成。

这种挂载方式比emptyDir更为持久，除非所在Node发生故障。不过，除了挂载一些配置文件/二进制文件之外，一般不采用该类挂载方式，因为这样的挂载操作增加了Pod文件与Node主机文件的耦合，不利于统一管理。

# 三.总结
- 3.1 在volume的配置过程中，涉及到具体挂载路径的需要按照一定的规则来配置。例如：文件或目录需要写绝对路径。不按照规则来配置，会出现以下报错：
```
Warning  Failed     8s (x3 over 20s)  kubelet, k8s-n1    Error: Error response from daemon: create ~/gysl: "~/gysl-dir" includes invalid characters for a local volume name, only "[a-zA-Z0-9][a-zA-Z0-9_.-]" are allowed. If you intended to pass a host directory, use absolute path
```

- 3.2 emptyDir和hostPath都是比较常见的两种类型的volume，在使用时需要根据具体情况进行配置。其他类型的volume可参考以上两种类型及官方文档进行配置，相关官方文档会在文末给出。
