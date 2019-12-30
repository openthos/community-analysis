# unsupported reloc 42 编译错误处理
- 错误信息
```
out/host/linux-x86/obj/SHARED_LIBRARIES/libart_intermediates/arch/x86_64/quick_entrypoints_x86_64.o:function art_quick_deoptimize: 
error: unsupported reloc 42
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
- 解决办法
使用soft link，链接到全局ld
```
ln -s /usr/bin/ld.gold   prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.15-4.8/x86_64-linux/bin/ld

```


# Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.
[详见](https://lore.kernel.org/lkml/20191127005312.GD20422@shao2-debian/)
