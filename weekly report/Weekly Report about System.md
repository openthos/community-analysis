# 2019-12-23 ~ 2019-12-27 工作总结
## 黃志偉
### 本周工作
* OTO8
  - Analyze how to add audio volume to an app
  - Modify ConfigurationInfo in PackageInfo to add audioVolume attr.
  - Study how to change volume when an activity is activated.
  - Help analyze musl-libc linking issue.

* Android-x86 10
  - Finish porting all patches of Settings to q-x86

## 萧络元
### 本周工作
* 奇异果投屏终端支持这几种投屏模式：AirPlay、DLNA、Miracast；Android的投屏默认支持的模式是Miracast；尝试了T45 openthos5.1、Intel NUC Celadon、Pixel C 以及hikey970开发板。
* 默认情况均无法正常使用投屏显示，情况有：无投射选项、无法搜索终端设备、连接后自动重启等；
* hikey970对Miracast所需的工作：
  - 无线HAL层适配，包括wpa_supplicant运行参数的部署，配置文件p2p_supplicant.conf的添加，使能wifip2p功能；
  - WifiDisaply服务层的启动，xml文件的添加：core_hardware、wifi.direct；
  - Frameworks中的项config_enableWifiDisplay置身为true，使得设置选项中出现无投射选项；
* 现在bug：无法搜索终端设备；
 
## 苗德行
### 本周工作
* musl 和 coreutils
  - 编译musl和测试用例hello，就测试用例无法运行向HZW请教，并成功运行   100%
  - 学习了解coreutils的编译过程，使用gcc整体编译通过                100%
  - 针对coreutils中的cat命令，使用gcc分步编译，解决出现的头文件及库链接问题，测试通过    100%
  - 基于musl-libc单独编译cat，并将所出现问题与HZW进行讨论，定位问题所在，目前正在解决问题              50%
* LKP
  - 获取内核最新一次commit，并与对应版本进行比较，获取数据                          100%
  - 调研LKP的数据结果分析，确定结果分析是internal Intel analysis，需要寻求帮助，已邮件发送陈老师      100%
### 下周计划
* 基于LKP的版本回溯
* 基于musl libc 完成cat的单独编译

# 2019-12-16 ~ 2019-12-20 工作总结
## 黃志偉
### 本周工作
* OTO8
  - Analyze Android audio focus policies
  - Modify Music app to request audio focus by AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK
  - Modify AudioManager to set AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK by default
  - Explain the study of audio focus in email
* Android-x86 10
  - Apply patches of Settings to q-x86, resolve conflicts
 
### 下周计划
* Study how to add volume to PackageManager

## 萧络元
### 本周工作
* hikey970板子，AOSP 9.0搭配hikey970 bsp代码，并加入OPENTHOS多窗口等的patch，生成的系统镜像可运行到桌面，不过存在蓝牙和WIFI无法使用的bug；
* 跟踪修复了蓝牙和WIFI无法使用的bug：
  - 蓝牙在启动时，检测到kernel无CLOCK_BOOTTIME_ALARM特性时，timer_create失败，进程异常退出；发现该bug在aosp新版本代码库中已有修复patch，遂打入；
  - 之后出现bluetooth hci的初始化延时与btservice延时不匹配的问题，导致hci初始化还未来得及完成时btservice便TIMEOUT了；遂重新匹配两者延时修复之；
  - WIFI问题，先从kernel层排除了驱动为正常加载的问题，后跟踪到HAL的wpa_supplicant，发现是其启动阶段对conf文件的读取出错导致，遂重新给定正确的参数启动成功；

## 苗德行
### 本周工作
* 完成不同kernel下LKP运行的QEMU环境
* 实现kernel主版本与某一commit的compare
### 下周计划
* 对compare数据解析并实现版本回溯

# 2019-12-09 ~ 2019-12-13 工作总结
## 苗德行
### 本周工作
* 制作QEMU运行需要的文件系统并在其中搭建ruby环境
* 实现QEMU中lkp本地运行，并完成其开机启动
* 编写脚本，完成外部传参来运行指定benchmark
* 实现QEMU与主机的文件共享
### 下周计划
* 根据kernel commit完成QEMU运行的benchmark数据分析

# 2019-12-02 ~ 2019-12-06 工作总结
## 萧络元
### 本周工作
* 清华同方一台服务器，托管到来广营机房；并部署好网络和网站服务。
* musl-libc移植到openthos；配合黄Sir，配合黄Sir，以源码方式集成binutils和coreutils，util-unix。
  - 现初步在编写集成AOSP编译系统的Android.mk
* Android10的MiraCast的屏幕无线投射功能的调研与测试；
  - 初步选用Android10对Windows10和ubuntu；
* LKP benchmark运行qemu测试kernel，对结果数据进行diff分析，lkp ncompare可以对物理机不同commit内核的测试结果，可以compare到结果数据表格展示，不过对qemu的结果数据统计还待进一步匹配处理；

## 苗德行
### 本周工作
* 调研理解本机运行LKP后数据结果的解析，并与XLY讨论。
* 与XLY讨论基于qemu的LKP数据解析实现方式，目前实现方式是希望基于lkp ncompare来实现对qemu的数据解析，现在在做在qemu中搭建ruby环境

# 2019-11-25 ~ 2019-11-29 工作总结
## 萧络元
### 本周工作
* 本周LKP已经可以在QEMU虚拟机中正确跑benchmark并取得结果数据，并实现了对较多jobs的适配。同时与MDX配合连接gitlabCI；
* Hikey960开发版从源码编译arm镜像，并烧写运行Android9，目前正常进入桌面；
  - 目前BUG：网络和蓝牙不通、桌面Launcher还未移植集成进去；
* Android 9和10的开发代码的同步与编译环境的部署，并发送指南邮件；

### 下周计划
* 跟踪修复目前Android 9和10在运行上的问题：
  - 默认Car编译版本的adb问题；
  - 运行无ROOT权限问题，无ROOT会导致文件管理器某些功能无法使用，开发获取的logcat不完整；
  - 使得默认打开freeform模式，而无需手动在开发者选项勾选的问题；

## 苗德行
### 本周工作
* 完成LKP在QEMU虚拟机中正确运行benchmark并取得结果数据，并连接gitlabCI回显数据；
* 完成权限管理专利材料
* 完成lkp运行步骤文档：https://github.com/openthos/kis-analysis/blob/master/doc/lkp-test-analysis/lkp-test%E8%BF%90%E8%A1%8C%E6%AD%A5%E9%AA%A4.md
* 在lkp中添加测试用例，目前数据解析仍未完成

### 下周计划
* 学习ruby，在lkp中添加测试用例，完成数据解析

# 2019-10-21 ~ 2019-10-25 工作总结
## 萧络元
### 本周工作
* Linux Kernel Performance的代码分析和运行试验；
  - 撰写好文档：https://github.com/openthos/kis-analysis/blob/master/doc/lkp-test-analysis/Linux%20Kernel%20Performance%20tests%E8%BF%87%E7%A8%8B%E5%88%86%E6%9E%90.md
