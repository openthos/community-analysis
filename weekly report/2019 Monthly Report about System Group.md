# 2019-12 月报
## 黃志偉
### 个人月总结

## 萧络元
### 个人月总结
* LKP在QEMU虚拟机中测试kernel跑benchmark并取得结果数据，并实现了对较多jobs的适配。同时与MDX配合连接gitlabCI；
* Android 9和10的开发代码的同步与编译环境的部署，并发送指南邮件；
* 清华同方一台服务器，托管到来广营机房；并部署好网络和网站服务。
* Hikey960开发版从源码编译arm镜像，AOSP 9.0搭配hikey970 bsp代码，并加入OPENTHOS多窗口等的patch，生成的系统镜像可运行到桌面，不过存在蓝牙和WIFI无法使用的bug；
* 跟踪修复Hikey960蓝牙和WIFI无法使用的bug：
  - 蓝牙在启动时，检测到kernel无CLOCK_BOOTTIME_ALARM特性时，timer_create失败，进程异常退出；发现该bug在aosp新版本代码库中已有修复patch，遂打入；
  - 之后出现bluetooth hci的初始化延时与btservice延时不匹配的问题，导致hci初始化还未来得及完成时btservice便TIMEOUT了；遂重新匹配两者延时修复之；
  - WIFI问题，先从kernel层排除了驱动为正常加载的问题，后跟踪到HAL的wpa_supplicant，发现是其启动阶段对conf文件的读取出错导致，遂重新给定正确的参数启动成功；
* MiraCast无线投屏功能，奇异果投屏终端支持这几种投屏模式：AirPlay、DLNA、Miracast；Android的投屏默认支持的模式是Miracast；尝试了T45 openthos5.1、Intel NUC Celadon、Pixel C 以及hikey970开发板。默认情况均无法正常使用投屏显示，情况有：无投射选项、无法搜索终端设备、连接后自动重启等；
* Hikey970对Miracast所需的工作：
  - 无线HAL层适配，包括wpa_supplicant运行参数的部署，配置文件p2p_supplicant.conf的添加，使能wifip2p功能；
  - WifiDisaply服务层的启动，xml文件的添加：core_hardware、wifi.direct；
  - Frameworks中的项config_enableWifiDisplay置身为true，使得设置选项中出现无投射选项；
  - 现在bug：无法搜索终端设备；


## 苗德行
### 个人月总结


# 2019-06 月报
## 黃志偉
### 个人月总结
* 準備 8.1-r2 release
  - 加入 dummy memtrack HAL 以避免 log 報錯
  - 研究並加入 virt_wifi 以 Ethernet 模擬 wifi 功能
  - 研究更改 network interface 名稱的方法，測試過 Google rename_netiface, wireless-tools 的 ifrename。最後發現 AOSP 自帶的 ip 指令就可以改名。
  - Unload wl driver if unnecessary
  - 合併 8.1-r2 至 multiwindow-oreo
* Android-x86 9.0 pie-x86
  - 移植 mesa 19.1.x 和 master branch 至 pie-x86，解決 vulkan makefiles 諸多問題，並提交 patches 至 mesa-dev list
  - 移植 libbt-vendor 至 pie-x86，測試 Bluetooth OK
  - 更新 houdini 至 9.0.0b_y.49939
  - 研究如何更新 GMS for pie-x86

### 下月计划
* 完善 Android-x86 9.0 pie-x86
* 準備 Android Q 的移植

## 萧络元
### 个人月总结
* 将oto2的代码同步到github并可下载编译成镜像	协助测试工程师解决编译问题，已测试通过；
* openthos镜像多服务器（185,tuna,www）同步的问题的修复与后期维护；
* 调研试验android-x86以docker方式运行,学习吴天健的PPT，试验重现。已运行起docker命令行，还未看到图形;
* openthos id格式问题,首次配置时，支持以邮箱格式注册OpenthosID;
* 协助中科院ZSJ，对security分支进行代码同步编译提交等问题的解决；
* chromium浏览器集成进openthos8.1。跟踪调试浏览器BUG：长按链接后拖拽会崩溃。			
* 开会做报告等事宜；

### 下月计划
* chromium浏览器集成后，测试提出的已存浏览器BUG修复；
* ota升级功能移植，配合wzx(陈威主负责)

