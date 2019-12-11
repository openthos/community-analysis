# QEMU虚拟机与主机共享文件(FTP服务器)[链接地址](https://blog.csdn.net/WMX843230304WMX/article/details/102640150)
1、主机安装ftp服务器
```
sudo apt-get install vsftpd
sudo /etc/init.d/vsftpd restart
```
2、主机访问服务器，查看是否成功<br>
   * 访问ftp服务器，输入用户名、密码
```
sudo ftp 127.0.0.1

```
3、qemu虚拟机安装 lftp　服务器
```
sudo apt-get install  lftp

```
4、qemu虚拟机登录主机ftp服务器
```
lftp 10.0.2.2 -u （主机用户名）
```
5、qemu中就可以使用get、put完成文件的上传、下载
