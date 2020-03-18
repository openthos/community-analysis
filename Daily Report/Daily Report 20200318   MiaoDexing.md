# 本地机器和minikube之间传输文件
- 您可以使用minikube命令的ssh-key和ip子命令：
```
scp -i $(minikube ssh-key) <local-path> docker@$(minikube ip):<remote-path>
```
所以来自问题的命令变为：
```
sudo scp -i $(minikube ssh-key)  arch/x86_64/boot/bzImage   docker@$(minikube ip):/home/docker
```
