# 2017-08-21 ~ 2017-08-25 工作总结
## 黃志偉
* 在 nougat-x86 解決 forced orientation portrait apps 的輸入問題。
* 在 drm_gralloc 加入 Nvidia GTX 1060 的支持。但需用 kernel 4.12 以上才能成功進 SurfaceFlinger。
* 開始 Android 8.0 oreo-x86 移植
   - 重整 manifest.xml，改用 include 方式加入 x86 projects。
   - 改用 mksquashfsimage.sh 來產生 system.sfs。
   - 解決 mesa 17.2-rc4 在 oreo-x86 的編譯問題。
   - 移植 system/core 的 patches，解決衝突。
* 下週工作：
   - 繼續 oreo-x86 移植。

# 2017-08-14 ~ 2017-08-18 工作总结
## 黃志偉
* 分析並解決帶 SAR (Sample Aspect Ratio)的視頻被不正確延展的問題。
* 分析並解決 Weibo apk crashing 的問題。
* 測試 Nvidia GTX 1060 顯卡。目前 kernel 4.9 不支援，需更新 kernel & drm_gralloc。
* 研究如何解決 apps in forced orientation 輸入不正常的問題。尚未獲得最後結果。
* 解釋如何整合 Houdini，以及 Android-IA 的現況。
* 下週工作：
   - 繼續研究如何支持 Nvidia GTX 1060 顯卡
   - 繼續 prepare 7.1-rc2 release, include kernel 4.9.44
   
# 2017-08-07 ~ 2017-08-11 工作总结
## 黃志偉
* 分析並解決 ShadowSocks 在 kernel 4.9 的問題
* 測試新 OPENTHOS image，VLC 硬解應正常
* Sync cm-x86-14.1 branch and fix some issues
* 更新 nougat-x86 至 android-7.1.2_r33
* 測試 kernel 4.9.41
* 下週工作：
   - 準備 7.1-rc2 release

# 2017-07-31 ~ 2017-08-04 工作总结
## 黃志偉
* 協助解決 OPENTHOS bugs:
   - 修正 VLC 在播放 2820x1200 video 會 crashing 的問題
   - 解決 3DMark 測試會卡住的問題
   - 解決掛載多 USB disks 時可能無法缷載的問題
   - 修正 vold 可能 crashing 的 bug
   - 研究 PCMark full screen 測試卡住的問題，似和 view size 有關，但未解決
   - 分析 GFXBench T-Rex 測試的雪花問題，仍未有線索
* Android-x86 7.1-rc2 方面：
   - 加入 "DisplayManagerService: disable display blanking on suspend" patch 以改善 suspend/resume
   - 測試 ShiftShader master branch with RGB_888 patch，顏色正常。
* 測試和建議一些遊戲，放到應用商店。   

# 2017-07-24 ~ 2017-07-28 工作总结
## 黃志偉
* 繼續支援測試 kernel 4.9 + mesa 13 的工作：
   - 確認 Nvidia 以及 AMD 顯卡的支持情況：
      - https://github.com/openthos/system-analysis/blob/master/display/GPUSupport.md
   - 修正 inotify 失效的問題。
* 研究 PCMark 測試中途崩潰的問題。在 gralloc 需增加 GRALLOC_USAGE_HW_VIDEO_ENCODER 的支持，並且放寬 SoftVideoEncoderOMXComponent 對 color format 的限制。提交相關 patches。
* 解釋目前 HDMI audio 的支持情況。
* 修正 VMware 不能支持 kernel cmdline video= 來調整 resolution 的問題。
* 調查 VLC 在 media.sf.hwaccel=0 時崩潰的問題。暫時無解。
* Review ChenGang libaudio patches。
* Android-x86 7.1 graphic stack RGBA_8888 改善：
   - virgl 搭配 gbm_gralloc + drm_hwcomposer 已能穩定運作，RGBA_8888 可用。
   - i965/i915/vmwgfx 搭配 RGBA_8888 patch 可運作
   - r600g 搭配 RGBA_8888 畫面花掉
   - nouveau 尚未測試
* 下週工作：
   - 繼續 7.1 工作 graphic stack 的改善測試。

