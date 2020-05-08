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



答案是**改变函数执行时的上下文**，再具体一点就是**改变函数运行时的this指向**。