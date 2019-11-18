---
title: Web 前端工程化（三） —— 使用 CircleCI + Github 搭建持续集成环境
author: Deepspace
categories: FrontEnd
date: 2019-11-07
urlname: set-up-ci-env-with-circleci-and-github
tags:
  - 持续集成
  - CircleCI
  - Github
---

## 使用 CircleCI + Github 搭建持续集成环境

### 一、CircleCI

首先介绍一下 `CircleCI`：https://circleci.com。

`CircleCI` 是一款 `SaaS` （软件即服务，`Software-as-a-service`） 服务，它是一个提供持续集成和持续交付（`CI`、`CD`）的工具。因为是一款 `SaaS` 服务，所以我们不用维护相关的服务器，只用关注在编码层面就好了。

`CircleCI` 支持 `GitHub` 和 `Bitbucket` 帐号的登录，授权登录完成后，就可以添加 `Projects` 了，支持 `GitHub` 和 `Bitbucket` 的公有及私有仓库。

`CircleCI` 需要付费的主要是它的容器。你可以免费使用一个容器，当你开始使用更多容器的时候，你可以选择你所需要的并行化级别来加速你的应用。



### 二、集成 CircleCI 到 Github 项目

我们以一个简单的 `React` 项目为例，项目地址：https://github.com/IDeepspace/react-typescript-frontend.git

1、使用 `github` 账号登录 `CircleCI`

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/FrontEnd/circleci.png" alt="Contiunous-Integration" style="zoom:50%;" />

