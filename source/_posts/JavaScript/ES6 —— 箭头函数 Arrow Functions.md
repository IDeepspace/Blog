---
title: ES6 —— 箭头函数 Arrow Functions
author: Deepspace
tags:
  - ES6
categories: JavaScript
date: 2017-02-18
urlname: es6-arrow-functions
---

<!-- ## ES6 —— 箭头函数 Arrow Functions -->

ES6 中引入了一种编写函数的新语法 ---- 箭头函数 `Arrow Functions` 。

### 一、箭头函数的优点

- 使用箭头函数比普通函数少些动词，如：`function ` 或  `return`
- `this ` 提前定义，从上下文可以捕获 `this`。

当你只需要一个只有一个参数的简单函数时，可以使用新标准中的箭头函数，它的语法非常简单：`标识符 => 表达式`。你无需输入 `function`和 `return`，一些小括号、大括号以及分号也可以省略。

<!-- more -->



### 二、箭头函数的用法

1. 如果箭头函数不需要参数或需要多个参数，就使用一个圆括号代表参数部分。

```javascript
let f = () => 5;
// 等同于
let f = function() {
  return 5;
};

let sum = (num1, num2) => num1 + num2;
// 等同于
let sum = function(num1, num2) {
  return num1 + num2;
};
```

2. 如果箭头函数的代码块部分多于一条语句，就要使用大括号将它们括起来，并且使用 `return` 语句返回。

```javascript
let sum = (num1, num2) => {
  return num1 + num2;
};

// 如果箭头函数只有一行语句，可以采用下面的写法，就不用写大括号了。
let fn = () => expression;
```

3. 由于大括号被解释为代码块，所以如果箭头函数直接返回一个对象，必须在对象外面加上括号，否则会报错。

```javascript
// 报错
let getTempItem = id => { id: id, name: "Temp" };

// 不报错
let getTempItem = id => ({ id: id, name: "Temp" });
```

4. 箭头函数还可以和解构赋值 `Destructuring` 联合使用。

```javascript
const full = ({ first, last }) => first + ' ' + last;

// 等同于
function full(person) {
  return person.first + ' ' + person.last;
}
```

5. 简化回调函数

```javascript
// 正常函数写法
[1, 2, 3].map(function(x) {
  return x * x;
});

// 箭头函数写法
[1, 2, 3].map(x => x * x);
```

6. `rest` 参数与箭头函数结合

```javascript
const numbers = (...nums) => nums;

numbers(1, 2, 3, 4, 5);
// [1,2,3,4,5]

const headAndTail = (head, ...tail) => [head, tail];

headAndTail(1, 2, 3, 4, 5);
// [1,[2,3,4,5]]
```



### 四、箭头函数中的 this

> 你可以在这里查看 `JavaScript` 中的 `this`：https://togoblog.cn/javascript-this/

#### 1、默认绑定外层this

我们都知道 ：`this` 的值是可以用 `call` 方法修改的，而且只有在调用的时候我们才能确定 `this` 的值，简单写个例子说明：

```javascript
const obj = {
  name: 'Jerry',
  greet: function () {
    console.log(this.name);
  }
};
obj.greet();  // Jerry 第一种调用方法
obj.greet.call(obj); // Jerry 第二种调用方法

// 手动指定 this
const obj1 = {
  name: 'Jerry',
  greet: function () {
    console.log(this.name);
  }
};

obj1.greet.call({ name: 'Spike' });  // Spike
```

而当我们使用箭头函数的时候，**箭头函数会默认帮我们绑定外层 `this` 的值，所以在箭头函数中 `this` 的值和外层的 `this` 是一样的。**

不使用箭头函数例子：

```javascript
const obj = {
  a: function() {
    console.log(this);
  },
};
obj.a(); // 打出的是 obj 对象
```

使用箭头函数的例子：

```javascript
const obj = {
  a: () => {
    console.log(this);
  },
};
obj.a(); // 打出来的是 window
```

在使用箭头函数的例子里，**因为箭头函数默认不会使用自己的 `this`，而是会和外层的 `this` 保持一致，外层的 `this` 就是 `window` 对象。**



#### 2、不能用 call 方法修改里面的 this

为了减少 `this` 的复杂性，箭头函数无法用 `call` 方法来指定 `this` 。

```javascript
const obj = {
  m: 1,
  a: () => {
    console.log(this.m);
  },
};

var m = 2;

obj.a(); // 2
obj.a.call({ m: 3 }); // 2
```



#### 3、多层对象嵌套里函数的 this

上面说过，箭头函数里的 `this` 是和外层保持一致的，但是如果这个外层有好多层，那它是和哪层保持一致呢？

看个例子：

```javascript
const obj = {
  a: function () {
    console.log(this);
  },
  b: {
    c: function () {
      console.log(this);
    },
  },
};
obj.a(); // 打出的是 obj 对象, 相当于 obj.a.call(obj)
obj.b.c(); // 打出的是 obj.b 对象, 相当于 obj.b.c.call(obj.b)
```

