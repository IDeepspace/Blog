---
title: Docker 从入门到实践（二）
author: Deepspace
categories: Docker
date: 2018-05-12
urlname: how-to-build-image
tags:
  - Docker
---

镜像是容器的基础，每次执行 `docker run` 的时候都会指定哪个镜像作为容器运行的基础。

直接使用 `Docker Hub` 中提供的镜像可以满足一定的需求，而当这些镜像无法直接满足需求时，我们就需要定制一些镜像。

并且，在部署应用程序的时候，我们也会将应用打包成 `Docker` 镜像并部署到服务器。

下面我们来看看如何定制镜像。



### 一、理解镜像构成

学习如何构建镜像（`image`）之前，我们先来理解一下镜像的构成。

#### 1、镜像的分层存储

我们应该都在电脑上重装过操作系统，会装 `Windows7`、`Windows10`，可能也会安装 `Ubuntu` ，重装的操作系统就是镜像，下载安装的镜像一般都是 `ISO` 格式的文件。

镜像包含操作系统完整的 `root` 文件系统，其体积往往是庞大的，所以 `Docker` 在设计的时候，将其设计为**分层存储的架构**。所以，`Docker` 中的镜像并非是像一个 `ISO` 那样的打包文件，镜像只是一个虚拟的概念，其实际体现并非由一个文件组成，而是**由一组文件系统组成**，或者说，由多层文件系统联合组成。

**镜像构建时，会一层层构建，前一层是后一层的基础**。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。比如，删除前一层文件的操作，实际上并不是真的删除前一层的文件，而是仅在当前层标记为该文件已删除。在最终容器运行的时候，虽然不会看到这个文件，但是实际上该文件会一直跟随镜像。因此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。

分层存储的特征还使得镜像的复用、定制变的更为容易。甚至可以用之前构建好的镜像作为基础层，然后进一步添加新的层，以定制自己所需的内容，构建新的镜像。



#### 2、利用 commit 理解镜像构成

现在我们通过定制一个 `Web` 服务器为例子，来讲解镜像是如何构建的。

```bash
$ docker run --name webserver -d -p 80:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
bc51dd8edc1b: Pull complete
66ba67045f57: Pull complete
bf317aa10aa5: Pull complete
Digest: sha256:ad5552c786f128e389a0263104ae39f3d3c7895579d45ae716f528185b36bc6f
Status: Downloaded newer image for nginx:latest
46b0732981d17cfcb3c71c17921ea009ea59cf11b04bfdd4ccf5b2fd0ce0e679
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                 NAMES
46b0732981d1        nginx               "nginx -g 'daemon of…"   11 minutes ago      Up 11 minutes       0.0.0.0:80->80/tcp                    webserver
```

这条命令会拉取一个 `nginx` 镜像，并基于镜像启动一个容器，命名为 `webserver`，并且映射了 `80` 端口，这样我们可以用浏览器去访问这个 `nginx` 服务器。`-d`  的作用是让容器可以保持后台运行，并返回容器 `ID`。

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/docker-welcome-to-nginx.png" alt="docker-welcome-to-nginx" style="zoom:50%;" />

直接用浏览器访问的 http://localhost，我们会看到默认的 `Nginx` 欢迎页面。

现在，我们不喜欢这个欢迎页面，想进行一些修改，该页面的存储位置在这个被取名为 `webserver` 的 `Nginx` 容器中的 `/usr/share/nginx/html/` 目录下。使用 `docker exec` 命令进入容器，修改其内容：

```bash
$ docker exec -it webserver bash
root@46b0732981d1:/#
root@46b0732981d1:/# echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
root@46b0732981d1:/# exit
exit
```

刷新页面，会发现内容被改变了。

我们修改了容器的文件，也就是改动了容器的存储层。可以通过 `docker diff` 命令看到具体的改动：

```bash
$ docker diff webserver
C /root
A /root/.bash_history
C /run
A /run/nginx.pid
C /var
C /var/cache
C /var/cache/nginx
A /var/cache/nginx/fastcgi_temp
A /var/cache/nginx/proxy_temp
A /var/cache/nginx/scgi_temp
A /var/cache/nginx/uwsgi_temp
A /var/cache/nginx/client_temp
C /usr
C /usr/share
C /usr/share/nginx
C /usr/share/nginx/html
C /usr/share/nginx/html/index.html
```

当我们运行一个容器的时候（如果不使用卷的话），我们在容器中做的任何文件修改都会被**记录于容器存储层里**。现在我们定制好了变化，希望能将其保存下来，构建出一个镜像。

`Docker` 提供了一个 `docker commit` 命令，其语法格式为：

```bash
$ docker commit [选项] <容器ID或容器名> [<仓库名>[:<标签>]]
```