## 苗德行
### 本月任务
- 完善google play爬取工程，解决了下载apk无法点击和无法爬取到应用图片的问题
- fdroid调研
- 完成了fdroid服务端雏形搭建
- 解决权限管理中camera与audio input中的system property问题

### 下月计划
- 继续解决权限管理system property问题

# 2019-04 月报
## 黃志偉
### 个人月总结
* pie-x86 移植
  - 修改 libexfat 為 shared library 並加入 mount.exfat
  - 修改 enable_nativebridge 以支持 houdini 9
  - 修正 wifi 問題
  - 修正 libcamera 以支持更多 video node 含 vivid
  - 研究如何移植 Celadon 的 minigbm & iacomposer
  - 加入 disable offlining of non-boot cpus patches
* Android-x86 網站更新 (www2.android-x86.org)
  - 修改 javascript 加入 back-to-top button
  - 調整 css 形式讓頁面好看
  - Review and fix typo errors
* 其他
  - 討論虛擬設備權限控管問題，提出建議
 
### 下月计划
* 完成網站更新並轉移至新網站
* 繼續 graphic stack 改善任務

## 苗德行
### 个人月总结
- 1、移植goldfish的camera至openthos8.1，最终确认AndroidX86不支持goldfish，此方案行不通
- 2、chromium编译、测试
- 3、移植camera vivid
- 4、camera vivid 与 Android权限管理结合，目前已经基本完成，仍有优化的空间
- 5、分析Android系统的Audio子系统，并与权限管理结合，目前正在验证测试阶段

### 下月计划
- 1、完成Android的Audio子系统与权限管理的结合
- 2、将张善民的虚拟GPS加入到权限管理中
- 3、优化现有的方案

## 张善民
### 个人月总结
* fake camera
 - 讨论camera hal和carmera service控制virtual camera的问题，并形成过渡方案。
 - 协助进行ndk/java framework接口的分析。
* fake gps
 - 分析qemu ranchu的源码，可通过命名管道实现根据应用程序设置对gps hal nema数据的生成，Android位置信息有多个来源，暂时看不到效果，正在排查。
* fake ril
 - 可生成全局有效的虚拟modem
* Android X Server文档
 - 整理Android X Server文档
* device-config
 - 维护device-config，可通过一套device config生成多窗口和单窗口的镜像（还需framework/base配合，暂时通过切换project的branch实现）。
* kernel update
 - unstable升级至5.0rc1
 - stable升级至4.19.36
* aosp update
 - android-desktop-oreo-mr1升级至aosp 8.1.0 r63
 - android-desktop-pie升级至aosp 9.0.0 r33
* android init/recovery
 - 可通过vmware进行串口调试
 - 找到一台可进行串口调试的台式机
* chinamobile 全互联笔记本
 - 协调intel平台Goodix 触控板、触摸屏 Linux驱动的问题，硬件厂商的工程师已跟进
 - 协调紫光展锐的aosp源码，预计源码开通权限后，android-desktop-oreo将加入紫光展锐的支持
### 下月计划
* 

## 萧络元
### 个人月总结
* 云服务器openthos.com域名证书问题，导致登录时出现ssl.SSLException的错误，已修复。
* openthos　5.1中文件管理器查看云服务中的目录无法执行mv操作，原因在于mv命令是弱化版本，基于musl库编译gnu　mv，已修复该bug;
* openthos 8.1无法U盘启动系统的bug调试,已修复并提交patch
  - 系统启动时crash在zygote进程，该进程在尝试读取一个文件时出错。
  - 调试并打印系统log分析发现是在init初始化时的脚本，出现文件重定向错误，导致的正常文件无法被zygote正确读取。

* 应用商店后台调研。与WZX沟通计划使用PHP+MySQL的方式构建，他完成功能后，我配合他上线到服务器即可。
* oto8：权限管理方案讨论交流，并把结论整理成文档放置github;
* 国产Linux发行版测评，跑测试用例，搜集数据，并整理成规范文档；
* 撰写文档：OPENTHOS系统开发环境构建与维护项目设计文档、OPENTHOS系统支持移动存储多分区设计文档；
* 整理文档格式：Android虚拟设备权限管理技术总结报告等等；
### 下月计划
根据openthos 8.1 项目进度表：
* 基于musl libc，移植Linux GNU常用命令工具到openthos 8.1;
* 无法通过adb命令连接到其它android设备（但可以ping通）
* ota升级功能移植(陈威主负责)

