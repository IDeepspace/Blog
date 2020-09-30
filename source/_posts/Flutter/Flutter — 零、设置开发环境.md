---
title: Flutter — 零、设置开发环境
author: Deepspace
categories: Flutter
date: 2019-05-09
urlname: flutter-development-environment-configuration
tags:
  - Flutter
---

### 一、介绍

- `Flutter` 是由 `Google` 的工程师团队打造的，用于创建高性能、跨平台的移动应用的框架

- `Flutter` 针对当下以及未来的移动设备进行优化，专注于 `Android and iOS` 低延迟的输入和高帧率

- `Flutter` 的设计跟 `react-native` 很像，但是比 `RN` 进了一步

- `Flutter` 的开发语言是 `Dart`

- `Flutter` 的热重载（`hot-reload`）特性让人惊叹，它能在编 码时为你提供超快的视觉反馈

### 二、安装

#### 1、获取 Flutter SDK

- 将 `Flutter` 项目克隆到本地：
<!-- more -->

> 在电脑上存放文件的时候，我有严重的"洁癖"。之前在用 `Windows` 的时候，有时候因为不小心把软件安装错盘符，卸载也有残余，我甚至会去重装系统，然后再花上整夜的时间设置各项环境和安装软件。
>
> 所以，这里我单独在根目录创建一个 `Development` 文件夹来存放克隆下来的 `flutter` 库，因为之后会用把这个库导入到环境变量里面，避免存放在其他位置造成误操作，也不利于后面的版本升级。

```bash
$ cd ~
$ mkdir Development
$ cd Development/
$ git clone -b beta https://github.com/flutter/flutter.git
```

- 将 `Flutter` 添加到本地环境变量：

```bash
$ vim ~/.bash_profile
```

在国内由于一些原因，还需要设置一下 `pub` 源，用以下载相关的依赖文件。其中 `PUB_HOSTED_URL` 和 `FLUTTER_STORAGE_BASE_URL` 是 `google` 为国内开发者搭建的临时镜像。

所以需要在环境变量中添加三个变量：

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PATH="PATH_TO_FLUTTER_GIT_DIRECTORY/flutter/bin:$PATH"
```

其中 `PATH_TO_FLUTTER_GIT_DIRECTORY` 为你的 `flutter sdk` 的路径（也就是前面 `clone ` 的 `repo` 地址）。如我这里就是改成：

```bash
export PATH="/Users/cxin/Development/flutter/bin:$PATH"
```

- 刷新 `bash` ，需要 `source` 一下：

```bash
$ source ~/.bash_profile
```

- 查看 `PATH` :

```bash
$ echo $PATH
```

可以看到 `flutter` 已经被写入了。

- 验证是否配置成功：

```bash
$ flutter -h
```

配置成功的话，会展示 `flutter` 的命令帮助。

#### 2、运行 flutter doctor

运行以下命令查看是否需要安装一些依赖项以完成安装：

```bash
$ flutter doctor
```

> 第一次运行 `flutter` 命令（如`flutter doctor`）时，它会下载自己的依赖关系并自行编译，所以速度会比较慢，后续的运行应该将会快得多。

该命令将检查你的环境并在终端窗口中显示报告。`Dart SDK` 是与 `Flutter` 捆绑在一起的，所以不用再单独安装`Dart`。

这里我们需要仔细检查显示出来的报告中是否提示需要安装其他软件或执行其他任务，下面是我的机器的检查报告：

```bas
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel beta, v1.5.4-hotfix.2, on Mac OS X 10.14.4 18E226, locale en-CN)
[✗] Android toolchain - develop for Android devices
    ✗ Unable to locate Android SDK.
      Install Android Studio from: https://developer.android.com/studio/index.html
      On first launch it will assist you in installing the Android SDK components.
      (or visit https://flutter.dev/setup/#android-setup for detailed instructions).
      If the Android SDK has been installed to a custom location, set ANDROID_HOME to that location.
      You may also want to add it to your PATH environment variable.

[!] iOS toolchain - develop for iOS devices (Xcode 10.2.1)
    ✗ libimobiledevice and ideviceinstaller are not installed. To install with Brew, run:
        brew update
        brew install --HEAD usbmuxd
        brew link usbmuxd
        brew install --HEAD libimobiledevice
        brew install ideviceinstaller
    ✗ ios-deploy not installed. To install:
        brew install ios-deploy
    ✗ CocoaPods not installed.
        CocoaPods is used to retrieve the iOS platform side's plugin code that responds to your plugin usage on the Dart side.
        Without resolving iOS dependencies with CocoaPods, plugins will not work on iOS.
        For more info, see https://flutter.dev/platform-plugins
      To install:
        brew install cocoapods
        pod setup
[!] Android Studio (not installed)
[!] IntelliJ IDEA Ultimate Edition (version 2019.1.1)
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
[✓] VS Code (version 1.33.1)
[!] Connected device
    ! No devices available

! Doctor found issues in 5 categories.
```

可以看到，对于每一项需要执行的任务，报告中都给出了相应的解决办法。按照提示执行就好了：

```bash
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel beta, v1.5.4-hotfix.2, on Mac OS X 10.14.4 18E226, locale en-CN)

