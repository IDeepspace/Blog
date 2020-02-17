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
mysql>
```

登录后会显示 `mysql` 命令。

显示所有数据库：

```bash
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
```

退出登录：

```bash
mysql> exit;
```



#### 4、通过客户端来连接

由于前面我们已经把数据库容器的端口映射出来了，所以我们也可以通过一些「数据库可视化客户端」或者「程序代码」进行数据库连接：

```
Host: 127.0.0.1
Port: 3306
User: root
Password: 123456
```

这里推荐一些可视化数据库工具：

- `DataGrip`：`Jetbrain` 家的产品，收费；
- `DBeaver`：功能强大，免费；
- `Navicat`：收费。



### 二、导入演示数据

为了便于演示，这里需要先导入一份数据库数据：

> 链接:https://pan.baidu.com/s/1brD2UJKWgpO0GKicFkyyiA  密码:4nqz

如何导入？

假设下载解压后的文件在本机的存储地址为：`/Users/cxin/Downloads/mysqlsampledatabase.sql`。

首先需要将宿主机（本机）上的文件拷贝至容器中，执行命令：

```bash
$ docker cp /Users/cxin/Downloads/mysqlsampledatabase.sql f0da3247bdd4:/opt/
```

进入容器，在容器内登陆 `Mysql` 并执行数据库脚本文件：

```bash
$ docker exec -it test_mysql bash
$ root@f0da3247bdd4:/opt# mysql -uroot -p123456
mysql> source /opt/mysqlsampledatabase.sql
```

该脚本会创建一个名为 `classicmodels` 的数据库，并写入一些数据。

```bash
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| classicmodels      |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```

数据库的表之间的关系为：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/DB/MySQL-Sample-Database-Schema.png" alt="MySQL-Sample-Database-Schema" />

接下来的 `SQL` 语句讲解都是基于上面所导入的数据。



### 二、SQL 语句



