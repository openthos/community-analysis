# 2019-04 月报
## 个人月总结
## 黃志偉

## 苗德行
### 工作内容
- 1、移植goldfish的camera至openthos8.1，最终确认AndroidX86不支持goldfish，此方案行不通
- 2、chromium编译、测试
- 3、移植camera vivid
- 4、camera vivid 与 Android权限管理结合，目前已经基本完成，仍有优化的空间
- 5、分析Android系统的Audio子系统，并与权限管理结合，目前正在验证测试阶段

#### 下月计划
- 1、完成Android的Audio子系统与权限管理的结合
- 2、将张善民的虚拟GPS加入到权限管理中
- 3、优化现有的方案

## 张善民
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

## 萧络元
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
