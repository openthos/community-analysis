
本文链接：https://blog.csdn.net/qiusi0225/article/details/80447710
qemu安装

sudo apt-get install qemu qemu-user


user模式联网
默认IP为10.0.2.15,只能虚拟机连接宿主机,默认宿主机的地址位客户机所在网络的第2个IP地址,10.0.2.2不能直接连到外网,也不能宿主机连接虚拟机.root登录qemu,

ping 10.0.2.2
scp username@ip(宿主机ip):/home/username/test ./
ls


bridge方式联网
ifconfig查看自己的网卡名称,在主机下编写两个脚本:

mkdir etc
cd etc
vim qemu-ifup

#!/bin/bash

IFNAME=enp4s0 #网卡名称

IP1=192.168.10.100/24
IP2=192.168.10.101/24

set -x
if [ -n "$1" ];then
#create bridge, add physical interface to bridge
    ip link set $IFNAME down
    ip link add br0 type bridge
    ip link set br0 up
    ip link set $IFNAME master br0
    ip link set $IFNAME up
#   ip addr add $IP1 dev br0
#   ip addr add $IP2 dev $IFNAME

#add tap device to bridge
#       ip tuntap add $1 mode tap user `whoami`
        ip link set $1 up
        sleep 0.5s
        ip link set $1 master br0

#config ip fro bridge
        pkill dhclient
    sleep 5
        dhclient -v br0

        exit 0
else
        echo "ERROR: no interface specified"
        exit 1
fi


vim qemu-ifdown


#!/bin/bash
if [ -n "$1" ];then
    IP1=192.168.10.100/24
    IP2=192.168.10.101/24

    IFNAME=enp4s0

    ip link set $IFNAME down
    ip link set $1 down
    ip link set br0 down

    ip link set $1 nomaster
    ip link set $IFNAME nomaster

    ip link del br0
#   ip tuntap del $1 mode tap

    #ip addr del $IP2 dev $IFNAME
    ip link set $IFNAME up

        pkill dhclient
    sleep 5
        dhclient -v $IFNAME

else
    echo "ERROR:no interface specified"
fi



给两个脚本添加权限

chmod 777 qemu-ifup qemu-ifdown
sudo modprobe tun 

    1
    2

启动虚拟机,其中ifname可能会冲突,那就改为tap1, tap2 ,….

qemu-system-mips64 -M malta -kernel vmlinux-2.6.32-5-5kc-malta -hda debian_squeeze_mips_standard.qcow2 -append "root=/dev/sda1 console=tty0" -netdev tap,id=mytap,ifname=tap0,script=etc/qemu-ifup,downscript=etc/qemu-ifdown -device e1000,netdev=mytap

    1

进入虚拟机后,已经可以与外网和宿主机互相通信了:

ping www.baidu.com
ping addrip # 宿主机ip

原文链接：https://blog.csdn.net/qiusi0225/article/details/80447710
