# 为gitlab添加kubernetes集群
[链接](https://www.jianshu.com/p/1208c132b84c)
- 点击project的【Add Kubernetes cluster】按钮。
- 选择【Add existing kubernetes】，填入相应的信息。
  -  name随意
  -  API URL通过kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}' 得到。
  -  CA Certificates，先运行kubectl get secrets查看默认的token，可以看到default-token-xxxxx，
  然后通过kubectl get secret <secret name> -o jsonpath="{['data']['ca\.crt']}" | base64 --decode 可得到。
```
~ # kubectl get secrets
NAME                                 TYPE                                  DATA   AGE
default-token-4w6nw                  kubernetes.io/service-account-token   3      22d
~ # kubectl get secret default-token-4w6nw -o jsonpath="{['data']['ca\.crt']}" | base64 --decode
-----BEGIN CERTIFICATE-----
………………………………………………………………
………………………………………………………………
………………………………………………………………
-----END CERTIFICATE-----
```
  -  Service Token，先创建一个叫做gitlab-admin-service-account.yaml的文件，内容如下。
  再通过kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab-admin | awk '{print $1}') 得到token值。
```
/home # cat gitlab-admin-service-account.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: gitlab-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: gitlab-admin
  namespace: kube-system
/home # kubectl apply -f gitlab-admin-service-account.yaml
serviceaccount "gitlab-admin" created
clusterrolebinding "gitlab-admin" created
/home# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab-ad
min | awk '{print $1}')
Name:         gitlab-admin-token-jd7dh
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: gitlab-admin
              kubernetes.io/service-account.uid: 44ff86e5-61f2-4e5a-94c6-68202032048f

Type:  kubernetes.io/service-account-token

Data
====
namespace:  11 bytes
token:      ……………………
ca.crt:     1497 bytes

```

- 添加成功，可自行选择添加Application。
