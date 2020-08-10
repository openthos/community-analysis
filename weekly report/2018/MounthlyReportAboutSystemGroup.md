# 2018-12 月報
## 個人月總结
## 黃志偉
* OPENTHOS
  - 提供以 sdcard service 掛載 Pictures 等目錄的想法以及 demo code。
  - 協助更新 e2fsprogs 以支援 project quota。
  - 研究 com.tencent.tmgp.sgame 卡住問題。無具體結果，懷疑為 app 與 5.1 的相容問題(與 houdini 有關)。
  
* Android-x86
  - 完成 kernel-4.19 移植測試。
  - 加入 external/kernel-drivers project 包含
    - wl
	- rtl8723bu
	- rtl8812au
  - 更新 mesa 至 18.3.1，以及 drm_gralloc。
  - 更新 libva 和 vaapi。
  - 討論 gralloc_handle_t 的 patch 以及消除 owner member 的可行性。
  - 修改 installer 更新機制，允許升級任意名稱目錄。
  - 修改 android.cfg 支持多目錄的啟動。  
 
## 萧络元
* 云服务相关:
  - Seafile Server创建用户时的初始模板，默认创建DATA和.UserConfig；
  - 对罗浩进行seafile服务器代码修改提供帮助，包括如何编辑源代码并生效，如何在代码中插入log调试信息并打印等；
  - 协助LN和ＷZX等工程师在对seafile keeper的熟悉修改时，相关问题的技术协助，如对用户账号文件的处理逻辑，远程库列表的获取并创建键值对的逻辑；
  - Ext4 Project Quota特性在OPENTHOS的构建与应用；

* 服务器相关：
  - 天天网联tstor03服务器故障，与GYK沟通并到机房更换硬盘，然后重建tstor存储服务；
  - 与陈康老师学生FJ和WCQ沟通，对接他们对seahub的基于源码的整体结构分析，已整理出一个分析流程图 https://github.com/openthos/multiwin-analysis/blob/master/seafile/seaf-upload.png
  - 网站域名未备案而禁止访问，刘总提示HTTPS应该可用，修复之https://cloud.openthos.org；
  - 云服务server关闭共享功能，目前先把共享上传下载链接功能关闭，还需关闭所有的共享创建功能：
    1. 禁止共享库、文件夹和文件；
    2. 禁止外链共享和成员间资源共享；
    3. 禁止群组资源共享；
    4. 禁止WEB端和其他客户端的共享功能；



# 2018-11 月報
## 個人月總结
## 黃志偉

* OPENTHOS
  - 編譯 gbm_gralloc + drm_hwcomposer 完成，在 Apollo Lake 測試成功。
  - 研究 camera 崩潰 log，提出簡單 workaround 來解決。
  - 測試並解決 oto2 & oto8 在 Ubuntu 18.04 的編譯問題。寫了簡單文件。
  - 研究 GFXBench 連網問題。追出導致問題的 kernel "bad" commits。
  - 更新 oto2 bionic kernel uapi headers 並解決編譯問題。
  - 找到 kernel 4.19 加 cmdline nosmt 可避開 GFXBench 連網問題。
  - 提出簡單 kernel 補丁以解決 GFXBench 連網問題。
  
* Android-x86
  - 加入社群提供的 Silead touchscreen patch。
  - 按社群用戶建議加入更多 Cherrytrail drivers。
  - 解決 wificond 因無法取得 NL80211_STA_INFO_TX_FAILED 而無信號強度的問題。
  - 解決 AOSP prebuilt flex 在 Ubuntu 18.04 崩潰的問題。
  - 加入 Mauro mesa i915 patch 並合併 mesa 18.2.6。
  - 開始 pie-x86。

## 萧络元
* 出差乌镇互联网大会，展出RISCV OS和OPENTHOS；