现在将容器的存储层保存下来成为镜像：

```bash
$ docker commit --author "cxin <cxin1427@gmail.com>" --message "modify the default welcome page" webserver nginx:v2
sha256:cacda6e1bab9dd3d451676cdd59224a8c6187266450eb111e7cac626fe1a0cbf
```

其中 `--author` 是指定修改的作者，而 `--message` 则是记录本次修改的内容。这点和 `git` 版本控制相似，不过这里这些信息可以省略留空。

我们可以在 `docker images` 中看到这个新定制的镜像：

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
nginx               v2                  828827c604fd        About a minute ago   127MB
nginx               latest              2073e0bcb60e        2 weeks ago          127MB
```

我们还可以用 `docker history` 具体查看镜像内的历史记录，比较其在 `nginx:latest` 镜像的基础上做的改动，这点和 `git` 的版本控制也是相似的：

```bash
$ docker history nginx:v2
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
828827c604fd        2 minutes ago       nginx -g daemon off;                            137B                modify the default welcome page
2073e0bcb60e        2 weeks ago         /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>           2 weeks ago         /bin/sh -c #(nop)  STOPSIGNAL SIGTERM           0B
<missing>           2 weeks ago         /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>           2 weeks ago         /bin/sh -c ln -sf /dev/stdout /var/log/nginx…   22B
<missing>           2 weeks ago         /bin/sh -c set -x     && addgroup --system -…   57.5MB
<missing>           2 weeks ago         /bin/sh -c #(nop)  ENV PKG_RELEASE=1~buster     0B
<missing>           2 weeks ago         /bin/sh -c #(nop)  ENV NJS_VERSION=0.3.8        0B
<missing>           2 weeks ago         /bin/sh -c #(nop)  ENV NGINX_VERSION=1.17.8     0B
<missing>           2 weeks ago         /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
<missing>           2 weeks ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           2 weeks ago         /bin/sh -c #(nop) ADD file:ba0c39345ccc4a882…   69.2MB
```

新的镜像定制好后，我们可以来运行这个镜像。

```bash
$ docker run --name webserver2 -d -p 81:80 nginx:v2
74dd9866b7ba14998f539f3c91da976cf4f5631d3c1b84bb1b6e00348a437258
```

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Docker/docker-welcome-to-nginx-1.png" alt="docker-welcome-to-nginx-1" style="zoom:50%;" />

访问 [http://localhost:81](http://localhost:81/) 看到结果，其内容和之前修改后的 `webserver` 是一样的。



现在，我们使用 `docker commit` 命令，手动操作给旧的镜像添加了新的一层，形成新的镜像，对镜像的多层存储设计应该有了更直观的感觉。但是在实际开发环境中，我们并不会这样使用。



#### 3、docker commit 的缺点

如果仔细观察之前我们执行 `docker diff webserver` 命令后打印的具体改动信息就会发现，**除了真正想要修改的 `/usr/share/nginx/html/index.html` 文件外，还有很多文件被改动或添加了**。这还仅仅是最简单的操作，如果是安装软件包、编译构建等操作，那会有大量的无关内容被添加进来，将会导致镜像极为臃肿。

而且，`Docker` 镜像使用的是分层存储的设计，除当前层外，之前的每一层都不会发生改变，也就是说，任何修改的结果仅仅是在当前层进行标记、添加、修改的，而不会改动上一层。如果使用 `docker commit` 制作镜像，以及后期修改的话，每一次修改都会让镜像更加臃肿一次，所删除的上一层的东西并不会丢失，会一直跟着这个镜像，即使根本无法访问到，这会让镜像变得更加臃肿。

另外，使用 `docker commit` 意味着所有对镜像的操作都是黑箱操作，除了制作镜像的开发人员知道执行过什么命令、怎么生成的镜像，其他人根本无从得知。而且，即使是这个制作镜像的人，过一段时间后也无法记清具体的操作。这种黑箱操作构建的镜像的维护工作是非常痛苦的。

所以，更好的方式就是 —— **基础设施代码化**。如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建镜像，那前面所说的问题都会被解决。这个脚本就是 `Dockerfile`。



### 二、使用 Dockerfile 构建镜像

`Dockerfile` 是一个文本文件，其内包含了一条条的**指令(`Instruction`)**，每一条指令构建一层，所以每一条指令的内容，就是描述该层应当如何构建。

还以之前定制 `nginx` 镜像为例，这次我们使用 `Dockerfile` 来定制。

在一个空白目录中，新建一个文件，并命名为 `Dockerfile`：

```bash
$ mkdir mynginx
$ cd mynginx
$ touch Dockerfile
```

其内容为：

```dockerfile
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

