# 1
- qemu-system-x86_64   -m 2G -append "root=/dev/ram0  rdinit=/bin/bash console=ttyS0" -serial stdio -kernel fbc/93eb07f72c8d86f8fe5e90907df1cc037f6ffbb7/vmlinuz-4.19.0-rc5-00255-g4e99d4e  -initrd final_initrd

# 2
- lkp compile  ./mytest-defaults.yaml -o my.sh
- lkp qemu my.sh

# 3
- vi ./rootfs/kexec/etc/inittab

# 4
- 使用buildroot编译生成的rootfs，不需要输入用户名密码直接登录
```
qemu-system-x86_64  -m 2G -append "root=/dev/sda rdinit=/sbin/init" -serial stdio -kernel bzImage  -hda rootfs.ext2
```
- 使用debian作为文件系统在内存中运行
```
qemu-system-x86_64  -m 2G -append "root=/dev/ram0 rdinit=/bin/bash" -serial stdio -kernel bzImage  -initrd debian-x86_64-2018-04-03.cgz
```
- gitlab  将qemu的输出指定到ttyS0，因为gitlab从console=ttyS0获取数据
```
qemu-system-x86_64 -nographic  -m 2G -append "root=/dev/sda init=/bin/bash console=ttyS0"  -kernel $1 -hda $2
```
- -curses方式和-nographic
  - 使用 --nographic 以非图形界面的方式启动，所以需要重定向guest的console，所以需要“-append console=ttyS0”参数，而使用该参数是必须要使用-kernel参数的，因为无法直接将append中的内核命令行参数传递到硬盘、CDROM等里面的kernel中去。有时，需要“ -append 'console=tty0 console=ttyS0,115200n8' ”这样的参数。
  -  curses 图形化方式
