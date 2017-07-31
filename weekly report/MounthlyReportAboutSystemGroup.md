# 2017-07月报

## 个人月总结

## 黃志偉
本月工作，主要協助處理 OPENTHOS 1.0 release 問題，特別是轉移到 kernel 4.9 + mesa 13 上。
1. 解決 kernel 4.9 與 libhoudini 相衝突問題
2. 解決 VLC 無法使用 H.264 硬解的問題
3. 解決 bilibili 無法使用硬解的問題
4. 與肖络元解決某 PC 外接顯卡無畫面的問題
5. 解決 kernel 4.9 inotify 失效的問題
6. 協助測試各應用在 kernel 4.9 + mesa 13 上的情況
7. 解決某些應用在 mesa 13 會黑屏的問題
8. 解決 PCMark 測試中途會 crashing 的問題
9. 解決 VMware 無法使用 video= 來設定 resolution 的問題
10. 解決 VLC 播放某些 size 影片會 crashing 的問題

另外在 Android-x86 上則持續著重在 graphic stacks 的改善。
1. 測試 SwiftShader，效果不錯。可替代 mesa srwast llvmpipe。
2. 整合 gbm_gralloc 至 nougat-x86 codebase，virgl 可穩定運作。
3. 測試並整合 Rob Herring 的 RGBA_8888 patch。針對某些 GPU 不支持 RGBA_8888，在 RenderEngine 做 workaround。

## 萧络元
1. RTLinux相关的测试框架的建立；
2. 刷BIOS解决同方笔记本休眠唤醒问题
3. kernel4.9内核升级，出现一台同方台式机显示bug，通过参考7.1代码mirror该VGA输出解决，同时增加了VGA的双屏输出功能；
4. kernel4.9内核升级，导致的打印app添加打印机crash，通过环境变量设置修复CUPS打印系统的proot的崩溃；
5. 协助测试组进行升级kernel4.9 + mesa13的编译使用测试；
6. 协助一铭lmm，进行android repo的源码git server和docker编译环境的搭建；
7. 调试调查桌面新建文件显示刷新问题的bug，发现kernel4.9的FileObserver的onEvent()在修改了文件后偶发性无法正确回调，而kernel4.4可，确定是应用层之下的问题。最后黄SIR提供内核patch修复了该bug；
8. 实验室的repo与github的同步出现bug，主要由于framworks/base存在大文件无法上传成功，现已修复；
9. windows系统恢复APP根据刘总的需求修改代码，包括分区信息的自动识别与展示，相关流程等的修改；

# 2017-06月报
月小结：

黄志伟重点解决skylake/kabylake硬件适配问题，Android-x86 7.1的稳定性和兼容性问题 ，取得了很好的成果。 王建兴同时参与sec组和系统组，主要解决 bootloader/os/system的boot优化/美化，硬盘复制，suspend/resume等，系统安装问题。对于suspend/resume的问题，可能涉及bios和其他团队，有所延后，总体基本完成任务。有关肖络元的事务比较繁杂，参与了多节点/多版本的openthos repos版本维护与管理，windows 恢复app,usb mount/unmount，autotest等工作。总体完成了任务。有关基于lkp的autotest方面，由于系统比较复杂，进度较慢。另外，王建兴和肖络元在日常的工作日志，周报告，月报告的撰写方面，还需加强对自身的管理。对于每周的工作，与小组长等交流还不够充分。

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
    * 測試 gralloc.gbm on virgl，使用 AOSP master 可成功但 7.1 不行。可能須更新 libsync。
    * 以 Chad Versace's patches 測試 pixel format 改為 RGBA_8888，搭配 gralloc.drm 的修改可解決 Screenshot apps 的問題。但 Teamviewer 仍不行。
7. 下月计划：
    * 以 git bisect 的方式調查 libhoudini 與 kernel 的關係
    * 繼續 7.1 移植工作

### 王建兴

1.xposed框架成功在marshmallow-x86上运行，

并学习xposed从app层->framework->art层的实现；

art以前没有接触过，现在正在搜索文档看code学习其实现过程;

后续会写分析过程的文档

2.和陈威组长一起看T43睡眠时出现的黑屏，不能正常恢复的问题

目前是同方BIOS在更改这个问题

3.集成预装应用

4.G4L工具改进

5.重构OPENTHOS安装部分的代码

6.系统初次安装完毕启动时，显示壁纸不完整问题调查

7.解决安装问题，从配置好的实际电脑分区上重新生成system.img和data.img替换到原本安装镜像里面的文件

## 肖络元 
1. chyyuu/linux中建立v4.x-oto分支，patch代码maurossi/linux;
2. 针对7.1的键盘wif等失效问题，debug跟踪查找发现为模块加载问题，提供方法解决之;
3. 对于7.1的Apps的开发，建立OtoApps开发分支用于app移植；本地与github的版本的协调同步；
4. windows恢复工具android 7.1版本初步移植；
5. 针对7.1多窗口以及systemUI的代码分析修改, 对比Bliss-x86, taskbar 默认开启7.1的SystemUI Tuner和多窗口freeform支持;
6. 协助ln解决OtoCompress应用的jni部分的问题；
7. 解决Autotest测试系统的bug，调试并通过重建docker的方式解决；
8. RTLlinux进行LKP自动化测试相关的工作；
9. windows恢复工具add new feature.

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
        
        
