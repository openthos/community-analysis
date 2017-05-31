# 2017-05月报
## 黃志偉
1. 整合 ffmpeg stagefright-plugin + libva + vaapi 至 OPENTHOS 與 Android-x86 7.1，解決穩定性問題。
2. 修改 Gallery2，能播放所有測試用 video files。
3. 再研究 OPENTHOS 在 VMware 的問題，修改 resolution 並更新 Mesa 解決。
4. 為 OPENTHOS 加入 QEMU virgl 的支持。
5. 適配 THTF NS4AU11，需更新 kernel 4.9 方能啟動成功。需加入 WIFI/BT firmwares。除 touchpad 外皆可使用。
6. 研究 StartupMenu 和 Fennc crashing 問題，與 Mesa 有關。改用 Mesa 13 似乎較為穩定。
7. 繼續更新 kernel 4.9.30 和 Mesa 17.1，為 7.1-rc1 release 做準備。

# 2017-04月报
**目前还有两个问题：**  
        1.trust boot--陈威  
        2.recovery问题(进度50%)--肖络元+王之旭  
## 王建兴

        1.OPENTHOS在VMVare上运行出现的鼠标不见的问题，分辨率不对的问题<+志伟>
        2.Follow志伟的硬解码工作，下一步是学习志伟的工作内容
        3.机器休眠重启问题,目前T43U的机器重启问题已经修复，还有一台超锐机器需要修复
        4.修理180服务器
        5.磁盘分区方案解决
        6.支援王之旭的工厂测试工具，提供prime5工具

## 肖络元

1. 为实验室repo代码与github repo代码保持一致：梳理了旧子仓库升级所造成的update github错误，部分开发子仓库之前未上传至github，自动化更新脚本的功能增强，包括检测github外部更新等；
2. Follow CWHuang的硬解码部分的ffmpeg测试，同步该部分代码到实验室并建立了对应的分支multiwindow-hwaccel， 编写对于的测试文档；        
3. 磁盘AutoMount的FileManager部分，提供filemanager应用层接口: MountService与vold的装卸接口。与王之旭协作；        
4. 接手xhl的window分区恢复工具，代码修改与增加，包括分区信息的自动扫描，efi分区的识别与还原等。与王之旭协助；
        
        