## 萧络元
* 调试调查桌面新建文件显示刷新问题的bug，发现kernel4.9的FileObserver的onEvent()在修改了文件后偶发性无法正确回调，而kernel4.4可，确定是应用层之下的问题。最后黄SIR提供内核patch修复了该bug；
* 实验室的repo与github的同步出现bug，主要由于framworks/base存在大文件无法上传成功，现已修复； 
* windows系统恢复APP根据刘总的需求修改代码，包括分区信息的更加只能识别与展示，相关流程等的修改； 

# 2017-07-17 ~ 2017-07-21 工作总结
## 黃志偉
* 本週工作比較雜，主要支援升級 kernel 4.9 + mesa 13 的工作
   - 與肖络元討論某台式機不能跑 kernel 4.9 的問題。發現顯示多了 eDP-1。建議移植 7.1 gralloc.drm 的多屏顯示代碼過來。肖络元測試成功。
   - 測試內置 apps 並回報給測試組，並應測試組要求測試更多 apps，大多數正常，少數應用有黑屏問題。移植 mesa 17.1 的修正過來解決。
   - 測試央視影音(cn.cntvhd)，查看 log 確定沒有使用硬解。在 Nexus 7 也一樣，應是 app 本身設計問題。
   - Back-port frameworks/base 7.1 對於新 kernel 的修正，以解決無法設置時鐘的問題。
* 更新 nougat-x86 至 android-7.1.2_r27 (security update 2017-07-05)
* 提交 libdrm 兩個 patches 以及 mesa 一個 patch 給 upstream，解決 Android build break。
* 測試 SwiftShader，在 QEMU 效能確實不錯，比 mesa swrast llvmpipe 好些。可考慮取代 swrast llvmpipe。
* 下週工作：
   - 繼續 7.1 工作
  
## 肖络元
* kernel4.9内核升级，导致一台同方台式机显示bug，通过参考7.1代码mirror该VGA输出解决，同时增加了VGA的双屏输出功能； 
* kernel4.9内核升级，导致的打印app添加打印机crash，通过环境变量设置修复CUPS打印系统的proot的崩溃； 
* 升级mesa13  kernel4.9的编译使用测试； 
* 协助一铭lmm，进行android repo的源码git server和docker编译环境的搭建；
* 学习陈刚的ubuntu+openthos双系统切换的报告； 


# 2017-07-10 ~ 2017-07-14 工作总结
## 黃志偉
* 測試 GLFBench，在 OPENTHOS 可重現雪花問題。但在 android-x86 5.1, 6.0, 7.1 以及 Remix OS 2.0, 3.0 測試均正常。
* 研究 VLC 和 bilibili 無法使用 hw codecs 的問題。
   - 加入 codec profile levels 可解決 VLC 使用 hw h264 codec 問題。
   - 修改 codec 名稱並在 frameworks/av 做 workaround 可解決 bilibili 的問題。
   - 上傳 openthos-k49-oto-8.img 以供測試。
* 繼續研究改良 graphic stacks 的方法。加入 RGBA_8888 patches 後，在 i965 & virgl 可正常顯示。但在 Nvidia 會有紅藍顏色交換的問題。在 AMD 則畫面整個亂掉。
* 下週工作：
   - 繼續調查 GFXBench GL 在 Apollo Lake 平台的問題。
   - 整合 gbm_gralloc。

# 2017-07-03 ~ 2017-07-07 工作总结
## 黃志偉
* 以 git bisect 研究 libhoudini 崩潰問題。找到問題 commit 並 revert，測試正常。上傳 openthos-k49-oto-7.img 以供測試。
* 繼續研究新 graphic stacks。成功在 virgl 使用 Rob Herring 的 gralloc.gbm 以及 hwcomposer.drm。較穩定但仍有不少 bugs。在 i965 測試則失敗。
* 測試 NS4AU11 wifi 問題。在 Windows 也訊號不良。疑是硬件問題。
* 下週工作：
   - 調查 GFXBench GL 在 Apollo Lake 平台的問題。

