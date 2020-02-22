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

那我们为什么要使用 `Docker` 呢，它有什么好处呢？

#### 1、没有虚拟化技术的原始年代

在没有计算虚拟化技术的年代，如果我们要部署一个应用程序（`Application`），一般的步骤是怎么样的？

第一步肯定是要先**准备一台物理服务器**，然后在物理服务器上**安装一个操作系统**（`Operating System`），有了操作系统之后，就可以在操作系统上**安装并运行我们的应用程序**。这个过程可以用下面的图来表示：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/deploy-application-without-virtualization.png" alt="deploy-application-without-virtualization" style="zoom:50%;" />

这种方式有几个缺点：

- 部署非常慢：得先准备硬件服务器，接着还要安装操作系统，然后再部署应用程序；而且应用程序还有很多的依赖软件和环境变量，这些都需要在安装的操作系统中设置，所以这个过程是比较慢的；

- 成本非常高：物理机器的成本是很高的，即使是部署一个简单的应用，也需要一台服务器；

- 资源浪费：如果应用非常简单，就容易浪费硬件资源，比如 `CPU` 和内存等；

- 迁移和扩展太慢：如果需要迁移应用，或者扩展应用，就要再准备其他的物理服务器，过程很麻烦，也很慢。

那有什么办法可以解决这些问题呢？答案就是**虚拟化技术**。



#### 2、使用虚拟机部署应用程序的年代

什么是虚拟化技术？

谈到计算机的虚拟化技术，我们直接想到的就是虚拟机。

虚拟机允许我们在一台物理计算机上模拟出多台机器。简单地理解，虚拟化技术就是在一台物理计算机上，通过中间虚拟软件层 `Hypervisor` 隔离 `CPU`、内存等硬件资源，虚拟出多台虚拟服务器，这样做的话，一台物理服务器就可以安装多个应用程序，达到资源利用的最大化，而且多个应用之间相互隔离，如下图所示：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/deploy-application-with-vm.png" alt="deploy-application-with-vm" style="zoom:50%;" />

使用虚拟机有这些优点：

- 把硬件资源分配到不同的虚拟机上，达到硬件资源的最大化利用；
- 与直接在物理机上部署应用相比，虚拟机更容易扩展应用；
- 通过虚拟机虚拟出不同的物理资源，可以快速搭建云服务。

但是它也有一些缺点，**虚拟机的不足之处就在于对物理服务器资源的消耗过大**。

当我们在物理服务器每创建一台虚拟机时，**就需要虚拟出一套硬件并在上面运行完整的操作系统**，虽然这个虚拟工作大部分都不用开发人员自己来操作，但是它所需的系统引导时间和操作系统运行的资源消耗是非常大的，往往需要几分钟甚至更长的时间。

并且，虚拟机一般都是一个完整的用户操作系统以及其中安装好的大量应用程序，它是非常笨重的。每一个虚拟机上也都需要再去安装许多依赖。在实际生产开发环境里，我们更关注的其实是自己部署的应用程序，如果每次部署发布都得搞一个完整操作系统和附带的依赖环境，这是很麻烦且影响效率的，非常容易出错。所以我们经常会听到开发者这样的抱怨 —— **"明明我本地是好的，怎么一到服务器就不行了呢？"**。



#### 3、容器化技术

那有没有一种方式，能让开发者更加关注部署的应用程序本身，让底层操作系统和依赖环境可以共享和复用呢？简单来说就是：当部署好一个服务后，再想移植到另外一个地方，可以不用再安装一套操作系统和依赖环境。容器（`Container`）化技术很好地解决了这个问题。

举个例子：这就像集装箱运载一样，把货物（应用程序）打包放到一个集装箱里，假设这个货物是一箱罐头和食用所需的勺子与叉子（依赖环境），它通过货轮可以轻而易举地从一个码头（`Ubuntu` 环境）运送到另一个码头（`Centos` 环境）。在运输期间，货物没有受到任何的损坏（程序文件没有丢失和损坏），在另外一个码头卸货后，依然可以很好地食用（启动正常）。

**容器和虚拟机的的区别**

我们看一下 `Docker` 官网的图示：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/container-vs-vm.png" alt="deploy-application-with-vm" style="zoom:50%;" />

虚拟机有 `Hypervisor` 层，`Hypervisor` 是整个虚拟机的核心所在，它为虚拟机提供了虚拟的运行平台，管理虚拟机的操作系统运行。而容器没有 `Hypervisor` 这一层，**并且每个容器是和宿主机共享硬件资源及操作系统，那么由 `Hypervisor` 带来性能的损耗，在 `linux` 容器这边是不存在的。**

