---
title: Docker Compose 简单实践
author: Deepspace
categories: Docker
date: 2018-05-12
urlname: what-is-docker-compose
tags:
  - Docker
---

`Compose` 是 `Docker` 官方开源的一个项目，可以管理多个 `Docker` 容器组成一个应用。例如 `Web` 服务，除了服务本身还有数据库、`Redis`、`Nginx` 等一系列相关联服务需要安装。

有个 `Compose` 的支持，我们只需要定义一个 `YAML` 格式的配置文件（`docker-compose.yml`），来编写一个项目所需要的多个容器配置及调用关系，通过简单的命令即可同时开始或者关闭这些容器。

下面我们演示一下如何使用 `Docker Compose` 来设置和运行一个简单的 `django / postgresql` 应用程序。 



### 一、安装

在开始之前，安装 `Compose`。

在桌面系统上，如 `Mac` 和 `Windows` ，在安装 `Docker Desktop` 的时候，`Docker Compose` 作为桌面安装的一部分已经包括在内了。如果已经安装，你可以跳过这部分。

如果是在 `Linux` 的机器上，我们可以从 `GitHub` 上的 `Compose` 库发布页面下载 `Docker Compose` 二进制文件。 按照链接中的说明操作。 

#### 1、下载

下载当前的 `Docker Compose` 稳定版本：

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```



#### 2、添加权限

对二进制文件添加可执行权限：

```bash
sudo chmod +x /usr/local/bin/docker-compose
```



#### 3、测试安装

```bash
$ docker-compose --version
docker-compose version 1.25.4, build 1110ad01
```



### 二、搭建 WordPress 个人博客

`WordPress` 是一个很流行的博客应用程序，基于 `PHP` 开发。`WordPress` 中，使用 `MySQL` 作为数据库。

下面我们使用 `Docker Compose` 来搭建 `WordPress` 个人博客。

创建一个文件夹（`WordPress-Blog`），并在该目录下创建名为 `docker-compose.yml` 的文件：

```shell
$ sudo mkdir WordPress-Blog && cd WordPress-Blog
$ sudo touch docker-compose.yml
```



#### 1、编写 docker-compose.yml

编辑 `docker-compose.yml` ，将如下内容保存在里面：

```yml
version: '3.3'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
volumes:
    db_data: {}
```

有两个 `service`，`db` 和 `wordpress`，其中 `wordpress` 依赖于 `db` 。

创建了一个卷 `db_data` ，用于保存 `WordPress` 对数据库的任何更新。

> 注：`WordPress` 只能在 `80` 和 `443` 端口使用。



#### 2、构建应用

使用 `docker-compose` 命令启动容器：

```shell
$ docker-compose up -d
Creating volume "hello-compose_db_data" with default driver
Pulling db (mysql:5.7)...
5.7: Pulling from library/mysql
efd26ecc9548: Pull complete
a3ed95caeb02: Pull complete
...
Digest: sha256:34a0aca88e85f2efa5edff1cea77cf5d3147ad93545dbec99cfe705b03c520de
Status: Downloaded newer image for mysql:5.7
Pulling wordpress (wordpress:latest)...
latest: Pulling from library/wordpress
efd26ecc9548: Already exists
a3ed95caeb02: Pull complete
589a9d9a7c64: Pull complete
...
Digest: sha256:ed28506ae44d5def89075fd5c01456610cd6c64006addfe5210b8c675881aff6
Status: Downloaded newer image for wordpress:latest
Creating my_wordpress_db_1
Creating my_wordpress_wordpress_1
```

我们可以查看启动的容器：

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                 NAMES
22b0b3d15ffe        wordpress:latest    "docker-entrypoint.s…"   27 seconds ago      Up 26 seconds       0.0.0.0:8000->80/tcp                  hello-compose_wordpress_1
e70ea0b4e610        mysql:5.7           "docker-entrypoint.s…"   28 seconds ago      Up 27 seconds       3306/tcp, 33060/tcp                   hello-compose_db_1
```

启动了两个容器。`hello-compose_wordpress_1` 这个容器的和宿主机的端口映射为：`0.0.0.0:8000->80`。



### 三、访问应用

我们在浏览器中访问地址：http://localhost:8000/，会出现安装 `WordPress` 的界面：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/docker-compose-wordpress.png" alt="docker-compose-wordpress" style="zoom:50%;" />



### 四、Compose 常用服务配置

#### 1、version

指定本 `yml` 依从的 `compose` 哪个版本制定的。



#### 2、build

指定构建镜像上下文路径。



#### 3、image

指定容器运行的镜像。



#### 4、expose

暴露端口，但不映射到宿主机，只被连接的服务访问。



#### 5、volumes

将主机的数据卷或着文件挂载到容器里。



#### 6、secrets

存储敏感数据，例如密码：

```
version: "3.1"
services:

mysql:
  image: mysql
  environment:
    MYSQL_ROOT_PASSWORD_FILE: /run/secrets/my_secret
  secrets:
    - my_secret

secrets:
  my_secret:
    file: ./my_secret.txt
```



#### 7、restart

- `no`：是默认的重启策略，在任何情况下都不会重启容器。
- `always`：容器总是重新启动。
- `on-failure`：在容器非正常退出时（退出状态非 0），才会重启容器。
- `unless-stopped`：在容器退出时总是重启容器，但是不考虑在 `Docker` 守护进程启动时就已经停止了的容器。

```
restart: "no"
restart: always
restart: on-failure
restart: unless-stopped
```





#### 8、healthcheck

用于检测 `docker` 服务是否健康运行。

```
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"] # 设置检测程序
  interval: 1m30s # 设置检测间隔
  timeout: 10s # 设置检测超时时间
  retries: 3 # 设置重试次数
  start_period: 40s # 启动后，多少秒开始启动检测程序
```



### 五、总结

更多内容请参考：https://docs.docker.com/compose/