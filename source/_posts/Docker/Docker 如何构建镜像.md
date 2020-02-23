---
title: Docker —— 使用 Dockerfile 构建镜像
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

下面我们来看看如何构建镜像。



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



#### 3、镜像构建上下文

`docker` 的运行模式是 `C/S`（`Client/Service`）架构的。我们本机是 `C`，`docker` 引擎是 `S`。实际上的构建过程并不是在我们的本机环境中完成的，而是在 `docker` 引擎下完成的。

`Docker` 的引擎提供了一组 `REST API`，被称为 [Docker Remote API](https://docs.docker.com/develop/sdk/)，我们在客户端工具中执行的 `docker` 命令，就是通过这组 `API` 与 `Docker` 引擎进行交互，从而完成各种功能。

因此，虽然表面上我们好像是在本机执行各种 `Docker` 功能，但实际上，一切都是使用的远程调用形式在服务端（`Docker` 引擎）完成。所以这个时候，`Docker` 引擎无法用到我们本机的文件。这就需要把我们本机的指定目录下的文件（上下文包）一起打包提供给 `Docker` 引擎使用。这就是构建上下文的概念（`context`）。

所以，刚才的命令 `docker build -t nginx:v3 .` 中的这个 `.`，实际上是在指定上下文的目录，`docker build` 命令会将该目录下的内容打包交给 `Docker` 引擎用以帮助构建镜像。

如果观察 `docker build` 输出，我们其实已经看到了这个发送上下文的过程：

```bash
$ docker build -t nginx:v3 .
Sending build context to Docker daemon  2.048kB
...
```

**注意**：上下文路径下不要放无用的文件，因为会一起打包发送给 `Docker` 引擎，如果文件过多会造成过程缓慢。



### 三、Dockerfile 指令详解

#### 1、COPY

复制指令，从上下文目录中复制文件或者目录到容器里指定路径。其格式为：

```dockerfile
COPY [--chown=<user>:<group>] <源路径1>...  <目标路径>
COPY [--chown=<user>:<group>] ["<源路径1>",...  "<目标路径>"]
```

- <源路径>：源文件或者源目录，可以是通配符表达式；
- <目标路径>：容器内的指定路径，该路径不用事先建好，路径不存在的话，会自动创建。

例如：

```dockerfile
COPY hom* /mydir/
COPY hom?.txt /mydir/
```

`[--chown=<user>:<group>]` 为可选参数，用于改变复制到容器内文件的拥有者和属组，例如：

```docker
COPY --chown=55:mygroup files* /mydir/
COPY --chown=bin files* /mydir/
COPY --chown=1 files* /mydir/
COPY --chown=10:11 files* /mydir/
```



#### 2、ADD

`ADD` 指令和 `COPY` 的使用格式一致，功能也类似，不同之处在于：

如果 `<源路径>` 为一个 `tar` 压缩文件，压缩格式为 `gzip`, `bzip2` 以及 `xz` 的情况下，`ADD` 指令将会自动解压缩这个压缩文件到 `<目标路径>` 去。在某些情况下，这个自动解压缩的功能非常有用。

但在某些情况下，如果我们真的是希望复制个压缩文件进去，而不解压缩，这时就不可以使用 `ADD` 命令了。在 `Docker` 官方的最佳实践中，要求尽可能的使用 `COPY`，因为 `COPY` 的语义很明确，就是复制文件而已，而 `ADD` 则包含了更复杂的功能，其行为也不一定很清晰。最适合使用 `ADD` 的场合，就是所提及的需要自动解压缩的场合。



#### 3、CMD

`CMD` 类似于 `RUN` 指令，但是 **`CMD` 指令给出的是一个容器的默认的可执行体**。也就是容器启动以后，默认的执行的命令。此命令会在容器启动且 `docker run` 没有指定其他命令时运行。如果 `docker run` 指定了其他命令，那么 `CMD` 指令会被覆盖。

它也有两种格式：

- `shell` 格式：`CMD <命令>`；
- `exec` 格式：`CMD ["可执行文件", "参数1", "参数2"...]`。

在指令格式上，一般推荐使用 `exec` 格式，这类格式在解析时会被解析为 `JSON` 数组，因此一定要使用双引号，而不要使用单引号。

注意：在 `Dockerfile` 中，如果有多个 `CMD` 指令，则以最后一个为准。



#### 4、ENTRYPOINT

`ENTRYPOINT` 指令和 `CMD` 指令都可以设置容器启动时要执行的命令，但用途是有略微不同的。

`ENTRYPOINT` 指令在构建镜像的时候并不会被执行，只有在执行 `docker run` 命令启动容器时才会起作用，它不会被 `docker run` 的命令行参数指定的名令所覆盖，而且这些命令行参数会被当作参数传递给 `ENTRYPOINT` 指令指定的程序。

如果 `Dockerfile` 中如果存在多个 `ENTRYPOINT` 指令，仅最后一个生效。



#### 5、ENV

这个指令用于设置环境变量，**无论是后面的其它指令，还是运行时的应用**，都可以直接使用这里定义的环境变量。



#### 6、ARG

`ARG` 构建参数指令和 `ENV` 的效果一样，都是设置环境变量。不同的是，`ARG` 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的。

这里要特别注意：不要因此就使用 `ARG` 保存密码之类的信息，因为 `docker history` 还是可以看到的。



#### 7、VOLUME

之前我们说过，容器运行时应该尽量保持容器存储层不发生写操作。但是对于数据库类需要保存动态数据的应用，其数据库文件应该保存下来 —— 数据卷（`volume`）中。

数据卷是被设计用来持久化数据的，它的生命周期独立于容器，`Docker` 不会在容器被删除后自动删除 数据卷，并且也不存在垃圾回收这样的机制来处理没有任何容器引用的数据卷。

所以，为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在 `Dockerfile` 中，我们可以事先指定某些目录挂载为匿名卷，保证数据不会丢失。

关于卷的使用，后面我会单独写一篇文章来介绍。



#### 8、EXPOSE

如果外界要和 `Docker` 容器进行通讯，就需要使用端口了。`EXPOSE` 指令的功能就是暴露容器运行时的监听端口给外部。

但是，`EXPOSE` 仅仅是个声明，如果想使得容器与主机的端口有映射关系，必须在容器启动的时候加上 `-P` 参数，此时容器端口会自动映射到本机的随机端口。

当然，我们也可以不暴露端口，使用手动映射，这就需要在启动容器的时候加上 `-p <宿主端口>:<容器端口>` 参数。



#### 9、WORKDIR

使用 `WORKDIR` 指令可以指定工作目录（或者称为当前目录），以后构建镜像的每一层的当前目录就会被改为所指定的目录。如果该目录不存在，`WORKDIR` 会帮你建立目录。



#### 10、USER

用于指定执行后续命令的用户和用户组。注意，这只是切换后续命令执行的用户，用户和用户组必须提前已经存在，否则无法切换。



#### 11、HEALTHCHECK

`HEALTHCHECK` 是设置检查容器健康状况的命令，该指令是告诉 `Docker` 应该如何进行判断容器的状态是否正常。

假设我们有个镜像是个最简单的 `Web` 服务，我们希望增加健康检查来判断该 `Web` 服务是否在正常工作，我们可以用 `curl` 来帮助判断。`Dockerfile` 的 `HEALTHCHECK` 可以这么写：

```dockerfile
FROM nginx
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -fs http://localhost/ || exit 1
```

这里我们设置了每 5 秒检查一次（这里为了试验所以间隔非常短，实际应该相对较长），如果健康检查命令超过 3 秒没响应就视为失败，并且使用 `curl -fs http://localhost/ || exit 1` 作为健康检查命令。



#### 12、ONBUILD

`ONBUILD` 指令用于延迟构建命令的执行。该指令在当前镜像构建时并不会被执行。只有当以当前镜像为基础镜像，去构建下一级镜像的时候才会被执行。

简单的说，就是 `Dockerfile` 里用 `ONBUILD` 指定的命令，在本次构建镜像的过程中不会执行（假设镜像为 `test-build`）。当有新的 `Dockerfile` 使用了之前构建的镜像 `FROM test-build`，执行新镜像的 `Dockerfile` 构建时候，会执行 `test-build` 的 `Dockerfile` 里的 `ONBUILD` 指定的命令。这有点像 `Java` 中的抽象类的概念。



### 四、Dockerfile 实践

下面我们通过一个 `Node.js` 的简单项目为例，介绍下如何编写 `Dockerfile` 文件、如何在 `Docker` 容器里运行  `Node.js` 项目。

#### 1、项目准备

创建一个 `Node.js` 项目：

```bash
$ mkdir hello-docker & cd hello-docker
$ npm init -y
$ npm install express --save
```

创建 `server.js` 文件，写入以下内容：

```javascript
const express = require('express');
const port = 30010;

const app = express();
app.get('/', (req, res) => res.send('Hello Docker!'));

app.listen(port, () => console.log(`Running on http://localhost:${port}`));
```

修改 `package.json` 里面的内容：

```json
{
  "name": "hello-docker",
  "version": "1.0.0",
  "description": "Node.js on Docker",
  "repository": "",
  "main": "app.js",
  "scripts": {
    "start": "node server.js"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.17.1"
  }
}

```



#### 2、编写 Dockerfile

```dockerfile
FROM node:10.0

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 30010
CMD [ "node", "server.js" ]
```



#### 3、构建镜像

```bash
$ docker build -t hello-docker .
```



#### 4、启动容器

```bash
$ docker run -d -p 30000:30010 hello-docker
```

将本机的 `30000` 端口映射到容器的 `30010` 端口，这样在外网就可通过 `30000` 端口访问到我们的服务了。

通过 `docker ps` 查看我们刚刚运行的容器信息：

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                 NAMES
70746429068a        hello-docker        "node server.js"         2 minutes ago       Up 2 minutes        0.0.0.0:30000->30010/tcp              modest_brown
```



#### 5、访问服务

此时我们的 `Node.js` 服务已经运行在 `Docker` 容器的虚拟环境里了，浏览器访问 http://localhost:30000 可以进行测试。也可以直接通过 `curl` 命令测试：

```bash
$ curl -i localhost:30000
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 13
ETag: W/"d-ycMOqUR5/PppgEP78YMMk23qVGA"
Date: Sun, 23 Feb 2020 02:13:19 GMT
Connection: keep-alive

Hello Docker!%
```



### 五、总结

更多内容可以参考：

- https://docs.docker.com/engine/reference/builder/
- https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