* Seafile Keeper功能完成
  - 1.seafile keeper跟随系统开机启动，类似logd等守护进程;
  - 2.seafile keeper在自身启动完后，启动seafile cli客户端daemon，并监测客户端运行状态信息如PID，若发现运行不正常重启之；
  - 3.seafile keeper可对seafile cli客户端进行相应的命令操作功能，如执行命令"seaf-cli status"；
  - 4.获取客户端状态信息，如上传下载状态、传输速度、传输文件数等，把状态信息写到指定log文件，以对接应用GUI；
  - 5.首次登录时应用GUI层接收的用户账户信息，通过写到指定文件的方式，seafile keeper监听并读取该文件，以登录该账户；

* Seafile Keeper bug修复
  - 修改代码增加默认同步目录Documents和Pictures的功能；
  - seafile在/system read-only模式运行的支持；
  - 修复重复mount占用system空间的bug；
  - seafile keeper开机启动研究，并记录seafile keeper日志文件；
  - 目录/tmp不再使用777权限，而通过用seafile app的uid权限来使得app可读写文件，根据刘总需求使用tmpfs；
  - 修复seaf-cli中文字符崩溃bug;

* GFXbench提示连不上服务器,阅读LXX文档对该bug初步了解，搜集MYM同学之前对kernel bug的分析文档，并尝试从内核角度分析；

* 外网服务器，提供openthosID验证、seafile云服务和系统镜像放置
  - 协助刘老师对openthos.org网站备案；
  - 云服务server关闭共享功能，目前先把共享上传下载链接功能关闭，还需关闭所有的共享创建功能；
  - 协助马青青修改更新cloud.openthos.org/id网站的页面，她负责具体页面设计，我负责提供后台等环境问题；
  - 管理内部git、github、来广营服务器，multiwindow不涉密的源码放在github上，正等待xposed和refind源码梳理完；

# 2018-10 月報
## 個人月總结
## 黃志偉
* OPENTHOS
  - 清理 oto installer 代碼，移除重複的 cmdline。
  - 在 oto2 編譯 llvm70 branch 成功。
  - 修正 gallium_dri.so 在 oto2 不能載入的問題。
  - 合併 8.1-rc2 到 multiwindow-oreo branch。
  - 嘗試在 oto2 加入 gbm_gralloc + drm_hwcomposer，修正編譯錯誤，在 Intel Apollo Lake 測試成功。
  - 修正 system partition UUID 重複的問題。
  - 將 ABI picker patches 加入到 multiwindow branch。

* Android-x86
  - 解決 ASUS T100 用新 kernel 的藍牙問題。
  - 在 kernel 4.18 加入 Surface 3 battery patches。
  - 更新 device/generic/firmware。
  - 合併 android-8.1.0_r48 並釋出 8.1-rc2。
  - 以 git bisect 找出 Google Play Store 在 SwiftShader 不穩定的原因，是 GLES 3.0 導致。
  - 修正 9p filesystem 不能安裝 app 的問題。

## 萧络元
* 外网服务器搭建，提供openthosID验证、seafile云服务和系统镜像放置
  - 共5台服务器从搬迁到天天网联，并部署好外网IP以及cloud、git域名解析;
  - Tstor有4块硬盘损坏，联系刘老师购买新硬盘，然后写好操作说明后安排高英凯去天天网联数据中心替换硬盘；
  - 修复了云服务帐户注册，并可自动发送确认邮件；
  - 增加服务器https协议，服务器增加统一的https出口;
  - 协助MQQ修改更新cloud.openthos.org/id网站的页面，初步有版本;

* seafile相关 
  - seafile cli客户端执行程序预置到system目录的/system/linux下，权限等状态预设好，运行时的目录通过"mount --bind"方式挂在/data/data/下对应目录，请lh试验；
  - seafile客户端与服务器交互的加密方式，在征询刘总意见后，命令行使用token的形式实现;
  相比原来的变化：首次通过用户密码获取token后，之后的与服务器的交换验证操作，在token半年有效期内，可以只使用token而不需要用户密码；
  - seafile客户端增加文件上传下载提示功能，通过自动创建上传下载状态文件，达到及时把状态通知到上层app；
  状态文件内容描述：”fetch“ 库正在clone下载；“uploading” 文件正在sync上传；“downloading” 文件正在sync下载；

