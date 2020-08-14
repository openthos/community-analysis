# 2020-08-10 ~ 2020-08-14工作总结
## 苗德行
### 本周工作
* 修改startmenu，完成startmenu中“FileManager”、"Settings"、"Power"显示及实现“power”功能
* 修复应用程序窗口全屏时被底部OpentosStatusBar覆盖问题

# 2020-08-03 ~ 2020-08-07工作总结
## 苗德行
### 本周工作
* 基于raspberry-pi-4，去除下拉菜单noticification
* 基于raspberry-pi-4，分析平台添加，并去除非必要平台menu info

# 2020-07-27 ~ 2020-07-31工作总结
## 苗德行
### 本周工作
* 基于raspberry-pi-4，分析Settings实现，并修改Settings中“About Tablet”显示openthos信息
* 基于raspberry-pi-4，去除SystemUi中“quick settings”
* 基于raspberry-pi-4，完成StartMenu的All Apps菜单与之适配

# 2020-07-20~2020-07-24工作总结
## 苗德行
### 本周工作
* 实现raspberry-pi-4从USB Driver启动
* 基于raspberry-pi-4，分析验证USB Camera
* 基于raspberry-pi-4，添加openthos平台

# 2020-07-13 ~ 2020-07-17工作总结
## 苗德行
### 本周工作
* 研究Android开机启动动画原理，并成功替换原有开机画面“ANDROID”或开机动画bootanimation
* 解决Rpi4因同步代码后无限重启问题
* 研究Rpi4从USB Driver 启动，10%

# 2020-07-06 ~ 2020-07-10工作总结
## 苗德行
### 本周工作
* 解决Rpi4无音量问题
* 升级Rpi4内核至5.4
* 同步Rpi4的Android10 代码，并基于最新源码整理StartMenu和SystemUi的patch


# 2020-06-29 ~ 2020-07-03工作总结
## 苗德行
### 本周工作
* 基于raspberry-pi-4，完成Launcher的搜索框的去除
* 基于raspberry-pi-4，完成Launcher的左右滑动页面切换的修改
* 基于raspberry-pi-4，完成Launcher的抽屉效果及所有APP界面展示的去除
* 基于raspberry-pi-4，完成Launcher的去除长按应用图标显示详细信息

# 2020-06-15 ~ 2020-06-19工作总结
## 苗德行
### 本周工作
* 分析SystemUi的启动流程以及raspberry-pi-4的Overlay原理，包括StatusBar和NavigationBar，完成StatusBar和NavigationBar的移植 
* 基于raspberry-pi-4，完成StartMenu移植 	
* 基于raspberry-pi-4，完成Launcher3的搜索框的去除


# 2020-06-01~ 2020-06-05工作总结
## 萧络元
### 本周工作
* 树莓派4试验其对UEFI的支持;rpi4的无线网络wifi功能的增加，调整kernel的80211和broadcom驱动部分，以使wpa可启动；
* 联系机房查看“超强TR246”服务器的标签的同方产品序列号，并拍照发给刘总；
* 应用商店服务器资源仓库迁移至 https://www.openthos.com/openthos/appstores/；并创建对应权限的账户提供LXX升级；
* 修复git.openthos.org的证书错误；

## 苗德行
### 本周工作
- 配置编译raspberry-pi-4对应的内核，支持USB Camera
- 基于raspberry-pi-4与WZX沟通，完成Launcher 和 FileManager
- 基于raspberry-pi-4与LXX做沟通，StartMenu目前完成10%
- 指导学生完成基于qemu的测试


# 2020-05-25 ~ 2020-05-29 工作总结
## 苗德行
### 本周工作
- 下载、编译raspberry-pi-4对应的内核及Android 10源码
- 根据raspberry-pi-4的github介绍，并与XLY沟通，完成raspberry-pi-4的镜像烧写
- 测试raspberry-pi-4的部分应用及多窗口支持
- 指导学生完成基于qemu的测试