* 基于AOSP与Kernel源码模式，编译跑在Pixel C机器中，wifi和蓝牙等正常；
  - 校内代码同步地址：https://aosp.tuna.tsinghua.edu.cn/kernel/tegra
* musl-libc移植到openthos; linux-apps由LinuxFromScratch融合至android平台中，编译路径，以及运行链接相关路径的尝试；
  - 通过交流后，以交叉编译成prebuild的方式来移植到OTO8中；（80%）
  
### 下周计划
* 跟踪调试OTO8的USER版本镜像启动失败的问题；

## 苗德行
### 本周工作
* CKI调研；
  -  分析了gitlab ci 过程，撰写相关文档
*  Location权限管理，patch待提交
### 下周计划
* 本机搭建gitlab 与 runner环境

# 2019-10-08 ~ 2019-10-12 工作总结
## 萧络元
### 本周工作
* 文件管理器硬盘分区自动挂载功能；
  - 在Android自带移动盘管理中增加磁盘挂载功能的入口。（暂无新进展）
* musl-libc移植到openthos; linux-apps由LinuxFromScratch融合至android平台中，编译路径，以及运行链接相关路径的尝试；（暂无新进度）
* Android10-x86系统移植工作；
  - 同步最新Android10_r2，并初步编译通过，尝试模拟器中运行；
* 服务器的无法访问题与刘总沟通，并计划搬到来广营托管；（这几天准备处理）
* Linux Kernel Performance的代码分析和运行试验；

# 2019-09-23 ~ 2019-09-30 工作总结
## 萧络元
### 本周工作
* 文件管理器硬盘分区自动挂载功能；
  - 在Android自带移动盘管理中增加磁盘挂载功能的入口。代码分析中;
* musl-libc移植到openthos;
  - linux-apps由LinuxFromScratch融合至android平台中，编译路径，以及运行链接相关路径的尝试；
* Android10-x86系统移植工作；
  - 同步最新Android10_r2，并初步编译通过，尝试了模拟器中运行未果；
  - 从源码编译运行Android10到Intel NUC硬件，一切正常，不过默认没有houdini支持；
* 服务器的无法访问题与刘总沟通，并计划搬到来广营托管；github同步失败问题的修复，已交测试；实验室服务器暴露端口的统计管理；
* Sifive开发版借取，调试烧写OS，并邮寄出去；
* 接手ZSM离职的115服务器的工作;
* 协助WZX，在OTO8的manifest中添加DeskClock,CalendarProvider,ContactsProvider子仓库的开发分支；

# 2019-09-16 ~ 2019-09-20 工作总结
## 苗德行
### 本周情况
* 1、根据WZX的要求，修改PMS及Contacts的patch，并提交          100%
* 2、整理Fdroid的服务器搭建文档，发送给WZX                                    100%
* 3、Calendar的权限管理                                                                                 60%
### 下周计划
* 完成Calendar权限管理
* 专利书写
* 配合WZX完成Fdroid服务器搭建
## 黃志偉
### 本周情况
* 測試 Celadon Android 10 的情況
  - 基本界面較為正常，原 Android Pie 的 bugs 已修正
  - 網路無法使用，難以 debug
  - 加入 houdini 測試，失敗，無法使用
  - 加入 GMS 測試失敗，無法啟動
* 準備 q-x86 的移植 
* 更新 pie-x86 至 android-9.0.0_r48
### 下周计划
* 繼續 q-x86 的移植工作
* 釋出 pie-x86 9.0-rc0

## 萧络元
### 本周情况
* 文件管理器硬盘分区自动挂载功能；
  - 在Android自带移动盘管理中增加磁盘挂载功能的入口。代码分析中;
  - 在vold增加功能进行硬盘动态创建并挂载节点。挂载节点在VolumeManager中通过分区UUID动态mkdir()和rmdir()；
  - 目前挂载完成后无法查看文件，原因是/storage目录权限限制，手动创建的节点失效，试验在动态mkdir()创建的节点挂载有效；
* Android10-x86系统移植工作；
  - 同步最新Android10_r2，并初步编译通过，尝试了模拟器中运行未果；
* 协助DP进行seafile客户端链接本地服务器出现的mysql数据库错误问题；
* 对测试组遇到的oto2仓库与oto8仓库同步到github出现的error进行排查解决；

### 下周计划
* 文件管理器硬盘分区自动挂载功能；继续分析修改代码
* Android10-x86系统移植工作；继续
* 部署一套可运行在模拟器中的Android10代码repo，以供上层开发人员移植使用；

# 2019-09-09 ~ 2019-09-12 工作总结
## 萧络元
### 本周情况
* 文件管理器自动挂载功能；
  - 任务1,在vold增加功能进行硬盘动态创建并挂载节点;
  - 任务2,目前挂载完成后无法查看文件，原因是/storage目录权限限制，手动创建的节点失效;
* linux-apps基于LinuxFromScratch融合至android平台中，编译路径以及运行链接相关路径的解决，后续将尝试集成至AOSP源码库中编译；
* 解决实验室服务器与外网代码同步出错的bug，并与刘总确认已故障服务器的情况;

## 苗德行
### 本周情况
* 提交联系人patch，配合测试工程师完成测试              100%；
* 根据测试bug，与相关工程师就应用跳转的权限管理做出讨论，修改PMS代码，并提交patch测试    100%；
* 在应用跳转的权限管理上修改camera、audio代码，提交patch测试       100%
* 在应用跳转的权限管理上完成联系人代码修改，提交patch测试     100%

### 下周计划
* 根据测试工程师提出的问题，修改camera、audio、contacts代码
* 完成calendar权限管理

# 2019-09-02~ 2019-09-06 工作总结
## 黃志偉
### 本周情况
* 建立 external/musl/libc/Android.mk，可搭配 OPENTHOS 環境編譯 libc-musl.so 和 musl-gcc。
* 準備 Android 10 的移植。

### 下週計劃：
* 建立 BUILD_MUSL_EXECUTABLE 和 BUILD_MUSCL_LIBRARY 兩個 makefiles，以編譯 musl-libc 相關文件。
* 開始 q-x86 porting。

## 苗德行
### 本周情况
- 1、日历的权限管理 ，目前暂停，下周继续       40%
- 2、与陈老师沟通联系人权限管理需求，与刘总邮件确认联系人需求，需求还需刘总再确认     90%        
- 3、初步完成联系人权限管理，提交patch交由QJW测试             100%
- 4、完成联系人权限管理分析文档，详见日报                                  100%
### 下周计划
- 1、继续完成联系人权限管理
- 2、 完成日历权限管理

