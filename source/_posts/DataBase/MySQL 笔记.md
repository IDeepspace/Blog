---
title: MySQL 笔记
author: Deepspace
categories: DataBase
date: 2016-03-29
urlname: mysql-note
tags:
  - Mysql
  - Docker
---



### 一、安装

网络上已经有很多讲述如何在 `Windows`、`Mac`、和 `Ubuntu` 等环境上安装 `MySQL` 的教程了，这里就不再赘述。

为了不在本地机器上设置太多的环境，这里我们使用 `Docker` 来安装 `MySQL` 并学习如何使用。

#### 1、安装 Docker

`Mac` 客户端下：

```bash
$ brew cask install docker
```

也可以手动下载 `.dmg` 格式安装包进行安装。

其它环境安装 `Docker` 的方式可以参考官方文档：https://docs.docker.com/get-docker/

验证安装：

```bash
$ docker --version
```

输出所安装的 `Docker` 版本。



#### 2、拉取 MySQL 镜像

这里我们拉取最新版本的镜像：

```bash
$ docker pull mysql
```



#### 3、启动 MySQL 容器

```bash
$ docker run -d -p 127.0.0.1:3306:3306 --name test_mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:latest
```

这里没有将容器中的数据映射出来；如果需要，可以在本机创建一个用作数据持久化的目录，将容器中的数据映射到本机该目录中：

```bash
$ docker run -d -p 127.0.0.1:3306:3306 --name mysql -v /Users/cxin/Development/persistent-local-data-for-mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD="123456" mysql:latest
```

验证启动：

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                 NAMES
f0da3247bdd4        mysql:latest        "docker-entrypoint.s…"   56 seconds ago      Up 54 seconds       127.0.0.1:3306->3306/tcp, 33060/tcp   test_mysql
```

我们可以进入 `test_mysql` 容器：

```bash
$ docker exec -it test_mysql bash
$ root@f0da3247bdd4:/#
```

在容器内登陆 `Mysql`：

```bash
$ root@f0da3247bdd4:/# mysql -uroot -p123456
```



#### 4、通过客户端来连接

由于前面我们已经把数据库容器的端口映射出来了，所以我们也可以通过一些「数据库可视化客户端」或者「程序代码」进行数据库连接：

```
Host: 127.0.0.1
Port: 3306
User: root
Password: 123456
```