# 2018-09 月報
## 個人月總结
## 黃志偉
* OPENTHOS
  - 將 SwiftShader 加入到 OPENTHOS 2.0 multiwindow branch 以支持 VM。在 Qemu/VMware/VirtualBox 測試成功。
  - 關閉 mesa x86 asm 時增加 app (特別是遊戲)的相容性。
  - 分析某些遊戲不能用的原因是缺乏正確的 x86 libraries。此問題在 8.1 已有 patches，但 5.1 沒有。
  - 在 oto installer 加入安裝 system partition 的進度條。
  - 測試組發現 oto installer 無法安裝啟動項目? 找到原因並修正。
  - 與陳威討論協助 amdgpu 的支援。
  
* Android-x86
  - 更新至 android-8.1.0_r46。
  - 加入 Mauro 的 oreo-x86_llvm70_soong branch，更新 mesa 到 18.2。
  - 放棄 kernel 4.14 因為非常不穩定。改測試 kernel 4.18。大致正常，但仍有特定裝置有 regressions 需解決。
  
## 萧络元
* 从东主楼搬迁5台服务器，检查共60个硬盘，组raid，组Tstor，硬盘运行过程中不断出现损坏并重新修复部署，联系了刘老师购置新硬盘；
* 外网服务器搭建，提供openthosID验证、seafile云服务和系统镜像放置(0827)
    - 共5台服务器从搬迁到天天网联，并部署好外网IP以及cloud、git域名解析；
    - 修复了云服务帐户注册，并发送确认邮件；
    - 协助MQQ修改更新http://cloud.openthos.org/id 网站的页面；
* seafile客户端与服务器交互的加密方式，在征询刘总意见后，命令行使用token的形式实现； 
    - 相比原来的变化：首次通过用户密码获取token后，之后的与服务器的交换验证操作，在token半年有效期内，可以只使用token而不需要用户密码；

* seafile客户端增加文件上传下载提示功能，通过自动创建上传下载状态文件，达到及时把状态通知到上层app；
    - 状态文件内容描述：”fetch“ 库正在clone下载；“uploading” 文件正在sync上传；“downloading” 文件正在sync下载；

# 2018-07 月報
## 個人月總结

## 萧络元
* 佳能打印首次打开时，点击同意协议按钮会停止运行，查看logcat会扫描camera服务，底层与/dev/video相关并已修复；
* 协助罗俊欢修复chroot到ubuntu无法使用adb的bug，解决方案已经发到群里，并试验可行；
* 维护三处服务器的seafile云存储环境正常运行，有问题及时给予解决；
* 协助王之旭解决termux卡顿的问题，与dex2oat频繁出现SIGSEGV错误相关，现问题好了；
* mesa18 kernel4.17 pcmark无pcmark在跑benchmark时，运行到视频编码阶段，线程会崩溃。邮件上黄SIR提示跟RGBA_8888格式支持有关，现已经修复。
* user版编译后出现应用缺失，与img创建时的mksquashfs丢失文件有关，通过增大img空间已修复；
* 分离软件所商密代码，主要通过git rebase清除他们的代码提交；
* 故障代码服务器硬盘坏了，重建之；
* 修复dev.opentos.org的seafile服务器客户端连接失败问题；
* 基于8.1的openthos-2.0先期的部署；

# 2018-05 月報
## 個人月總结
## 黃志偉
* Android-x86：
  - 完成 7.1-r2 的釋出。
  - 完成 cm-x86 14.1-r2 的釋出。
  - 嘗試解決 oreo-x86 read-write mode 問題。嘗試多種方法，最終改回 system.img in system.sfs 的方式。
  - 合併 hwaccel-simple 至 oreo-x86，基本測試 OK。
  - Kernel 4.14.x 在某些機台仍不穩定，未能找到根本原因。
  - 加入 theme support 至 grub-efi。
  - 更新 libdrm 至 2.4.92，mesa 至 18.1.0。
  - 加入 abipicker patches 到 oreo-x86 並解決衝突。
  - 更新 libva 和 vaapi 至最新 master branch，解決 Android 編譯問題。