# 2019-08-26 ~ 2019-08-30 工作总结
## 黃志偉
### 本周情况
* 研究 musl-libc、LFS、alpine-linux 等相關 projects。
* 建立 external/musl/libc repo，嘗試將其 makefile 轉換成 Android.mk 以便在 OPENTHOS 環境下編譯。
### 下週計劃：
* 完成 musl-libc 的 Android.mk
* 建立基於 musl-libc 的 Android 編譯系統

## 萧络元
### 本周情况
* openthos需要一个精简的linux apps based on musl-libc;
  - 根据LinuxFromScratch，基于musl-1.1.22、Linux-4.19.36 headers、binutils-2.32、GCC-8.3.0等，现从源码构建出Cross Compiler Toolchain;
* 跟踪调试浏览器新bug: 打开outlook.com后崩溃问题;
  - CrGpuMain进程在checkCompiled时出问题:`GLSL compilation error`,`error: 'gl_LastFragData' undeclared`
  - 触发SIGABRT, 定位问题在skia/src/gpu/gl/builders/GrGLShaderStringBuilder.cpp +143
* 协助WZX解决oto-8.1代码仓库提交出现的一些error；

### 下周计划
* OPENTHOS系统上的精简的linux apps based on musl-libc，与黄一起开展此项工作；
* 跟踪调试浏览器新bug: 打开outlook.com后崩溃问题；
* 继续对各模块符合selinux的规则、编译运行问题的解决，理解selinux的policy；

## 苗德行
### 本周情况
* 完成弹窗方式对权限的管理，提交patch给WZX
  -   已完成
* 根据WZX要求做出代码修改，生成最新patch并提交WZX
  -   已完成
* 就vendor目录修改与HZW做出讨论，并根据其要求生成最新patch并提交WZX
  -   已完成
* 配合测试完成GooglePackageInstaller删除对现有系统的影响
  -   已完成
* 与张善民做出沟通，开始日历权限管理
  -  刚开始
* 完成了弹窗方式对权限的管理的分析
  -  已完成

### 下周计划
* 日历权限管理

# 2019-08-19 ~ 2019-08-23 工作总结
## 黃志偉
* 研究基於 Project Celadon cel_kbl 的 Android 9 解決方案：
  - 將 cel_kbl 由 car mode 修改為 tablet mode，移除 car 相關 components 以解決無法開進桌面的問題。
  - 測試加入 GMS，基本運作正常。但 Chrome browser 無法開啟。安裝 Firefox 可正常執行。
  - 測試加入 houdini，32-bit arm app 可正常運作。但須移除 arm64 abi 以免安裝到 arm64 app。
* SELinux enabling 卡在 neverallow rules 的修改。目前暫停，待 Android 9/10 一併解決。
* 討論並 review 權限管理相關 patches。
* 下週計劃：
  - 將 celadon 改為基於 android-x86 或 openthos style installer 以方便測試。

>>陈渝：openthos需要一个精简的linux apps based on musl-libc，请与肖一起在本周开始此项工作

## 萧络元 
### 任务情况
* 修复selinux策略文件编译时出现的如下报错，这类错误需要预先对所描述的type对象进行申明定义，代表一个对象（例如，文件、套接字）或一组对象的标签；
```
RROR 'unknown type surfaceflinger_tmpfs' at token ';' on line 22603:
ERROR 'unknown type platform_app_tmpfs' at token ';' on line 22583:
allow platform_app platform_app_tmpfs:file map;
allow platform_app device:dir { open read };
checkpolicy:  error(s) encountered while parsing configuration
```

* 在repo代码库的manifest中添加packages/apps/PackageInstaller项目，并构建对应开发分支；

### 下周计划
* 继续对各模块符合selinux的规则、编译运行问题的解决，理解selinux的policy；
* 跟踪调试浏览器新bug: 打开outlook.com后崩溃问题；
* 沟通并了解权限管理组的写代码进度情况； 

>>陈渝：openthos需要一个精简的linux apps based on musl-libc，请与黄一起在本周开始此项工作

## 苗德行
### 本周任务
* 与黄志伟就权限管理patch沟通，并根据其要求做出修改，提交最终patch与王之旭
* 在PMS中增加Location权限管理，并形成patch提交给王之旭
* 协助张善民与测试完成Location权限管理测试
* 分析PMS弹窗
### 下周计划
* 完成弹窗对权限的管理
* 增加权限管理的其他接口
* 分析电话，短信权限管理

>>陈渝：请与张一起在本周完成分析相关权限管理代码，写出分析报告并实现联系人、日历、通话记录的虚拟权限

## 张善民
### 本周工作进展：

    根据PackageManager预留的Location接口，修改了虚拟位置权限的Patch，经测试在高德地图、百度地图、搜狗地图上基本可用。
    分析了一部分ContentProvider的源码。

### 下周工作计划：

    继续分析ContentProvider的源码，尝试寻找合适的入口点，注入联系人、日历、通话记录的虚拟权限代码。

>>陈渝：请与苗一起在本周完成分析相关权限管理代码，写出分析报告并实现联系人、日历、通话记录的虚拟权限

# 2019-08-05 ~ 2019-08-09 工作总结
## 萧络元
### 任务情况
* 保证各模块符合selinux的规则、可以编译运行通过 ，分析理解selinux的policy，统计所有报错“avc: denied”，为自动生成对应的sepolicy试验规则配置工具audit2allow	
* 同步oto8代码到github	梳理好openthos修改过的仓库，并把multiwindow-oreo分支push到github，见https://github.com/openthos/OTO/blob/master/README.md
* oto8上常用应用崩溃问题协助黄sir分析，出bug的都是houdini对so库翻译有关，闭源目前也没有好的解决方法
  - 知乎
  java.lang.UnsatisfiedLinkError: dlopen failed: "/data/user/0/com.zhihu.android/lib/libDexHelper-x86.so" has unexpected e_machine: 3
  libDexHelper.so ELF32,ARM
  libDexHelper-x86.so ELF32,Intel80386
  通过删除该库的方式也无法正常。
  - 天猫
  SIGSEGV
  0020084b /system/lib/libhoudini.so

# 2019-07-08 ~ 2019-07-12 工作总结
## 萧络元
### 任务情况
* chromium浏览器集成进openthos8.1，修复浏览器BUG：进入百度贴吧后崩溃，登陆qzone崩溃，登陆126邮箱崩溃。已完成并通过测试；
* 启动界面的openthos字符串改为全部大写，完成主界面包括图片，字符串的修改，还有安装界面的efi自动生成字符串待修改
* 虚拟设备权限管理，沟通讨论并形成方案文档，研究试验了把权限表从Framework传输HAL的通信方式，同时理解GPS的底层相关代码；

## 苗德行
### 任务情况
* 研究camera的NDK业务流程，针对NDK开发，完成了camera虚拟设备权限管理
* 研究settings global的工作原理，对权限表做了安全控制
* 实现了在Framework的C++代码使用TinyXML2解析XML文件
* 虚拟设备权限管理，沟通讨论并形成方案 
# 2019-03-25 ~ 2019-03-29 工作总结
## 苗德行
### 本周计划
 * 分析PMS及AMS，在openthos8.1中添加摄像头权限管理；

