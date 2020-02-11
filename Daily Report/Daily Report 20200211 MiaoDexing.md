# 在MAC上安装gitlab
## 安装docker
- 下载地址：
https://docs.docker.com/docker-for-mac/install/
安装之后必须启动docker才可以在终端使用doceker命令

- 安装gitlab-ce
使用下面的命令安装gitlab-ce

'''
sudo docker run --detach \
    --hostname mygitlab.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
'''
  - 上面的参数说明：
    - hostname按照自己的需要改
    -  volume的冒号前面为物理机器上的实际目录，需提前建好，然后改为正确路径。冒号后面为挂载点，不要改
    -  publish的三个端口映射自己看情况来，一般自己网内使用，光一个80就好了，443和22都需要额外配置数字证书什么的
- 然后打开浏览器访问：

  localhost
  或者
  mygitlab.com
  这个时候会要求你修改root账户的密码，输入2次密码确定就可以了。注意这个root账户是gitlab的账户不是你mac系统的root账户，不要搞错了。
  到这里，在macos中搭建gitlab系统就算完成了。

# 问题记录

安装gitlab 的时候报错: <br>
'''

docker: Error response from daemon: Mounts denied:
The paths /srv/gitlab/logs and /srv/gitlab/config and /srv/gitlab/data
are not shared from OS X and are not known to Docker.
You can configure shared paths from Docker -> Preferences... -> File Sharing.
See https://docs.docker.com/docker-for-mac/osxfs/#namespaces for more info.

'''

没看懂官方的解决办法，用以下方式替代了/srv目录 <br>

'''

sudo docker run --detach \
    --hostname mygitlab.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume ~/gitlab/config:/etc/gitlab \
    --volume ~/gitlab/logs:/var/log/gitlab \
    --volume ~/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
    
'''