* OPENTHOS：
  - 解決 NVMe SSD 的安裝問題。
  - 移除 ramdisk 512MB 限制。
  - 完成 OPENTHOS 2.0 device configuration makefiles。
  - 更新 mesa 至 18.1.0。
* 其他：
  - 研究 Intel Celadon project，但 live mode 仍無法開機成功。

## 萧络元
* kernel4.15与xposed集成的试验，重现移植xposed art到openthos，重新合并由官方合并完art后问题解决；
* 对测试组发现的众多应用闪退问题，跟踪之，发现都是被xposed force stop，进而跟踪到任务管理器，它把把新安装的应用加入启动阻止列表，例如当微博新安装后，启动几秒后则被任务管理器结束。于CYR交流，解决方式是修改任务管理器app的阻止名单规则；
* kernel4.15时的应用内存占用统计，有些出现为0KB的现象，协助CYR修复，先已把任务移交给他了；
* 对于新新CPU和显卡的同方机器S1/Z2，试验了mesa13与mesa18的运行情况，并总结结果；
* 部署android8.1开发环境，给multiwindow组提供必要的支持；
* Repo代码库维护，合并security分支，讨论OPENTHOS device configuration 的修改，gcc-7.3 for Kernel的修改；
* 对samba server多目录共享以及用户列表支持,　CP邮件中提到的samba问题，都进行了修复，并重新编译，对APP端试验问题进行及时修复；
* 提高服务器编译效率，等待刘老师购的新SSD及其连接附件；图书馆空余服务器可用于各组编译服务，不过目前单个服务器空间甚至低于100G，正在构建网络存储方案。目前还在进行中；　
* Seafile云服务、OAuth验证等服务迁移到dev服务器，已迁移完成并发送使用说明邮件；
* 升级mesa18出现的解决应用崩溃：pcmark、3dmark、hpeprint问题以及微信、亚马逊购物HD、亚马逊Kindle无法登录问题；待进一步跟踪解决；目前情况定位到mesa API glGetGraphicsResetStatusEXT,且该函数入口由mesa的入口分发表动态分发。黄ＳＩＲ提供了二进制webview方案。

# 2018-04 月報
## 個人月總结
## 黃志偉
* 準備 7.1-r2：
  - 修正 kbdsensor 導致 system_server high load 問題。
  - 更新 grub-efi 64-bit 至 2.02。
  - 修正 installer 一些問題。
  - 嘗試修正 i965 導致 Google Play Service crashing。似有改善。
  - 更新 kernel 至 4.9.95，打開 cpuset 相關設定。
  - 加入 abipicker patches 以提升對 RPC apps 相容性。
  - 修正 stagefright-plugins memory leak。
  - 修正 Hyper-V legacy boot 的顯示和 mouse 問題。
  - 加入 e2label、fbset。
  - 修正 getSupportedPreviewFpsRange exception。
* 準備 8.1-rc1：
  - 更新 kernel-4.14，加入 WM5102 patches
  - 合併 android-8.1.0_r22
  - 解決 HdmiLpeAudio 在 VivoStick & Surface 3 的問題。
* OPENTHOS + Mesa 18.1：
  - 修正 llvm 6.0、mesa 18.1 編譯的諸多問題。測試可開機。

## 萧络元
* 部署校内服务器，包括seafile server, OpenthosID server, AppStore server, 系统更新Server，最后实现多网络服务统一OAuth验证;
* 同方电视按照刘总需求移植定制并刷系统;
* 辅助Launcher组解决Seafile、Samba问题:
  - 尝试了SDCARD文件同步和mount --bind sdcard特定文件夹两种方式，最后讨论决定使用mount --bind sdcard文件夹方式，时同步共享的文件都在sdcard某个目录，解决权限被随意修改的问题。
