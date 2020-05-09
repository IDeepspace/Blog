---
title: JavaScript 中 call、apply、bind 的模拟实现
author: Deepspace
tags:
  - call
  - apply
categories: JavaScript
date: 2018-03-29
urlname: javascript-call-apply
---



## JavaScript 中 call、apply、bind 的模拟实现

`call`、`apply`、`bind` 这三个方法的作用是一样的，它们都可以**改变函数执行时的上下文**，再具体一点就是**改变函数运行时的 `this` 指向**。既然作用是一样的，为什么还要设计三个这样的方法呢？所以它们三者又有一些区别

