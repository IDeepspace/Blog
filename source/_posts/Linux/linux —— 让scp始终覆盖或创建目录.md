---
title: linux — 让 scp 始终覆盖或创建目录
author: Deepspace
tags:
  - Linux
categories: Linux
date: 2019-05-20
urlname: linux-scp-cover-completely
---


前段时间在搭建前端项目的基础设施时，遇到这样一个问题：在 `pipline` 上将前端项目 `build` 之后的文件夹拷贝到 `aws` 上，我使用 `scp` 命令将目录从一个远程服务器复制到另一个远程服务器上的新目录，命令如下：

```shell
$ scp -r server1:dir1 server2:dir2
```

如果在 `server2` 上不存在 `dir2`，这可以正常工作，它会创建一个名为 `dir2` 的新目录，其中包含 `server1` 上 `dir1` 的所有内容。

但是当 `dir2` 已经存在于 `server2` 上时，就会出现问题，已经存在的文件不会被覆盖。
<!-- more -->
**解决办法：**

```shell
$ scp -prq server1:dir1/. server2:dir2/
```

在文件目录后面加个点 `.`，将复制该目录的内容，而不是目录本身。
