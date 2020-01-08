# Ubuntu18.04 GitLab仓库服务器搭建
## 首先安装必须的一些服务
```
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates
sudo apt-get install -y postfix

```
使用左右键和回车键选择确定、取消，弹出列表选项的时候，选择 Internet Site
## 接着信任 GitLab 的 GPG 公钥:
```
curl https://packages.gitlab.com/gpg.key 2> /dev/null | sudo apt-key add - &>/dev/null  

```
## 配置镜像路径
由于国外的下载速度过慢，所以配置清华大学镜像的路径。
```
sudo vi /etc/apt/sources.list.d/gitlab-ce.list  

```
写入
```
deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu xenial main
```
## 安装 gitlab-ce
```
sudo apt-get update
sudo apt-get install gitlab-ce

```
## 更改配置
gitlab默认使用8080端口，而8080端口往往被其他进程占用，为避免冲突，这里改为9898
```
sudo vi /etc/gitlab/gitlab.rb 
```
更改内容
```
external_url 'http://ip:98'
unicorn['port'] = 9898
```
## 执行配置
```
sudo gitlab-ctl reconfigure

```
## 启动gitlab
```
sudo gitlab-ctl start

```
浏览器进行访问
```
http://ip:98
```
第一次进入，需要输入管理员账号的密码，以方便后期的管理。
输入好之后，就可以以管理员进行登录，账号是root，密码就是你刚才输入的密码。
至此，gitlab已安装成功，之后的使用方式，和github没有太大差异，就不进行介绍了。
