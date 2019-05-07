---
title: Linux 常用命令
author: Deepspace
tags:
  - Linux
categories: Linux
date: 2017-12-20
urlname: linux-frequently-used-commands
---

#### 1、pwd — 打印出当前工作目录名

```shell
 $ ~/Documents: pwd
/Users/cxin/Documents
```

#### 2、cd — 更改目录

```shell
 $ ~/Documents: cd Workspace
 $ Documents/Workspace: 
```

#### 3、ls — 列出目录内容

- 除了当前工作目录以外，也可以指定别的目录：`$ ls /usr`

- 也可以指定多个目录，用空格隔开即可：`$ ls ~ /usr`

- 改变输出格式，来得到更多的细节：`$ ls -l`

#### 4、file — 确定文件类型

```shell
$ ~/Desktop: file a.png
a.png: PNG image data, 1920 x 6154, 8-bit/color RGBA, non-interlaced
$ ~/Desktop:
```

#### 5、less — 浏览文件内容

```shell
$ less filename
```
<!-- more -->
#### 6、mkdir — 创建目录

```shell
$ mkdir directoryName
```

#### 7、rm — 删除文件和目录

删除文件：

```shell
$ rm filename
```

删除目录：

```shell
$ rm -rf directoryName
```

#### 8、cp — 复制文件和目录

**复制文件：**

```shell
$ cp Source Directory
```

- `Source`：要复制的源文件

- `Directory`：复制文件的新位置。如果此参数是一个新目录名，则将文件复制到新位置时重命名文件

**复制目录：**

将目录 `test` 复制到目录 `file` 中

```shell
$ cp -R test file/
```

如果要复制的源目录中还存在子目录，可能会发生错误，此时使用选项R递归地复制子目录。

#### 9、mv — 移动/重命名文件和目录

`mv` 命令对文件或文件夹进行移动，如果文件或文件夹存在于当前工作目录，还可以对文件或文件夹进行重命名。

#### 10、cat — 输出文件内容

`cat` 用于在标准输出（监控器或屏幕）上查看文件内容。

#### 11、tail — 输出

默认在标准输出上显示给定文件的最后10行内容，可以使用 `$ tail -n N`  命令来指定在标准输出上显示文件的最后 `N` 行内容。

#### 12、less — 按页或按窗口打印文件内容

`less` 按页或按窗口打印文件内容。在查看包含大量文本数据的大文件时是非常有用和高效的。可以使用 `Ctrl+F` 向前翻页，`Ctrl+B` 向后翻页。

#### 13、grep — 在给定的文件中搜寻指定的字符串

```shell
~ Desktop/demo: grep module data.js
module.exports = data;
~ Desktop/demo:
```

#### 14、find — 搜索文件

`find` 用于在给定位置搜寻与条件匹配的文件。

```shell
~ Desktop/demo: find data.js
data.js
~ Desktop/demo: find data1.js
find: data1.js: No such file or directory
```

`find -iname` 来进行不区分大小写的搜寻：

```shell
~ Desktop/demo: find . -iname data.js
./data.js
~ Desktop/demo:
```

#### 15、tar

`tar` 命令能创建、查看和提取 `tar` 压缩文件

- `tar -cvf` 是创建对应压缩文件

  ```shell
   ~/Desktop: ls
  demo
   ~/Desktop: tar -cvf demo.tar demo
  a demo
  a demo/result.json
  a demo/test.js
  a demo/index.js
  a demo/data.js
  a demo/periods.js
   ~/Desktop:
  ```

- `tar -tvf` 来查看对应压缩文件

  ```shell
   ~/Desktop: tar -tvf demo.tar
  drwxr-xr-x  0 cxin   staff       0 May  7 14:11 demo/
  -rw-r--r--  0 cxin   staff 1497545 May  5 10:35 demo/result.json
  -rw-r--r--  0 cxin   staff     313 May  6 22:58 demo/test.js
  -rw-r--r--  0 cxin   staff    4443 Apr 25 15:47 demo/index.js
  -rw-r--r--  0 cxin   staff     210 Apr 29 09:44 demo/._data.js
  -rw-r--r--  0 cxin   staff  111200 Apr 29 09:44 demo/data.js
  -rw-r--r--  0 cxin   staff     578 Apr 24 09:12 demo/periods.js
  ```

- `tar -xvf` 来提取对应压缩文件

  ```shell
  ~/Desktop: ls
  demo.tar
  ~/Desktop: tar -xvf demo.tar
  x demo/
  x demo/result.json
  x demo/test.js
  x demo/index.js
  x demo/._data.js
  x demo/data.js
  x demo/periods.js
  ~/Desktop: ls
  demo     demo.tar
  ~/Desktop: cd demo
  Desktop/demo: ls
  data.js     index.js    periods.js  result.json test.js
  ```

#### 16、gzip

`gzip` 命令创建和提取 `gzip` 压缩文件，还可以用 `gzip -d` 来提取压缩文件。

#### 17、unzip

`unzip` 对 `gzip` 文档进行解压。在解压之前，可以使用 `unzip -l` 命令查看文件内容。

#### 18、whatis — What is this command

`whatis` 会用单行来描述给定的命令，就是解释当前命令。

#### 19、who — Who Is logged in

`who` 能列出当前登录的用户名。

#### 20、uname

`uname` 会显示出关于系统的重要信息，如内核名称、主机名、内核版本、处理机类型等等，使用 `uname -a` 可以查看所有信息。

#### 21、ps — ProcesseS

显示系统的运行进程。

#### 22、top — Top processes

`top` 命令会默认按照 `CPU` 的占用情况，显示占用量较大的进程。

