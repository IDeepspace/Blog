---
title: JavaScript 中 call、apply、bind 的用法及模拟实现
author: Deepspace
tags:
  - call
  - apply
categories: JavaScript
date: 2018-03-29
urlname: javascript-call-apply
---



## JavaScript 中 call、apply、bind 的用法及模拟实现

`call`、`apply`、`bind` 这三个方法的作用是一样的，它们都可以**改变函数执行时的上下文**，再具体一点就是**改变函数运行时的 `this` 指向**。既然作用是一样的，为什么还要设计三个这样的方法呢？所以它们三者又有一些区别。

本篇文章将详细介绍这三个方法的用法，并模拟实现这三个方法。

<!-- more -->



### 一、call

#### 1、用法

`call` 函数的语法：

```javascript
func.call(thisArg, arg1, arg2, ...);
```

`fn` 是你调用的函数，`thisArg` 参数是希望函数的 `this` 所绑定的对象，后面的作为函数调用时的参数。

看个例子：

```javascript
const obj = {
  name: 'Deepspace',
};

function sayHi() {
  console.log(this.name);
}

var name = 'globe name';

sayHi();

sayHi.call(obj); // Deepspace
```

试试传递参数：

```javascript
const obj = {
  name: 'Deepspace',
};

function sayHi(age, gender) {
  console.log(`${this.name} ${age} ${gender}`);
}

sayHi.call(obj, 23, 'male'); // Deepspace
```

上面的例子，我们拿别人的属性（当然也可以是方法），并动态改变其上下文帮自己输出了信息，说到底其实就是实现了复用。



#### 2、常见用途

##### 2.1、在继承中使用

`call` 可在继承中使用，基本思想是：在子类型的构造函数内部调用父类型构造函数。

```javascript
function Animal(name, food) {
  this.name = name;
  this.food = food;
  this.say = function () {
    console.log(`${name} likes ${this.food}.`);
  };
}

function Rabbit(name, food) {
  Animal.call(this, name, food);
}

const Judy = new Rabbit('Judy', 'carrot');

Judy.say(); // Judy likes carrot.
```

当然，`apply` 方法和 `bind` 方法也可以实现。



##### 2.2、类数组

