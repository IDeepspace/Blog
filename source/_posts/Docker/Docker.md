---
title: Docker 从入门到实践（一）
author: Deepspace
categories: Docker
date: 2017-05-12
urlname: docker-tutorial-1
tags:
  - Docker
---



### 一、什么是 Docker

`Docker` 是一种虚拟化容器技术，其设计理念是 「 `build once, run anywhere` 」（一次构建，到处运行），和 `Java` 的跨平台特点 —— 「 `wirte once, run anywhere` 」（一次编写，到处运行）很像。

为什么要使用 `Docker` 呢？

`Docker` 可以将应用以**集装箱**的方式进行打包，通过镜像的方式可以实现在不同的环境下进行快速部署，在团队中还可实现一次打包，多次共享，使用 `Docker` 可以轻松的为任何应用创建一个轻量级的、可移植的、自给自足的容器。

例如，我们在本地将编译测试通过的程序打包成镜像，可以快速的在服务器环境中进行部署，有时也能解决不同的开发环境造成的问题 —— **"明明我本地是好的，但是一到服务器就不行"**。

总结下来其有以下优点：

- 高效的利用系统资源（节约成本）
- 持续交付与部署（敏捷）
- 多平台的迁移更容易（可移植性）
- 容易的沙箱机制（安全性）



### 二、Docker 架构一瞥

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/docker-architecture.jpg" alt="Docker Architecture" style="zoom: 62%;" />

<p align="center">（图片来自网络）</p>

1. 中间部位为我们进行 `Docker` 操作的宿主机，其运行了一个 `Docker daemon` 的核心守护程序，负责构建、运行和分发 `Docker` 容器；

2. 左边为 `Docker` 客户端，其与 `Docker` 守护进程进行通信，客户端会将 `build`、`pull`、`run` 命令发送到 `Docker` 守护进程进行执行；

3. 右边为 `Docler` 注册表存储 `Docker` 镜像，是一个所有 `Docker` 用户共享 `Docker` 镜像的服务，`Docker daemon` 与之进行交互。



### 三、基本概念

#### 1、镜像

`Docker` 会把应用程序及依赖打包进镜像（`Images`）里，提供了容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等），通过这个镜像文件可生成 `Docker` 容器。

例如：这个镜像文件包含了一个完整的 `Ubuntu` 系统，我们可以在 `Ubuntu` 镜像基础之上安装 `Redis`、`Mysql` 等其它应用程序。

另外制作好的镜像文件可以拷贝到其它机器使用，镜像是通用的。镜像的制作可以基于 `Dockerfile` 构建（后面会讲解）。



#### 2、容器

容器是镜像的可运行实例。镜像（`Image`）和容器（`Container`）的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体。

我们可以使用 `Docker` 提供的 `API` 创建、启动、停止、移动或删除容器。在默认情况下，容器与其它容器及其主机是隔离的，拥有自己的独立进程空间、网络配置。

容器由其镜像以及在创建或启动容器时提供的配置选项来定义。当容器被删除时，对其状态的任何未存储在持久存储中的更改都会消失。



#### 3、仓库

镜像构建完成后，可以很容易的在当前宿主机上运行。但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，[Docker Hub](https://hub.docker.com/) 就是这样的服务，我们把这个服务叫作**仓库**（ `Docker Registry` ），仓库的概念与 `Git` 类似，可以理解为 `GitHub` 这样的托管服务。

一个 `Docker Registry` 中可以包含多个仓库（`Repository`）；每个仓库可以包含多个 标签（`Tag`）；每个标签对应一个镜像。通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。我们可以通过 `<仓库名>:<标签>` 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 `latest` 作为默认标签。



### 四、安装

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



### 五、使用镜像

#### 1、获取镜像

[Docker Hub](https://hub.docker.com/explore/) 上有大量的高质量的镜像可以用。从 `Docker` 镜像仓库获取镜像的命令是 `docker pull`。其命令格式为：

```bash
$ docker pull [OPTIONS] NAME[:TAG|@DIGEST]
```

[Docker Hub](https://hub.docker.com/explore/) 上提供了一个非常简单的 `hello-world` 的镜像，下面我们拉取一下该镜像：

```bash
$ docker pull hello-world
Using default tag: latest
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:fc6a51919cfeb2e6763f62b6d9e8815acbf7cd2e476ea353743570610737b752
Status: Downloaded newer image for hello-world:latest
docker.io/library/hello-world:latest
```

有了镜像后，我们就能够以这个镜像为基础，启动并运行一个容器。

```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

基于 `hello-world` 镜像启动的容器的作用就是在命令行窗口打印一些文本信息。

`docker run` 是运行容器的命令，具体格式我们会在容器一节进行详细讲解。



#### 2、列出镜像

要想列出已经下载下来的镜像，可以使用 `docker image ls` 命令或者 `docker images` 命令。

```bash
$ docker images
hello-world         latest              fce289e99eb9        13 months ago       1.84kB
```

列出部分镜像。假设我们拉取了很多镜像，现在想列出 `java` 仓库中的镜像，我们可以这样：

```bash
$ docker images java

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
java                8                   308e519aac60        6 days ago          824.5 MB
java                7                   493d82594c15        3 months ago        656.3 MB
java                latest              2711b1d6f3aa        5 months ago        603.9 MB
```

也可以添加标签进行进一步的过滤：

```bash
$ docker images java:8

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
java                8                   308e519aac60        6 days ago          824.5 MB
```



#### 3、删除本地镜像

可以使用 `docker rmi` 命令来删除一个或多个镜像。语法如下：

```bash
$ docker rmi [OPTIONS] IMAGE [IMAGE...]
```

`OPTIONS` 说明：

- `-f`：强制删除；
-  `--no-prune`：不移除该镜像的过程镜像，默认移除。

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql               latest              791b6e40940c        2 weeks ago         465MB
hello-world         latest              fce289e99eb9        13 months ago       1.84kB
$ docker rmi fce289e99eb9
Untagged: hello-world:latest
Untagged: hello-world@sha256:fc6a51919cfeb2e6763f62b6d9e8815acbf7cd2e476ea353743570610737b752
Deleted: sha256:fce289e99eb9bca977dae136fbe2a82b6b7d4c372474c9235adc1741675f587e
Deleted: sha256:af0b15c8625bb1938f1d7b17081031f649fd14e6b233688eea3c5483994a66a3
```

如果有容器正在使用镜像，需要删除该容器，才可以删除镜像；我们也可以添加 `-f` 参数执行强制删除。



### 六、操作容器

#### 1、启动容器

启动容器有两种方式，一种是基于镜像新建一个容器并启动，另外一个是将在终止状态（`stopped`）的容器重新启动。因为 `Docker` 的容器实在太轻量级了，所以很多时候用户都是随时删除和新创建容器。

**新建并启动：**

```bash
$ docker 
$ docker run 
```

