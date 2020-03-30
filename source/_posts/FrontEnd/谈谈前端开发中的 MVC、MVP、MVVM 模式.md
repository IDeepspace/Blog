---
title: 谈谈前端开发中的 MVC、MVP、MVVM 模式
author: Deepspace
categories: FrontEnd
date: 2020-01-01
urlname: mvc-map-mvvm
tags:
  - MVC
  - MVP
  - MVVM
---



## 谈谈前端开发中的 MVC、MVP、MVVM 模式

在前端开发中，我们经常会听到 `MVC`、`MVP`、`MVVM` 这些名词。

- `MVC` 代表 `Model-View-Controller`；
- `MVP` 代表 `Model-View-Presenter`；
- `MVVM` 代表 `Model-View-ViewModel`。

它们都是为了解决图形化界面应用程序（`GUI`，`Graphical User Interface`）复杂性管理问题而产生的应用架构模式。

网络上也有很多文章来介绍这三种模式，但是有些杂乱，可能有些表述也并不是特别准确。本文将会更加细致地介绍这三种模式。

<!-- more -->

### 一、GUI 所面临的问题

图形界面的应用程序（`Graphical User Interface`）为用户提供**交互式可视化组件的操作界面**。用户的**输入行为**（如鼠标点击、键盘输入）会执行一些**应用逻辑**（`application logic`），应用逻辑可能会触发一定的**业务逻辑**（`business logic`），这时候应用程序的数据就可能会发生变更；数据的变更自然需要**用户界面的同步变更**以提供最准确的信息。

例如用户对一个电子表格进行重新排序的操作，应用程序需要响应用户操作，对数据进行排序，然后需要再同步到界面上。

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/FrontEnd/gui.png" alt="GUI" style="zoom:80%;" />

下面我们来看一些 `GUI` 应用所面临的常见的设计问题。

#### 1、界面的变化和业务的变化频率不同

通常，界面的变化更加频繁，而我们希望一方的变化不至于影响另一方的逻辑。



#### 2、测试难度大

`GUI` 界面是相对难以测试的。直接测试 `GUI` 的测试工具都面临以下问题：

- 测试耗时长， 因为要启动真实的应用；
- 测试比较脆弱， 无论是可靠性还是可维护性，都会比较脆弱；因为界面元素的变化很频繁， 而通过编程来控制界面和用户真实操作经常有细微的差别， 尤其是时序相关的问题。

所以，在开发 `GUI` 应用程序的时候，为了降低应用的复杂度，提高可维护性，开发人员基于职责分离（`Speration of Duties`）的思想，对应用程序进行了分层：

**把管理用户界面的层次称为 `View`（视图），把应用程序的数据称为 `Model` （模型）**。

`View` 用于定义结构、布局，它以一种合适的方式展示数据；`Modal` 用于封装和应用程序的业务逻辑相关的数据以及对数据的处理方法。

有了 `View` 和 `Model` 的分层，那么问题就来了：`View` 如何同步 `Model` 的变更呢？也就是说，我们要怎样将 `View` 和 `Model` 粘合在一起呢？

下面我们带着这个问题来去探究 `MVC、MVP、MVVM` 这三种模式。



### 二、MVC

`MVC` （ `Model-View-Controller`）模式里，除了把应用程序分成 `View`、`Model` 层，还额外的加了一个 `Controller` （控制器）层。

`Controller` 的职责就是充当 `View` 和 `Model` 之间的中介者。`Controller` 负责处理传入的请求。 它通过 `Model` 处理用户的数据，并将结果传递回 `View`。

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/FrontEnd/mvc.jpg" alt="mvc" style="zoom: 65%;" />

> 在网上的一些资料里，`Controller` 和 `View` 之间的依赖关系可能不一样，有些是单向依赖，有些是双向依赖，这个其实区别不大，它们的依赖关系就是为了把处理用户行为触发的事件的处理权转交给 `Controller`。

在 `MVC` 的模式里：

1. 用户的对 `View` 操作以后，`View` 捕获到这个操作，会把处理的权利转交移给 `Controller`；
2. `Controller` 会对来自 `View` 的数据进行预处理，决定调用哪个 `Model` 的接口；
3. 然后由 `Model` 执行相关的业务逻辑；当 `Model` 变更了以后，会通知 `View`；`View` 收到 `Model` 变更的消息以后，会向 `Model` 请求最新的数据，然后更新界面。

这里有一个需要理解的地方：`Model` 的更新是通过**观察者模式（`Observer Pattern`）**告知 `View` 的，具体表现形式可以是 `Pub/Sub` 或者是触发 `Events`。

清楚 `MVC` 的架构模式后，下面我们来动手实现一个简易版的 `MVC`。

> // 待补充

实现完一个 `MVC` 之后，我们来看看它的优缺点：

优点：

1. 把业务逻辑和展示逻辑分离，模块化程度高。且当应用逻辑需要变更的时候，不需要变更业务逻辑和展示逻辑，只需要 `Controller` 换成另外一个 `Controller` 就可以了；
2. 观察者模式可以做到多视图同时更新。

缺点：

1. `Controller` 的测试比较困难。因为 `View` 只能在有 `UI` 的环境下运行，在没有 `UI` 环境下对 `Controller` 进行单元测试的时候，应用逻辑正确性是无法验证的，即： `Model` 更新的时候，无法对 `View` 的更新操作进行断言；
2. `View` 无法组件化。`View` 是强依赖特定的 `Model` 的，如果需要把这个 `View` 抽出来作为一个另外一个应用程序可复用的组件，就比较困难了，因为不同程序的的 `Domain Model` 是不一样的。



### 三、MVP

`MVP` 模式是 `MVC` 模式的改良。`MVP` 模式把 `MVC` 模式中的 `Controller` 换成了 `Presenter`。

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/FrontEnd/mvp.png" alt="mvp" style="zoom:65%;" />

`MVP` 打破了 `View` 原来对于 `Model` 的依赖，其余的依赖关系和 `MVC` 模式一致。那么问题来了，`View` 如何同步 `Model` 的变更呢？

和 `MVC` 模式一样，用户对 `View` 的操作都会从 `View` 交移给 `Presenter` 。`Presenter` 会执行相应的应用程序逻辑，并且对 `Model` 进行相应的操作；而这时候 `Model` 执行完业务逻辑以后，也是通过观察者模式把自己变更的消息传递出去，但是是传给 `Presenter` 而不是 `View`。`Presenter` 获取到 `Model` 变更的消息以后，通过 `View` 提供的接口更新界面。