[✓] Android toolchain - develop for Android devices (Android SDK version 28.0.3)
[✓] iOS toolchain - develop for iOS devices (Xcode 10.2.1)
[✓] Android Studio (version 3.4)
[✓] IntelliJ IDEA Ultimate Edition (version 2019.1.1)
[✓] VS Code (version 1.33.1)
[✓] Connected device (1 available)

• No issues found!
```

这中间有些是 `IDE` 的配置，在对应的 `IDE` 中安装 `Dart` 和 `Flutter` 即可。

> 因为我使用的是 `Mac`，所以这里只介绍了 `macOS` 上的配置方法，关于其他系统的配置可以参考官网：<https://flutter.dev/docs/get-started/install>

### 三、创建项目

我们使用 `VSCode` 来开发。需要在 `VSCode` 中安装 `Dart` 和 `Flutter` 两个 `Extensions` 。

打开 `VSCode` ，选择 `View` > `Command Palette` > `Flutter: New Project` > `Enter Project Name` ，`VSCode` 会自动帮我们创建一个 `Flutter` 项目。这里我创建的项目名称为 `demo` 。

运行 `demo` :

```bash
$ flutter run
```

执行报出如下错误：

```bash
It appears that your application still contains the default signing identifier.
Try replacing 'com.example' with your signing id in Xcode:
  open ios/Runner.xcworkspace
```

按照上面的提示，用 `Xcode` 打开示例项目中的 `ios/Runner.xcworkspace` 这个文件。

选择项目菜单 `Runner` – `General` 选项 ，可以看到 `Signing` 中的 `Status` 提示错误信息：

```bash
Signing for "Runner" requires a development team.
Select a development team in the projct editor.
```

点击 `Team` 选项的 `Add Account...` 按钮，登录 `Apple ID` ，没有则需要创建一个。回到 `General` 界面，选择 `Team` 名称，等待验证。

这里我又遇到另外的问题：

```bash
ailed to create provisioning profile.
The app ID "com.example.demo" cannot be registered to your development team. Change your bundle identifier to a unique string to try again.

No profiles for 'com.example.demo' were found
Xcode couldn't find any iOS App Development provisioning profiles matching 'com.example.demo'.
```

找了好久，有人给出一个解决办法：

**将 `Bundle Identifier` 的值改变一下，比如在结尾随机加上几个数字。**

然后点击 `try again` ，成功 `sign` 。

接下来我们重新执行 `flutter run` 运行，中间会要求输入密码，能够正常运行了，也支持热加载调试。

<img src="https://deepspace.coding.net/p/personal-blog/d/ImageHosting/git/raw/master/Flutter/flutter-start-demo.gif" alt="Flutter Demo" style="zoom: 50%;" />

### 四、Flutter 版本更新

执行 `flutter doctor` ，如果有新版本更新，会提醒升级，按照提示，执行 `flutter upgrade` 进行升级即可。