# 2017-06-26 ~ 2017-06-30 工作总结
## 黃志偉
* 繼續研究 QQ、Wechat 崩潰問題。Kernel 4.4 搭配 mesa 13.0 無崩潰。結論應與 mesa 13.0 無關，而是 kernel 4.9 與 libhoudini 相容問題。
* 研究 USB power management。確認 kernel 並未 enable autosuspend by default。手動 enabled 可用。提供測試方法。
* 測試 Chad Versace (Chromium developer) RGBA_8888 patches，搭配修改 drm_gralloc，可解決 Screenshot Touch app 的問題。但 Teamviewer 仍有問題。
* 以 ramoops 研究 NS4AU11 唤醒後系统重启的現象。找到 kernel panic 位置，和 "Silence NETLINK when in S3" patch 有關。Revert 後就未再發生唤醒後重启的現象。上傳 openthos-k49-oto-6.img 以供測試。
## 王建兴
1.重构OPENTHOS安装部分的代码  
2.系统初次安装完毕启动时，显示壁纸不完整问题调查  
3.解决安装问题，从配置好的实际电脑分区上重新生成system.img和data.img替换到原本安装镜像里面的文件   
# 2017-06-19 ~ 2017-06-23 工作总结
## 黃志偉
* 研究 7.1 無法讓 app 進入 freeform mode 的問題。未找到 root cause，但有 workaround。(據說 7.1.2 才有問題)
* 與 Taskbar 作者合作，修正 Taskbar build with AOSP。已將 Taskbar 放入 7.1 codebase。
* 研究 Android-IA graphics stack，嘗試於 nougat-x86 使用。需 patch bionic, system/core, frameworks/base。
* 研究 gralloc.gdm on virgl，但 SurfaceFlinger 起不來。請教 Rob Herring，需更新 libsync。
* 研究 QQ、wechat crashing 與 mesa 13 的關係。似乎無關，而是受 kernel 4.9 的影響。
* 嘗試用 ramoops 研究 NS4AU11 resume 重啟的問題。但奇怪的是開了 ramoops 之後問題沒再複現?

## 肖络元
* 7.1多窗口进行集成taskbar和多窗口相关patch， 如tuner；
* 协助ln解决OtoCompress应用的jni部分的问题；
* 解决Autotest测试系统的bug，调试并通过重建docker的方式解决；
* 协助CWHuang，保持本地与github的版本的协调同步；
* RTLlinux进行LKP自动化测试相关的工作；

# 2017-06-12 ~ 2017-06-16 工作总结
## 黃志偉
* 請 BIOS owner 協助處理 NS4AU11 touchpad 的問題。
  - 修改後的 THTF BIOS touchpad 可用，但無法清楚區分多指，有時少一指。
  - Wifi 無法使用。
  - Suspend/resume 後 keyboard & touchpad 有時失效，以 power.x86 workaround 有改善但非 100%.
  - 換回 Thirdwave BIOS，較 wifi 正常，但 suspend/resume 後有很高機率重啟。
* 測試 Android-IA graphics stack，搭配 nougat-x86 codebase。
  - Kernel 需換用 Android-IA 的，否則無法起來。
  - 在 Baytrail 下 Launcher3 起不來。Skylate 正常，但容易 ANR。
* 搜尋 Nougat SystemUI tunder / freeform window 資料。
## 王建兴
 * 系统背光被关掉无法重新打开问题的调查
   - 目前台湾的BIOS团队正在fix这个问题
 * 集成预装应用
   - 第一次启动时，因为预装应用比较多，系统处理繁忙，这会对系统的使用体验有影响
     如果使用pm来安装应用，合适的时间点比较难找(系统服务启动完成->第一次开机配置中间)
 * G4L工具改进
   - G4L本身支持UEFI启动；我从Android-x86上取的efi.img文件，".disk/info"文件比较特殊；
 * art内部机制学习
 * 其他工作:
    /system/build.prop问题调研
    因为Hibernate，ntfs挂载失败问题
    启动中小错误的修复
    自动安装时应用安装问题修复(还没有提交代码)
## 肖络元
* 针对7.1多窗口以及systemUI的代码分析修改
* 对比Bliss-x86, 默认开启7.1的SystemUI Tuner和多窗口freeform支持
* 与黄SIR交流，并配合他关于VM、多窗口等的工作

# 2017-06-05 ~ 2017-06-09 工作总结
## 黃志偉
* 本周繼續清理 Android-x86 7.1-rc1 最後 issues/tasks
  - Update AOSP to android-7.1.2_r17
  - Update kernel to 4.9.31
  - Update Mesa to 17.1.2
  - Update linux-firmware dir
  - Apply suspend/resume patches from youling257
  - Workaround suspend issue on T100
  - Update Chrome apk to avoid crashing on i965
  - 週四發佈正式 7.1-rc1，上傳 iso，撰寫 release note。
* 在 OPENTHOS 加入視頻畫質改善的修正。
* 更新 NS4AU11 testing image，加入 GMS。

