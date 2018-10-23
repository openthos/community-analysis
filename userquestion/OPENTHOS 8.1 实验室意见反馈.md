# 优先问题
- android studio 大小写切换不灵敏(x86) ------曹永韧、陈鹏
- Temux 拖拽复制不可用 ------罗俊欢
- Termux 在su状态下无法使用scp，ssh ------罗俊欢
- 界面图标大(openthos) ------肖络元、王之旭
- 文件管理器功能不全，缺少右键等功能，且容易崩溃(openthos) ------王之旭、刘晓旭
- openthos-8.1上termux无法使用,卡在初始化下载(openthos) ------刘晓旭、曹永韧
- 经常连不上adb(x86) ------卢宁、罗俊欢

# 各工程师提交问题
## 王之旭
- 因大量基础没有，很多操作无法实现，导致文件管理器缺失了大量功能(openthos)
- 整体界面太大，感觉空间变小，可控范围小(openthos)
- 多窗口区域太小，往边上拉，还没有到边就全屏，没有感受到多窗口的便携(openthos)

## 卢宁
- Termux切换、新建窗口体验差(x86)
- 多窗口操作复杂影响效率(x86)
- as经常连不上adb(x86)

## 陈鹏
- x86_64，自带的文件管理器不好操作(x86)
- android studio 大小写切换不灵敏(x86)
- 浏览器只能开1个窗口(x86)

## 刘晓旭
- 鼠标右键无法使用，在文件管理器中，长按鼠标左键，应用停止运行。(openthos)
- 自带的chrome，地址栏输入，应用停止运行(openthos)
- openthos-8.1上第三方termux安装后无法使用(openthos)
- 鼠标滚轮不好用，在微信朋友圈中使用滚轮滑动，结束后会返回初始位置

## 曹永韧
- Temux 在su状态下无法使用scp，ssh  (x86)  openthos-8.1上termux不能使用(openthos)
- 自己装的openthos浏览器每次打开新页面总是处于放大状态(openthos)
- studio总是出现大小写无法自由切换.(x86)

## 罗俊欢
- adb 测试，经常无法连接(openthos)
- apk不能可视化使用(openthos)

## 肖络元
- 界面图标偏大，影响内容正常查看(openthos)
- win键无法调出开始菜单(openthos)
- 打开的窗口默认太小，看不全内容(openthos)

## 张善民
- 部分app右侧有黑边，经确认是NavigationBar导致，在oreo-x86上禁用NavigationBar可解决此问题，但是在openthos上，systemui会崩溃。
- android studio 无法使用gdb进行调试，在oreo-x86上此问题不会出现。
- 安装应用程序的权限问题导致必须手动修改/data/user/0下app的权限，才能使用app。
