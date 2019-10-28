# Gitlab 配置不与本机已安装的Nginx冲突
Gitlab安装包自带了http服务，会与系统已经安装的nginx冲突，导致http服务不可用。

所以，修改Gitlab默认配置
- 修改 gitlab.rb 
```
sudo vim /etc/gitlab/gitlab.rb
```
将unicorn的端口改为8082
```
## Advanced settings
unicorn['listen'] = '127.0.0.1'
unicorn['port'] = 8082
```
将gitlab的nginx端口改为82
```
nginx['listen_addresses'] = ['*']
nginx['listen_port'] = 82
```

- 修改 gitlab-rails 配置
```
sudo vim /var/opt/gitlab/gitlab-rails/etc/unicorn.rb
```
将socket端口改为8082
```
# What ports/sockets to listen on, and what options for them.
listen "127.0.0.1:8082", :tcp_nopush => true
listen "/var/opt/gitlab/gitlab-rails/sockets/gitlab.socket", :backlog => 1024
```
- 修改 gitlab-nginx 配置
```
vim /var/opt/gitlab/nginx/conf/gitlab-http.conf
```

修改 端口 82
```
server {
  listen *:82;

  server_name gitlab.example.com;
```

此时 gitlab的nginx服务监听82端口，rails监听8082端口

- 重置gitlab配置
完成配置之后执行下面命令重置配置
```
sudo gitlab-ctl reconfigure
```

- 访问
此时访问 127.0.0.1：82 即可进入