## 肖络元
* chyyuu/linux中建立v4.x-oto分支，patch代码maurossi/linux
* 帮助软件所-初 建立openthos源码环境等
* 针对7.1的键盘wif等失效问题，debug跟踪查找发现为模块加载问题，提供方法解决之；
* 对于7.1的Apps的开发，与wzx协商，建立OtoApps开发分支用于app移植；
* windows恢复工具7.1版本初步移植；

# 2017-05-31 ~ 2017-06-03 工作总结
## 黃志偉
* 準備 Android-x86 7.1-rc1 release
  - Update kernel to 4.9.30
  - Update Mesa to 17.1.1
  - Fix kernel OOPS on Surface 3 by optimizing performance instead of size
  - Update ffmpeg, vaapi, libdrm, ntfs-3g, bluez to latest upstream master branch
  - Update GMS to 7.1.2
  - Workaround Youtube playback green screen on Chrome
  - Disable Bluetooth by default and fix crashing on VMware
* 測試 OPENTHOS 在新 NS4AU11 with ELAN touchpad 並安裝。需手動修改 BIOS 才能啟動。
## 王建兴
  本周主要进行sec组任务，暂无System组任务  
  https://github.com/openthos/community-analysis/blob/master/weekly%20report/Weekly%20Report%20about%20sec.md
## 肖络元
1. 建立Android-x86-7.1的源码repo和docker代码编译开发环境，并分别为各位开发建立好docker；
2. 编写Android-x86-7.1文档到wiki，同时补上openthos for vmware and qemu 测试配置wiki
3. 准备git bisect使用文档，并发送至bigandroid mailing list
4. 调试图库白边bug：在播放某些视频，边上存在空白的边，已经测试三月份3.13的版本，依然存在，确定是multiwindow引入的bug

# 2017-05-22 ~ 2017-05-26 工作总结
## 黃志偉
* 加入 OPENTHOS 對 QEMU virgl 的支持。但仍不穩定。
* 測試 THTF NS4AU11，用 kernel 4.4 無法開機，改用 kernel 4.9.27 解決。提供一版 image 供測試。
* 研究 NS4AU11 touchpad 問題，用最新 kernel 4.12-rc1 仍無解。
* 修改 VMware resolution 為 1280x720 。
* 繼續修整 kernel-4.9 branch，為 7.1-rc1 做準備。
* 調查 StartupMenu & Fennec 崩潰問題。StartupMenu 可在 Mesa revert d9164fd 解決。但 Fennec 不確定和 Mesa 有關?
* 下週工作：
  * 繼續研究 Mesa 與 Fennec 的問題。
  * 繼續準備 7.1-rc1 的發佈。

## 肖络元
1. 分析log并测试openthos运行在qemu virgl不稳定的原因；
2. 编写openthos for vmware and qemu 测试文档；
3. 由原android-x86进行重现硬解码的移植过程；
4. 处理由mesa升级出现的应用卡顿崩溃、浏览器打开特定网页崩溃等bug；
5. 对于黄sir对mesa升级代码的跟踪复现；
6. 建立Android-x86-7.1 的开发仓库multiwindow-nougat

# 2017-05-15 ~ 2017-05-19 工作总结
## 黃志偉
* 調查 VMware 問題在原生 lollipop-x86 和 OPENTHOS 之間的差異。結論是與 resolution 有關。
* 修正 Mesa 17.0/17.1 在 OPENTHOS 的編譯問題。因 5.1 的 llvm 過舊，必須 disable radeonsi。
* 提供 lollipop-x86 和 OPENTHOS 的 VMware 測試用 iso。確認無誤後 push 代碼至 github。
* 協助合併 hwaccel branch，更新 manifest。
* 提供 Fennec 集成的建議，實作相關 patch。
* 下週工作：
  * 準備 7.1-rc1 的發佈

## 王建兴

## 肖络元
1. 根据刘总对windows分区恢复工具新需求修改代码，并提交给测试，集成windows系统恢复工具为系统应用；
2. 编译试验Qemu对openthos virgl 3d加速支持；
3. 完成对原生浏览器的disable；
4. 协助CMHuang集成fennec浏览器作为系统应用；
5. github代码同步，并向老师沟通需求，以及自动化测试相关的支持；
6. 修复bug 1383，windows分区恢复工具的首次启动黑色。

