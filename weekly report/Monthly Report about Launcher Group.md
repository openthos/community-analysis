# 2018-11 月报
## 王之旭
  - 云服务整体
  - Auto-Mount过滤efi分区
  - 文件管理器不显示DATA,直接进入目录
  - 云服务备份还原
## 12月计划
  - 完成云服务
  - 整理文档

# 2018-10 月报
## 王之旭
  - 完成Seafile的整体架构
  - 完成Seafile的流程图设计
  - 整理优化Seafile的代码
  - 测试Seafile的解压不完成问题
  - 测试Seafile的备份还原问题

# 2018-09 月报
## 王之旭
  - 重做seafile的备份还原
  - 整理Seafile的文档

# 2018-07 月报
## 王之旭
  - 文件管理器云服务中对其他library 的显示
  - samba 共享一个目录后切换另一个目录共享时，无法显示共享文件
  - samba目录显示重复，路径不正常
  - OTA商密算法流程验证
  - 恢复修改过的谷歌输入法，可在设置中配置
  - Termux卡顿以及使用logcat会停止运行
  - 文件管理器手机模式下显示不正常
  - Ota:手动升级校验失败
  - Termux:优化卡顿问题
  - Seafile 其他Library向上功能
  - OTA升级恢复到gnupg验签方式
  - 图片管理器升级到最新代码，解决大量bug
## 陈鹏
  - 云服务增加其他library模块
  - 云服务其他library完善（基本功能，新建，打开，下载，上传）
  - 云服务其他library完善（文件，文件夹的显示，移除特殊Library）
## 卢宁
  - 云服务：新建文件文件夹，需按enter两次才可创建成功（0627）
  - 云服务备份时选择默认未选中的app不会备份相关数据（0628）
  - 恢复配置时openthos浏览器和Termux崩溃（0628）
  - 更改服务器地址时直接选择而不是输入（0706）
  - 云服务恢复数据后，浏览器书签未恢复，bilibili停止运行
  - 云服务配置备份还原代码迁移
  - 云服务OpenthosId迁移
## 王明
  - 压缩解压缩合并（类似windows） （未完成）
## 8月工作目标
- 完善自研应用
- 完善并推广云服务
- 开始着手应用在8.1上的运行支持

# 2018-06 月报
## 王之旭
- Termux取消长按弹出上面工具栏功能
- Termux快捷键功能整合到汉堡式菜单里，并在菜单项后面注明快捷键
- Termux文本复制粘贴功能，选中复制、粘贴快捷键
- 支持新的nvme分区挂载功能
- 微信识别图片目录
- Termux复制、粘贴、剪切快捷键
- Termux崩溃后再次打开页面混乱，只能清理缓存重新打开
- Termux增加Tab窗口后，关闭Termux，再打开，Tab窗口不可见，只剩下“＋”可见
- Termux修改应用名、图标
- Termux菜单改成安卓标准的“汉堡”式菜单，菜单下面是：新建分页/选择URL/拷贝/粘贴/Reset/配色/字体/关闭分页
- Termux默认字体变小，需确定一个合理的字体大小(可能需要读取dpi设置来自动调整)
- Termux快捷键功能整合到汉堡式菜单里，并在菜单项后面注明快捷键
- Termux机器睡眠唤醒后，termux无法使用，需要关闭重新打开
- 输入exit无法退出某个tab，按回车后termux崩溃
- 禁用自研谷歌输入法，使用第三方谷歌输入法
- 去掉本地打印服务、windows系统恢复，在User版中去掉OtoVirtual
- 云服务中对其他library 的显示
## 陈鹏
- 云服务外链分享
- 云服务官方API修改移植
- 云服务增加其他library模块
## 卢宁
- seafile云服务OAUTH统一验证
- 云服务地址动态
- 云服务官方API修改移植
- 云服务注册提示失败
- 数据同步只显示waiting for sync的问题
- 云服务DATA目录状态不会刷新
- 云服务显示多个userconfig和data
## 王明
- 未完成如下任务
  - 合并文件管理器和桌面，为以后拖拽、优化代码做准备
  - Seafile其他Library界面模块
  - 压缩解压缩合并（类似windows）


# 2018-05 月报
## 王之旭
- [bug 2433] 文件管理器中复制粘贴的文件不会立即显示，需要排序才会显示
- Termux鼠标选择
- 使用Openthos
- 自研应用性能优化
- [bug 2435] 文件管理器更换壁纸导致界面混乱
- 更换默认壁纸
- openthos 1.1上使用Android Studio
- Seafile云服务注册登录修改
- Seafile云服务同步，接触同步的修改
- Seafile云服务开启停止的修改
- 重构文件管理器前进后退向上逻辑,解决大量bug

## 陈鹏
- 完善samba service用户列表
- Termux 1.drawer移动至上方并固定显示 2.Tab上增加“x”，右侧增加“+”
- 使用Openthos

## 卢宁
- 云服务状态提醒
- 解决seafile通知乱窜问题
- 使用Openthos
- seafile云服务注册、登录、使用更换为dev服务器
- seafile 无法正常使用调研
- 云服务状态提醒

## 王明
- 使用Openthos
- 合并文件管理器和桌面，为以后拖拽、优化代码做准备（完成度80%）


