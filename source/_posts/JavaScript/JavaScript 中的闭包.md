---
title: JavaScript 中的闭包
author: Deepspace
tags:
  - 闭包
categories: JavaScript
date: 2018-03-29
urlname: javascript-closure
---



## JavaScript 中的闭包

### 一、闭包的定义

闭包是一个特别抽象的概念，我们先从代码看起，之后再去理解它的概念。看一个最简单原始的闭包 `demo`：

```javascript
function A() {
  function B() {
    console.log("Hello Closure!");
  }
  return B;
}

var c = A();

c(); // Hello Closure!
```

我们简单分析一下它和普通函数有什么不同。上面代码翻译成自然语言如下：

1. 定义了一个普通函数 `A`；

2. 在 `A` 中定义了普通函数 `B`；

3. 在 `A` 中返回 `B`（确切地讲，在 `A` 中返回 `B` 的引用）；

4. 把 `A` 的返回结果赋值给变量 `c` （此时 `c` 指向 `B` 的引用）；

5. 执行 `c()` 。

总结成一句话就是：函数 `A` 的内部函数 `B` 被函数 `A` 外的一个变量 `c` 引用。

所以，闭包的定义就是：**当一个内部函数被其外部函数之外的变量引用时，就形成了一个闭包。**



### 二、闭包的作用

我们知道，[`JavaScript` 的内存管理](https://togoblog.cn/javascript-memory-management/)里，堆区内存的垃圾机制是：`Javascript` 程序会对数组等引用数据（对象）的引用数量计数，一旦没有引用，就会被清除释放，否则这个一直会保存在内存中。

在上面例子中，`B` 定义在 `A` 中，因此 `B` 依赖于 `A` ，而外部变量 `c` 又引用了 `B`， 所以 `A` 间接的被 `c` 引用，也就是说，`A` 不会被回收，会一直保存在内存中。

我们可以把上面的例子改动一下，验证这个观点：

```javascript
function A() {
  var count = 0;
  function B() {
    count++;
    console.log(count);
  }
  return B;
}

var c = A();

c(); // 1
c(); // 2
c(); // 3
```

`count` 是 `A` 中的一个变量，它的值在 `B` 中被改变，执行 `c` 时（ `c` 指向 `B` 的引用），每执行一次，`count` 的值就在原来的基础上累加 `1` 。因此，`A` 中的 `count` 一直保存在内存中。

这个就是闭包的作用：**当需要一个模块中定义这样一个变量，并且希望这个变量一直保存在内存中但又不会污染全局的变量的时候，我们就可以用闭包来定义这个模块。**

我们经常用闭包做这样的事情：**是封装对象的私有属性和私有方法。**

```javascript
function Person(name) {
  var _age;

  function setAge(num) {
    _age = num;
  }

  function getAge() {
    return _age;
  }
  return {
    name: name,
    setAge: setAge,
    getAge: getAge
  };
}

var p1 = new Person('陈星星');
p1.setAge(18);
console.log(p1.getAge()); // 18
```

函数 `Person` 的内部变量 `age`，通过闭包 `getAge` 和 `setAge`，变成了返回对象 `p1` 的私有变量。

注意，外层函数每次运行，都会生成一个新的闭包，而这个闭包又会保留外层函数的内部变量，所以内存消耗很大。因此不能滥用闭包，否则会造成网页的性能问题。



**再看一个闭包的常见应用场景：**

有一个组件，这个组件的功能是：可以初始化一个容器，可以给这个容器添加子容器，也可以移除一个容器。

```javascript
(function (document) {
  var viewport;
  var obj = {
    init: function (id) {
      viewport = document.querySelector("#" + id);
    },
    addChild: function (child) {
      viewport.appendChild(child);
    },
    removeChild: function (child) {
      viewport.removeChild(child);
    }
  };
  window.jView = obj;
})(document); // 这里用到了立即执行函数
```

便于理解，可以拆分成下面这样：

```javascript
var f = function (document) {
  var viewport;

  var obj = {
    init: function (id) {
      viewport = document.querySelector("#" + id);
    },
    addChild: function (child) {
      viewport.appendChild(child);
    },
    removeChild: function (child) {
      viewport.removeChild(child);
    }
  };

  window.jView = obj; // <---
};

f(document);
```

问题来了，函数 `f` 中并没有返回值啊，似乎不符合闭包的条件。注意代码中的这行代码：

```javascript
window.jView = obj;
```

`obj` 是在函数 `f` 中定义的一个对象，这个对象中定义了一系列方法。

执行 `window.jView = obj` 就是在 `window` 全局对象定义了一个变量 `jView`，并将这个变量指向 `obj` 对象，也就是说全局变量 `jView` 引用了 `obj` 。而 `obj` 对象中的函数又引用了 `f` 中的变量 `viewport` ，因此 `f` 中的 `viewport` 不会被回收，会一直保存到内存中，所以这种写法满足闭包的条件。



### 三、闭包的回收

函数执行完后，函数内的局部变量没有释放，占用内存时间会变长，容易造成内存泄漏。所以，我们也需要将引用设置成 `null` 来回收闭包：

```javascript
function fn1() {
  var arr = new Array(1000);
  function fn2() {
    console.log(arr.length);
  }
  return fn2;
}
var f = fn1(); // 已经产生闭包
f(); // 1000

f = null; // 回收闭包
```



### 四、检验是否理解了闭包

最后，为了检验自己是否理解了闭包，看看下面两道题（如果你不清楚 `this`，请看这里：https://togoblog.cn/javascript-this/）：

```javascript
var name = 'The Window';

var object = {
  name: 'My Object',

  getNameFunc: function () {
    return function () {
      return this.name;
    };
  }
};

console.log(object.getNameFunc()()); // 'The Window' (浏览器环境下)
```

再对比下面这个：

```javascript
var name = 'The Window';

var object = {
  name: 'My Object',

  getNameFunc: function () {
    var that = this;
    return function () {
      return that.name;
    };
  }
};

console.log(object.getNameFunc()()); // 'My Object'
```

最后，看一个面试中几乎必考的题目：

```javascript
var data = [];

for (var i = 0; i < 3; i++) {
  data[i] = function () {
    console.log(i);
  };
}

data[0]();
data[1]();
data[2]();
```

答案都是 `3`。为什么呢？

**解析：**

当循环结束后，得到的是：

```javascript
data[0] = function(){console.log(i)}
data[1] = function(){console.log(i)}
data[2] = function(){console.log(i)}
```

接着，当执行到 `data[0]` 函数的时候，`for` 循环已经执行完了，`i` 是全局变量，此时的值为 `3`，例如：

```javascript
for (var i = 0; i < 3; i++) {}
console.log(i); // 3
```

所以，最终的执行结果都为 `3`。

