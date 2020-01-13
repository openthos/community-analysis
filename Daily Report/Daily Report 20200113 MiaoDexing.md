sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

ou can download a binary for every available version as described in Bleeding Edge - download any other tagged release.

Give it permissions to execute:
```
sudo chmod +x /usr/local/bin/gitlab-runner
```
Create a GitLab CI user:
```
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
```
Install and run as service:
```
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner start
```
Register the Runner
