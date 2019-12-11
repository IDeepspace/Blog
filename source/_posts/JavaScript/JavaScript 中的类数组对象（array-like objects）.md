---
title: JavaScript 中的类数组对象（array-like objects）
author: Deepspace
tags:
  - ES6
categories: JavaScript
date: 2017-02-11
urlname: array-like-object
---

## JavaScript 中的类数组对象（array-like objects）

`JavaScript` 中的某些对象看起来像数组，但并不数组，这类对象被称为类数组。这篇博客文章我们一起看看类数组对象的含义以及如何最好地使用这些对象。



### 一、定义

- 类数组对象拥有索引和 `length` 属性。
- 但是类数组对象没有数组的方法，例如：`push`，`forEach`，`indexOf` 等。

举个例子：

```javascript
const array = ['name', 'age', 'sex'];

const arrayLike = {
  0: 'name',
  1: 'age',
  2: 'sex',
  length: 3
}

console.log(array[0]); // name
console.log(arrayLike[0]); // name

console.log(array.length); // 3
console.log(arrayLike.length); // 3

array[0] = 'new name';
arrayLike[0] = 'new name';

console.log(array);
console.log(arrayLike);
```

<!-- more -->



### 二、遍历

类数组对象可以和数组一样使用 `for...i` 循环：

```javascript
for (let i = 0, len = array.length; i < len; i++) {
  console.log(array[i])
}
// name
// age
// sex

for (let i = 0, len = arrayLike.length; i < len; i++) {
  console.log(array[i])
}
// name
// age
// sex
```

但是类数组对象不可以使用数组的方法，会直接报错。比如：

```javascript
arrayLike.push('4'); // TypeError: arrayLike.push is not a function
```



### 三、调用数组方法

既然无法直接调用数组的方法，那有没有办法可以间接调用呢？

```javascript
const arrayLike = { 0: 'name', 1: 'age', 2: 'sex', length: 3 }

console.log(Array.prototype.join.call(arrayLike, '&')); // name&age&sex

console.log(Array.prototype.slice.call(arrayLike, 0)); // ["name", "age", "sex"] 
// slice可以做到类数组转数组

console.log(Array.prototype.map.call(arrayLike, function (item) {
  return item.toUpperCase();
})); // ["NAME", "AGE", "SEX"]
```

我们可以用 `Function.call` 间接调用。



### 四、类数组对象转数组

```javascript
const arrayLike = { 0: 'name', 1: 'age', 2: 'sex', length: 3 };

// 1. slice
console.log(Array.prototype.slice.call(arrayLike)); // ["name", "age", "sex"] 
// 2. splice
console.log(Array.prototype.splice.call(arrayLike, 0)); // ["name", "age", "sex"] 
// 3. ES6 Array.from
console.log(Array.from(arrayLike)); // ["name", "age", "sex"] 
// 4. apply
console.log(Array.prototype.concat.apply([], arrayLike)); // ["name", "age", "sex"] 
```



<br>

> 转载文章请给作者署名：https://togoblog.cn/