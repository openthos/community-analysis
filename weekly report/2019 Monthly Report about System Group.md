# 2019-04 月报
## 个人月总结
## 黃志偉

## 苗德行
### 工作内容
- 1、移植goldfish的camera至openthos8.1，最终确认AndroidX86不支持goldfish，此方案行不通
- 2、移植camera vivid
- 3、camera vivid 与 Android权限管理结合，目前已经基本完成，仍有优化的空间
- 4、分析Android系统的Audio子系统，并与权限管理结合，目前正在验证测试阶段

#### 下月计划
- 1、完成Android的Audio子系统与权限管理的结合
- 2、将张善民的虚拟GPS加入到权限管理中
- 3、优化现有的方案


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
