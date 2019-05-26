---
title: JavaScript 中的对象拷贝
author: Hazelnut Latte
tags:
  - 对象拷贝
categories: JavaScript
date: 2018-12-07
urlname: javascript-copy-object
---

<!-- ## JavaScript 中的对象拷贝-->

> 翻译自：原文链接：[copying-objects-in-javascript](https://smalldata.tech/blog/2018/11/01/copying-objects-in-javascript)
### 前言

这篇文章我们将会说说  `Javascript`  中对象拷贝的几种方式，我们会仔细探究深拷贝（`deep coping`）和浅拷贝（`shallow coping`）。

在文章开始之前，先提一下一些基础知识：在 `Javascript`  中，对象只是指向内存中某个位置的指针。这些指针是可变的，也就是说，它们可以重新被赋值。因此，如果我们单单简单地复制这个指针，**那就可能造成有两个指针指向内存中的同一块地址的结果。**
<!-- more -->
```javascript
var foo = {
  a: 'abc'
};
console.log(foo.a); // abc

var bar = foo;
console.log(bar.a); // abc

foo.a = 'yo foo';
console.log(foo.a); // yo foo
console.log(bar.a); // yo foo

bar.a = 'whatup bar?';
console.log(foo.a); // whatup bar?
console.log(bar.a); // whatup bar?
```

从上面的例子可以看出，`foo` 和 `bar` 这两个对象都能根据对方的变化而变化。因此，在拷贝 `Javascript` 中的对象的时候，我们要根据实际使用情况选择拷贝方式。

### 一、浅拷贝

如果要操作的对象拥有的属性都是值类型，那么我们可以用 `ES6` 中的扩展运算符或者 `Object.assign(...)` :

**1、扩展运算符：**

```javascript
var obj = { foo: "foo", bar: "bar" };

var copy = { ...obj }; // Object { foo: "foo", bar: "bar" }
```

**2、`Object.assign(...)` :**

```javascript
var obj = { foo: "foo", bar: "bar" };

var copy = Object.assign({}, obj); // Object { foo: "foo", bar: "bar" }
```

可以看到，上面的两个方法都可以把多个不同来源对象中的属性拷贝到一个目标对象中。

```javascript
var obj1 = { foo: "foo" };
var obj2 = { bar: "bar" };

var copySpread = { ...obj1, ...obj2 }; // Object { foo: "foo", bar: "bar" }
var copyAssign = Object.assign({}, obj1, obj2); // Object { foo: "foo", bar: "bar" }
```

但是，上面的两种方法也存在一些问题：如果对象的属性本身也是对象，那么实际被拷贝的还只是那些指针。也就是说，这跟执行 `var bar = foo;`  的效果是一样的，跟前言中的代码的做法效果是一样的。

```javascript
var foo = { a: 0 , b: { c: 0 } };
var copy = { ...foo };

copy.a = 1;
copy.b.c = 2;

console.dir(foo); // { a: 0, b: { c: 2 } }
console.dir(copy); // { a: 1, b: { c: 2 } }
```



### 二、深拷贝（有缺陷）

如果想要深拷贝一个对象，一个可用的解决方法是：**先把对象序列化成字符串，然后再把它反序列化回来。**

```javascript
var obj = { a: 0, b: { c: 0 } };
var copy = JSON.parse(JSON.stringify(obj));
```

不幸的是，这个方法只在对象包含可序列化值，并且没有循环引用的时候有用。其中一个不可序列化的类型的就是**日期对象**。尽管它显示出来是字符串化的 `ISO` 格式，但是 `JSON.parse` 只会把它解析成为一个字符串，而不是日期类型。



### 三、深拷贝 (缺陷少一些)

对于一些更复杂的情景，我们可以使用 `HTML5` 的一个新算法，叫做[结构化克隆](https://developer.mozilla.org/en-US/docs/Web/API/Notification/Notification)。不过，截至本篇文章发表为止，有些内置类型还是无法支持，但相比 `JSON.parse` ，它支持的类型要多的多：**日期类型，正则表达式，Map，集合，二进制大对象，文件集合，图像数据，sparse函数和数组**。 它还维护克隆对象的引用，使得他可以支持循环引用结构的拷贝，而这些在上面的序列化例子中是不支持的。

目前，没有直接调用结构化克隆的方法，但是有些新的浏览器特性，底层使用了这个算法。因此，深拷贝对象可能需要一系列的环境才能实现。

通过 `MessageChannels`:  这样做的原理是，借用通讯的一个特性中使用到的序列化算法。由于那个特性是基于事件的，所以这里的克隆也是一个异步操作。

```javascript
class StructuredCloner {
  constructor() {
    this.pendingClones_ = new Map();
    this.nextKey_ = 0;
    const channel = new MessageChannel();
    this.inPort_ = channel.port1;
    this.outPort_ = channel.port2;
    this.outPort_.onmessage = ({ data: { key, value } }) => {
      const resolve = this.pendingClones_.get(key);
      resolve(value);
      this.pendingClones_.delete(key);
    };
    this.outPort_.start();
  }

  cloneAsync(value) {
    return new Promise(resolve => {
      const key = this.nextKey_++;
      this.pendingClones_.set(key, resolve);
      this.inPort_.postMessage({ key, value });
    });
  }
}

const structuredCloneAsync = (window.structuredCloneAsync = StructuredCloner.prototype.cloneAsync.bind(
  new StructuredCloner()
));
const main = async () => {
  const original = { date: new Date(), number: Math.random() };
  original.self = original;
  const clone = await structuredCloneAsync(original);
  // different objects:
  console.assert(original !== clone);
  console.assert(original.date !== clone.date);
  // cyclical:
  console.assert(original.self === original);
  console.assert(clone.self === clone);
  // equivalent values:
  console.assert(original.number === clone.number);
  console.assert(Number(original.date) === Number(clone.date));
  console.log('Assertions complete.');
};
main();

```

通过 `history` 对象 `API` ：`history.pushState()` 和 `history.replaceState()`  都会给它们的第一个参数做一个结构化克隆！要注意的是，这个方法是同步的，操作浏览器历史这个操作速度不是非常快，如果频繁调用这个方法，会导致浏览器卡死。

```javascript
const structuredClone = obj => {
  const oldState = history.state;
  history.replaceState(obj, null);
  const clonedObj = history.state;
  history.replaceState(oldState, null);
  return clonedObj;
};
```

通过 [notification API](https://developer.mozilla.org/en-US/docs/Web/API/Notification/Notification): 当创建一个 `notification` 实例的时候，构造器为它相关的数据做了结构化克隆。需要注意的是，它会尝试向用户展示浏览器通知，但是，除非它接收到用户允许展示通知的请求，否则，它什么也不会做。一旦用户点击同意的话，`notification`  会立刻被关闭。

```javascript
const structuredClone = obj => {
  const n = new Notification('', { data: obj, silent: true });
  n.onshow = n.close.bind(n);
  return n.data;
};
```



### 四、使用Node.js进行深拷贝

`Node.js` 的 8.0.0 版本提供了一个 [序列化 api](https://nodejs.org/api/v8.html#v8_serialization_api) 可以跟结构化克隆媲美。不过这个 `API` 在本文发布的时候，还只是被认为是试验性的:

```javascript
const v8 = require('v8');
const buf = v8.serialize({a: 'foo', b: new Date()});
const cloned = v8.deserialize(buf);
cloned.b.getMonth();
```

8.0.0 版本以下的话，比较稳定的方法，可以考虑用[ `lodash`](https://lodash.com/docs/4.17.11) 的 [`cloneDeep`](https://lodash.com/docs/4.17.11#cloneDeep) 函数，它的思想也多少有点基于结构化克隆算法。

### 结论

总结一下，`Javascript` 中最好的对象拷贝的算法，很大程度上取决于使用环境，以及你需要拷贝的对象的类型。虽然 `lodash` 是最安全的泛型深拷贝函数，但是，如果你自己封装的话，可能可以得到效率更高的实现方法，以下就是一个简单的深拷贝，也同样适用于`Date`日期对象：

```javascript
function deepClone(obj) {
  var copy;
  // Handle the 3 simple types, and null or undefined
  if (null == obj || 'object' != typeof obj) return obj;
  // Handle Date
  if (obj instanceof Date) {
    copy = new Date();
    copy.setTime(obj.getTime());
    return copy;
  }

  // Handle Array
  if (obj instanceof Array) {
    copy = [];
    for (var i = 0, len = obj.length; i < len; i++) {
      copy[i] = deepClone(obj[i]);
    }
    return copy;
  }

  // Handle Function
  if (obj instanceof Function) {
    copy = function() {
      return obj.apply(this, arguments);
    };
    return copy;
  }

  // Handle Object
  if (obj instanceof Object) {
    copy = {};
    for (var attr in obj) {
      if (obj.hasOwnProperty(attr)) copy[attr] = deepClone(obj[attr]);
    }
    return copy;
  }

  throw new Error(
    "Unable to copy obj as type isn't supported " + obj.constructor.name
  );
}
```

就个人来说，我很期待可以随便使用结构克隆的那一天，让对象拷贝不再令人头疼。

[JAVASCRIPT ](https://www.zcfy.cc/article/tag/JavaScript)[算法 ](https://www.zcfy.cc/article/tag/%E7%AE%97%E6%B3%95)[浏览器 ](https://www.zcfy.cc/article/tag/%E6%B5%8F%E8%A7%88%E5%99%A8)[API ](https://www.zcfy.cc/article/tag/API)[HTML](https://www.zcfy.cc/article/tag/HTML)
