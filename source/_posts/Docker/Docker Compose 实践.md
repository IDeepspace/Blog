---
title: Docker Compose 实践
author: Deepspace
categories: Docker
date: 2018-05-12
urlname: what-is-docker-compose
tags:
  - Docker
---

`Compose` 是 `Docker` 官方开源的一个项目，可以管理多个 `Docker` 容器组成一个应用。例如 `Web` 服务，除了服务本身还有数据库、`Redis`、`Nginx` 等一系列相关联服务需要安装。

有个 `Compose` 的支持，我们只需要定义一个 `YAML` 格式的配置文件（`docker-compose.yml`），来编写一个项目所需要的多个容器配置及调用关系，通过简单的命令即可同时开始或者关闭这些容器。