* 与可信计算交流，了解可信代码组成，创建对应分支security，并帮助解决他们遇到的一些git代码操作相关的问题;
* 根据测试组的测试结果，openthos repo 代码默认内核升到kernel-4.15;
* 为适配seafile命令行客户端进行seafile的OAuth验证，根据刘总临时方案的说法，通过同步OpenthosID OAuth和seafile server账号数据库，解决了现有的seaf-cli命令行不能使用的问题;
* [bug 2378] 设置dpi为120，从wps或微软office文档中使用打印机时崩溃。发现是应用对该dpi的资源文件缺失问题，与后端打印机无关；感谢罗浩帮忙解决并已提交代码;
* [bug 855] OTA升级启动到桌面后，显示“‘查询出错 -refreshJobs- Cups start failed’”。调查跟踪到Printer/src/com/github/openthos/printer/localprint/task/，与曹永韧合作解决并提交代码;

# 2018-01月報
## 個人月總结
## 黃志偉
* 本月主要工作為 7.1-r1 stable release 做準備，修正一些 pending issues：
  - 合併 7.1.2_r36 到 nougat-x86。
  - 修正 libgralloc_drm.so 在某些情況下的崩潰問題。
  - 修正 ASUS T100 microphone 和 backlight。
  - 改善 installer 長期存在的幾個問題：
    - 加入 efibootmgr 以建立正確的 EFI boot entry。
    - 修正安裝到 ntfs partition 無法啟動的問題。
    - 在 partition / disk selection menu 提供更多資訊。
    - 增加 grub2 savedefault 功能。
    - 加入自動安裝功能，提供三種模式。
    - 增加 advanced submenu。
    - 加入 startup.nsh 做為 fallback boot。
  - 解決 Superuser 無法儲存選擇結果的問題。
  - 解決 libsensorservice.so 崩潰的問題。
* 根據測試組測試結果，調整 default 錄音音量。
* 研究 browser benchmark view port 問題，結果與 browser 處理縮放的方式有關。
* 研究討論 display、DPI 的問題。

## 肖络元
* OPENTHOS Autotest测试系统qemu无测试bug的修复；
* OPENTHOS集成思源字体并更新相关配置，使得系统默认中文简体和繁体使用思源字体，相关的文字应用也可使用思源字体；
* kernel测试工具kAFL部署，测试最新kernel，试验bug重现功能。结合代码了解其PT相关部分，及阅读相关的论文；
* bionic相对于glibc的调研，尝试了samba的静态编译方式的移植，但未果，后基于NDK的方式编译移植，可运行但出现运行错误，调试之；
* Termux的pkg包管理机制，试验到openthos上；计划将termux集成为系统的必备组件，需选择好路线；

## 张善民

# 2017-12月报
## 個人月總结
## 黃志偉
* 本月主要任務是前往北京演講與交流培訓
  - https://github.com/openthos/system-analysis/blob/master/meeting/training-scheduling.md
  - https://drive.google.com/open?id=1-Q0uKwO9KTtc15Zlf-DbO_J_dWfdKIe4
* 繼續解決 oreo-x86 問題：
  - 完成 oreo-x86 升級到 8.1.0，重寫了新的 module loading for ueventd。
  - 解決 Bluetooth 在 8.x 的問題。
  - 加入 Camera HIDL HAL。
  - 加入新 iio-sensor-hal from 01.org。
  - 解決 mouse 無法 select listview 的 bug。

## 肖络元
* linux kernel自动化测试kAFL部署；
* 源代码的自研代码模块，添加OPENTHOS版权声明；
* openthos的HOSTNAME设置 OPENTHOS，/system目录大文件包如printer、 seafile、fennec等清理；
* autotest自动化测试系统卡住、qemu未测试等bug修改代码解决之；
* 协助CP解决seafile云服务无法使用的bug，在升级kernel4.9后，seafile使用到的proot运行错误，已修复；
* 黄SIR来京培训，学习并试验；
* ZSM入职相关事务，写关于开发环境等文档；
* 协助CYR，5.1预集成system下不可卸载APK；
* 协助CW解决xposed错误等；
* 8.0升级8.1，编译系统及HAL相关bug的试验解决；

