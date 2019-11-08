# 用buildroot编译出来的文件系统，开机时每次都要登录。

解决办法：

vi /etc/inittab

找到：

console::respawn:/sbin/getty -L  console 0 vt100 # GENERIC_SERIAL

修改为：console::respawn:-/bin/sh
