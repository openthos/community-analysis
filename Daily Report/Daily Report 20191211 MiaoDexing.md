# QEMU虚拟机与主机共享文件(FTP服务器)[链接地址](https://blog.csdn.net/WMX843230304WMX/article/details/102640150)
1、主机安装ftp服务器
```
sudo apt-get install vsftpd

```
2、配置:sudo vi /etc/vsftpd.conf

设定系统本地用户账户登录ftp
```
local_enable=YES
```
使用本地账户目录作为ftp目录
```
chroot_local_user=YES

write_enable=YES
```
重启
```
sudo /etc/init.d/vsftpd restart
```
3、主机访问服务器，查看是否成功<br>
   * 访问ftp服务器，输入用户名、密码
```
sudo ftp 127.0.0.1

```
4、qemu虚拟机安装 lftp　服务器
```
sudo apt-get install  lftp

```
5、qemu虚拟机登录主机ftp服务器
```
lftp 10.0.2.2 -u （主机用户名）
```
6、qemu中就可以使用get、put完成文件的上传、下载
