# gitlab 变量使用
## 打开debug logs
默认情况下，GitLab Runner会隐藏处理作业时所做操作的大部分细节。
To enable debug logs (traces), set the CI_DEBUG_TRACE variable to true:
```
job_name:
  variables:
    CI_DEBUG_TRACE: "true"

```
以下是 CI_DEBUG_TRACE 设置为 true 的输出:
```
export CI_SERVER_TLS_CA_FILE="/builds/gitlab-examples/ci-debug-trace.tmp/CI_SERVER_TLS_CA_FILE"
if [[ -d "/builds/gitlab-examples/ci-debug-trace/.git" ]]; then
  echo $'\''\x1b[32;1mFetching changes...\x1b[0;m'\''
  $'\''cd'\'' "/builds/gitlab-examples/ci-debug-trace"
  $'\''git'\'' "config" "fetch.recurseSubmodules" "false"
  $'\''rm'\'' "-f" ".git/index.lock"
  $'\''git'\'' "clean" "-ffdx"
  $'\''git'\'' "reset" "--hard"
  $'\''git'\'' "remote" "set-url" "origin" "https://gitlab-ci-token:xxxxxxxxxxxxxxxxxxxx@example.com/gitlab-examples/ci-debug-trace.git"
  $'\''git'\'' "fetch" "origin" "--prune" "+refs/heads/*:refs/remotes/origin/*" "+refs/tags/*:refs/tags/*"
else
  $'\''mkdir'\'' "-p" "/builds/gitlab-examples/ci-debug-trace.tmp/git-template"
  $'\''rm'\'' "-r" "-f" "/builds/gitlab-examples/ci-debug-trace"
  $'\''git'\'' "config" "-f" "/builds/gitlab-examples/ci-debug-trace.tmp/git-template/config" "fetch.recurseSubmodules" "false"
  echo $'\''\x1b[32;1mCloning repository...\x1b[0;m'\''
  $'\''git'\'' "clone" "--no-checkout" "https://gitlab-ci-token:xxxxxxxxxxxxxxxxxxxx@example.com/gitlab-examples/ci-debug-trace.git" "/builds/gitlab-examples/ci-debug-trace" "--template" "/builds/gitlab-examples/ci-debug-trace.tmp/git-template"
  $'\''cd'\'' "/builds/gitlab-examples/ci-debug-trace"
fi
echo $'\''\x1b[32;1mChecking out dd648b2e as master...\x1b[0;m'\''
$'\''git'\'' "checkout" "-f" "-q" "dd648b2e48ce6518303b0bb580b2ee32fadaf045"
'
+++ hostname
++ echo 'Running on runner-8a2f473d-project-1796893-concurrent-0 via runner-8a2f473d-machine-1480971377-317a7d0f-digital-ocean-4gb...'
Running on runner-8a2f473d-project-1796893-concurrent-0 via runner-8a2f473d-machine-1480971377-317a7d0f-digital-ocean-4gb...
++ export CI=true
++ CI=true
++ export CI_API_V4_URL=https://example.com:3000/api/v4
++ CI_API_V4_URL=https://example.com:3000/api/v4
++ export CI_DEBUG_TRACE=false
++ CI_DEBUG_TRACE=false
++ export CI_COMMIT_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ CI_COMMIT_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ export CI_COMMIT_SHORT_SHA=dd648b2e
++ CI_COMMIT_SHORT_SHA=dd648b2e
++ export CI_COMMIT_BEFORE_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ CI_COMMIT_BEFORE_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ export CI_COMMIT_REF_NAME=master
++ CI_COMMIT_REF_NAME=master
++ export CI_JOB_ID=7046507
++ CI_JOB_ID=7046507
++ export CI_REPOSITORY_URL=https://gitlab-ci-token:xxxxxxxxxxxxxxxxxxxx@example.com/gitlab-examples/ci-debug-trace.git
++ CI_REPOSITORY_URL=https://gitlab-ci-token:xxxxxxxxxxxxxxxxxxxx@example.com/gitlab-examples/ci-debug-trace.git
++ export CI_JOB_TOKEN=xxxxxxxxxxxxxxxxxxxx
++ CI_JOB_TOKEN=xxxxxxxxxxxxxxxxxxxx
++ export CI_PROJECT_ID=1796893
++ CI_PROJECT_ID=1796893
++ export CI_PROJECT_DIR=/builds/gitlab-examples/ci-debug-trace
++ CI_PROJECT_DIR=/builds/gitlab-examples/ci-debug-trace
++ export CI_SERVER=yes
++ CI_SERVER=yes
++ export CI_SERVER_URL=https://example.com:3000
++ CI_SERVER_URL=https://example.com:3000
++ export 'CI_SERVER_HOST=example.com'
++ CI_SERVER_HOST='example.com'
++ export 'CI_SERVER_NAME=GitLab CI'
++ CI_SERVER_NAME='GitLab CI'
++ export CI_SERVER_VERSION=
++ CI_SERVER_VERSION=
++ export CI_SERVER_VERSION_MAJOR=
++ CI_SERVER_VERSION_MAJOR=
++ export CI_SERVER_VERSION_MINOR=
++ CI_SERVER_VERSION_MINOR=
++ export CI_SERVER_VERSION_PATCH=
++ CI_SERVER_VERSION_PATCH=
++ export CI_SERVER_REVISION=
++ CI_SERVER_REVISION=
++ export GITLAB_CI=true
++ GITLAB_CI=true
++ export CI=true
++ CI=true
++ export CI_API_V4_URL=https://example.com:3000/api/v4
++ CI_API_V4_URL=https://example.com:3000/api/v4
++ export GITLAB_CI=true
++ GITLAB_CI=true
++ export CI_JOB_ID=7046507
++ CI_JOB_ID=7046507
++ export CI_JOB_TOKEN=xxxxxxxxxxxxxxxxxxxx
++ CI_JOB_TOKEN=xxxxxxxxxxxxxxxxxxxx
++ export CI_COMMIT_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ CI_COMMIT_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ export CI_COMMIT_BEFORE_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ CI_COMMIT_BEFORE_SHA=dd648b2e48ce6518303b0bb580b2ee32fadaf045
++ export CI_COMMIT_REF_NAME=master
++ CI_COMMIT_REF_NAME=master
++ export CI_COMMIT_NAME=debug_trace
++ CI_JOB_NAME=debug_trace
++ export CI_JOB_STAGE=test
++ CI_JOB_STAGE=test
++ export CI_SERVER_URL=https://example.com:3000
++ CI_SERVER_URL=https://example.com:3000
++ export CI_SERVER_HOST=example.com
++ CI_SERVER_HOST=example.com
++ export CI_SERVER_NAME=GitLab
++ CI_SERVER_NAME=GitLab
++ export CI_SERVER_VERSION=8.14.3-ee
++ CI_SERVER_VERSION=8.14.3-ee
++ export CI_SERVER_REVISION=82823
++ CI_SERVER_REVISION=82823
++ export CI_PAGES_DOMAIN=gitlab.io
++ CI_PAGES_DOMAIN=gitlab.io
++ export CI_PAGES_URL=https://gitlab-examples.gitlab.io/ci-debug-trace
++ CI_PAGES_URL=https://gitlab-examples.gitlab.io/ci-debug-trace
++ export CI_PROJECT_ID=17893
++ CI_PROJECT_ID=17893
++ export CI_PROJECT_NAME=ci-debug-trace
++ CI_PROJECT_NAME=ci-debug-trace
++ export 'CI_PROJECT_TITLE="GitLab FOSS'
++ CI_PROJECT_TITLE='GitLab FOSS'
++ export CI_PROJECT_PATH=gitlab-examples/ci-debug-trace
++ CI_PROJECT_PATH=gitlab-examples/ci-debug-trace
++ export CI_PROJECT_NAMESPACE=gitlab-examples
++ CI_PROJECT_NAMESPACE=gitlab-examples
++ export CI_PROJECT_URL=https://example.com/gitlab-examples/ci-debug-trace
++ CI_PROJECT_URL=https://example.com/gitlab-examples/ci-debug-trace
++ export CI_PIPELINE_ID=52666
++ CI_PIPELINE_ID=52666
++ export CI_PIPELINE_IID=123
++ CI_PIPELINE_IID=123
++ export CI_RUNNER_ID=1337
++ CI_RUNNER_ID=1337
++ export CI_RUNNER_DESCRIPTION=shared-runners-manager-1.example.com
++ CI_RUNNER_DESCRIPTION=shared-runners-manager-1.example.com
++ export 'CI_RUNNER_TAGS=shared, docker, linux, ruby, mysql, postgres, mongo'
++ CI_RUNNER_TAGS='shared, docker, linux, ruby, mysql, postgres, mongo'
++ export CI_REGISTRY=registry.example.com
++ CI_REGISTRY=registry.example.com
++ export CI_DEBUG_TRACE=true
++ CI_DEBUG_TRACE=true
++ export GITLAB_USER_ID=42
++ GITLAB_USER_ID=42
++ export GITLAB_USER_EMAIL=user@example.com
++ GITLAB_USER_EMAIL=user@example.com
++ export VERY_SECURE_VARIABLE=imaverysecurevariable
++ VERY_SECURE_VARIABLE=imaverysecurevariable
++ mkdir -p /builds/gitlab-examples/ci-debug-trace.tmp
++ echo -n '-----BEGIN CERTIFICATE-----
MIIFQzCCBCugAwIBAgIRAL/ElDjuf15xwja1ZnCocWAwDQYJKoZIhvcNAQELBQAw'

```