# 2019-03-18 ~ 2019-03-22 工作总结
## 苗德行
### 本周计划
 * oto8：蓝牙系统底层支持
 
### 任务情况
* 目前已经明确通过消息队列，应用层->Frameworks->HAL已经开始搜索，但蓝牙底层却没有搜索到设备信息，任务已经转交XLY


# 2019-03-25 ~ 2019-03-29 工作总结
## 萧络元
### 本周计划
 * 基于musl libc，着手移植Linux GNU常用命令工具到openthos8.1；

### 任务情况

# 2019-03-18 ~ 2019-03-22 工作总结
## 苗德行
### 本周计划
*目前排除蓝牙驱动层面问题，定位到问题出现在BTA消息未到达应用层，本周计划是进一步缩小问题范围，分析BTA下的消息发送及各个子系统

# 2019-03-18 ~ 2019-03-22 工作总结
## 萧络元
### 本周计划
 * 云服务器修改成https后，登录时出现ssl.SSLException的错误提示问题；
 * 多窗口组请求device/generic/common下overlay frameworks相关文件调整到device/openthos/common；
 * oto2: 同时安装openthos和神州网信系统时，openthos的首次配置时会提示停止运行的bug
 * oto8：蓝牙系统底层支持，协助MDX对该问题的分析解决
 
### 任务情况
 * 云服务器修改成https后，登录时出现ssl.SSLException的错误提示问题；
 * 多窗口组请求device/generic/common下overlay frameworks相关文件调整到device/openthos/common。具体patch已邮件交付给LXX，反馈说功能正常；
 * 云服务器openthos.com域名问题导致的部分登录问题的处理；
 
## 张善民
### 本周计划
 * oto8：分辨率，云服务、打印移植的系统底层支持
 * 将multiwindow合并到android8.1

## 苗德行
### 本周计划
 * oto8:休眠问题
 * oto8:蓝牙系统底层问题
 
# 2019-03-11 ~ 2019-03-15 工作總結
## 萧络元
### 本周任务
* 用户手册的gitbook目录修改，自动生成并更新到网站：http://dev.openthos.org/userguide/;
* musl-libc对openthos的支持试验，已发送调研情况的邮件;
* oto8：以太网系统底层支持，试验确认系统底层有线网正常，等待UI界面的设置功能的移植；
* 工厂反馈问题161：搭配SSD安装系统时，安装界面会出现字符输出；
  - 问题161中的字符输出为安装过程中的正常提示信息，且在正常硬盘安装也是输出的，已经和无锡工厂人员说明情况，对方回复说不影响使用。
   
# 2018-12-17 ~ 2018-12-21 工作總結
## 黃志偉

## 萧络元
- cloud,dev,158多台服务的代码修改的合并；
- seafile keeper在init.rc中以late_start方式启动的试验，并邮件发出可用patch；
- seafile keeeper运行时对字符串处理的错误修复，代码已告知LXX；
- ext4 project quota可行性的调研与试验，并尝试移植了e2fsprogs和quota-tools；
- 管理内部git、github、来广营服务器；

# 2018-10-22 ~ 2018-10-26 工作總結
## 黃志偉

## 萧络元
- 外网服务器搭建，提供openthosID验证、seafile云服务，增加统一的https出口；
- 协助MQQ修改更新cloud.openthos.org/id网站的页面；
- seafile客户端增加文件上传下载提示功能，配合LH修改state文件路径，方便上层文件监听；
- 云服务server关闭共享功能，目前只把共享上传下载链接功能关闭，还需关闭所有的共享创建功能；
- tstor若干硬盘损坏，使用其他好盘替代tstor block方式修复存储,等待新硬盘；
- seafile keeper跟随系统开机启动，类似logd等守护进程,初步搭建编译与类的框架；
- seafile cli客户端执行程序预置到system目录的/system/linux下，权限等状态预设好，运行时的目录通过"mount --bind"方式挂在/data/data/下对应目录。lh试验在只读模式运行，但失败，还需进一步跟踪运行时对文件或目录的读写；

# 2018-06-25 ~ 2018-06-29 工作總結
## 黃志偉
* 本週主要研究以 clang 編譯 kernel 的方法，參考來源：https://www.linuxplumbersconf.org/2017/ocw//system/presentations/4799/original/LPC%202017-%20Clang%20built%20kernels.pdf
  - 編譯 64-bit x86_64 kernel 4.9 成功，有部分 drivers 有小錯誤，可修正。
  - Kernel 4.14 64-bit x86_64 需加入額外 patches 方能編譯成功。
  - 32-bit x86 kernel 目前仍無法編譯。
  - Kernel 4.17 或以上無法編譯成功，相關 issues 討論見：https://github.com/ClangBuiltLinux/linux/issues
* 研究 mesa 18.1 搭配 LLVM 7.0，可編譯成功。待測試。

# 2018-06-19 ~ 2018-06-22 工作總結
## 黃志偉
* 釋出 Android-x86 8.1-rc1。
* 在 camera HAL 加入 workaround 以忽略 invalid camera。
* 研究如何用 clang 編譯 kernel。修改 kernel.mk，搭配 kernel 4.9 並修改少數錯誤後測試成功。

# 2018-06-11 ~ 2018-06-15 工作總結
## 黃志偉
* 嘗試修改 drm_gralloc 支援第二個 GPU，但未成功。
* 由社群開發者 Luke 提供的 script 來更新 bootia32.efi 成功。
* 修改 short URL，加入 t.cn 以便於大陸使用者下載。
* 更新 Taskbar 到 3.9.2。
* 在 Settings 加入 Android-x86 統計選項。
* 以 quiet loglevel=0 的方式關閉 console 的 kernel messages 成功。
* 合併 android-8.1.0_r33 至 oreo-x86。
* 合併 mesa 18.1.1 至 oreo-x86。
* 更新 device/generic/firmware。

## 萧络元
* mesa18 kernel4.17在新机器s1上投影无法使用；uevent以及gralloc源码分析hdmi输出过程并进行log打印，最后发现通过重新sync代码，make clean问题好了，试验了t45和s1新笔记本；
* mesa18 kernel4.17 pcmark无法跑完，还在尝试分析解决中；
* 提高服务器编译效率，在编译服务器180和158上，安装好新SSD；图书馆空余服务器可用于各组编译服务，不过目前单个服务器空间小，还在构建大硬盘方案；　
* 服务器seafile部署到实验室局域网192.168.0.158服务器上；
* 刘总通知给用户的同方电视刷原生系统；
* 185服务器硬盘损坏，开发代码无法提交，还在解决中；

# 2018-06-04 ~ 2018-06-08 工作總結
## 黃志偉
* 修正 OPENTHOS 1.1 mesa 18.1 webview crashing 問題。
* 修正 OPENTHOS 1.1 mesa 18.1 HDMI out 問題。
* 支援 Computex 會場解說。