# 2020-05-11 ~ 2020-05-15 工作总结
## 苗德行
### 本周工作
- 调研PINE64、rk3399、全志、PIPO、树梅派等开发板、笔记本，与上述产品的客服技术人员沟通，并下载对应的镜像、源码
- 与XLY、陈老师就ARM系列开发板、笔记本问题做沟通
- 参加Celadon会议
- 正在同步Android 10源码  10%
- 实现k8s master和多个物理机node的部署
  -  正在解决从k8s.gcr.io拉取镜像失败问题   60%


# 2020-05-06 ~ 2020-05-09 工作总结
## 苗德行
### 本周工作
- 实现k8s中emptyDir和hostPath，将主机的文件或目录挂载给Pod的容器使用
- 实现k8s master和多个物理机node的部署
  -  解决ubuntu使用国内镜像安装kubelet kubeadm kubectl
  -  正在解决从k8s.gcr.io拉取镜像失败问题
# 2020-04-26 ~ 2020-04-30 工作总结
## 苗德行
### 本周工作
* 实现k8s的本地存储、网络数据卷、Persistent Volume(PV)和Persistent Volume Claim(PVC)等数据据卷形式
* 研究k8s pod和容器，尝试在以单个pod的形式运行gitlab-runner
* 与刘老师和专利相关责任人做沟通

# 2020-04-20 ~ 2020-04-24 工作总结
## 苗德行
### 本周工作
* 完成minikube中docker中qemu的数据与docker共享
* 完成host 与 minikube的数据共享
* 解决了minikube中docker中运行的qemu的lkp数据compare
* 与专利相关责任人做沟通

# 2020-04-13 ~ 2020-04-17 工作总结
## 苗德行
### 本周工作
* 完成docker启动之后rc.local中相关数据处理
* 搭建minikube中vm的9p环境

# 2020-04-06 ~ 2020-04-10 工作总结
## 苗德行
### 本周工作
* 解决kernel commit 正常情况下无法拿到commit信息问题
* 解决kernel ok情况下无法获得lkp信息问题
* 完成docker 启动之后rc.local相关bug
* 正才解决docker image 与 minikube 数据共享
# 2020-03-30 ~ 2020-04-03 工作总结
## 苗德行
### 本周工作
* 完成在gitlab中“install Runner on Kubernetes”
* 基于gitlab，构建lkp在minikube中所需要的docker image（受限于image较大和网速问题，频繁测试较慢）
* 尝试实现lkp ncompare

# 2020-03-23 ~ 2020-03-27 工作总结
## 黃志偉
### 本周工作
* Fix Surface 3 audio issue
* Apply a patch to add minimize & pip buttons to freeform windows
* Enable pip feature (from BlissOS)
* Release 9.0-r2 to include recent fixes
* Study if possible to add softdep to ueventd
* kernel: r8169: fix realtek module not loaded issue

## 苗德行
### 本周工作
- 尝试在minikube中直接构建lkp环境，经多次验证不可行
  - 经多次验证，清楚minikube环境构建部分依赖本定docker，可以不用在minikube内部
- minikube中构建docker所能运行的文件系统
  - 构建编译内核所需要的文件系统
  - 构建运行lkp所需要的文件系统
- 解决minikube中docker的pull和push速度较慢
  - 搭建私有docker仓库
  - 更改已有docker仓库为国内仓库地址

# 2020-03-16 ~ 2020-03-20 工作总结
## 黃志偉
### 本周工作
* Change default resolution of virgl to fix hwcomposer crashing
* Workaround GMS crashing on 32-bit image
* Update kernel-4.19 branch to 4.19.110
* Merge aosp/android-8.1.0_r74 into oreo-x86 and release 8.1-r4
* Prepare 9.1-r2 release
* 辦公室搬家打包

## 苗德行
### 本周工作
* 就三份专利文档与专利负责人多次沟通，修改，并形成最终文档
* Minikube 启动的单节点 k8s Node 实例是需要运行在本机的 VM 虚拟机里面，底层使用 docker 容器，但是在docker容器中运行qemu无法成功运行，目前在尝试在Minikube直接部署lkp


