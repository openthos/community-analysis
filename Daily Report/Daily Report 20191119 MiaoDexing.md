# 1
- qemu-system-x86_64   -m 2G -append "root=/dev/ram0  rdinit=/bin/bash console=ttyS0" -serial stdio -kernel fbc/93eb07f72c8d86f8fe5e90907df1cc037f6ffbb7/vmlinuz-4.19.0-rc5-00255-g4e99d4e  -initrd final_initrd

# 2
- lkp compile  ./mytest-defaults.yaml -o my.sh
- lkp qemu my.sh
