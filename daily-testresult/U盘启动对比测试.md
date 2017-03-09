## openthos在两种SanDisk-32G的U盘上的测试对比
对比项|黑色(小)SanDisk-32G|白色SanDisk-32G|
-----|-----|-----|
制作镜像的时间|4m12s|9m45s|
启动时间|30s|44s|
系统流畅度|使用流畅|使用流畅，但是会偶尔出现停止运行的弹框|
文件管理器|功能正常，使用流畅|功能正常，使用过程中，在删除或者复制粘贴文件操作时，偶尔会停止运行|
Fennec浏览器|使用流畅，可以播放视频|使用流畅，可以播放视频|
ms-office|使用流畅，可以正常操作，与硬盘上的一样|使用过程流畅，在第一次登录帐号时提示了停止运行，再次登录时正常|
应用商店|下载安装全部应用，过程流畅|下载安装全部应用，完成后在关闭应用时卡住|

## remix,phoenix,openthos在四类U盘上的测试对比
制作镜像的时间| 64G | SanDisk-32G | Netac-32G | 16G | 
-----|-----|-----|-----|-----|
remix|30s |1m22s |1m26s |3m2s |
phoenix|1)3m30s<br>2)remix工具+P-iso: 26s |1)5m36s<br>2)remix工具+P-iso:38s |1)6m21s <br>2)remix工具+P-iso: 1m17s|1)11m45s<br>2)remix工具+P-iso:1m51s |
openthos|1m25s |6m45s |5m22s |11m38s |

启动时间| 64G | SanDisk-32G | Netac-32G | 16G | 
-----|-----|-----|-----|-----|
remix|3m16s |3m9s |13m | 40m没有成功启动|
phoenix(live)|livecd:45s |1m17s |52s | |
openthos|30s |31s |1m36s |1m50s |

应用使用情况| 64G | SanDisk-32G | Netac-32G | 16G | 
-----|-----|-----|-----|-----|
remix-文件管理器|不卡顿<br> 菜单操作选项很少，只能新建文件夹<br> 快捷键操作都正常<br> 支持FM多开<br>支持拖拽|不卡顿<br> 菜单操作选项很少，只能新建文件夹<br> 快捷键操作都正常<br> 支持FM多开<br>支持拖拽|严重卡顿<br> 无法进行菜单操作<br> 无法进行快捷键操作<br> 无法多开<br>无法拖拽 |没有成功启动，无法测试|
remix-浏览器|不卡顿<br> 不支持视频播放<br> 没有滚动条<br>Fennec root 以手机模式打开并闪退，不能运行<br> |不卡顿<br> 不支持视频播放<br> 没有滚动条<br> Fennec root 以手机模式打开并闪退，不能运行<br>|严重卡顿会崩溃<br> 不支持视频播放<br> 没有滚动条<br> Fennec root 以手机模式打开并闪退，不能运行<br>|没有成功启动，无法测试 |
remix-office|不卡顿<br> ppt全屏播放<br> excel无穿透效果，可正常使用<br> 登录输入密码页面花屏<br> |不卡顿<br>ppt全屏播放<br>excel无穿透效果，可正常使用<br>登录输入密码页面花屏<br> |无法安装<br> |没有成功启动，无法测试 |
phoenix(live)-文件管理器| |不卡顿<br> 菜单操作正常<br> 快捷键操作正常<br> 支持FM多开<br>支持拖拽 |不卡顿<br> 菜单操作正常<br> 快捷键操作正常<br> 支持FM多开<br>支持拖拽 | |
phoenix(live)-浏览器| |不卡顿<br> 电脑版不支持视频播放，平板模式和手机模式支持<br> 没有滚动条<br> Fennec root以全屏模式打开，页面加载一会儿然后闪退<br>|不卡顿<br> 电脑版不支持视频播放，平板模式和手机模式支持<br> 没有滚动条<br> Fennec root以全屏模式打开，页面加载一会儿然后闪退<br> | |
phoenix(live)-office| |不卡顿<br> ppt全屏播放<br> excel无穿透效果，可正常使用<br> |不卡顿<br> ppt全屏播放<br> excel无穿透效果，可正常使用<br> | |
openthos-文件管理器|不卡顿<br> 菜单操作正常<br> 快捷键操作正常<br> 不支持FM多开<br>不支持拖拽<br> |不卡顿<br> 菜单操作正常<br> 快捷键操作正常<br> 不支持FM多开<br>不支持拖拽<br> |不卡顿<br> 菜单操作正常<br> 快捷键操作正常<br> 不支持FM多开<br>不支持拖拽<br>系统操作不如硬盘流畅<br> |不卡顿<br> 菜单操作正常<br> 快捷键操作正常<br> 不支持FM多开<br>不支持拖拽<br>系统操作不如硬盘流畅<br> |
openthos-浏览器|不卡顿<br> 视频播放时会卡死，Fennec root崩溃退出<br> 有滚动条<br> | 不卡顿<br> 视频播放时会卡死，Fennec root崩溃退出<br> 有滚动条<br>|安装和第一次打开时会卡顿<br> 视频播放时会卡死，Fennec root白屏不退出<br> 有滚动条<br> |安装失败 |
openthos-office|不卡顿<br> ppt全屏播放<br> excel穿透FX，可正常使用<br> |不卡顿<br> ppt全屏播放<br> excel穿透FX，可正常使用<br> |安装和第一次打开时会卡顿<br> ppt全屏播放<br> excel穿透FX，可正常使用<br> |安装失败 |