# 2020-03-09 ~ 2020-03-13 工作总结
## 黃志偉
### 本周工作
* Use AOSP's isohybrid instead of isohybrid.pl to fix UEFI booting failure issue. (oreo-x86/pie-x86/q-x86)
* Add some quirks for Teclast devices.
* Merge aosp/android-9.0.0_r54 into pie-x86
* Merge aosp/android-10.0.0_r32 into q-x86
* Fix a bug in installer/init: avoid finding system dir too aggressive
* Add firmware of Broadcom AP6255
* Update kernel-4.19 branch to 4.19.109
* Merge mesa 19.3.5 into pie-x86

## 苗德行
### 本周工作
* 搭建build Linux kernel 的 docker image，并上传至docker hub，并解决“ docker push失败:denied: requested access to the resource is denied
”问题
* 替换minikube的docker image为最新制作build kernel image
* 在gitlab中使用最新docker image完成kernel building
* 在最新制作的docker image中启动qemu
* 与专利编写人做具体技术细节沟通

# 2020-03-02 ~ 2020-03-06 工作总结
## 黃志偉
### 本周工作
* Fix swiftshader r-b swapped issue in q-x86.
* Replace rtl8723bs_bt firmwares (reported in android-x86 list)
* Update packages/apps/Taskbar to support both portrait mode apps.
* Work on kernel-5.4 branch based on kernel/common android-5.4. (unfinished)

## 苗德行
### 本周工作
- 与专利负责人沟通专利细节，根据沟通结果更改原有文档并反馈给专利书写负责人
- 搭建kubernetes环境
  * 解决Helm之Tiller version问题
  * 完成k8s单个节点环境部署
  * 完成gitlab-runner在k8s单个节点部署
  * 完成gitlab某个project在k8s测试


# 2020-02-24 ~ 2020-02-28 工作总结
## 黃志偉
### 本周工作
* Update kernel to 4.19.105
* Update device/generic/firmware
* Update mesa to 19.3.4
* Release android-x86 9.0-r1
* Merge latest oreo-x86 into multiwindow-oreo


## 萧络元
### 本周工作
* openthos网站证书过期，更新证书；
* oto8代码库更新同步至github;
* 关于在Android-x86中移植使用MiraCast，整理好使能功能PATCH于pie-hikey970/frameworks/av提供给黄sir；
* 对于hikey970运行速度不够流畅的问题，对比了原厂的系统镜像与自编译的图形EGL情况相同：
Renderer  : Mali-G72，OpenGL ES 3.2，载入库/vendor/lib64/egl/libGLES_mali.so
滑动鼠标拖影的显示情况一致，猜测是原厂图形HAL没有完备支持； 

## 苗德行
### 本周工作
- 构建lkp开发环境
  * 完成lkp开发环境基于gitlab 与qemu 的运行
- 搭建kubernetes环境
  * 了解Kubernetes的背景，Kubernetes的安装环境、Kubernetes 基本概念
  * 完成Minikube-Kubernetes本地实验环境的构建
  * 完成Helm的环境构建
  * 完成Kuberctl的环境构建

# 2020-02-17 ~ 2020-02-21 工作总结
## 黃志偉
### 本周工作
* Android-x86
  - Settings: use DownloadManager to get native bridge libraries
  - Camera2: fix camera facing by querying characteristics
  - inputflinger: fix relative mouse movement

## 萧络元
### 本周工作
* 在测试盒子Intel NUC上，使能MiraCast功能，连接到投屏客户端跑起无线投射屏模式；
* 对Android-9无线投屏出现的“[OMX.google.h264.encoder] configureCodec returning error”，视频编码格式的问题，运行速度不够流畅比特率过低的问题，跟踪分析该模块相关代码：frameworks/av/media/libstagefright
* 与黄SIR讨论在Android-x86中移植使用MiraCast的工作；
* 根据测试组反馈，同步更新openthos仓库于github;

## 苗德行
### 本周工作
- 构建lkp开发环境
  * 构建gitlab-ci开发环境，完成Linux 内核自动编译
  * 构建qemu运行所需要rootfs
  * 构建Ubuntu邮件自动发送环境，为bisect做准备
  * 了解kubernetes
# 2020-01-13 ~ 2020-01-17 工作总结
## 黃志偉
### 本周工作
* OTO8
  - Implement per app audio volume based on media session.

* Android-x86 10
  - Fix internal pro
