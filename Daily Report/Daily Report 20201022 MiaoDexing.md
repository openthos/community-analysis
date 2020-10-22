# Ubuntu搭建RISCV之QEMU测试环境
## 前言
搭建此测试环境需要qemu、交叉工具链、内核、文件系统
## 安装QEMU
- 安装运行库
```
$ sudo apt-get install gcc libc6-dev pkg-config bridge-utils uml-utilities zlib1g-dev libglib2.0-dev autoconf automake libtool libsdl1.2-dev
```
- 下载qemu
```
$ git clone https://git.qemu.org/git/qemu.git
```
- 配置qemu，riscv-64-linux-user为用户模式，可以运行基于riscv指令集编译的程序文件,softmmu为镜像模拟器，可以运行基于riscv指令集编译的linux镜像，为了测试方便，这两个我都安装了
```
$ cd qemu
$ ./configure --target-list=riscv64-linux-user,riscv64-softmmu  [--prefix=INSTALL_LOCATION]
```
--prefix跟的是安装路径，这里记住，后面会用到
- 编译qemu
```
$ make
```
- 安装qemu
```
$ make install
```
在安装路径的bin目录下能够看到“qemu-riscv64    qemu-system-riscv64”即代表成功！
## 安装交叉工具链
- 下载交叉工具链
```
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

```
- 安装运行库
```
sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev
```
- 配置安装路径
```
./configure --prefix=/home/linux/riscv-test/riscv-gnu-toolchain_install
```
- 编译linux版本
```
make linux
```
在安装路径的bin目录下即可以找到工具集
- 为了方便使用，建议将安装的工具链设置到环境变量中
```
vi .bashrc
```
写入
```
export PATH=/home/linux/riscv-test/riscv-gnu-toolchain_install/bin:$PATH
```
## 编译内核
- 下载内核
```
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
```
- 配置内核
```
make ARCH=riscv defconfig
make ARCH=riscv menuconfig
```
- 编译内核
```
make CROSS_COMPILE=riscv64-unknown-linux-gnu-  ARCH=riscv
```
## 制作文件系统
- debootstrap
制作一个 "standard"文件系统，可以使用debootstrap
```
sudo apt-get install debootstrap qemu-user-static binfmt-support debian-ports-archive-keyring
sudo debootstrap --arch=riscv64  unstable /home/linux/riscv64-chroot http://deb.debian.org/debian-ports

```
- 添加一些基本信息
```
cat >>/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
```

```
cat >>/etc/default/u-boot <<EOF
U_BOOT_PARAMETERS="rw noquiet root=/dev/vda1"
U_BOOT_FDT_DIR="noexist"
EOF
```
目录不存在可以直接创建
- 创建disk image for qemu
```
sudo apt-get install libguestfs-tools
sudo virt-make-fs --partition=gpt --type=ext4 --size=10G  /home/linux/riscv64-chroot  rootfs.img
sudo chown ${USER} rootfs.img
```
## 启动QEMU
```
qemu-system-riscv64 -nographic -machine virt -m 1G \
 -bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
 -kernel Image  \
 -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-device,rng=rng0 \
 -append "console=ttyS0 rw root=/dev/vda1" \
 -device virtio-blk-device,drive=hd0 -drive file=rootfs.img,format=raw,id=hd0 \
 -device virtio-net-device,netdev=usernet -netdev user,id=usernet,hostfwd=tcp::22222-:22
```
bios涉及到的fw_jump.elf去这里下载[opensbi](https://packages.debian.org/opensbi)
