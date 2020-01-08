# ubuntu18.04 heirloom-mailx 通过外部SMTP服务器发送邮件

## 配置软件源
ubuntu18.04上无法直接安装heirloom-mailx，需要添加软件源
```
sudo vi  /etc/apt/sources.list
```
写入
```
deb http://cz.archive.ubuntu.com/ubuntu xenial main universe
```
## 安装heirloom-mailx
```
sudo apt-get update
sudo apt install heirloom-mailx
```
## 配置外部SMTP
Ubuntu18.04的配置文件为/etc/s-nail.rc，把下面几行放置在最后
```
set from="759381818@qq.com"
set smtp="smtps://smtp.qq.com:465"
set smtp-auth-user="759381818@qq.com"
set smtp-auth-password="ahkphzlybshabbga"
set smtp-auth=login  
```
注意：第四行password是指的QQ邮箱授权码，不是密码
## 测试
```
echo "邮件内容" | s-nail  -s "邮件主题" miaodexing@openthos.org
```
或者
```
s-nail  -s "邮件主题" miaodexing@openthos.org  < result.txt
```