## 萧络元
* 提高服务器编译效率，新购SSD做bcache；图书馆空余服务器可用于各组编译服务，不过目前单个服务器空间甚至低于100G，正在构建网络存储方案；　
* Seafile云服务、OAuth验证等服务迁移到dev服务器，并已发送使用说明邮件；同时对APP组与服务器用户密码等交互的问题进行修复解决；
* 协助samba server多目录共享以及用户列表支持,　邮件中提到的samba问题，都进行了修复，并重新编译，陈鹏试验后多用户共享还有一些bug，继续源代码调试解决中；
* 升级mesa18出现的解决应用崩溃：pcmark、3dmark、hpeprint问题以及微信、亚马逊购物HD、亚马逊Kindle无法登录问题。
  - 目前黄sir提供了webview google库的方案，试验效果不错；
  - 我在继续跟踪mesa源代码，争取能走通mesa问题的关键，现在bug API glGetGraphicsResetStatusEXT地址值，通过mesa eglGetProcAddress()函数动态获得的，故之前无法从源代码搜索到，真研究与其相关的mesa的函数指针分发表机制；


# 2018-05-28 ~ 2018-06-01 工作總結
## 黃志偉
* 加入 unload second GPU driver patch，但測試後認為沒有幫助而移除。
* 合併 kernel 4.9.103 + ipts patches，但 ipts patches 導致 Baytrail 無法開機? 暫時移除。
* 加入 abipicker patches 並解決 conflicts，測試 OK。
* 更新 libva + vaapi。需更新 config_android.h，已提交 pull request 給 Intel。
* 嘗試合併陳剛 mesa vaapi patches，暫無法測試。
* 合併 kernel 4.9.105。

## 萧络元
* 为提高服务器编译效率，一个是等待刘老师购的服务器新SSD及其连接附件；一个是图书馆空余服务器用于各组编译服务，不过目前单个服务器空间甚至低于100G，正在构建网络存储方案；
* Seafile云服务迁移到dev服务器，大部分功能已迁移；Seafile-Server:　http://dev.openthos.org/ ,OAuth:　http://dev.openthos.org/id/
* 协助samba server多目录共享以及用户列表支持，对于出现的samba问题，都进行了修复，并重新编译等待，app端试验；
* 升级mesa18出现的解决应用崩溃：pcmark、3dmark、hpeprint问题以及微信、亚马逊购物HD、亚马逊Kindle无法登录问题；待进一步跟踪解决；
* 目前情况： 在webview的线程GpuThread对　来自InProcessCommandBuffer的GPU渲染命令包 进行解码时，调用GLES2DecoderImpl::WasContextLost(),再调用函数glGetGraphicsResetStatusARB()，接着会调用opengl API在glGetGraphicsResetStatusEXT()，此时再单步跟进将crash. 已定位到Mesa API glGetGraphicsResetStatusEXT，已邮件请求黄SIR帮忙；

# 2018-05-21 ~ 2018-05-25 工作總結
## 黃志偉
* OPENTHOS:
  - 完成 OPENTHOS 2.0 device configuration makefiles。
  - 更新 mesa 至 18.1.0 for OPENTHOS 1.1。

* Android-x86 8.1:
  - 更新 libdrm 至 2.4.92。
  - 更新 mesa 至 18.1.0。
  - 合併 android_8.1.0_r29，但有些奇怪的 conflicts 待解決。
  - kernel 4.14.x 的穩定性問題仍未解決。打算在 8.1-rc1 仍用 kernel 4.9。

## 萧络元
* 确保openthos1.1在S1/Z2上正常运行，对不同内核与mesa版本进行比对试验；
* Mesa18升级导致的应用崩溃：pcmark、3dmark、hpeprint，微信、亚马逊购物HD、亚马逊Kindle无法登录等问题；已定位到在创建线程new GpuInProcessThread后立即crash，原因暂未知。
* Seafile云服务网络问题分析，联系了图书管服务器管理员关于网络慢的问题，没有好的解决方法，故计划暂时用dev.openthos.org服务器,把已经部署的迁移过去；
* 讨论OPENTHOS device configuration 的修改，gcc-7.3 for Kernel的修改，并将仓库push维护到服务器；

# 2018-05-14 ~ 2018-05-18 工作總結
## 黃志偉
* OPENTHOS:
  - NVME SSD support
  - 研究 mesa 18 crashing log，但無結果。
  - 移除 data ramdisk 512MB 限制。
* Android-x86 8.1:
  - 測試將 mouse right button 改為 Back，基本上可用。
  - 加入 Intel IPTS touch driver。在 Surface Pro 4 測試可用。
  - 加入 grub theme support。
  - Kernel 4.14 似乎不穩定。研究哪些修改導致...
* 其他：
  - 繼續測試 Celadon。按照 Intel 提供的方法 enable live mode，但仍無法開機成功。
  

## 萧络元
* 为提高服务器开发效率，与各组确认模块编译方案，并与刘老师讨论购买SSD的方案；
* 确保openthos1.1在S1/Z2上正常运行,源码跟踪crash:pcmark、3dmark、hpeprint, 微信、亚马逊购物HD、亚马逊Kindle无法登录问题；
* Seafile云服务网络问题分析，查找慢的原因；
*　合并中科院开发的security分支；
* 协助samba server多目录共享以及用户列表支持，多目录共享还有问题需要调整；
* 协助黄sir进行mesa升级；


# 2018-05-07 ~ 2018-05-11 工作總結
## 黃志偉
* 在 grub android.cfg 增加 lookback iso 的支持。
* 改用 dd seek 來產生 large file，對 ext4 and ntfs 有效。
* 改用 ext4 格式的 system.img 來解決 read-write 的安裝模式問題。
* 嘗試在 OPENTHOS 加入 NVMe SSD 支援，但未測試。
* 編譯測試 Intel Celadon project，但不支援 live mode。

## 萧络元
* 协助黄SIR，升级mesa18到实验室，主要用于新i7机器与AMD机器；
* 维护dev.openthos.org服务器，解决drupal中病毒服务器被用于挖矿，ＣＰＵ占用奇高，通过整体升级已修复；
* android8.1 repo源码环境创建，docker开发环境部署好；
* 协助samba server多目录共享以及用户列表支持，编译了初步镜像给ＣＰ进行应用测试；
* 协助支持同方笔记本新CPU和显卡，现mesa13可跑在s1, Mesa18可跑在s2，不过Mesa18存在应用crash问题待解决；　

# 2018-04-30 ~ 2018-05-04 工作總結
## 黃志偉
* 釋出 7.1-r2 以修正 7.1-r1 以來發現的問題。
* 釋出 cm-x86 14.1-r2 (基於 7.1-r2)。
* 合併 7.1-r2 的修正到 oreo-x86。

