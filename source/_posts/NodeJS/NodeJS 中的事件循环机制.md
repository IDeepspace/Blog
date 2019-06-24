---
title: Node.JS 中的事件循环机制
author: Hazelnut Latte
tags:
  - 事件循环
categories: NodeJS
date: 2019-05-29
urlname: event-loop-in-nodejs
---

### 一、与浏览器中事件循环机制的差异

前面我们对浏览器中的事件循环机制有了一些了解，那 `Node` 环境下事件循环机制是否也是一致的呢？看段代码：

```javascript
setTimeout(() => {
    console.log('timer1')

    Promise.resolve().then(function () {
        console.log('promise1')
    })
}, 0)

setTimeout(() => {
    console.log('timer2')

    Promise.resolve().then(function () {
        console.log('promise2')
    })
}, 0)
```

<!-- more -->

我们现在浏览器里面运行一下，结果应该和我们预想的一样(如果你已经读过[《浏览器中的事件循环》](https://togoblog.cn/event-loop-in-browser/))：

```javascript
timer1
promise1
timer2
promise2
```

再在 `Node` 环境下运行下，发现运行结果和浏览器中的运行结果并不是一样的：

```javascript
timer1
timer2
promise1
promise2
```

所以，浏览器中的事件循环机制和 `Node` 环境下的时间循环机制是有差异的。之后，我们在谈事件循环机制的时候，就要分不同的场景：浏览器环境和 `Node` 环境，不能混为一谈。

简单的讲：

- Node.js 的 `event loop` 是基于 `libuv` 实现，而浏览器的 `event loop` 则在 `HTML5` 的规范中定义。
- `libuv` 已经对 `event loop` 作出了实现，而 `HTML5` 规范中只是定义了浏览器中 `event loop` 的模型，具体实现留给了浏览器厂商。

> 对于上面的代码在 `Node` 环境中执行结果的原因，我会在下文解释。



### 二、Node.js 的架构

把 `Node.js` 拆分到组件，看看它们的关键作用是什么、如何交互协作。

 `Node.js` 运行时环境图示：

![node.js 架构图](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/NodeJS/nodejs-architecture.png)

- **Application/Modules（JS）**：这部分就是所有的 `JavaScript` 代码：我们的应用程序、`Node.js` 核心模块、任何 `npm install` 的模块，以及你写的所有模块代码等等，我们花费的主要精力都在这部分。
- **C/C++ Bindings**：`Node.js` 中用了很多 `C/C++` 的代码和库，它们的性能很好。但是这三种不同的语言是怎么相互调用的呢？`Bindings` 就在这里发挥了作用。`Bindings` 是一些胶水代码，能够把不同语言绑定在一起，使其能够互相沟通调用。
- **Addons**：`Binding` 仅桥接 `Node.js` 核心库的一些依赖，`zlib`、`OpenSSL`、`c-ares`、`http-parser ` 等。如果你想在应用程序中包含其他第三方或者自己的 `C/C++` 库的话，需要自己完成这部分胶水代码。那我们自己写的这部分胶水代码就称为 `Addon`。可以把 `Binding` 和 `Addons` 视为连接` JavaScript` 代码和 `C/C++` 代码的桥梁。
- [**V8**](https://developers.google.com/v8/)：Google 开源的高性能 `JavaScript` 引擎，以 `C++` 实现。这也是集成在 `Chrome` 中的 `JS` 引擎。`V8` 将你写的 `JavaScript` 代码编译为机器码（所以它超级快）然后执行。

- [**libuv**](https://github.com/libuv/libuv)：提供异步功能的 `C` 库。它在运行时负责一个事件循环（`Event Loop`）、一个线程池、文件系统 `I/O`、`DNS` 相关和网络 `I/O`，以及一些其他重要功能。
- [**其他 C/C++ 组件和库**](https://nodejs.org/en/docs/meta/topics/dependencies/)：如 [c-ares](http://c-ares.haxx.se/)、[crypto (OpenSSL)](https://www.openssl.org/)、[http-parser](https://github.com/nodejs/http-parser) 以及 [zlib](http://zlib.net/)。这些依赖提供了对系统底层功能的访问，包括网络、压缩、加密等。



### 三、事件循环

上面我们对 `Node.js` 架构中的顶层组件有了一个简单的了解。

在 `Node.js` 中，也是单线程的事件循环。`Nodejs` 的事件循环会分为6个阶段，它们会按照顺序反复运行。

![NodeJS事件循环](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/NodeJS/nodejs-eventloop-structure.jpg)

每个阶段的作用如下:

- `timers` 阶段：这个阶段执行 `timer` (包括 `setTimeout`、`setInterval`) 的回调；

- `I/O callbacks` 阶段：执行 `I/O`（例如文件、网络）的回调；
- `idle, prepare` 阶段：队列的移动，仅 `node` 内部使用；
- `poll` 阶段：最重要的阶段，获取新的 `I/O` 事件, 适当的条件下 `node` 将阻塞在这里；
- `check` 阶段：执行 `setImmediate()` 的 `callback`；
- `close callbacks` 阶段：执行 `close` 事件的 `callback`，例如 `socket.on("close",func)`

我们重点看 `timers`、`poll`、`check ` 这3个阶段就好，因为日常开发中的绝大部分异步任务都是在这3个阶段处理的。

#### 1、timers 阶段

`timers`  是事件循环的第一个阶段，`Node` 会去检查有无已过期的 `timer`，如果有则把它的回调压入 `timer` 的任务队列中等待执行。

事实上，`Node` 并不能保证 `timer` 在预设时间到了就会立即执行，因为 `Node` 对 `timer` 的过期检查不一定靠谱，因为它会受机器上其它运行程序影响，或者那个时间点主线程不空闲。比如下面的代码，`setTimeout()` 和 `setImmediate()` 的执行顺序是不确定的。

```javascript
setTimeout(() => {
  console.log('timeout')
}, 0)

setImmediate(() => {
  console.log('immediate')
})
```

但是把它们放到一个 `I/O` 回调里面，就一定是 `setImmediate()` 先执行，因为 `poll` 阶段后面就是 `check` 阶段。

#### 2、poll 阶段

`poll` 阶段主要有2个功能：

- 处理 `poll` 队列的事件
- 当有已超时的 `timer`，执行它的回调函数

`even loop` 将同步执行 `poll` 队列里的回调，直到队列为空或执行的回调达到系统上限（上限具体多少未详），接下来 `even loop` 会去检查有无预设的 `setImmediate()`，分两种情况：

1. 若有预设的 `setImmediate()`，`event loop` 将结束 `poll` 阶段进入 `check` 阶段，并执行 `check` 阶段的任务队列；
2. 若没有预设的 `setImmediate()`，`event loop` 将阻塞在该阶段等待。

注意一个细节，没有 `setImmediate()` 会导致 `event loop` 阻塞在 `poll` 阶段，这样之前设置的 `timer` 岂不是执行不了了？所以呢，在 `poll` 阶段 `event loop` 会有一个检查机制，检查 `timer` 队列是否为空，如果 `timer` 队列非空，`event loop` 就开始下一轮事件循环，即重新进入到 `timer` 阶段。

#### 3、check 阶段

`setImmediate()` 的回调会被加入 `check` 队列中， 从 `event loop` 的阶段图可以知道，`check` 阶段的执行顺序在 `poll` 阶段之后。



**小结一下：**

- `event loop` 的每个阶段都有一个任务队列；
- 当 `event loop` 到达某个阶段时，将执行该阶段的任务队列，直到队列清空或执行的回调达到系统上限后，才会转入下一个阶段；
- 当所有阶段被顺序执行一次后，称 `event loop` 完成了一个 `tick`。