# 2017-05-08 ~ 2017-05-12 工作总结
## 黃志偉
* 繼續清理 ffmpeg & stagefright-plugins makefiles & warnings
* 合併 hwaccel code 至 nougat-x86, 公告請其他 developers 試試。
* 測試 VMware with Mesa 17.0, 但鼠標依舊不穩定。
* 重新提交給 Intel libva patches，已合併 (https://github.com/01org/libva/pull/47)
* Rebase Mesa 17.1 with nougat-x86. 在不同 GPUs 測試，大致正常。
* Check and solve multiwindow-hwaccel compiling issues
* 下週工作：
  * Prepare nougat-x86 release
  * Study multiwindow framework
  * Continue study LKP

## 王建兴
1.调查超锐x700重启原因  
这台设备问题太多了些，可能机器本身就不太稳定  
2.投影仪少像素问题  
3.OTA升级失败问题解决  
4.尝试rebase到最新的kernel-4.9,解决了一些冲突问题和编译问题  
这个更加直接的办法可以是直接fetch android-x86的branch，然后rebase到最新的upstream  
5.学习mesa  

## 肖络元
1. windows分区恢复工具，合并WZX的界面代码; 重写网络下载class，之前的下载异常慢，原因未知；编写efi备份函数；
2. 刘锋windows分区恢复工具新需求：
> 地址现在还无法确定，做个配置文件先用个测试地址放着吧，需要完成定义相关的格式规范（比如适用电脑型号、系统版本win10/win8/win7、系统次要版本比如build1703,1506等、大小、MD5校验值，语言，图标url等等）
3. 根据刘总新需求修改代码并集成windows系统恢复工具为系统应用；

# 2017-05-02 ~ 2017-05-05 工作总结
## 黃志偉
       1、 Intel 已合併 libva 和 vaapi pull request。漏掉一小個 patch，再 push 並送 pull request。

       2、 更新 ffmpeg 至 master branch。有較佳的 hwaccel 支持和穩定性。
       
       3、 繼續 debug stagefright plugins。將 thread_count 改為 1 有助於解決 crashing。
       
       4、 在 github 記錄 debug ffmpeg & libva 的方法。
       
       5、 測試以 mainline kernel 搭配 nougat-x86 編譯成功。說明測試方法。
       
       6、 下週工作：
       
              a. Study Intel's libstagefrighthw implementation
              
              b. Try to enable Intel QSV in ffmpeg
              
              c. Study LKP & test script
              
## 王建兴
本周总结:  

    1.机器稳定性问题
    T43现在稳定性良好，超锐x700的问题比较棘手，正在调查中
    T43的patch也已经向upstream询问过了，目前代码可以解决这个问题
    2.志伟的硬解码分支代码同步问题,并测试。目前还没有机会深入分析原理  
    3.向王之旭提供prime95工具,支援工厂测试工具
    4.磁盘分区方案完成
    
下周计划:
    
    1.超锐机器的唤醒问题
    2.学习志伟的硬解码工作
    
 
## 肖络元
1. 主要windows分区恢复工具功能的修改与增加，包括分区信息的自动扫描，efi分区的识别与还原等
2. follow硬件编解码代码,并跟踪最新更新到分支multiwindow-hwaccel
    
# 2017-04-24 ~ 2017-04-28 工作总结
## 黃志偉
       1、 按照 Intel 要求更新 libva 和 vaapi 並送新的 pull request。
       2、 完成 ffmpeg stagefright plugins 整合到 OPENTHOS。
       3、 提供 LKP 在 Android-x86 on QEMU 的測試建議。
       4、 協助檢查 jni build error 的 log 並提供意見。
       5、 下週工作：
              a. 繼續 debug stagefright-plugins unstable issue
              b. 研究 LKP 並提供測試 script。
       
## 王建兴      
       1、 T43机器休眠问题的初步解决

## 肖络元
1. 接手xhl的window分区恢复工具代码，试编译运行之；
2. 询问刘总关于该工具的具体需求，说界面需重新美观设计，以及增加efi分区部分的恢复；界面部分请求的王之旭协助，但可能他们时间有限无暇估计这边。
3. 协助ln解决修复jni的编译错误，ndk已编译通过；
4. follow硬件编解码代码,同步到实验室并建立了对应的分支multiwindow-hwaccel

## 陈威
       1、 
       2、 
       3、 

# 2017年04月17日-04月21日
## 本周总结
### 黄志伟
1. 與王建兴合作研究 VMVare上鼠标问题。嘗試換到 Mesa 13.0 branch，VMVare上鼠标可顯現，但系統不穩定。
2. 提交 Mesa 13.0 相關修改至 github。寫說明文件。
3. 繼續修改 stagefright-plugins，能同時搭配 libav & ffmpeg 編譯，以便對比。
4. 研究在 libva enable vaapi 的方法，預計下週能完成。
5. 下週將嘗試把 stagefright-plugins 加到 OPENTHOS.
### 王建兴
1.调查OPENTHOS的VMVare上鼠标问题  
虽然最后mesa13可以解决这个问题,但是会导致一些应用crash.  
2.测试和调查T45上重启的问题  
缩小patch的范围来降低整体升级kernel不稳定的风险  
3.修理180服务器   
目前来看服务器重启问题不再出现  
### 肖络元
1. 针对磁盘AutoMount的FileManager部分增加fragment view，并请教处理过类似问题的罗俊欢；并且与王之旭讨论进度，他提供filemanager应用层代码，调用我提供的MountService与vold的装卸接口，先AutoMount还有一个小bug待解决；
2. 对于vmware运行openthos的patch出现的错误，协助陈鹏；给陈工的repo仓库创建给予帮助；
2. 对于androidia的硬解码编译以及其解码的错误log分析，这部分未明显进展；
### 陈威
1. 给同方政府客户准备信息系统搬通州办公区的迁移方案
2. OVERLAY FS将基于shell的命令整合到app时，遇到字符串处理问题，写了java的字符串处理程序
3. 收到后老师转发来的与软件所的合同模板，完成合同技术部分
# 2017年04月10日-04月14日
## 本周总结
### 王建兴
1.调查T43的睡眠唤醒问题  
已经知道了原因,但是目前还没有找到最合适的方法来解决这个问题.  
2.Follow黄志伟关于OPENTHOS运行在虚拟机上的工作  
目前已经基本可以运行,但是VMvare上还存在问题  
3.Follow黄志伟关于硬解码的工作  
目前的状态和黄志伟那里保持一致,志伟仍然在修改硬解码的错误  
### 肖络元
1. 对于黄志伟要求的github代码与实验室代码保持一致的要求，
重点 梳理了旧子仓库升级的造成的update github错误，以及部分开发提交过的子仓库未上传到github，自动化更新脚本的功能增强，包括检测github外部更新等；
2. 协助chengang对android-x86的原生代码的获取以解决bug
3. Follow CWHuang的硬解码部分的ffmpeg测试；
4. 对于文件管理器的硬盘automount功能，进行分析修改filemanager的java部分
### 陈威
基于小DATA.img的U盘OVERLAY FS系统，基本完成。将在U盘启动时，自动启动一下android程序这个程序检测是否有OVERLAY DATA的分区，
1. 如有则按Overlay的方式挂载该分区。
2. 如无则询问用户是否需要永久保存数据，如果用户选择需要，则将U盘的剩余空间为用户分区并格式化。如不需要则为用户overlay一个内存空间的临时盘。  
本周因同方客户出同方客户现场及与同方总部进行一些事务交接耽误了一些时间。下周一应该可以进行集成测试。
# 2017年03月27日-04月1日
## 本周总结
### 王建兴
1.Openthos使用localtime的功能完成,并且可以重新切换使用UTC  
Openthos和windows双系统可以使用localtime  
Openthos+Linux系统,需要配置属性来使用UTC时间  
2.支援EmindOS legacy boot时字符串的遮蔽   
3.Silent boot功能完成进度80%,还有一些kernel的配置和硬盘启动时的更新时的工作需要做.  
4.follow黄志伟的硬解码工作  
### 肖络元
1.协助董鹏进行一铭版ISO的定制，包括开机启动图片定制等
2.Android多窗口的调研，并部署好代码原生5.1代码服务器提供给开发人员测试原生multiwindow
3.follow黄志伟的硬解码工作  
### 陈威
1.silent boot的工作  
2.U盘启动时的overlay fs工作  
# 2017年03月20日-03月24日
## 本周总结
### 王建兴
1.Openthos存储localtime到BIOS,基本完成  
2.xposed的尝试,因为优先级比较低暂停  
3.成功使用ramoops来抓取crash信息,但是有效范围还有待验证.  
### 肖络元
1.完成了U盘多分区的识别挂载工作  
2.着手文件管理器的硬盘AUTOMOUNT的工作  
3.对于向老师测试再次报告OTO的自动更新停止的bug，详细检测github自动更新的部分，
包括之前子仓库的创建，oto仓库的本地与github的冲突等，进行初步梳理更新相关的操作；
### 陈威
1.silent boot的工作  
2.U盘工具的重新优化  
3.用户手册中安装部分添加修改
# 2017年03月16日-03月22日
## 陈威,王建兴
- project需求分析和设计文档修订  
  安装部分修改  
系统休眠问题复现
## 肖络元
用户手册网站UserGuide网站的搭建及相应文档的修改.  
U盘LiveCD的用户数据保存方案的bug修复.
U盘多分区支持，vold部分进行测试.
对一铭的ISO，对于linux启动logo修改并编写自动化脚本
# 2017年03月13日-03月17日
## 本周总结
### 王建兴
```
1.裁剪应用
browser和下载应用，但是仍需重新议定
2.对安装时data分区的size限制取消
3.对于解压缩中文的i问题调查
4.实验室内部代码和github上rc1版拉取分支
5.更新安装user-guide
6.bug管理工具调查
```
# 2017年03月6日-03月10日
## 本周总结
### 王建兴
1.office字体的预装，app部分由wangzhixu帮忙集成到filemanager中  
2.发布镜像的裁剪工作,并拉出了专门的分支开展本次工作  
3.发布镜像中应用运行问题的调查和解决  
4.帮助yiming公司搭建开发环境  
5.帮助caoyongren搭建firefox开发环境  
6.帮助测试解决大量的实测问题  
7.openthos注册服务配置修改  
8.同方电脑休眠问题的准备工作，复现和准备工具  
# 2017年02月总结
## 王建兴
1.服务器正常运行的问题    
dev.openthos.org的证书问题,seafile问题  
185的同步问题，  
180服务器坏了，重建docker环境等问题  
2.黄志伟代码提交的同步,实验室内部ｓerver的升级    
内外部同步的问题,内部升级的问题，重新打tag问题，董鹏的flash问题等    
3.U盘系统问题   
两个方案的尝试，测试,优化；目前仍然没有好的办法克服在一般的U盘上的运行卡顿问题   
4.其他杂项问题  
drm_gralloc支持VGA接口的clone模式  
openthos下可以识别系统其他的硬盘分区，进度50%  
wps的word字体问题,进度70%  
## 肖络元  
1.调研U盘系统制作，提供了很好的思路，如整合.iso, efi支持legacy和uefi双中模式启动，类似ubuntu ISO
2.尝试移植parted工具到windows，后因编译依赖库众多等问题，更换为编译成Linux静态版本的parted试验通过
3.live方式下保存数据的工作，等待细节测试 
## 陈威  
## 主要工作  
### U盘体验版开发
1. 为openthos在livecd模式的基础新增了evaluation引导模式
2. 针对evaluation模式开发了生成工具
3. 代码做了大容量U盘的适配，fat32不支持超过32GB的分区，而作为uefi启动，fat32是必须使用的文件系统。
4. 为统一uefi及legacy展开了研究，现U盘体验版已经同时支持在两种环境下启动。
## 下一步工作  
Xposed在Android X86-64体系下的移植
# 2017年02月２7日-03月03日
## 本周总结
### 王建兴
1.U盘系统运行的测试,尝试优化的调研；但目前来看瓶颈是卡在了U盘的物理读写速度上  
2.drm_gralloc支持VGA接口的clone模式  
3.openthos下可以识别系统其他的硬盘分区，进度50%  
4.wps的word字体问题,进度70%  
## 本周计划
1.U盘启动的系统运行流畅，接近硬盘运行的效果  
2.OpenThos中FAQ清理  
检查FAQ中的问题，能够集成进入openthos中的集成到openthos中  
3.openthos库整理，openthos库的manifest目前过于混乱，重新整理以利于升级  
# 2017年02月２０日-02月２４日
## 本周工作总结
周二做出来了第一版，测试出来了一些问题;其中读写速度慢的问题最为严重，我们正在改进该问题,下周一应该可以正常使用.
## 陈威  
1.在windows上生成U盘系统工具制作;  
2.针对U盘系统做了大量测试;  
3.在windows上完成了legacy和uefi引导合一的工作  
## 王建兴  
1.不同版本的U盘系统测试，调查FAT32+image文件读写速度慢的问题  
2.seafile暴露出的一些问题调查  
3.VDI工具试用  
## 本周任务
U盘版系统的安装，bug修复，文档撰写  
VDI client管理  https://github.com/openthos/community-analysis/graphs
# 2017年02月１３日-02月１７日
## 王建兴
```
1.180服务器ｄｏｃｋｅｒ服务出现问题，修复
２．和叶雷，中科大张婵娟，陈明毅完成ｏｐｅｎｔｈｏｓ镜像同步到中科大内部源上
３．ｆｉｒｅｆｏｘ的库搭建
４．测试相关软件：电源，应用商店，终端模拟器，投影
５．检查服务器重启的问题
最近服务器的web服务总是突然stop,看到是ｓeafile出现问题导致apaches stop.
已经升级seafile到最新,运行了３６小时没有发现服务重启问题
６．配合黄志伟将openthos升级到android_5.1.1_r38,中间花了比较长时间的验证和备份工作
７.协助董鹏查找firefox-flash问题
８.升级后动项添加失败问题修复
９.和陈威一起做U盘启动，已经做出来可用的U盘安装。需要更多测试和自动化的工作
```
##　陈威
```
完成了在windows上Ｕ盘系统的制作
```
# 2017年02月6日-02月10日
## 王建兴
### 本周总结
```
1.刘总新提的问题<完成>
dev.openthos.org的https证书被修改了？之前一直使用letsencrypt提供的免费证书，工作很正常，但是这次重启之后显示证书变成了自签发证书，会导致很多客户端不正常的。
/（包括/home）是一个SSD，占用过高会影响其性能和寿命，有需要可以使用/opt
2.185代码服务器到github同步问题<完成>
  脚本的同步问题,修复
  计划搭建一个外部的代码服务器
3.user预览版的初步测试<完成>
  和eng相比,没有特别多的差异
4.180服务器修复<暂时修复好了,特别感谢陈威今天的帮助>
  SSD损坏之后影响了系统启动,修复
  docker丢失,修复
5.配合黄志伟,验证他的提交;<还没有结束>
  一个是对于media的软解码库的升级问题
  一个是houdini的升级问题
```
### 本周计划
```
新增任务:
1.刘总新提的问题
dev.openthos.org的https证书被修改了？之前一直使用letsencrypt提供的免费证书，工作很正常，但是这次重启之后显示证书变成了自签发证书，会导致很多客户端不正常的。
/（包括/home）是一个SSD，占用过高会影响其性能和寿命，有需要可以使用/opt
2.185代码服务器到github同步问题
3.user预览版的初步测试
4.用户卡顿问题(长期)
```
## 陈威
* 完成windwos版安装工具的开发  

# 2017年01月16日-01月20日
## 王建兴
### 本周总结
```
1.system vold分析文档总结
2.android-x86 nougat版本的本地化mirror
3.openthos系统实验室内部和外部github的同步(未彻底完成)
```
### 下面任务计划
```
1.鼠标卡顿/光标卡顿
```
## 陈威  
### 本周总结  
1. 撰写windows环境下，手动安装OPENTHOS的指南  
2. 研究windows的U盘多分区管理及mount（目前通过移植sgdisk能进行分区，但仍然不能格式化及mount第二分区）   
### 后续计划
1. 先提供一个单FAT32分区的安装工具  
2. 研究一下chromeos下android（包括APK及studio）的情况  

# 2017年01月09日-01月13日
## 王建兴
### 本周总结
```
1.解决U盘反复插拔问题,现在部分已经正常了  
2.U盘格式不识别问题:支持了ISO9660文件系统   
目前我们支持的格式为: vfat,ext4,ntfs,exfat,ISO9660(其他主流格式周生强会测试出一份一览表);   
```
### 下周任务计划
```
1.用户怎么分辨哪个是自己的U盘,需要加上U盘特定的Label  
2.一个U盘多个分区时Android完全不支持多分区功能
```
### 当前待完成任务
```
1.185代码服务器到github同步问题
2.多个U盘label的识别问题
3.user预览版的问题
4.用户卡顿问题(长期)

偶现的问题:
1.周生强和刘明明电脑休眠唤醒之后重启问题(目前实验室没有复现)
2.安装时的日志扰乱dialog菜单问题(目前实验室没有复现)
3.更新完成后第一次重启，升级应用完毕会卡死在“正在启动应用“处，强制关机重启后正常进入系统。(目前实验室没有复现)
```
