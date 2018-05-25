## OPENTHOS 1.1 RC2需求

- 在0523基础上移除以下功能：
  - 1.Window部署工具
  - 2.Android Studio相关内容
  - 3.多余的壁纸
  - 4.本地打印服务
  - 5.WLNEW

- 确认以下内容：
  - 1.Kernel 4.15 + MESA 18
  - 2.主流应用覆盖测试
  - 3.z2笔记本如果支持搞不定就暂时放弃，等待OTA修正
  - 4.可信计算相关功能，启用后系统性能测试
  - 5.商密算法OTA流程验证
  - 6.XPOSED功能，并默认启用了权限管理器和任务管理器模块

- 尚待解决的问题：
  - 1.Fennec的UI和Zoom修正
  - 2.腾讯游戏
  - 3.Termux
  - 4.云服务
  - 5.安装完之后分区类型及名称设置成a006 OPENTHOS system和a008 OPENTHOS data
