---
title: 一些比较有用的 JS 技巧
author: Hazelnut Latte
tags:
  - JavaScript
categories: JavaScript
date: 2019-01-28
urlname: javascript-tricks
---

#### 1、数组去重

```javascript
const j = [...new Set([1, 2, 3, 3])];

console.log(j); // [ 1, 2, 3 ]
```

#### 2、过滤错误值

将 `0`， `undefined`，`null`， `false` 等错误值从数组中剔除：

```javascript
myArray
  .map(item => {
    // ...
  })
  // Get rid of bad values
  .filter(Boolean);
```
<!-- more -->
#### 3、创建一个空对象

你当然可以使用 `{}` 来创建一个空对象，但是这个对象依旧有 `__proto__` 、 `hasOwnProperty` 和对象上的一些其它方法。可以这样创建一个纯的空对象：

```javascript
let dict = Object.create(null);

// dict.__proto__ === "undefined"
// No object properties exist until you add them
```

#### 4、合并对象

```javascript
const person = { name: 'David Walsh', gender: 'Male' };
const tools = { computer: 'Mac', editor: 'Atom' };
const attributes = { handsomeness: 'Extreme', hair: 'Brown', eyes: 'Blue' };

const summary = {...person, ...tools, ...attributes};
/*
Object {
  "computer": "Mac",
  "editor": "Atom",
  "eyes": "Blue",
  "gender": "Male",
  "hair": "Brown",
  "handsomeness": "Extreme",
  "name": "David Walsh",
}
*/
```

#### 5、Require Function Parameters

```javascript
const isRequired = () => {
  throw new Error('param is required');
};

const hello = (name = isRequired()) => {
  console.log(`hello ${name}`);
};

// This will throw an error because no name is provided
hello();

// This will also throw an error
hello(undefined);

// These are good!
hello(null);
hello('David');
```

#### 6、为解构赋值添加别名

```javascript
const obj = { x: 1 };

// Grabs obj.x as { x }
const { x } = obj;

// Grabs obj.x as { otherName }
const { x: otherName } = obj;
```

#### 7、获取查询字符串参数

```javascript
// Assuming "?post=1234&action=edit"

const urlParams = new URLSearchParams(window.location.search);

console.log(urlParams.has('post')); // true
console.log(urlParams.get('action')); // "edit"
console.log(urlParams.getAll('action')); // ["edit"]
console.log(urlParams.toString()); // "?post=1234&action=edit"
console.log(urlParams.append('active', '1')); // "?post=1234&action=edit&active=1"
```



