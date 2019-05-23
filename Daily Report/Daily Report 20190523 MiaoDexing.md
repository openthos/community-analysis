
- google play 爬取应用的数据库设计

  |       字段                       | 数据类型                        | 备注      |
  | ---------------------------- | -------------------------------------- | ------------------ |
  | _id               | ObjectId                     | 系统自动添加 |
  | apk_downurl       | String                       | apk下载地址    |
  | apk_name          | Array                        | 名称   |
  | apk_star          | Array                        | 评分 |
  | apk_review        | Array                        | 描述信息   |
  | apk_img           | Array                        | 应用预览图地址   |
  | apk_icon          | Array                        | 图标对应的地址   |
  | apk_update        | String                       | 更新日期   |
  | apk_version       | String                       | 版本号   |
  | apk_fileSize      | String                       | 文件大小  |
  | apk_packageName   | String                       | 包名   |
  | apk_company       | String                       | 开发者   |
  | apk_category_1    | String                       | 类别1   |
  | apk_category_2    | String                       | 类别2（有可能不存在）   |
  | flag              | String                       | 是否下载过，true代表下载过   |
  | update            | String                       | 是否需要更新，true代表需要更新   |
  
  
