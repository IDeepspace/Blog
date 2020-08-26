---
title: Hexo+Github 搭建博客教程
author: Deepspace
tags:
  - Hexo
categories: Hexo
date: 2016-10-12
urlname: create-blog-site-with-hexo
---

<!-- ## Hexo+Github 搭建博客教程 -->

>  github 有一个非常强大的功能 —— **GitHub Page**

GitHub Pages 有以下几个优点：

- 轻量级的博客系统，没有麻烦的配置
- 免费空间，享受 Git 版本管理功能
- 使用标记语言，比如 Markdown
- 无需自己搭建服务器
- 可以绑定自己的域名

当然他也有缺点：

- 搭配模板系统，相当于静态页发布，每运行生成一次都必须遍历全部的文本文件，网站越大，生成时间越长
- 动态程序的部分相当局限，比如没有评论，不过有解决方案
- 基于 Git，很多东西需要定制，不像 Wordpress 有强大的后台

要想搭建漂亮的 blog，还需要模板系统，官方推荐的是 jekyll，但是配置稍复杂，我们使用另一个选择 —— [hexo](https://hexo.io/)，一个简单地、轻量地、基于 Node 的一个静态博客框架。

下面介绍下如何使用 hexo + github pages 搭建个人博客 。
<!-- more -->
### 一. 安装GIt

#### 1. for windows :

https://github.com/git-for-windows/git/releases/tag/v2.14.1.windows.1

#### 2. for linux :

```shell
$ sudo apt-get update
$ sudo apt-get install git  
```

安装下载完成后，可以使用下面的命令行，确认`git`的版本：

```shell
$ git --version
```



### 二.安装node

#### 1. for windows

https://nodejs.org/en/download/

#### 2. for linux

1 . 先装一个 nvm (  [https://github.com/creationix/nvm](https://github.com/creationix/nvm) )

```shell
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.2/install.sh | bash
```

nvm 的全称是 **Node Version Manager**，之所以需要这个工具，是因为 Node.js 的各种特性都没有稳定下来，所以我们经常由于老项目或尝新的原因，需要切换各种版本。

安装完成后，你的 shell 里面应该就有个 nvm 命令了，调用它试试 , 有输出 ,  则 nvm 安装成功

```shell
$ nvm
```

2. 使用 nvm 的命令安装 Node.js 最新版

```shell
$ nvm install node
```

查看安装效果

```
nvm use node
```

显示 :

```shell
Now using node v6.11.0 (npm v3.10.10)
```



### 三. 安装 hexo

```shell
$ npm install hexo-cli -g
```



### 四. 初始化 hexo 博客项目

1.新建一个文件夹 ( 我是在桌面创建的 HEXO )

2.在Hexo文件下，右键运行Git Bash，输入命令：

```shell
$ hexo init
```

会生成如下图所示的文件结构 :

![xhexo-folder](/ImageHosting/Hexo/hexo-folder.png)

下面对文件目录做个简单介绍 :

**1. _config.yml**

全局配置文件，网站的很多信息都在这里配置，诸如网站名称，副标题，描述，作者，语言，主题，部署等等参数, 这个文件下面会做较为详细的介绍 。

**2. scaffolds**

`scaffolds` 是“ 脚手架、骨架 ”的意思，当你新建一篇文章（`hexo new  'title'`）的时候，`hexo `是根据这个目录下的文件进行构建的 。

**3. package.json**

`hexo` 框架的参数和所依赖插件，如下：

```shell
{
  "name": "hexo-site",
  "version": "0.0.0",
  "private": true,
  "hexo": {
    "version": ""
  },
  "dependencies": {
    "hexo": "^3.2.0",
    "hexo-generator-archive": "^0.1.4",
    "hexo-generator-category": "^0.1.3",
    "hexo-generator-index": "^0.2.0",
    "hexo-generator-tag": "^0.2.0",
    "hexo-renderer-ejs": "^0.3.0",
    "hexo-renderer-stylus": "^0.3.1",
    "hexo-renderer-marked": "^0.3.0",
    "hexo-server": "^0.2.0"
  }
}
```

如果后期我们想安装一些插件, 也会写入 `package.json` 当中 .

**4. source**

这个目录很重要，新建的文章都是在保存在这个目录下的.

- `_posts` 。需要新建的博文都放在 `_posts` 目录下。

- `_posts` 目录下是一个个 `markdown` 文件。你应该可以看到一个 `hello-world.md` 的文件，文章就在这个文件中编辑 。

- `_posts` 目录下的`md`文件，会被编译成 `html` 文件，放到 `public` （此文件现在应该没有，因为你还没有编译过）文件夹下。

**5. themes**

网站主题目录，hexo有非常好的主题拓展，支持的主题也很丰富。该目录下，每一个子目录就是一个主题

**6. 我们打开 `theme` 文件夹下的主题文件夹, 会发现也有一个 `_config.yml` 文件**

`_config.yml` 文件中的内容，是主题的一个配置信息

`_config.yml` 采用YAML语法格式，具体配置可以参考[官方文档](https://hexo.io/zh-cn/docs/configuration.html)



### 五.本地浏览博客

分别输入下面两条命令 :

```
$ hexo g
$ hexo s
```

在浏览器中输入 : `http://localhost:4000/`

会看到 :

<img src="/ImageHosting/Hexo/hexo-init-theme.png" alt="hexo-init-theme" style="zoom:50%;" />



### 六.部署到 `Github` 上

1. 申请Github账号 ( 别忘了邮箱验证 )

2. 新建一个 ` Repository`  , 注意仓库的名字前缀必须和自己 `github` 的用户名保持严格一致，如 `IDeepspace.github.io`

3. 在 `_config.yml` 进行配置

```shell
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo:
    github: https://github.com/IDeepspace/IDeepspace.github.io.git
  branch: master
```

在 `deploy` 中配置自己的仓库信息 ( 注意冒号后面有空格 )

4. 安装[hexo-deployer-git](https://github.com/hexojs/hexo-deployer-git)自动部署发布工具

```shell
$  npm install hexo-deployer-git -–save
```

5. 发布到Github

输入如下命令 :

```
$ hexo clean && hexo g && hexo d
```

然后输入自己的 `Github` 用户名和密码即可

6. 在浏览器中输入  https://IDeepspace.github.io/ 便可以打开自己的博客啦 !
