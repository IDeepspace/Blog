---
title: JavaScript 中的值传递
author: Deepspace
tags:
  - 值传递
  - JavaScript
categories: JavaScript
date: 2018-07-03
urlname: javascript-passing-by-value
---

## JavaScript 中函数参数的值传递

`JavaScript` 中函数参数是按值传递，还是按引用传递呢？

我们知道 `JavaScript` 中的数据类型分为两类：

- 基本类型
- 引用类型

下面我们分别通过例子来分析。

### 一、基本类型

先看一个基本类型的例子：

```javascript
const value = 1;
function foo(v) {
  v = 2;
  console.log(v); // 2
}
foo(value);
console.log(value); // 1
```

很好理解，当传递 `value` 到函数 `foo` 时中，相当于**拷贝**了一份 `value`，假设拷贝的这份叫 `_value`，函数中修改的都是 `_value` 的值，而不会影响原来的 `value` 值。所以，基本类型是按值传递的。

### 二、引用类型

拷贝虽然很好理解，但是当值是一个复杂的数据结构的时候，拷贝就会产生性能问题。所以还有另一种传递方式叫做**按引用传递**。

所谓按引用传递，就是**传递对象的引用**，函数内部对参数的任何改变都会影响该对象的值，因为两者引用的是同一个对象。

来看传递对象的例子：

```javascript
const obj = {
  value: 1,
};
function foo(o) {
  o.value = 2;
  console.log(o.value); // 2
}
foo(obj);
console.log(obj.value); // 2
```

函数 `foo` 中对传递的参数做了更改，影响到了外部的 `obj` 对象。那是不是说如果传递的参数是引用类型， `JavaScript` 采用的就是按引用传递呢？

将上面的例子稍微做下改动：

```javascript
const obj = {
  value: 1,
};
function foo(o) {
  o = 2; // <-- 这里发生了改变
  console.log(o); // 2
}
foo(obj);
console.log(obj.value); // 1
```

结果发现外层的值没有被修改。如果 `JavaScript` 采用的是引用传递，外层的值也会被修改，怎么回事呢？

我们知道：基本类型值存储于栈内存中，传递的就是当前值，修改不会影响原有变量的值；引用类型值其实也存于栈内存中，只是它的值是指向堆内存当中实际值的一个地址，如下图所示：

```javascript
var person1 = { name: "陈星星" };
var person2 = { name: "Deepspace" };
var person3 = { name: "陈鑫" };
```

<img src="https://gitee.com/IDeepspace/image-hosting/raw/master/JavaScript/javascript-memory-management-heap.jpg" alt="img" style="zoom:50%;" />

所以引用传递传的其实是**栈内存当中的引用地址**。回到上面的例子中：

```javascript
const obj = {
  value: 1,
};
function foo(o) {
  o.value = 2;
  console.log(o.value); // 2
}
foo(obj);
console.log(obj.value); // 2
```

在这个例子中，**`obj` 和 `o` 引用的是同一个对象，所以会互相影响**。

但是在下面的例子中：

```javascript
const obj = {
  value: 1,
};
function foo(o) {
  o = 2; // <-- 这里发生了改变
  console.log(o); // 2
}
foo(obj);
console.log(obj.value); // 1
```

**当 `o` 被重新定义时，其引用的对象已经与 `obj` 不同，所以，`o` 的更改不会对 `obj` 引用的对象有任何影响**。

### 三、总结

- 基本类型值存储于栈内存中，传递的就是当前值，修改不会影响原有变量的值；

- 引用类型值也存于栈内存中，只是它的值是指向堆内存当中实际值的一个地址；函数参数中以地址传递时，修改值（栈中的地址没有更改，只是更改了堆中的值）会影响到原始值，但如果将其完全替换成另一个值（更改了栈中的地址），则原来的值不会受到影响。

所以，`JavaScript` 中函数参数都是按值传递的。

最后，看下面的一个题目：

```javascript
function changeObjProperty(o) {
  o.siteUrl = "http://www.baidu.com";
  o = new Object();
  o.siteUrl = "http://www.google.com";
}

const webSite = new Object();
changeObjProperty(webSite);
console.log(webSite.siteUrl);
```

结果：

```javascript
http://www.baidu.com
```