接下来把 `obj.b.c` 对应的函数换成箭头函数：

```javascript
const obj = {
  a: function () {
    console.log(this);
  },
  b: {
    c: () => {
      console.log(this);
    },
  },
};

obj.a(); // { a: [Function: a], b: { c: [Function: c] } }
obj.b.c(); // Window
```

`obj.a` 调用后打出来的是 `obj` 对象，而 `obj.b.c` 调用后打出的是 `window` 对象而非 `obj` 。那是不是说**这就表示多层对象嵌套里箭头函数里 `this` 是和最最外层保持一致呢？**

其实不是的！！！我在刚开始的时候，看过一些博客里有这样去定义，其实这样描述是不正确的。

**箭头函数中的 `this`，总是指向定义时所在的对象，而不是运行时所在的对象。**

看个例子：

```javascript
function foo() {
  setTimeout(() => {
    console.log('id:', this.id);
  }, 100);
}
var id = 21;

foo(); // id: 21
foo.call({ id: 42 }); // id: 42
```

这个例子中，箭头函数位于 `foo` 函数内部。只有 `foo` 函数运行后，它才会按照定义生成，所以 **`foo` 运行时所在的对象，恰好是箭头函数定义时所在的对象**。

所以，和上面的理由一样，下面的代码结果都是 1： 

```javascript
function foo() {
  return () => {
    return () => {
      return () => {
        console.log('id:', this.id);
      };
    };
  };
}

var f = foo.call({ id: 1 });

var t1 = f.call({ id: 2 })()(); // id: 1
var t2 = f().call({ id: 3 })(); // id: 1
var t3 = f()().call({ id: 4 }); // id: 1
```

下面看个例子：

```javascript
function fn0() {
  return {
    fn1: function () {
      console.log(this);
      var obj = {
        a: {
          c: function () { console.log(this); }
        },
        b: {
          c: () => console.log(this),
        },
        d: function () {
          return {
            c: () => { console.log(this); }
          };
        }
      };
      return obj;
    },
  };
}

fn0().fn1().a.c();
// { fn1: [Function: fn1] }
// { c: [Function: c] }

fn0().fn1().b.c();
// { fn1: [Function: fn1] }
// { fn1: [Function: fn1] }

fn0().fn1().d().c();
// { fn1: [Function: fn1] }
/*{
   a: { c: [Function: c] },
   b: { c: [Function: c] },
  d: [Function: d]
 }*/
```



#### 4、箭头函数的使用

由于箭头函数中的 `this` 问题，我们在使用时需要遵守下面的规则，避免代码过于混乱：

- 对于需要使用 `object.method()` 方式调用的函数，使用普通函数定义，不要使用箭头函数；
- 其他情况下，全部使用箭头函数。



### 五、箭头函数的其他特性

1. `typeof` 运算符和普通的函数一样

```javascript
let commFunc = function () { };
console.log(typeof commFunc);
```

输出为 `function`。

```javascript
let arrowFunc = () => {};
console.log(typeof arrowFunc);
```

输出也为`function`。从此可以看出箭头函数的类型和普通的函数一样都为 `function`。



2. `instanceof ` 也返回  `true`，表明是 `Function` 的实例

```javascript
let func = () => {};
console.log(func instanceof Function);
```

输出为`true`，由此可以看出箭头函数也是 `Function` 的实例。



3. 返回对象用小括号括起来

```javascript
let person = () => {
  name: 'galler';
};
console.log(person());
```

输出为`undefined`。此时的 `{}` 表明函数的起始位置和结束位置，由于该函数没有返回值，所以被调用时值为 `undefined`

```javascript
let person = () => ({
  name: 'galler'
});
console.log(person());
```

输出为`{name:"galler"}`。 此时 `{}` 表示定义一个对象。用 `()` 括起来表示是一个表达式，默认返回该对象。



4. 箭头函数中不能使用 `new`

```javascript
let Person = name => {
  this.name = name;
};
let one = new Person('galler');
```

运行该程序，则出现 `TypeError: Person is not a constructor` 。



5. `arguments` 

```javascript
function person() {
  console.log(arguments);
}
person(1);
```

一般的函数使用 `arguments`，在浏览器中输出为一个数组：`[1]`，在 `Node` 环境中输出为一个对象：`{'0':1}`

```javascript
let person = () => {
  console.log(arguments);
};
person('galler');
```

箭头函数使用 `arguments`，在浏览器环境中，则出现 `ReferenceError`，在 `Node` 环境中输出 `{"0":{}，……}`。
由此可以得出，箭头函数与普通函数的再一个区别：不能使用 `arguments` 对象。



6. 没有原型

```javascript
let person = () => {};
console.log(person.prototype);
```

输出为 `undefined`。由此可以看出箭头函数没有原型 。
