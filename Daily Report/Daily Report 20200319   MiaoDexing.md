# helm之“Error: could not find a ready tiller pod”
```
linux@ubuntu:~$ helm version
Client: &version.Version{SemVer:"v2.16.3", GitCommit:"1ee0254c86d4ed6887327dabed7aa7da29d7eb0d", GitTreeState:"clean"}
Error: could not find a ready tiller pod

```
- 代表tiller的pod已经存在，但是没有运行起来。执行命令：
```
linux@ubuntu:~$ kubectl get pod --all-namespaces
NAMESPACE              NAME                                         READY   STATUS             RESTARTS   AGE
kube-system            coredns-7f9c544f75-4mqjf                     1/1     Running            5          85m
kube-system            coredns-7f9c544f75-8jzw2                     1/1     Running            5          85m
kube-system            etcd-minikube                                1/1     Running            0          12m
kube-system            kube-apiserver-minikube                      1/1     Running            0          12m
kube-system            kube-controller-manager-minikube             1/1     Running            6          85m
kube-system            kube-proxy-6k4tr                             1/1     Running            3          85m
kube-system            kube-scheduler-minikube                      1/1     Running            6          85m
kube-system            storage-provisioner                          1/1     Running            8          85m
kube-system            tiller-deploy-56f8b86db5-4s2lg               0/1     ImagePullBackOff   0          8m
kubernetes-dashboard   dashboard-metrics-scraper-7b64584c5c-bfpxb   1/1     Running            4          85m
kubernetes-dashboard   kubernetes-dashboard-79d9cd965-2rvkb         1/1     Running            10         85m

```

发现“kube-system            tiller-deploy-56f8b86db5-4s2lg               0/1     ImagePullBackOff   0          8m”
这里代表镜像拉取失败！
- 为此要编辑deploy，更改镜像地址
```
linux@ubuntu:~$ kubectl edit deploy tiller-deploy -n kube-system
```
将 image  gcr.io/kubernetes-helm/tiller:v2.16.3  替换成   image: sapcc/tiller:v2.16.3

- 保存后，kubernetes会自动生效，再次查看pod，已经处于running状态了。
```
kubectl get pod --all-namespaces
NAMESPACE              NAME                                         READY   STATUS    RESTARTS   AGE
kube-system            coredns-7f9c544f75-4mqjf                     1/1     Running   5          89m
kube-system            coredns-7f9c544f75-8jzw2                     1/1     Running   5          89m
kube-system            etcd-minikube                                1/1     Running   0          16m
kube-system            kube-apiserver-minikube                      1/1     Running   0          16m
kube-system            kube-controller-manager-minikube             1/1     Running   6          89m
kube-system            kube-proxy-6k4tr                             1/1     Running   3          89m
kube-system            kube-scheduler-minikube                      1/1     Running   6          89m
kube-system            storage-provisioner                          1/1     Running   8          89m
kube-system            tiller-deploy-6776684d65-fsrv5               1/1     Running   0          34s
kubernetes-dashboard   dashboard-metrics-scraper-7b64584c5c-bfpxb   1/1     Running   4          89m
kubernetes-dashboard   kubernetes-dashboard-79d9cd965-2rvkb         1/1     Running   10         89m

```

- 验证helm

```
linux@ubuntu:~$ helm version
Client: &version.Version{SemVer:"v2.16.3", GitCommit:"1ee0254c86d4ed6887327dabed7aa7da29d7eb0d", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.16.3", GitCommit:"1ee0254c86d4ed6887327dabed7aa7da29d7eb0d", GitTreeState:"clean"}

```
