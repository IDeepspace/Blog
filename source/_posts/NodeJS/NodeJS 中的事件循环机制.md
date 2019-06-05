---
title: Node.JS 中的事件循环机制
author: Hazelnut Latte
tags:
  - 事件循环
categories: NodeJS
date: 2019-05-29
urlname: event-loop-in-nodejs
---

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
我们现在浏览器里面运行一下，结果应该和我们预想的一样：

```javascript
timer1
promise1
timer2
promise2
```

再在 Node 环境下运行下，发现运行结果和浏览器中的运行结果并不是一样的：

```javascript
timer1
timer2
promise1
promise2
```

所以，浏览器中的事件循环机制和 `Node` 环境下的时间循环机制是有差异的。那之后，我们在谈事件循环机制的时候，就要分不同的场景：浏览器环境和 `Node` 环境。

在 Node.js 中，也是单线程的事件循环。