传统虚拟化技术是对硬件资源的虚拟，**而容器化技术则是对进程的虚拟**，在用户空间**以分离的进程运行**，从而可提供更轻量级的虚拟化，实现进程和资源的隔离。因此容器化比完整虚拟机使用更少的资源，减轻主机内存的压力，更加轻量，启动速度也更加迅速（通常都是秒级）。



#### 4、Docker 的优点

这种容器化技术 ——  `Linux Container` （简称 `LXC`）其实很早就已经诞生了。那么为什么 `Docker` 的出现会快速吸引到技术业界的注意？

`Docker` 相比于其它容器化技术，有以下优点：

- 易用性：`Docker` 可以将应用以**集装箱**的方式进行打包，通过**镜像**的方式可以实现在不同的环境下进行快速部署。使用 `Docker` 可以轻松的为任何应用创建一个轻量级的、可移植的、自给自足的容器；
- 速度快： `Docker` 容器具备轻量化与高速特性。由于容器本身属于运行在内核之上的沙箱环境，因此对资源的需求量极低。开发人员可以在数秒钟内完成容器的创建与运行，而虚拟机则由于需要引导完整的虚拟操作系统而耗费更多时间；
- `Docker Hub`：它相当于 `Docker` 镜像的应用商店。`Docker Hub` 提供了成千上万由社区开发的公共镜像，我们可以轻松地根据需要搜索到合适的镜像，将其提取并稍加修改即可使用；
- 模块性与可扩展性：`Docker` 允许我们轻松地将应用程序的功能拆分成多个独立容器。举例来说，我们可以将自己的 `Postgres` 数据库运行在一套容器当中，并将 `Redis` 服务器运行在另一容器内，而 `Node.js` 也拥有自己的容器系统。在 `Docker` 的帮助上，大家能够轻松将这些容器对接起来以创建完整的应用程序，这就让未来的规模伸缩或者组件更新得以通过相互独立的方式完成。



#### 5、Docker 的版本

`Docker` 分为社区版（`CE`）和企业版（`EE`）两个版本，社区版本可以免费使用，而企业版则需要付费使用。对于我们个人开发者或小企业来说，一般使用社区版就足够了。



### 二、Docker 架构一瞥

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/docker-architecture.jpg" alt="Docker Architecture" style="zoom: 62%;" />

<p align="center">（图片来自网络）</p>

1. 中间部位为我们进行 `Docker` 操作的宿主机，其运行了一个 `Docker daemon` 的核心守护程序，负责构建、运行和分发 `Docker` 容器；

2. 左边为 `Docker` 客户端，其与 `Docker` 守护进程进行通信，客户端会将 `build`、`pull`、`run` 命令发送到 `Docker` 守护进程进行执行；

3. 右边为 `Docler` 注册表存储 `Docker` 镜像，是一个所有 `Docker` 用户共享 `Docker` 镜像的服务，`Docker daemon` 与之进行交互。



### 三、基本概念

#### 1、镜像

`Docker` 会把应用程序及依赖打包进镜像（`Images`）里，提供了容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等），通过这个镜像文件可生成 `Docker` 容器。

我们也可以自己制作镜像，例如我们可以在 `Ubuntu` 镜像基础之上安装 `Redis`、`Mysql` 等其它应用程序，然后将其制作成一个镜像。制作好的镜像文件可以拷贝到其它机器使用。镜像的制作可以基于 `Dockerfile` 构建（后面会讲解）。



#### 2、容器

容器是镜像的可运行实例。镜像（`Image`）和容器（`Container`）的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体。

我们可以使用 `Docker` 提供的 `API` 创建、启动、停止、移动或删除容器。在默认情况下，容器与其它容器及其主机是隔离的，拥有自己的独立进程空间、网络配置。

容器由其镜像以及在创建或启动容器时提供的配置选项来定义。当容器被删除时，未对容器状态做持久化存储的更改都会消失。



#### 3、仓库

