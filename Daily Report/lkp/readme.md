## Step 1:
```
# ./run.sh  bzImage  rootfs_ok.ext4  kernel_dir=/home/linux/lkp/kernel/linux
```
其中：
  -  bzImage 编译好的内核镜像
  -  rootfs_ok.ext4 已经制作好的文件系统
  -  kernel_dir   内核源码路径
## Step 2:
```
./bisect.sh commit=f6ea18da633f583b43f71b02d1653b8654c6fdad
```
其中：
  -  commit:    最近的一次good commit id
