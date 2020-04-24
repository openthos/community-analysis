- 今天遇到一个很坑的问题：
gitlab服务器ip地址由原来的“192.168.1.108”换成了“192.168.1.106”,然后一直提示
“fatal: unable to access 'http://192.168.1.108:98/root/linux-kernel.git/': Failed to connect to 192.168.1.108 port 98: Host is unreachable”，
起初一直以为是客户端的问题，重装了minikube 的所有环境，还是没有解决。重启了服务器，问题依旧，虽然在客户端可以通过106访问gitlab服务器！
- 最后发现，重启了服务器机器，并没有重置gitlab的配置信息
修改完gitlab 的配置文件“/etc/gitlab/gitlab.rb”，将所有108改成了106，必须执行
```
gitlab-ctl reconfigure

 
gitlab-ctl restart
```
再次强调：只重启机器是没有用的，没有用的！