镜像构建完成后，可以很容易的在当前宿主机上运行。但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，[Docker Hub](https://hub.docker.com/) 就是这样的服务，我们把这个服务叫作**仓库**（ `Docker Registry` ）。仓库的概念与 `Git` 类似，可以理解为 `GitHub` 这样的托管服务。

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

[Docker Hub](https://hub.docker.com/explore/) 上有大量的高质量的镜像可以用。从 `Docker` 镜像仓库获取镜像的命令是 `docker pull`：

```bash
$ docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
```

- 拉取一个镜像，需要指定 `Docker Registry` 的地址和端口号，默认是 `Docker Hub`；
- 还需要指定仓库名和标签，**仓库名和标签可以唯一确定一个镜像**，仓库名则由作者名和软件名组成；
- 而标签是可以省略的，如果省略，则默认使用 `latest` 作为标签名。

以拉取 `centos` 镜像为例：

```bash
$ docker pull centos
```

因为省略作者名，则作者名为 `library`，表示使用 `Docker` 官方的镜像，所以上面的命令等同于：

```bash
$ docker pull library/centos:latest
```

因此，如果拉取非官方的第三方镜像，则需要指定完整仓库名，如下：

```bash
$ docker pull mysql/mysql-server:latest
```



#### 2、运行镜像

使用 `docker run` 命令，可以通过镜像创建一个容器：

```bash
$ docker run -it centos /bin/bash
```

具体格式会在容器一节进行详细讲解。



#### 3、列出镜像

要想列出已经下载下来的镜像，可以使用 `docker image ls` 命令或者快捷命令 `docker images` 。

```bash
$ docker images
```

**列出部分镜像**

假设我们拉取了很多镜像，现在想列出 `java` 仓库中的镜像，可以使用命令：

```bash
$ docker images java
```

也可以添加标签做进一步的过滤：

```bash
$ docker images java:8
```



#### 4、删除本地镜像

当本地有些镜像我们不再需要时，那我们也可以删除该镜像，以节省存储空间。不过要注意，如果有使用该镜像创建的容器未删除，则不允许删除镜像。

```bash
$ dockere image rm image_name/image_id
```

> `image_name` 表示镜像名，`image_id` 表示镜像 `id` 。

快捷命令为：

```bash
$ docker rmi image_name/image_id
```

如果想要删除全部镜像：

```bash
$ docker rmi $(docker images -q)
```

强制删除全部镜像：

```bash
$ docker rmi -f $(docker images -q)
```





### 六、操作容器

#### 1、启动容器

启动容器有两种方式，一种是基于镜像新建一个容器并启动，另外一个是将在终止状态（`stopped`）的容器重新启动。因为 `Docker` 的容器实在太轻量级了，所以很多时候用户都是随时删除和新创建容器。

**新建并启动：**

```bash
$ docker run hello-world
```

如果本地环境中没有 `hello-world` 镜像，会从远程仓库中拉取镜像；如果有，则使用本地的镜像。

> 注意：命令执行之后，`hello-world`  这个容器会自动停止，但并不是所有的容器运行之后都会停止的。



**重新启动停止的容器：**

```bash
$ docker start CONTAINER_ID
```



#### 2、查看容器

如果要查看本地的容器，可以使用 `docker container ls` 命令：

```bash
$ docker container ls
```

查看所有容器也有简洁的写法，如下：

```bash
$ docker ps
```

注意，上面两条命令都是列出正在运行的容器。如果想要列出所有容器（包含已停止的容器），可以使用命令：

```bash
$ docker ps --all
```

或者快捷命令：

```bash
$ docker ps -a
```



#### 3、停止容器

可以使用 `docker container stop` 来终止一个运行中的容器。也可以使用快捷命令：

```bash
$ docker stop container_id
```

此外，`docker container restart` 命令会将一个运行态的容器终止，然后再重新启动它。



#### 4、删除容器

我们可以使用 `docker container rm` 命令，或者简洁的写法 `docker rm` 命令来删除容器。不过不允许删除正在运行的容器，因此如果要删除的话，就必须先停止容器。

```bash
$ docker rm container_id
```

> `container_id` 表示容器 `id`，可以通过 `docker ps` 查看容器 `id` 。

当我们需要批量删除所有容器，可以用下面的命令：

```bash
$ docker rm $(docker ps -q)
```

删除所有退出的容器：

```bash
$ docker container prune
```



#### 5、进入容器

```bash
$ docker exec -it container_id command
```

`container_id` 表示容器的 `id`，`command` 表示 `linux` 命令，如 `/bin/bash`。

下面的命令则启动一个 `bash` 终端，允许用户进行交互：

```bash
$ docker run -it ubuntu:18.04 /bin/bash
root@75053a970732:/#
```

其中，`-t` 选项让 `Docker` 分配一个伪终端（`pseudo-tty`）并绑定到容器的标准输入上， `-i` 则让容器的标准输入保持打开。可以合起来写成 `-it` 。

在交互模式下，用户可以通过所创建的终端来输入命令，例如：

```bash
root@75053a970732:/# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
```



### 七、访问仓库

仓库（`Repository`）是集中存放镜像的地方。	

`Docker Hub` 有很多官方或其他开发者提供的高质量镜像供我们使用。当然，我们也可以把自己在本地构建的镜像发送到 `Docker Hub` 的仓库当中。

注意，这里有一个比较容易混淆的概念 —— 注册服务器 `Docker Registry` 。注册服务器是管理仓库的具体服务器，每个服务器上可以有多个仓库（`Repository`），而每个仓库下面有多个镜像，每个仓库对应多个标签，不同标签对应一个软件的不同版本。

大部分时候，我们并不需要严格区分这两者的概念。

