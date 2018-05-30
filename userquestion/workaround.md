# OPENTHOS使用问题变通方案
1. 无wifi的台式机无法使用微信聊天记录迁移等功能  
**解决方案：**  
使用无线网卡，注意要选择免驱动的，比如TP-LINK的TL-WN726N，使用前要先在windows上运行一下自带的程序，再回到openthos上即可直接使用。
2. 需要更多的命令行工具，编译生成的ELF文件的分析处理工具，如readelf / pandoc命令  
**解决方案：**  
chroot解决
