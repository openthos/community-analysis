# 2017-06月报
月小结：

黄志伟重点解决skylake/kabylake硬件适配问题，Android-x86 7.1的稳定性和兼容性问题 ，取得了很好的成果。 王建兴同时参与sec组和系统组，主要解决 bootloader/os/system的boot优化/美化，硬盘复制，suspend/resume等，系统安装问题。对于suspend/resume的问题，可能涉及bios和其他团队，有所延后，总体基本完成任务。有关肖络元的事务比较繁杂，参与了多节点/多版本的openthos repos版本维护与管理，windows 恢复app,usb mount/unmount，autotest等工作。总体完成了任务。有关基于lkp的autotest方面，由于系统比较复杂，进度较慢。

## 下月计划：
上月除黄志伟外，工程师大部分工作还是基于openthos 5.1的改进与完善。本月除了要进一步优先解决openthos 5.1存在的问题外，接下来主要是基于Openthos7.1的系统开发与维护工作。

## 个人月总结

## 黃志偉
1. 清理 7.1-rc1 最後 pending tasks 並完成 release。
2. 繼續 THTF NS4AU11 適配工作，與 BIOS owner 解決 touchpad 問題。調查 NS4AU11 睡眠唤醒重启問题，revert S3 patch 似可解決。
3. 在 OPENTHOS 加入 libyuv dithering patch，可有效改善視頻播放畫質。
4. 與 Taskbar 作者合作導入 Taskbar 到 Android-x86 7.1。研究 7.1 無法自動進 freeform window 問題，在 frameworks 加一 patch 可解決。
5. 研究 USB power management，確認 kernel 未 enable autosuspend by default，但可手動 enable 有效。
6. 研究改善 graphics stack 的可能性：
    * 測試 HWC2 的可行性。使用 minigbm + ia hwcomposer 成功，但僅能用在 Intel GPU Gen8+ 以上。
    * 測試 gralloc.gdm on virgl，使用 AOSP master 可成功但 7.1 不行。可能須更新 libsync。
    * 以 Chad Versace's patches 測試 pixel format 改為 RGBA_8888，搭配 gralloc.drm 的修改可解決 Screenshot apps 的問題。但 Teamviewer 仍不行。

# 2017-05月报

## 月小结：

黄志伟加入system组，对硬件适配，openthos系统支持，硬解码，android-7.1准备，模拟器支持等方面做了大量的工作，取得了很好的成果。
王建兴同时参与sec组和系统组，事务比较繁杂，涉及appstore/oto server端，boot, 外接视频支持，系统崩溃bug的fix，硬盘复制等，较好地完成了安排的工作。肖络元的事务比较繁杂，参与了多节点/多版本的openthos repos版本维护与管理，理解与分析硬解码，模拟器支持，多窗口支持, android-7.1， usb mount/unmount等等工作，较好地完成了安排的工作。下月

## 下月计划：

重心将转入android-x86-7.1/openthos，并进一步解决android-x86-5.1/openthos中潜在的系统bug。
- 第一周：请黄志伟，肖络元，王建兴能够对android-7.1的编译，运行，安装，配置等有充分的了解，能够帮助实验室其他工程师。
- 第二周：黄志伟确保android-x86-7.1/openthos在系统层面的稳定/高效运行，支持硬解码。王建兴能够在黄志伟的帮助下，跟上mesa的升级，开始了解gpu driver等，开始了解/分析/测试android-7.1/openthos的外接多屏（包括extend/mirror两种模式）。肖络元需要帮助测试组实现自动测试，希望能协助我完成kernel的自动升级测试，能够进一步完善vmware/qemu 模拟器，跟进硬解码的工作。
- 第三周：黄志伟确保android-x86-7.1/openthos在系统层面的稳定/高效运行，支持硬解码。王建兴建立脚本，可实现自动进行mesa的升级，能快速分析mesa系统的崩溃问题和性能瓶颈问题。肖络元实现vmware/qemu自动测试，能够与lkp对接，至少实现Kernel的自动升级测试，争取实现openthos图形/multiwin自动测试，能快速分析系统的崩溃问题和性能瓶颈问题。
- 第四周：根据前三周的进展进行调整。

## 个人月总结

## 黃志偉
1. 整合 ffmpeg stagefright-plugin + libva + vaapi 至 OPENTHOS 與 Android-x86 7.1，解決穩定性問題。
2. 修改 Gallery2，能播放所有測試用 video files。
3. 再研究 OPENTHOS 在 VMware 的問題，修改 resolution 並更新 Mesa 解決。
4. 為 OPENTHOS 加入 QEMU virgl 的支持。
5. 適配 THTF NS4AU11，需更新 kernel 4.9 方能啟動成功。需加入 WIFI/BT firmwares。除 touchpad 外皆可使用。
6. 研究 StartupMenu 和 Fennc crashing 問題，與 Mesa 有關。改用 Mesa 13 似乎較為穩定。
7. 繼續更新 kernel 4.9.30 和 Mesa 17.1，為 7.1-rc1 release 做準備。

## 陈渝
1. 分析Linux kernel for android-x86/openthos，分析自动升级kernel的设计与实现。
2. 安排与检查各组本月工作

## 王建兴
1. 双屏显示BUG的修复
2. VMWARE的支持工作
3. OTA升级BUG的修复
4. T43/T45重启问题的调查及修复
5. SDCARD0路径隐藏的研究
6. 硬盘复制方案完成了两版的实现：基于文件的和基于扇区的方式
   目前采用更加通用的基于扇区的方案来测试硬盘复制方式
7. ntfs挂载失败的问题修复
8. 支持overlay功能实现,整理overlay FS的patch

## 肖络元
1. windows分区恢复工具，根据刘总需求修改代码，最后集成为系统应用，后根据测试组提的bug解决之；
2. 编译试验Qemu对openthos virgl 3d加速支持，分析log并测试openthos运行在qemu virgl不稳定的情况；
3. 完成对原生浏览器的disable；协助CMHuang集成fennec浏览器作为系统应用；
4. github代码同步，并向老师沟通需求，以及自动化测试相关的支持，但现有一个编译环境bug未解决；
5. 硬件编解码代码，更新并merge到主开发分支，后在原android-x86重现硬解码的移植过程；
6. openthos for VM，更新并merge到主开发分支，处理由此更新导致的应用崩溃等bug，编写该wiki文档；
7. 建立Android-x86-7.1 的开发仓库multiwindow-nougat，并分别为各位开发建立好docker开发环境，编写该文档到wiki ；
8. 准备git bisect使用文档，并发送至bigandroid mailing list，由git bisect调试图库白边bug：在播放某些视频，边上存在空白的边，已经测试月份3.13的版本，依然存在，确定是multiwindow引入的bug;

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
        
        
