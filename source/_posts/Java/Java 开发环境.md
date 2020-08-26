---
title: 设置 Java 开发环境
author: Deepspace
tags:
  - Java 开发环境
  - Java
categories: Java
date: 2017-06-29
urlname: java-set-environment
---

<!-- ## 设置 Java 开发环境 -->

### 一、安装

- Mac 环境下
- Windows 环境下
- Linux 环境下



#### 1、下载

1. 浏览到 [Java SE Downloads](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ，以显示最新版 `JDK` 的下载页面；

2. 同意你想要下载的版本的许可条款；

3. 选择与你的操作系统和芯片架构匹配的下载。

   - `mac` 环境的 `jdk` 包是 `dmg` 安装文件；

   - `windows` 环境的 `jdk` 包是 `exe` 安装文件；

   - `Linux` 环境的 `jdk` 包是压缩文件。

<!-- more -->

#### 2、Mac 环境

**安装**

安装比较简单，一路点击**下一步**就可以了。

安装完成后，可以通过在终端命令行以下执行命令，找到 `JDK` 的安装位置：

```bash
$ /usr/libexec/java_home -v 1.8
/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home
```

将路径复制一下，后面要用。



**设置环境变量**

进入用户主目录，查看有没有 `.bash_profile` 文件。

1. 如果没有，使用命令 `touch .bash_profile` 新建一个（如果有忽略这条）；
2. 在终端中输入 `sudo vim ~/.bash_profile`，打开 `.bash_profile` 文件。按 `i` 进入输入模式，在文件内容的末尾加入以下内容：

```bash
JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home"
PATH="$JAVA_HOME/bin:$PATH"
CLASSPATH="$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"

export JAVA_HOME
export PATH
export CLASSPATH
```

> 其中 `JAVA_HOME` 后面的路径就是前面复制的路径，根据自己的实际路径修改。

3. 点击 `esc` ，输入 `:wq` 回车（保存并退出文本）；
4. 添加完成后输入： `source ~/.bash_profile` 应用所做的变更。



**通过 `brew` 来安装**

在 `MacOS` 上，也可以通过 `brew` 来安装 `Java`。

安装并更新 `brew`：

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

$ brew tap homebrew/cask-versions

$ brew update
```



**新方式（2019年6月新增）：**

从 `AdoptOpenJDK` 安装 `jdk`：

```bash
$ brew tap adoptopenjdk/openjdk

$ brew cask install adoptopenjdk8
$ brew cask install adoptopenjdk9
$ brew cask install adoptopenjdk10
$ brew cask install adoptopenjdk11
```



**老方式：**

`Java 8`：

```bash
$ brew cask install java8
```

`Java Latest`：

```bash
$ brew cask install java
```



#### 3、Windows 环境

**安装**

单击下载后的 `exe` 安装文件，将 `JDK` 安装到硬盘驱动器中容易记住的位置，比如 `D:\Program Files\Java\jdk1.8.0_151`。

在安装过程中，也会安装 `jre`，位置选择与 `JDK` 同级目录：`D:\Program Files\Java\jre` 。

**这个时候我们会发现：在 `JDK`的安装目录里面也有一个 `jre` 文件夹，这里解释一下原因：**

- `JDK` 目录下(内部)的 `jre` 称作 专用 `jre` ，而和 `JDK` 处于同级目录下(外部)的 `jre`，称作公用 `jre`；
- 运行 `JAVA` 程序的时候，只需要适合的 `jre` 就能够运行了，而并不需要使用 `JDK` 中的开发工具（如 `javac` 、`java` 等等），公共 `jre` 就是为运行加载到计算机中的 `JAVA` 程序来提供运行环境的，也就是说，如果我们并不需要开发 `JAVA` 程序，而仅仅是运行他人的已有的 `JAVA` 程序的时候，仅仅安装这个在 `JDK` 外部的 `jre` 文件就足够了；
- 但是如果我们需要开发 `JAVA` 程序，那么就必须安装 `JDK`，`JDK` 中包含专用 `jre` 和开发工具，这些开发工具需要专用 `jre` 才能够使用，**也就说专用 `jre` 是为我们开发 `JAVA` 程序准备的**；
- 同时要注意，这两个 `jre` 文件中的内容是有区别的，所以不能够简单的进行替换。



**设置环境变量**

计算机 > 属性 > 高级系统设置 > 高级 > 环境变量。

在**系统变量**里我们可以看到系统的各个环境变量的值。我们需要设置以下环境变量（如果没有，需要新建）：

- `JAVA_HOME` 变量设置
  - 变量名：`JAVA_HOME`； 
  - 变量值：`D:\Program Files\Java\jdk1.8.0_151` (绝对路径，后面不要用分号)。
- `Path` 变量设置
  - 变量名：`Path`； 
  - 变量值：`%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;` 。
- `Classpath` 变量
  - 变量名：`Classpath` ； 
  - 变量值：`.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;`（注意前面有个 `.`）。



#### 4、Linux 环境

**安装**

解压下载后的 `jdk` 压缩文件。

```bash
$ tar zxvf ./jdk-8u231-linux-x64.tar.gz  -C /usr/lib/jvm  
```



**设置环境变量**

执行 `vi /etc/profile` ，编辑环境变量文件。添加下面两行：

```bash
export JAVA_HOME=/usr/lib/jvm/jdk-8u231-linux-x64
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
```

保存并退出，执行 `source /etc/profile` ，让变更生效。



#### 5、测试是否安装成功

执行如下两条命令，如果安装成功，会打印当前 `java` 环境的信息。

```bash
$ java -version
$ javac
```



### 二、开发工具

工欲善其事，必先利其器。编写 `Java` 程序，当然有必要选择一个合适的 `IDE`。

> `IDE`（`Integrated Development Environment`，即集成开发环境）是用于提供程序开发环境的应用程序，一般包括代码编辑器、编译器、调试器和图形用户界面等工具。

常见的 `Java IDE` 如下：

- `IntelliJ IDEA` 
- `Eclipse` 
- `MyEclipse` 

`IntelliJ` 在业界被公认为最好的 `java` 开发工具之一，社区版是免费的，基本上可以满足日常的学习使用。

下载地址：https://www.jetbrains.com/idea/download/

`IntelliJ` 支持非常多好用的快捷键：

- `Intellij` 常用快捷键：https://codingstyle.cn/topics/241



### 三、第一个 Java 程序

开始第一个 `Java` 程序：`Hello World` 。

- 新建一个自己开发用的文件夹（如 `JavaWorkSpace`）；

- 在新建的文件夹下创建一个文件：`HelloWorld.java`；

- 用 `IDE` 打开新建的文件，添加下面代码：

  ```java
  public class HelloWorld {
    public static void main(String[] args) {
      // Prints "Hello, World" in the terminal window.
      System.out.println("Hello, World！");
    }
  }
  ```

- 保存之后退出；

- 在当前文件夹下打开命令终端；

- 执行命令：`javac HelloWorld.java`，这个命令就会将这个 `java` 文件编译成 `class` 文件，所以你会看到当前文件夹下多了一个 `class` 文件；

- 执行命令 `java helloWorld`，这个命令就是执行编译后的文件；

- 这时，如果一切顺利，就可以看到 `Hello, World！` 在控制台输出了。



### 四、Java程序的运行过程

`Java` 程序的运行必须经过**编写、编译和运行** `3` 个步骤：

- 编写：是指在 `Java` 开发环境中进行程序代码的输入，最终形成后缀名为 `.java` 的 `Java` 源文件；
- 编译：是指使用 `Java` 编译器对源文件进行错误排査的过程，如果编写的 Java 代码没有错误，将生成后缀名为 `.class` 的字节码文件（否则会编译不成功），不像 `C` 语言那样生成可执行文件；
- 运行：是指使用 `Java` 解释器将字节码文件翻译成机器代码，执行并显示结果。

如下图所示：

<img src="../ImageHosting/Java/java-run-process.png" alt="Java 程序运行过程" style="zoom:50%;" />



**`Java` 编译器**

`JAVA` 编译器的作用是将 `Java` 源程序编译成中间代码字节码文件。

编译时，首先读入 `Java` 源程序（即在 命令行下键入 `javac HelloWorld.java` 等文件名参数和其他选项参数），然后进行语法检查；如果出现问题就终止编译。语法检查通过后，生成中间代码（即字节码）；字节码文件名和源文件名相同，扩展名为 `.class`。



**字节码文件**

字节码文件是一种中间代码，是一种二进制文件，它和任何具体机器环境及操作系统环境都是无关的。

编程人员和计算机都无法直接读懂字节码文件，它**必须由专用的 `Java` 解释器来解释执行**，因此 `Java` 是一种**在编译基础上进行解释运行的语言。**



**`Java` 解释器**

`Java` 解释器负责将字节码文件翻译成具体硬件环境和操作系统平台下的机器代码，以便执行。

因此， `Java` 程序不能直接运行在现有的操作系统平台上，它必须运行在被称为 `Java` 虚拟机的软件平台之上。



**`Java` 虚拟机（`JVM`）**

`Java` 虚拟机是运行 `Java` 程序的**软件环境**。`Java` 解释器是 `Java` 虚拟机的一部分。

`Java` 字节码程序只能运行于 `JVM` 之上。这样利用 `JVM` 就可以把 `Java` 字节码程序和具体的硬件平台以及操作系统环境分隔开来，只要在不同的计算机上安装了针对特定平台的 `JVM`，`Java` 程序就可以运行，而不用考虑当前具体的硬件平台及操作系统环境，也不用考虑字节码文件是在何种平台上生成的。

`JVM` 把这种不同软、硬件平台的具体差别隐藏起来，从而实现了真正的二进制代码级的跨平台移植。有效地解决了大多数高级程序设计语言需要针对不同系统来编译产生不同机器代码的问题，即硬件环境和操作平台的异构问题，大大降低了程序开发、维护和管理的开销。也就是我们所说的**一次编写，到处运行**。

**`Java` 程序通过 `JVM` 可以实现跨平台特性，但 `JVM` 是不跨平台的。**也就是说，不同操作系统之上的 `JVM` 是不同的，`Windows` 平台之上的 `JVM` 不能用在 `Linux` 平台，反之亦然。