## 萧络元
* kernel4.15与xposed集成的试验，重现移植xposed art到openthos，问题解决
* 对测试发现的众多应用闪退问题，跟踪之，发现都是被xposed force stop，进而跟踪到任务管理器，它把把新安装的应用加入启动阻止列表，例如当微博新安装后，启动几秒后则被任务管理器结束。于CYR交流，解决方式是修改任务管理器app的阻止名单规则
* kernel4.15时的应用内存占用统计，有些出现为0KB的现象，正协助CYR解决中。

# 2018-04-23 ~ 2018-04-27 工作總結
## 黃志偉
* 更新 kernel 4.14.35 for oreo-x86。
* 更新 kernel 4.9.95 for nougat-x86。
  - 開啟 cpuset 相關設定。
* 加入 abipicker patches 到 nougat-x86 framework。
* 加入 e2label。
* 修正 stagefright-plugins 的 memory leaks。
* 修正 Android bison 編譯新 kernel 時無法找到 m4 檔案的問題。
* 修正 7.1-r2 在 Hyper-V legacy mode 無法進入 graphic mode 的問題。

## 萧络元
* 为适配seafile命令行客户端进行seafile的OAuth验证，根据刘总临时方案的说法，通过同步OpenthosID OAuth和seafile server账号数据库，解决了现有的seaf-cli命令行不能使用的问题
* [bug 2378] 设置dpi为120，从wps或微软office文档中使用打印机时崩溃。发现是应用对该dpi的资源文件缺失问题，与后端打印机无关；感谢罗浩帮忙解决并已提交代码
* [bug 855] OTA升级启动到桌面后，显示“‘查询出错 -refreshJobs- Cups start failed’”。调查跟踪到Printer/src/com/github/openthos/printer/localprint/task/，与曹永韧合作解决并提交代码

# 2018-04-16 ~ 2018-04-20 工作總結
## 黃志偉
* 更新 grub-efi 至 2.02
* 經過多種方法嘗試，終於編出 OPENTHOS + mesa 18.1 + LLVM 6.0 image。基本測試可開機。
* 嘗試解決 Google Play service 在 nougat-x86 i965 crashing 問題。
* 更新 GMS for nougat-x86 為 7.1-r2 做準備。

## 萧络元
* 辅助应用组解决Seafile、Samba共享文件权限被应用修改的问题；
尝试了SDCARD文件同步和mount --bind sdcard特定文件夹两种方式，最后讨论决定使用mount --bind sdcard文件夹方式，时同步共享的文件都在sdcard某个目录，解决权限被随意修改的问题；
* 协助应用组关于客户端连接新Seafile server oauth验证的问题。seafile server安装刘总要求可正常oauth验证，服务端已完成；
* 与可信计算交流，了解可信代码组成，创建对应分支security，并帮助解决他们遇到的一些git代码操作相关的问题；
* 根据测试组的测试结果，openthos repo 代码默认内核升到kernel-4.15.

## 张善民

# 2018-04-02 ~ 2018-04-13 工作總結
## 黃志偉
* 更新 SwitftShader 至 4.0.3。
* 在 kernel 加入 WM5102 相關 patches。
* 更新 oreo-x86 到 android-8.1.0_r22。
* 修正 HdmiLpeAudio 導致 Surface 3 無聲的問題。
* 修正 kbdsensor 導致 system_server high load 的問題。
* 嘗試更新 grub-efi，64-bit OK 但 32-bit 未成功。

## 萧络元
* 部署校内服务器，包括seafile server, OpenthosID server, AppStore server, 系统更新Server，最后实现多网络服务统一OAuth验证。待继续
* kAFL自动化kernel测试，每天循环更新最新kernel并自动启动kAFL测试，测试结果数据的分析可视化；
测试结果数据查看：http://192.168.0.77/kafl/
* 同方电视移植定制并刷系统, 本周已还原出一个原生版本，并=周一给用户刷系统.


## 张善民

# 2018-03-26 ~ 2018-03-31 工作總結
## 黃志偉
* 在 mesa 18.1-devel 修正 i965 bug 導致的 Google Play service 崩潰。
* 在 kernel 4.14 加入 Surface 3 battery patch。
* 研究 snd-hdmi-lpe-audio 無法自動載入的問題，原因在 modalias 不 match。
* 研究如何偵測 snd-hdmi-lpe-audio 的 jack 插入。但不 reliable，放棄。測試 single_port patch 但不 work。
* 在 Settings 加入 Android-x86 的設定。
* 修正 /dev/memcg 無法掛載的問題。

# 2018-03-19 ~ 2018-03-23 工作總結
## 黃志偉
* 在 oreo-x86 測試 GMS 8.1。解決大部分問題。但 Google Play service 在 i965 driver 仍經常崩潰
* 研究以 overlayfs 解決 system partition read-write 問題，但 overlayfs 無法正確反應 lowerdir 的 selinux label。與 Red Hat 開發者討論但無具體結論。
* 更新 libdrm 2.4.91 + mesa 18.0-rc5。不過 Google Play service crashing 問題仍存在。
* 在 OPENTHOS 1.1 嘗試使用 kernel-4.14。必須 disable selinux。大致正常。

# 2018-03-12 ~ 2018-03-16 工作總結
## 黃志偉
* 研究 kernel 4.14 在 VM fail 的問題。
  - Virtual Box 已解決
  - VMware 有進展，但仍未找到解決方法
* 研究以 overlayfs 解決 read-write mode 問題，但 selinux 有問題，無法 keep selinux label。
* 更新並測試 GMS 8.1，還有許多 crashing。

# 2018-03-05 ~ 2018-03-09 工作總結
## 黃志偉
* 本週主要工作在完成 kernel-4.14 的移植與 oreo-x86 的搭配測試：
  - 合併最新 aosp/android-4.14 branch 並更新 defconfigs。
  - 加入 ASUS T100 Ubuntu group 的 kernel patches。
  - 修正 modprobe 的返回值以避免 kernel panic。
  - 修正 exec & services 未定義 security domain 的問題。
  - 更新 oreo-x86 至 android-8.1.0_r18。
  - 更廣泛的測試 kernel-4.14 在各平台的表現。目前 vbox、vmware、apollo lake 仍有問題。

# 2018-02-12 ~ 2018-03-02 工作總結
## 黃志偉
* 農曆春節
* 完成 cm-x86 14.1-r1 的釋出
* 繼續 oreo-x86 開發
  - 合併最新 nougat-x86 的修改。
  - 修正 modprobe 忽略 options 的問題。
  - 修正 superuser patches 在 oreo-x86 的衝突與編譯錯誤。
  - 研究 read-write 安裝無法啟動的原因，與 selinux 有關。還在構思解決方法。
  - 加入 nativebridge 設定到 Settings。

# 2018-02-05 ~ 2018-02-09 工作總結
## 黃志偉
* 本週完成 7.1-r1 的釋出：
  - 更新 device/generic/firmware
  - 更新 kernel 4.9.80
