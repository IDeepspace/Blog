---
title: 使用 CircleCI + Github 搭建持续集成环境
author: Deepspace
categories: FrontEnd
date: 2019-11-07
urlname: set-up-ci-env-with-circleci-and-github
tags:
  - 持续集成
  - CircleCI
  - Github
---

### 一、CircleCI 介绍

首先介绍一下 `CircleCI`：https://circleci.com。

`CircleCI` 是一款 `SaaS` （软件即服务，`Software-as-a-service`） 服务，它是一个提供持续集成和持续交付（`CI`、`CD`）的工具。因为是一款 `SaaS` 服务，所以我们不用维护相关的服务器，只用关注在编码层面就好了。

`CircleCI` 支持 `GitHub` 和 `Bitbucket` 帐号的登录，授权登录完成后，就可以添加 `Projects` 了，支持 `GitHub` 和 `Bitbucket` 的公有及私有仓库。

`CircleCI` 需要付费的主要是它的容器。你可以免费使用一个容器，当你开始使用更多容器的时候，你可以选择你所需要的并行化级别来加速你的应用。

<!-- more -->

### 二、集成 CircleCI 到 Github 项目

我们以一个简单的 `React` 项目为例，项目地址：https://github.com/IDeepspace/react-typescript-frontend.git

1、使用 `github` 账号登录 `CircleCI`

<img src="https://gitee.com/IDeepspace/image-hosting/raw/master/FrontEnd/circleci.png" alt="Contiunous-Integration" style="zoom:50%;" />

`Add Project` ，将项目集成到 `CircleCI` 中：

![circleci-set-up-project](https://gitee.com/IDeepspace/image-hosting/raw/master/FrontEnd/circleci-set-up-project.png)

选择对应的环境和语言：

![circleci-select-env](https://gitee.com/IDeepspace/image-hosting/raw/master/FrontEnd/circleci-select-env.png)

选择 `Linux` 系统，由于我们是 `JavaScript` 的项目，所以这里选择 `Node` 就好了。

因为我们没有提前编写 `CircleCI` 配置文件，所以创建之后，不会构建成功。接下来我们看看如何编写 `CircleCI` 配置文件。

### 三、编写 CircleCI 配置文件

我们在项目的根目录下创建一个 `.circleci` 文件夹，在文件夹中创建配置文件 `config.yml` 。

在演示项目里，我们的配置文件是这样的：

```yml
version: 2
jobs:
  test:
    working_directory: ~/repo
    docker:
      - image: circleci/node:latest
    steps:
      - checkout
      - restore_cache:
          key: dependency-cache-{{ checksum "package.json" }}
      - run:
          name: install npm dependences
          command: npm install
      - save_cache:
          key: dependency-cache-{{ checksum "package.json" }}
          paths:
            - ./node_modules
      - run:
          name: run lint
          command: npm run lint
      - run:
          name: run test
          command: npm test

workflows:
  version: 2
  test-deploy:
    jobs:
      - test
```

这里的配置比较简单，定义了一个名为 `test` 的 `job` ，在这里 `job` 里面做了代码格式检查和测试。`CircleCI` 会读取 `workflows` 里面的一个个 `flow`，在 `test-deploy` 的 `flow` 里面，执行了 `test` 的 `job` 。

关于更多配置，可以参考 `CircelCI` 的文档：https://circleci.com/docs/

### 四、提交代码进行持续集成

我们可以将本地开发分支代码提交到仓库，当 `push` 事件发生时，`Github` 会发送 `Webhook` 请求到 `CircleCI`，`CircleCI` 根据项目中的 `.circleci/config.yml` 配置文件初始化环境并对项目进行构建和测试，这个请求是异步进行的，这种设计也比较合理，因为环境初始化、构建和测试都比较耗时。

我们进入 `github` 中 `repo` 的 `commit` 界面，可以看到我们在 `CircleCI` 的构建状态，会标注出成功或失败的状态：

![github-circleci-status](https://gitee.com/IDeepspace/image-hosting/raw/master/FrontEnd/github-circleci-status.png)

进入 `CircleCI` 中，我们也可以在 `WORKDLOWS` 查看更详细的构建信息，包括 `CircleCI` 配置文件中的步骤和相关 `log` 信息等。

![circleci-ci-status](https://gitee.com/IDeepspace/image-hosting/raw/master/FrontEnd/circleci-ci-status.png)

### 五、最后

搭建持续集成需要做的事情，远远不止上面这些简单的步骤，这里只是抛了一个引子，更多实践可以参考 `CircleCI` 的相关文档。