## 张善民
* android-x86 oreo 相关工作
  - 搭建android-x86编译环境
  - 草拟培训大纲
  - 对android-x86解决方案可行性试验，编写培训总结
  - 对repo,manifest进行规范化工作（目的：形成openthos(oreo)开发起点，并与ci工具、自动测试工具对接）
  - 整理openthos(oreo)设备配置文件
* 自动测试环境的相关工作
  - 学习jenkins,beaker,lava,docker等工具的使用，编写相关文档
  - 在docker中构建基于ubuntu 16.04的jenkins master服务器
  - 分别基于物理机和docker的jenkins slave服务器
  - 完成jenkins对接，可以实现master服务器控制下的，多台build slave，多台validate slave协同工作，可自动分配build，validate任务到不同的slave，可根据任务属性和slave的硬件特征进行qemu测试和kAFL测试（kAFL部分由肖络元负责）
  - 初步实现基于jenkis的android-x86编译环境（未来可实现android自动更新，完成repo,manifest,buildsystem规范化是先决条件）

# 2017-11月報
## 個人月總结
## 黃志偉
本月繼續解決 Android-x86 8.0 的問題，包括：
* 修正 gralloc.drm 在 8.0 的問題，成功啟用 GPU 3D 硬件加速。
* 解決 audio、wifi、sensors、power 等 HAL 問題。
* 修正 Bluetooth 無法使用的問題(未完成)。
* 修正 vold 掛載 ntfs/exfat/ext4 的問題。
* 解決 video playback 問題。
* 移植 kernel 4.14 初步測試成功，但仍有不少問題如 wifi 無法使用。

Android-x86 相關：
* 釋出 cm-x86-14.1-rc1。
* 修正 gralloc.drm 綁定 /dev/dri/card0 的問題，不再依賴 fb driver 載入的次序。

# 2017-10月報
## 個人月總结
## 黃志偉
本月繼續 Android6 8.0 的移植：
* 修正 AnalyticsService 在 8.0 問題。
* 更新 libnb 到 native_bridge version 3。
* 修改 Settings About page 顯示 manufacturer、OpenGL version。
* 完成 frameworks/base 移植。

Android-x86 相關：
* 解決 7.1-rc2 pending issue 並釋出 7.1-rc2。

# 2017-09月报
## 个人月总结
## 黃志偉
本月主要工作都在 Android 8.0 的移植。
* 準備好 oreo-x86 branch 並 push 到 osdn.net。由於 8.0 的設計變更，諸多 HAL 尚無法使用。
* 研究並解決自編的 Android 8.0 emulator 不能使用的問題。
* 設計 device/generic/openthos 做為 8.0 的移植方案。
* 為 OPENTHOS emulator 加上 houdini 的支援。
* 更新 mesa 17.2 與 kernel 4.9.49，為 7.1-rc2 做準備。

# 2017-08月报
## 个人月总结
## 黃志偉
OPENTHOS 相關：
* 從 Google Play 挑選合適 OPENTHOS 的遊戲，建議放到應用商店
* 解決 3DMark 測試會卡住的問題
* 解決 vold umount 反向 unmount 多個 USB 可能卡住的問題
* 修正 vold return-local-addr bug
* 修正 ShadowSocks 在 kernel 4.9 無法使用的問題 (netd)
* 解決某些視頻因不正確的 SAR 而被錯誤拉伸的問題
* 解決 Weibo 崩潰的問題
* 分析 VLC 播放 1920x1080 H.264 視頻產生干擾條的問題，但未解決

Android-x86 7.1 相關：
* 更新至 android-7.1.2_r33
* 合併 kernel 4.9.41
* Backport nouveau patches for GTX 1060
* 解決 forced orientation mode 部分區域無法輸入的問題

開始 Android-x86 8.0 移植：
* 修改 manifest.xml，加入 include android-x86.xml
* 暫時 disable busybox, alsa-*, stagefright-plugins, mesa r600g and radeonsi, Eleven
* 解決 mesa + llvm 編譯問題
* 使用 mksquashfsimage.sh 產生 system.sfs，修改對應的 init script
* 移植 Android init patches，目前 module loading patches 尚未完成

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
        
        