* 修正 auto update 可能 freeze 問題
* 修改 grub android.cfg 可啟動更多 OSes
* 更新 cm-x86 branch 並準備 cm 14.1-r1

# 2018-01-29 ~ 2018-02-02 工作總結
## 黃志偉
* 解決 libsensorservice.so 崩潰的問題。
* 加入 Advanced options 到 boot menu。
* 加入 startup.nsh 做為 UEFI 啟動的 fallback 項目。
* 研究並解決 Superuser 無法儲存選擇結果的 bug。
* 研究能否用 Firebase SDK 取代 Google Analytics SDK。沒有好的結果。
* 下週任務：
  - 準備 final 7.1-r1
  - Build Oreo image with kernel 4.15 and Mesa master

# 2018-01-22 ~ 2018-01-26 工作總結
## 黃志偉
* 本週繼續 installer 的改進，加入自動安裝功能：
  - AUTO_INSTALL=n - auto install Android-x86 to the n-th disk or /dev/$n
                       if n is a device node name. If the specified disk
                       doesn't exist, the installer will ask you to select
                       the target disk.
  - AUTO_INSTALL=force - auto install Android-x86 to the first disk
                       without any confirmation.
  - AUTO_INSTALL=update - auto update Android-x86 to the first partition
                       with label Android-x86, or the first ext4 partition
                       and install boot loader.
* 討論 DPI 與顯示的關係
* 再測試「王者榮耀」，確定在 7.1 無法運行?

# 2018-01-15 ~ 2018-01-19 工作總結
## 黃志偉
* 繼續準備 7.1-r1 relase
  - 在 installer 的選擇 disk menu 提供更多資訊。
  - 改進 grub.cfg，可啟動其它 OSes (Windows, Fedora, Ubuntu)。
  - 增加 grub savedefault 的功能。
* 研究 browser benchmark 的 view port 問題。結論與 browser 本身處理縮放的方式有關。
* 嘗試在 OPENTHOS 使用 kernel 4.14，但會 kernel panic。還要研究...

# 2018-01-08 ~ 2018-01-12 工作總結
## 黃志偉
* 本週主要準備 7.1-r1 relase
  - 修正 Baytrail micphone、backlight 等已知問題。
  - 移植 efibootmgr。
  - 在 installer 加入 efiboormgr 來建立 boot entry。
  - 修正安裝到 ntfs 無法啟動的問題。
  - 嘗試在 initrd.img 加入 fsck，但沒有 tools，暫時放棄。
* 研究如何調整錄音的音量。

# 2018-01-02 ~ 2018-01-05 工作總結
## 黃志偉
* 修正 libgralloc_drm.so 在某些情況下 crashing 的問題。
* 合併 7.1.2_r36 到 nougat-x86，測試正常。
* 測試 kernel 4.9.74 正常。
* 準備 7.1-r1 release。
* 與實驗室同仁討論並分享 makefile 的技巧。

# 2017-12-25 ~ 2017-12-29 工作总结
## 黃志偉
* 本週繼續 oreo-x86 問題：
  - 加入 Camera HIDL HAL
  - 修正 8.1 藍牙問題
  - 解決 8.1 modules 載入問題，改回單一 process 載入
  - 加入新的 iio-sensor-hal，在 Surface 3 測試成功
  - 討論 8.x listview bug，在 AOSP Gerrit 找到 patch 可解決

## 肖络元
* 源代码的自研代码模块，加上OPENTHOS版权声明；
* 调查解决android-x86 8.1的setting崩溃的原因，并发现master分支的相关patch；
* openthos的HOSTNAME设置 OPENTHOS，/system目录大文件包如printer、 seafile、fennec等清理；
* 系统自动化测试的卡住，qemu未测试等bug正在加紧修改代码解决之；

## 张善民

# 2017-12-11 ~ 2017-12-15 工作总结
## 黃志偉
* 與實驗室交流培訓
* 解決 SurfaceFlinger hwc1 bug in 8.1.

## 肖络元
* 协助CP解决seafile云服务无法使用的bug，在升级kernel4.9后，seafile使用到的proot运行错误，现已修复；
* ZSM入职相关事务，写关于开发环境等文档；
* 协助CYR，5.1预集成system下不可卸载APK；
* 协助CW解决xposed错误等；
* 8.0升级8.1，编译系统相关如Android.bp等问题的试验解决；

## 张善民

# 2017-12-04 ~ 2017-12-08 工作總結
## 黃志偉
* 本週繼續處理 oreo-x86 問題：
  - 解決 Bluetooth socket 的讀寫問題。測試數種 BT 設備(Speaker, keyboard, mouse)成功。
  - 測試 Google kernel/common android-mainline-tracking branch (4.14)，大致正常，但有些 firmware 需更新。
  - 更新 device/generic/firmware 以配合 kernel 4.14
  - 合併 android-8.1.0_r1。(未完成)
* 下週工作：
  - 繼續完成合併 android-8.1.0_r1。
  - 準備 OS2ATC 2017 演講及訓練。
    
# 2017-11-27 ~ 2017-12-01 工作总结
## 黃志偉
* 本週繼續解決 oreo-x86 剩餘問題：
  - 解決開機完成後必發的 ANR。
  - 更新 Intel libsensors HAL API 到 version to 1_3。
  - 修正 vold 無法掛載 ntfs/exfat/ext4 的問題。
  - 移植 frameworks/av 相關 patches，解決 video playback 問題。
  - 研究 Bluetooth hci command 無法寫入的問題，參考 android-ia patch 可解決。
* 下週工作：
  - 繼續解決 oreo-x86 剩下的問題，包括 camera、lights、ANR 等。
  - 建立 openthos_x86(_64) targets 以便移植。
  - 研究 kernel 4.14 的問題。

# 2017-11-20 ~ 2017-11-24 工作总结
## 黃志偉
* 本週繼續解決 oreo-x86 剩餘問題：
  - 更新 mesa 至 17.3-rc5。
  - 改用 wpa_supplicant_overlay.conf 來 disable p2p，無需刪除原本的 wpa_supplicant.conf。
  - 更新 sensors HAL API version to 1_3 以解決 sensors init failed 的問題。
  - 加入 binderized power HAL.
  - 在 init 加入 ctrl-alt-ctl 的處理，可叫出 poweroff menu。
  - 改進 drm_gralloc 尋找 drm device 的方式，不再依賴 driver 載入的順序。
* 下週工作：
  - 繼續解決 oreo-x86 剩下的問題，包括 bluetooth、camera、lights、ANR 等。
  - 研究 kernel 4.14 的問題。

# 2017-11-13 ~ 2017-11-17 工作总结
## 黃志偉
* 本週繼續解決 oreo-x86 剩餘問題：
  - 更新 mesa 至 17.3-rc3。
  - 解決 audio driver 在某些平台無法正確載入的問題。和 oreo-x86 改用 toybox modprobe 有關。改用 init 來實作 modprobe 解決(先前的做法)。
  - 解決 wifi service 無法找到 network interface 的問題，暫時 disable p2p support。
