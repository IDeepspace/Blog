---
title: 如何自动备份Hexo博客源文件
author: Deepspace
top: true
img: ../../ImageHosting/bg/mountain.jpg 
tags:
  - Hexo
categories: Hexo
date: 2016-10-12
urlname: hexo-backup
---

<!-- ## 如何自动备份Hexo博客源文件 -->

### 一.前言

> 电脑装了双系统，前些天重装了系统，没有备份 `Hexo` 博客源文件，只能重新去安装一堆依赖和修改配置了。。。搜了一下网络教程解决了备份的问题，所以此博客记录自动备份`Hexo`博客源文件到`Github`的过程。

原文出自：[自动备份Hexo博客源文件](http://notes.xiamo.tk/2015-07-06-%E8%87%AA%E5%8A%A8%E5%A4%87%E4%BB%BDHexo%E5%8D%9A%E5%AE%A2%E6%BA%90%E6%96%87%E4%BB%B6.html)

### 二.原理

通过通过监听`Hexo ` 的其它事件来完成自动执行Git命令完成自动备份。查阅[Hexo文档](https://hexo.io/zh-cn/api/events.html#deployBefore)，找到了`Hexo` 的主要事件，见下表：

| 事件名         | 事件发生时间         |
| -------------- | -------------------- |
| deployBefore   | 在部署完成前发布     |
| deployAfter    | 在部署成功后发布     |
| exit           | 在 Hexo 结束前发布   |
| generateBefore | 在静态文件生成前发布 |
| generateAfter  | 在静态文件生成后发布 |
| new            | 在文章文件建立后发布 |

于是我们就可以通过监听 `Hexo` 的 `deployAfter` 事件，待上传完成之后自动运行 `Git` 备份命令，从而达到自动备份的目的。
<!-- more -->
### 三.实现

#### 1.将`Hexo`目录加入Git仓库

在`Github`下创建一个新的 `repository`，取名为`HEXO`。进入本地的`Hexo`文件夹，执行以下命令创建仓库:

```shell
$ git init
```

设置远程仓库地址，并更新:

```shell
$ git remote add origin git@github.com:XXX/XXX.git
$ git pull origin master
```

修改 `.gitignore`文件（如果没有请手动创建一个），在里面加入`*.log` 和 `public/` 以及`.deploy*/`。因为每次执行`hexo generate`命令时，上述目录都会被重写更新。因此忽略这两个目录下的文件更新，加快 `push`速度。

执行命令以下命令，完成 `Hexo`源码在本地的提交:

```shell
$ git add .
$ git commit -m "添加hexo源码文件作为备份"
```

执行以下命令，将本地的仓库文件推送到 Github

```shell
$ git push origin master
```

#### 2.安装shelljs模块

要实现这个自动备份功能，需要依赖 `Node.js  `的一个 `shelljs ` 模块,该模块重新包装了`child_process`,调用系统命令更加的方便。该模块需要安装后使用。

在命令中键入以下命令，完成shelljs模块的安装：

```shell
$ npm install --save shelljs
```

#### 3.编写自动备份脚本

待到模块安装完成，在Hexo根目录的scripts文件夹下新建一个js文件，文件名随意取。

> ps: 如果没有scripts目录，请新建一个。

然后在脚本中，写入以下内容：

```javascript
require('shelljs/global');

try {
	hexo.on('deployAfter', function() {//当deploy完成后执行备份
		run();
	});
} catch (e) {
	console.log("产生了一个错误<(￣3￣)> !，错误详情为：" + e.toString());
}

function run() {
	if (!which('git')) {
		echo('Sorry, this script requires git');
		exit(1);
	} else {
		echo("======================Auto Backup Begin===========================");
		cd('D:/hexo');    //此处修改为Hexo根目录路径
		if (exec('git add --all').code !== 0) {
			echo('Error: Git add failed');
			exit(1);

		}
		if (exec('git commit -am "Form auto backup script\'s commit"').code !== 0) {
			echo('Error: Git commit failed');
			exit(1);

		}
		if (exec('git push origin master').code !== 0) {
			echo('Error: Git push failed');
			exit(1);

		}
		echo("==================Auto Backup Complete============================")
	}
}
```

其中，需要修改第17行的 `D:\hexo` 路径为 `Hexo` 的根目录路径。（脚本中的路径为博主的 `Hexo` 路径）

如果你的 `Git` 远程仓库名称不为 `origin` 的话，还需要修改第28行执行的 `push` 命令，修改成自己的远程仓库名和相应的分支名。

保存脚本并退出，然后执行 `hexo deploy` 命令，将会得到类似以下结果:

```shell
INFO  Deploying: git
INFO  Clearing .deploy_git folder...
INFO  Copying files from public folder...
INFO  Copying files from extend dirs...
[master ca549c6] Site updated: 2017-12-19 13:34:01
 61 files changed, 75 insertions(+), 75 deletions(-)
 rewrite archives/2016/page/2/index.html (64%)
 rewrite archives/2017/page/4/index.html (68%)
 rewrite archives/page/4/index.html (68%)
 rewrite archives/page/8/index.html (64%)
 rewrite page/4/index.html (78%)
 rewrite page/8/index.html (74%)
Branch 'master' set up to track remote branch 'master' from 'https://github.com/IDeepspace/IDeepspace.github.io.git'.
To https://github.com/IDeepspace/IDeepspace.github.io.git
   c9c91a4..ca549c6  HEAD -> master
On branch master
nothing to commit, working tree clean
Branch 'master' set up to track remote branch 'master' from 'https://git.coding.net/IDeepspace/IDeepspace.coding.me.git'.
To https://git.coding.net/IDeepspace/IDeepspace.coding.me.git
   c9c91a4..ca549c6  HEAD -> master
INFO  Deploy done: git
======================Auto Backup Begin===========================
cd: no such file or directory: E:HEXO
[master 5244810] Form auto backup script's commit
 1 file changed, 6 insertions(+), 6 deletions(-)
 rename scripts/{index.js.bak => index.js} (70%)
To https://github.com/IDeepspace/HEXO-BLOG.git
   e6b6921..5244810  master -> master
==================Auto Backup Complete============================
```

这样子，每次更新博文并 `deploy` 到服务器上之后，备份就自动启动并完成备份啦 !