配置文件在  /etc/gitlab-runner/config/config.toml


添加参数：pull_policy = "if-not-present"   #如果本地存在则不去下载，或者配置私有
