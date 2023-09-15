# `git` 使用技巧

## 关于 `git tag`

+ 添加一个标签，并将其推送到远端

    - `git tag TAG_NAME`

    - `git tag TAG_NAME -a -m "message"`, 以给定的消息（而非提示输入），创建一个 “带注解的” 标签。

    - `git push origin TAG_NAME`

+ 删除本地及远端的标签

    - `git tag -d TAG_NAME`

    - `git push --delete origin TAG_NAME`

- 以提交日期顺序列出标签: `git tag --sort=committerdate`


## Jenkins 中检出标签

Jenkins 流水线不会在指定 `agent` 的默认检出源码仓库中，检出标签。而需要在某个阶段中执行以下步骤：


```groovy
        stage('checkout_scm') {
            environment {
                GITHUB_CREDS = credentials('for-github-op')
                GIT_SSH_COMMAND = 'ssh -i $GITHUB_CREDS'
            }
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: scm.branches,
                    doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                    extensions: [[$class: 'CloneOption', noTags: false, shallow: false, depth: 0, reference: '']],
                    userRemoteConfigs: scm.userRemoteConfigs,
                ])

                sh """rm -rf api/ docs/
                    git submodule update --init --recursive --remote"""
            }
        }
```

其中的 `checkout` 步骤，就修改了默认检出参数，而指定了检出各个标签。
