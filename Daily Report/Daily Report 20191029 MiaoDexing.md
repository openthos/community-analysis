# gitlab持续集成部署（CI/CD），使用docker配置gitlab-runner
- 创建gitlab-runner容器：
```
sudo docker pull gitlab/gitlab-runner

sudo docker run -d --name gitlab-runner --restart always \
    -v /etc/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

```

- 将gitlab上的项目注册到gitlab-runner中：
```
sudo docker exec -it gitlab-runner gitlab-ci-multi-runner register
```
过程如下图：
![Image_text](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/docker_gitlab-runner_register.png)

-  url 与 token 和 gitlab中的project的setting->CI/CD->runner中的一致
-  decription: 可以随意
-  tags: 需要与yml中的对应
-  executer:  因为我这里希望在docker中运行，所以选择 docker
-  Docker image: 希望你的project在哪个docker image运行，需要和yml中对应

- 注册成功runner：
![Image_text](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/runner_2.png)

- .gitlab-ci.yml
```
image: ubuntu:18.04

test:
  stage: test
  script: 
    - ls -l
  tags:
    - mdx

```