这个 `Dockerfile` 很简单，只包含了 `FROM` 和 `RUN` 两条指令。

#### 1、FROM 和 RUN 指令的作用

- `FROM`：定制的镜像都是基于 `FROM` 的镜像，这里的 `nginx` 就是定制需要的基础镜像，后续的操作都是基于 `nginx`；

- `RUN`：用于执行后面跟着的命令行命令。有两种格式：

  - `shell` 格式：`RUN <命令行命令>`，`<命令行命令>` 等同于在终端操作的 `shell` 命令；

  - `exec` 格式：`RUN ["可执行文件", "参数1", "参数2"]`，这更像是函数调用中的格式，例如：

    ```bash
    $ RUN ["./test.js", "dev", "offline"] 
    ```

    等价于 `shell` 格式的：

    ```bash
    $ RUN ./test.js dev offline
    ```

既然 `RUN` 就像 `shell` 脚本一样可以执行命令，那么我们是否就可以像 `shell` 脚本一样把每个命令对应一个 `RUN` 呢？比如这样：

```dockerfile
FROM debian:stretch

RUN apt-get update
RUN apt-get install -y gcc libc6-dev make wget
RUN wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz"
RUN mkdir -p /usr/src/redis
RUN tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1
RUN make -C /usr/src/redis
RUN make -C /usr/src/redis install
```

之前说过，`Dockerfile` 中每一个指令都会建立一层，`RUN` 也不例外。每一个 `RUN` 的行为，就和刚才我们手工建立镜像的过程一样：**新建立一层，在其上执行这些命令，执行结束后，`commit` 这一层的修改，构成新的镜像。**

而上面的这种写法，创建了 7 层镜像。这是完全没有意义的，而且很多运行时不需要的东西，都被装进了镜像里，比如编译环境、更新的软件包等等。结果就是产生非常臃肿、非常多层的镜像，不仅仅增加了构建部署的时间，也很容易出错。

所以，上面的 `Dockerfile` 正确的写法应该是这样：

```dockerfile
FROM debian:stretch

RUN buildDeps='gcc libc6-dev make wget' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && rm -rf /var/lib/apt/lists/* \
    && rm redis.tar.gz \
    && rm -r /usr/src/redis \
    && apt-get purge -y --auto-remove $buildDeps
```

之前所有的命令只有一个目的：编译、安装 `redis` 可执行文件。因此没有必要建立很多层，这只是一层的事情。因此，这里仅仅使用一个 `RUN` 指令，并使用 `&&` 将各个所需命令串联起来，将之前的 7 层，简化为了 1 层。

并且，这里为了格式化还进行了换行。`Dockerfile` 支持在行尾添加 `\` 的命令换行，以及行首 `#` 进行注释的格式。**良好的格式，比如换行、缩进、注释等，会让维护、排障更为容易，这是一个比较好的习惯。**

此外，还可以看到这一组命令的最后添加了清理工作的命令，删除了为了编译构建所需要的软件，清理了所有下载、展开的文件，并且还清理了 `apt` 缓存文件。这是很重要的一步，我们之前说过，镜像是多层存储，每一层的东西并不会在下一层被删除，会一直跟随着镜像。**因此镜像构建时，一定要确保每一层只添加真正需要添加的东西，任何无关的东西都应该清理掉**。



#### 2、构建镜像

现在我们来通过 `Dockerfile` 构建这个镜像，在 `Dockerfile` 文件所在目录执行：

```bash
$ docker build -t nginx:v3 .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM nginx
 ---> 2073e0bcb60e
Step 2/2 : RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
 ---> Running in d1b384920233
Removing intermediate container d1b384920233
 ---> ff3b6f56ff97
Successfully built ff3b6f56ff97
Successfully tagged nginx:v3
```

`docker build` 命令用于构建镜像，其格式为：

```bash
$ docker build [选项] <上下文路径/URL/->
```

- `-t` 是 `--tag` 的简写，用于指定镜像的名字及标签，通常 `name:tag` 或者 `name` 格式，在这里我们指定了最终镜像的名称 `-t nginx:v3` ；

- `.` 代表本次执行的上下文路径，这个我们待会解释。

下面，查看构建好的镜像：

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
nginx               v3                  ff3b6f56ff97        About a minute ago   127MB
```

通过该镜像启动一个容器：

```bash
$ docker run --name webserver3 -d -p 82:80 nginx:v3
cc6cd57fb1d8d627abf0f47f5415ff9f10a6f0cba0e45cf4973cc54c02515bc2
```

访问 [http://localhost:82](http://localhost:82/) 可以看到结果，其内容和之前使用 `docker commit` 的方式构建的镜像是一样的。

