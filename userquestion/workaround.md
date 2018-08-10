# OPENTHOS8.1使用问题变通方案
1. 无法使用ssh连接180  
**解决方案：**  
安装termux，pkg install openssh  
如果安装后无法正常使用应用，在/data/data/目录下修改com.termux的权限，权限查看/data/system/packages.list
2. 如何使用android studio  
**解决方案：**  
在Androidx86-8.1中进行安装。（镜像位置:lh@192.168.0.180:/var/www/html/dl/android_x86_64.iso）  
**请勿直接dd制作U盘，会导致U盘无法识别**
所需文件在180服务器：/var/www/html/dl/oto-android-studio/目录下。  
启动脚本的运行方法是sh startas.sh  
scp、ssh不可用的情况下使用wget下载文件  
参考文档：  
https://github.com/openthos/jenkins-ci-analysis/blob/master/docs/App_Development_with_Android_Studio_on_OPENTHOS.md


# OPENTHOS2.0使用问题变通方案
1. 无wifi的台式机无法使用微信聊天记录迁移等功能  
**解决方案：**  
使用无线网卡，注意要选择免驱动的，比如TP-LINK的TL-WN726N，使用前要先在windows上运行一下自带的程序，再回到openthos上即可直接使用。
2. 需要更多的命令行工具，编译生成的ELF文件的分析处理工具，如readelf / pandoc命令  
**解决方案：**  
chroot解决  
1.1RC2解决：将**所有** busybox符号链接方式提供的命令，替换成ubuntu linux 18.04中对应的原始命令，并提供man-pages以便查询帮助
3. 使用xbox one手柄玩魂斗罗时，不能使用按键跳跃开枪  
**解决方案：**  
请注意是否有使用无线鼠标(罗技无线鼠标)，拔掉鼠标后，可解决冲突
4. QQ／微信发送消息快捷键  
**解决方案：**
打开QQ设置中，开启回车键发送消息。打开微信设置，点击聊天,开启回车键发送消息
5. 微信消息提示音（默认跟随系统导致没有声音）  
**解决方案：**
打开设置中新消息提醒，选择其他的新消息提示音
6. Termux中代码显示不完整，或半屏显示  
**解决方案：**
点击放大缩小窗口能够使代码termux正常显示，或者不要su，在普通用户目录下操作
7. openthos在chroot到Ubuntu 时，adb无法使用  
**解决方案：**
问题在ubuntu与adb server交互的端口被chroot外的openthos占用了。解决方法是指定新的端口即可，即在执行"export DISPLAY=192.168.0.111:0"后，增加一句`alias adb='adb -P 5030'`
8. 系统升级或重置导致的有线网络无法连接。  
**解决方案：**
使系统睡眠，然后再唤醒
9. wps关闭文档后会留下红色界面  
**解决方案：**
使用快捷键ALT+F4关闭
10. 谷歌输入法按键粘滞，自动删代码，重复输入文字字母等  
**解决方案：**
切换输入法
11. OTA 升级时提示升级包校验失败  
**解决方案：**
在/sdcard目录下手动创建System_OS目录