我们接触的第一个[类数组对象](https://ideepspace.gitee.io/array-like-object/)，就是 `arguments` 元素。如何将类数组对象作为数组使用呢？可以使用 `call` 方法来实现：

```javascript
function main(val1, val2, val3, val4, val5) {
  console.log(arguments);
  const args1 = Array.prototype.slice.call(arguments);
  // 或者这样写
  const args2 = [].slice.call(arguments);
  // 或者使用 Array.from() 方法
  const args3 = Array.from(arguments);
  console.log(args1);
  console.log(args2);
  console.log(args3);
}

main(1, 2, 3, 4, 5);
```





#### 3、模拟实现

下面我们来模拟实现以下 `call` 方法。

拿上面的例子来说，当执行 `call` 方法的时候，我们可以把实际执行的代码看成是这样的：

```javascript
const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  },
};

obj.sayHi(); // Deepspace
```

将函数 `sayHi()` 当成对象 `obj` 的一个属性，执行完之后再将这个属性给删除了。所以，模拟的步骤可以分为：

1. 将函数设为对象的属性
2. 执行该函数
3. 删除该函数

按照这个思路，我们来模拟实现 `call` 方法：

```javascript
Function.prototype.call2 = function (context) {
  context.fn = this; // 用 this 获取要调用 call 方法的函数
  context.fn();
  delete context.fn;
};

const obj = {
  name: 'Deepspace',
};

function sayHi() {
  console.log(this.name);
}

sayHi.call2(obj); // Deepspace
```

前面说了，`call` 方法是支持传递参数的，由于参数的个数不确定的，所以，我们可以从 `Arguments` 对象中取值，取出第二个到最后一个参数，然后放到一个数组里。下面我们接着改造：

```javascript
Function.prototype.call2 = function (context) {
  context.fn = this; // 用 this 获取要调用 call 方法的函数
  const args = [];
  for (let i = 1, len = arguments.length; i < len; i++) {
    args.push(`arguments[${i}]`);
  }
  eval(`context.fn(${args})`);
  delete context.fn;
};

const obj = {
  name: 'Deepspace',
};


function sayHi(age, gender) {
  console.log(`${this.name} ${age} ${gender}`);
}

sayHi.call2(obj, 23, 'male'); // Deepspace
```

这里要遗留下两个小问题：

- `this` 参数可以传 `null`，当为 `null` 的时候，视为指向 `window`；
- 函数是可以有返回值的。

最终版本：

```javascript
Function.prototype.call2 = function (context) {
  var context = context || window;
  context.fn = this;

  const args = [];
  for (let i = 1, len = arguments.length; i < len; i++) {
    args.push(`arguments[${i}]`);
  }

  const result = eval(`context.fn(${args})`);

  delete context.fn;
  return result;
};

// 测试一下
var name = 'global name';

const obj = {
  name: 'Deepspace',
};


function sayHi(age, gender) {
  console.log(`${this.name} ${age} ${gender}`);
}

sayHi.call2(null); // Deepspace
sayHi.call2(obj, 23, 'male'); // Deepspace

```



### 二、apply

#### 1、用法

`apply` 方法的作用与 `call` 方法类似，也是改变 `this` 指向，然后再调用该函数。**唯一的区别就是，它接收一个数组作为函数执行时的参数**。语法如下：

```javascript
func.apply(thisArg, [argsArray])
```

看个例子：

```javascript
function getAge(gap) {
  const y = new Date().getFullYear();
  return y - this.birth - gap;
}

const chenxingxing = {
  name: '陈星星',
  birth: 1995,
  age: getAge,
};

console.log(chenxingxing.age(1)); // 24
console.log(getAge.apply(chenxingxing, [1])); // 24, this 指向 chenxingxing, 参数为 1
```



#### 2、常见用途

##### 2.1、函数转移

将调用传递给另一个函数：

```javascript
const wrapper = function () {
  return anotherFunction.apply(this, arguments);
};
```



##### 2.2、连接数组

```javascript
const array = ['a', 'b'];
const elements = [0, 1, 2];

array.push.apply(array, elements);

console.log(array); // [ 'a', 'b', 0, 1, 2 ]
```



##### 2.3、和内置函数一起用

```javascript
/* 找出数组中最大/小的数字 */
const numbers = [5, 6, 2, 3, 7];
/* 应用(apply) Math.min/Math.max 内置函数完成 */

const max = Math.max.apply(null, numbers);
/* 基本等同于 Math.max(numbers[0], ...) 或 Math.max(5, 6, ..) */

const min = Math.min.apply(null, numbers);

console.log('max: ', max); // max: 7
console.log('min: ', min); // min: 2
```



#### 3、模拟实现

和 `call` 很类似：

```javascript
Function.prototype.apply = function (context, arr) {
  var context = Object(context) || window;
  context.fn = this;

  let result;
  if (!arr) {
    result = context.fn();
  } else {
    const args = [];
    for (let i = 0, len = arr.length; i < len; i++) {
      args.push(`arr[${i}]`);
    }
    result = eval(`context.fn(${args})`);
  }

  delete context.fn;
  return result;
};
```



### 三、bind

#### 1、用法

`call` 和 `bind` 的区别在于，在绑定 `this` 到对象参数的同时，`call` 将立即执行该函数，`bind` 不执行函数，只返回一个可供执行的函数。

```javascript
const obj = {
  name: 'Deepspace',
  sayHi: function (gender) {
    console.log(`${this.name} ${gender}`);
  },
};

var name = 'globeName';
const hello = obj.sayHi;

hello('male'); // globeName male

const regard = hello.bind(obj, 'female'); // 使用 bind 绑定
regard(); // Deepspace female
```



#### 2、常见用途

##### 2.1、bind 和 new

看个例子：

```javascript
var nickname = 'window';

const bottle = {
  nickname: 'bottle',
};

function sayHello() {
  console.log('Hello,', this.nickname);
}

const bindBottle = sayHello.bind(bottle); // this 指向 bottle
bindBottle(); // Hello,  bottle

console.log(new bindBottle());
// Hello, undefined
// sayHello {}
```

使用 `new` 之后，打印出来的并不是全局变量 `window`， 也不是 `bottle` 中的 `nickname`，而是 `undefined`，这说明 `bind` 的 `this` 对象失效了，`new` 的实现中生成一个新的对象，这个时候的 `this` 指向的是 `sayHello` 。**这一点要特别注意**。

但是**参数依旧是可以传递**的：

```javascript
var value = 2;

var foo = {
    value: 1
};

function bar(name, age) {
    this.habit = 'shopping';
    console.log(this.value);
    console.log(name);
    console.log(age);
}

bar.prototype.friend = 'kevin';

var bindFoo = bar.bind(foo, 'daisy');

var obj = new bindFoo('18');
// undefined
// daisy
// 18
console.log(obj.habit);
console.log(obj.friend);
// shopping
// kevin
```



#### 3、模拟实现

`bind` 函数有两个特点：

1. 返回一个函数
2. 可以传入参数

关于指定 `this` 的指向，我们可以使用 `call` 或者 `apply` 实现。所以，我们可以写出第一版代码：

```javascript
Function.prototype.bind2 = function (context) {
  const self = this;
  return function () {
    return self.apply(context);
  };
};

const foo = {
  value: 1,
};

function bar() {
  console.log(this.value);
}

// 返回了一个函数
const bindFoo = bar.bind2(foo);

bindFoo(); // 1
```

下面实现可以传入参数的功能：

```javascript
Function.prototype.bind2 = function (context) {
  const self = this;
  // 获取 bind2 函数从第二个参数到最后一个参数
  const args = Array.prototype.slice.call(arguments, 1);

  return function () {
    // 这个时候的 arguments 是指 bind 返回的函数传入的参数
    const bindArgs = Array.prototype.slice.call(arguments);
    return self.apply(context, args.concat(bindArgs));
  };
};
```

接着，前面我们注意到使用 `new` 操作对象之后，会导致 `bind` 时的 `this` 无效的问题，也就是说

**当 `bind` 返回的函数作为构造函数的时候，`bind` 时指定的 `this` 值会失效，但传入的参数依然生效**。

第三版代码：

```javascript
Function.prototype.bind2 = function (context) {
  const self = this;
  const args = Array.prototype.slice.call(arguments, 1);

  const fBound = function () {
    const bindArgs = Array.prototype.slice.call(arguments);
    // 当作为构造函数时，this 指向实例，此时结果为 true，将绑定函数的 this 指向该实例，可以让实例获得来自绑定函数的值
    // 以上面的是 demo 为例，如果改成 `this instanceof fBound ? null : context`，实例只是一个空对象，将 null 改成 this ，实例会具有 habit 属性
    // 当作为普通函数时，this 指向 window，此时结果为 false，将绑定函数的 this 指向 context
    return self.apply(this instanceof fBound ? this : context, args.concat(bindArgs));
  };
  // 修改返回函数的 prototype 为绑定函数的 prototype，实例就可以继承绑定函数的原型中的值
  fBound.prototype = this.prototype;
  return fBound;
};
```