# 2018-04 月报
## 王之旭
  - samba client 文件名称不显示中文
  - samba client 切换网络到无线网再切回有线网后，部分设备的共享文件夹打开无内容，终端显示获取文件信息失败，也无法删除这个文件
  - seafile无法跟随系统启动而启动，data目录为空
  - seafile云服务壁纸备份与还原
  - seafile云服务wifi备份与还原
  - seafile云服务应用商店备份与还原
  - seafile云服务还原不能正常结束，第一次设置界面卡在正在从应用商店下载应用
  - seafile2405 云服务恢复应用数据后，开始菜单崩溃
  - seafile2399 云服务：第一次启动恢复各项数据，桌面壁纸拉伸
  - seafile文件管理器增加U盘格式化确定提示框，以防误操作
  - seafile首次配置不登录ID，跳过后进入系统，无法在设置中绑定帐号
  - seafile壁纸恢复的时候会产生缩放的问题
  - samba client 路径修改 
  - samba client 不显示共享文件，命令行可以看到
  - samba client 文件无法打开(部分文本可使用浏览器打开，文档、图片、视频等无法打开)
  - Seafile 文件权限(sdcard/data下限制应用修改权限)
  - OTA升级自动提醒通知不显示
  - 所有自研应用命名格式oto.xxx或者org.openthos.xxx
  - 文件管理器降低权限后，U盘不可卸载格式化的bug
  - 移除文件管理器，OTA，Seafile的SU用户警告 
  - OTA补丁自动提醒，添加选项供用户选择是否开启自动提醒（提示方式？）
  - Termux 字体，样式文件的整理
  - [高优先级] samba client 确定实现方案
  - Seafile增加监测，若同步状态出现问题，则重启Seafile
  - 2309 文件管理器无法通过tab键切换到云服务和网上邻居
  - 将samba客户端的扫描速度由30秒缩短到5秒
  
## 陈鹏
- 调研U盘 文件权限，未解决
- 处理文件管理器降低权限后，samba server不可使用的问题
- 与肖络元配合完成OpenthosID、Seafile云服务的帐号注册

## 卢宁
- 调研Seafile 文件权限,未解决
- Seafile应用数据备份与恢复
- 谷歌拼音输入法 包名的修改
- Seafile开始菜单备份与恢复
- 云服务目录中出现两个UserConfig

## 王明
- 文件管理器收藏动态  功能完成，代码问题没有提交

## 总结
samba和seafile基本完成,后期如果没有其他任务，将对代码进行优化。

# 2018-03 月报
## 王之旭
- 使用网上邻居访问文件，按win+d快捷键时，文件管理器崩溃 bug： 2278  
- 修改bug2323：首次配置设置语言为英文，进入桌面后，系统语言仍为中文 
- 第一次配置安装预装软件，可能因为目录的不存在崩溃
- seafile 帐号注册，登录整体优化，云服务地址接口
- [bug 2218] 首次配置完成后有时提示setupwizard已停止运行，且进入桌面后无法显示任务栏
- 优化seafile备份还原代码，预留aidl通信接口
- setupwizard无法正常结束
- [bug 2222] 录音机播放保存的录音会崩溃，log见附件
- 某些录音无法播放的bug
- 录音机播放录音进度条不圆润的问题
- 处理Samba客户端的几个bug
- 合并termux app 和termux style 并 移植termux源码
- 去掉Internet浏览器49.0和Flash Master

## 陈鹏
- OTA升级后，卸载旧应用的功能 bug：2265
- 完成samba server的用户可用界面，目前仅支持单文件夹的共享
- 调研samba client的实现

## 卢宁
- Seafile支持多个浏览器数据备份还原
- 文件管理器中增加云服务状态界面
- seafile压力测试
- seafile 在ubuntu和openthos的性能对比测试
- 云服务自动运行并保存配置， 在首次配置，设置界面可以还原， 设置界面可以备份
- 调研Seafile应用数据的备份还原

## 王明
- 压缩解压缩初始化进度无法结束
- 物业项目技术文档
- seafile配置的备份还原

## 总结
3月samba和seafile完成度80%。
后面会针对seafile samba filemanager launcher进行系列的优化和维护
4月任务目标，配合Openthos的1.1版本发布！



# 2018-01 月报

## 王之旭
  - 完成Samba Client基本功能（Samba Client目前存在扫描问题）
  - 完成OTA稳定版，开发版的划分（OTA目前无其他问题）
  - 完成Sound Recorder的移植（Sound Recorder目前无其他问题）
  - 完成Photo Manager的移植，并修改bug（Photo Manager目前无其他问题）
  - 学习使用自动化测试
      
## 陈鹏
  - Seafile中关于应用后台安装的实现
  - 调研SAMBA/CIFS（调研后，未解决问题）
  - 调研基于Ubuntu中Samba Server的实现（基本理解，目前存在问题Windows端不能很好的发现Ubuntu端）
  - 学习使用自动化测试
  
## 卢宁
  - Seafile
    - 完成修改 后台自动创建多个DATA Library的bug
    - 整理Seafile账号切换流程并修改设置界面
    - 整理Seafile启动流程，使其独立运行在后台
    - 修改Seafile缓存目录
  
## 王明
  - 完成物业会议系统需求报告
  - 修复了压缩解压缩中弹窗卡顿的问题，因代码问题还未提交
  - 调研Seafile，未完成任务
  - 调研Sound Recorder移植任务，未完成任务
  - 物业会议系统设计报告，未完成任务
  
## 总结
2月份集中将Seafile和Samba完成
