[2019-01-14 ~ 2019-01-18个人周报](https://github.com/openthos/community-analysis/blob/master/weekly%20report/Weekly%20Report%20about%20Launcher%20Group.md#2019-01-14--2019-01-18%E4%B8%AA%E4%BA%BA%E5%91%A8%E6%8A%A5)<br />
[2019-01-07 ~ 2019-01-11个人周报](https://github.com/openthos/community-analysis/blob/master/weekly%20report/Weekly%20Report%20about%20Launcher%20Group.md#2019-01-07--2019-01-11%E4%B8%AA%E4%BA%BA%E5%91%A8%E6%8A%A5)<br />
[2019-01-02 ~ 2019-01-04个人周报](https://github.com/openthos/community-analysis/blob/master/weekly%20report/Weekly%20Report%20about%20Launcher%20Group.md#2019-01-07--2019-01-11%E4%B8%AA%E4%BA%BA%E5%91%A8%E6%8A%A5)<br />

# 2019-01-14 ~ 2019-01-18个人周报
## 王之旭
- 完成 8.0自研应用默认没有权限查看sd卡问题
- 8.0图片管理器打开崩溃问题（完成50%）
- 8.0自研应用打开文件需要提供一个统一的方法（完成50%）
- 之后计划
  - 8.0图片管理器打开崩溃问题
  - 8.0自研应用打开文件需要提供一个统一的方法
  - 8.0录音机崩溃的问题

## 苗德行
- 完成 实现根据包名下载所有应用程序的图标，并实现了去除重名的应用程序，更新数据库和应用商店需要的参数字段
- 完成 按照应用商店要求，生成接口文件，并通过测试
- 完成 监测应用程序更新，并更新数据库表
- 之后计划
  - 增加黑名单，白名单功能
  - 脱离真机环境，建议VMvare（硬件或其他支援）
  - 实现自动化（人工维护耗时，一周4小时）
  
## 董鹏
- 根据效果图在title栏中添加 上传，下载，新建文件，删除按钮，其中新建文件已实现其余按钮未实现
- 添加左侧资料库栏和右侧展示资料库内容的布局，并实现了点击左侧资料库，动态刷新右侧展示资料库内容（有bug）

# 2019-01-14 ~ 2019-01-11个人周报
- 完成 8.0Launcher的移植
- 分析、解决文件管理器和桌面无法用相关应用打开文件（正在找最优方法）
- 应用商店默认打开存储权限（正在找最优方法）
- 完成 cloud服务器无法通过文件管理器上传下载文件，原因是ssl证书验证失败
- 完成 设置cloud.openthos.org服务器为缺省
- 完成 seaf_start.sh改为seafile-keeper或cloud-service-keeper
- 完成 按ctrl+alt+t调出终端后，会出现ctrl键粘滞的问题，此时双击文件或文件夹无法进入，需要再次按ctrl解除粘滞

# 2019-01-02 ~ 2019-01-04个人周报
