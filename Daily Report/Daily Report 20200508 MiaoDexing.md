# ubuntu使用国内ustc镜像安装kubelet kubeadm kubectl
- 非科学上网想安装k8s比较困难，下面是我不断试错找出来较快速的能搭建k8s环境的步骤，仅供参考。
    - 添加镜像源
    ```
    echo “deb [arch=amd64] https://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main” | sudo tee -a /etc/apt/sources.list
    apt-get update
    ```
可能会报错GPG ERROR
```
gpg --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 
gpg --export --armor E084DAB9 | sudo apt-key add - 
```

 -  E084DAB9 是提示的NO_PUBLICKEY公匙的后八位
    
    重新apt-get update
    
  -  安装
```
apt-get install -y kubelet=1.10.3-00 kubeadm=1.10.3-00 kubectl=1.10.3-00
```
