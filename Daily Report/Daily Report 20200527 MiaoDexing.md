# QEMU
## 运行命令
```
bootloader_arg="root=/dev/sda rw rdinit=/sbin/init console=ttyS0"
fs9p="-fsdev local,id=id_dev,path=${host_shared},security_model=none -device virtio-9p-pci,fsdev=id_dev,mount_tag=9p_mount"
qemu-system-x86_64  -nographic   -m 2G $fs9p -append "$bootloader_arg job=xxx" -kernel zImage  -hda rootfs.ext4
```
### 参数说明
- bootloader_arg 是指qemu运行时传递给kernel的参数，在qemu内部可以通过“cat /proc/cmdline”获得到内核的启动参数，这里可以通过“job=xxx”
  来告诉qemu内部的文件系统要启动的测试任务
 - fs9p 用来实现qemu内部的目录与host共享，从而拿到测试任务的测试结果方面在host分析
 - kernel要支持9p文件系统
 - rootfs文件系统内部的开机启动脚本要去分析“/proc/cmdline”获得到内核的启动参数，主要是获得要执行的测试任务