* 釋出 cm-x86-14.1-rc1 (基於 Android-x86 7.1-rc2 + LineageOS 14.1)。
  - 研究 kernel 4.9.54 在 Intel Atom N270 無法開機的問題，但無所獲。問題突然消失。
* 將 kernel-4.14 branch rebase 到 4.14 final release。測試成功。
* 下週工作：
  - 繼續解決 oreo-x86 剩下的問題，包括 sensors、bluetooth、camera、lights、ANR 等。

# 2017-11-06 ~ 2017-11-10 工作总结
## 黃志偉
* 本週在 oreo-x86 的移植上取得較重大進展：
  - 將 android.hardware.graphics.allocator 設為 passthrough mode 後 gralloc.drm 已能運作。
  - 解決 audio 問題，將 android.hardware.audio 設為 binderized mode。
  - 加入 configstore, dumpstate, media.omx, renderscript 和 usb 等 HIDL HALs。
* 下週工作：
  - 繼續解決 oreo-x86 剩下的問題，包括 wifi、sensors、bluetooth 等。

# 2017-10-30 ~ 2017-11-03 工作总结
## 黃志偉
* 繼續 oreo-x86 移植：
  - 合併先前的 Settings patches 至 oreo-x86 branch。
  - 將 ro.product.manufacturer 和 ro.product.model 移出 build.prop，由 init.sh 設定。
  - 更新 Taskbar 至最新 master branch。
  - 更新 libdrm, drm_hwcomposer, mesa 以解決 virgl 的顯示問題。
  - 研究 audio 時好時壞的問題，仍無結論。
* 測試 cm-x86-14.1 branch。遇到網路無法使用以及 built-in browser 崩潰的問題。
  - 經比對以及與社群其他開發者討論後，必須 disable dex pre-optimization。
* 下週工作：
  - 繼續 oreo-x86 移植。
  - 準備 cm-x86-14.1-rc1 release。

# 2017-10-23 ~ 2017-10-27 工作总结
## 黃志偉
* 繼續 oreo-x86 移植：
  - 在 Settings 加入 manufacturer info 和 OpenGL version。
  - 移植 frameworks/base 相關 patches。
  - 在 libnb 加入 houdini 8 的支援。
* 更新 cm-x86-14.1 branch。
* 下週工作：
  - 測試並準備 cm-x86-14.1-rc1 release
  - 繼續 oreo-x86 移植
  
# 2017-10-16 ~ 2017-10-20 工作总结
## 黃志偉
* 修正 AnalyticsService 在 Nougat/Oreo 不能發送 boot_completed event 的問題。
* 合併 HardwareCollectorService 至 AnalyticsService 以修正在 Oreo 無法執行的問題。
* 在 power events 加入 build info 以辨識是哪個版本。
* 測試 7.1-rc2 在 android-x86 list 回報的問題，基本上未能重現。
* 測試數個 apps 在 houdini 7.1 的問題。確認「王者荣耀」和「穿越火线」在 houdini 7.1 無法執行，但舊的 houdini 6 反倒可以。在 houdini 8 也可執行。
* 下週工作：
  - 解決 houdini 8 在 oreo-x86 的使用問題。
  - 移植 Settings & frameworks/base。

## 肖络元
* android-x86-8.0 repo代码及emulator根据开发需求更新;
* 同方电视的按键板调试并修正按键功能；
* 请教同方工程师，对同方电视进行openthos多窗口移植，进行到七成左右，剩余有systemUI,Launcher,Wallpaper;
* 系统组面试简历进行技术匹配筛选；

# 2017-10-02 ~ 2017-10-13 工作总结
## 黃志偉
* 釋出 Android-x86 7.1-rc2
  - 修正 gbm_gralloc 8-byte alignment 問題
  - 更新 kernel 至 4.9.54
  - 更新 mesa 至 17.1.10
  - 修正 libnb 對 houdini 7.1 的支持
* 更新 multiwindow-oreo android-8.0.0_r17
* 更新 oreo-x86 至 android-8.0.0_r17
* 下週工作：
   - 繼續 oreo-x86 porting

# 2017-09-25 ~ 2017-09-30 工作总结
## 黃志偉
* 建立 device/generic/openthos 相關 configs 為移植方案
* 繼續解決並改善 emulator image for Android 8.0：
   - 建立 openthos_emu_{x86,x86_64,arm,arm64,mips,mips64} 的 build target，上傳至代碼服務器。
   - 修正網路無法使用的問題。
   - 修正 Webview Tester 崩潰的問題。
   - 修正 Settings 崩潰的問題
   - 加入 nativebridge 支援
* 找出 vmwgfx 在 mesa 17.2 的 regression 問題並 workaround。
* 在 i915/nouveau/vmwgfx 測試 gbm_gralloc + drm_hwcomposer 並收集 logs 給 upstream developers 分析。
* 下週工作：
   - 準備 7.1-rc2 release

# 2017-09-18 ~ 2017-09-22 工作总结
## 黃志偉
* 本週嘗試編譯 emulator image for Android 8.0，但遭遇許多困難。與 Google engineer 工作幾日後，已能開進 Home。但問題仍多。見 https://issuetracker.google.com/issues/66066209
* 測試 Mesa 17.2 在各種 GPUs 使用情況。其中 vmwgfx 有問題，已 workaround。
* 嘗試 sdcardfs 以取代 fuse，但只能搭配 ext4 使用。在 tmpfs/9p 的情況下仍只能使用 fuse。
* 下週工作：
   - 準備 device/generic/openthos 做為移植 8.0 使用。
   - 準備 7.1-rc2 release

# 2017-09-11 ~ 2017-09-15 工作总结
## 黃志偉
* 本週主要繼續 oreo-x86 的移植：
   - 整理來 oreo-x86 codebase 並 push 出來
   - 修正 auto module loading 未 sync coldboot 的問題
   - 研究 init.sh 不能執行的原因，與 SELinux 有關，先跳過 SELinux 的檢查來解決
   - 移植 vold 完成。目前 USB 可掛載了。
   - 研究 Mesa 的問題，QEMU virgl (gbm_gralloc) 可用了。但 drm_gralloc 仍不行。
* 將 SwiftShader 加到 nougat-x86 取代 swrast llvmpipe。
* 移植 Mesa 17.2 到 nougat-x86。
* 移植 gptfdisk (sgdisk) 到 OPENTHOS
* 下週工作：
   - 準備 7.1-rc2 release
   - 繼續解決 oreo-x86 問題。

# 2017-08-28 ~ 2017-09-08 工作总结
## 黃志偉
* 繼續 oreo-x86 移植：
   - 重新實作 auto module loading
   - 修正一大堆編譯錯誤
   - 使用 SwiftShader 可開進桌面

* 下週工作：
   - 完善 oreo-x86 移植。
   
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
