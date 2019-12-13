---
title: JavaScript 中的 this 关键字
author: Deepspace
tags:
  - this
categories: JavaScript
date: 2018-12-09
urlname: javascript-this
---

`JavaScript` 中的 `this` 关键字是一个非常重要的语法点，在开发过程中，我们会经常用到它。

学习 `this` 之前，我们先思考一个问题：`JavaScript` 中为什么会有 `this ` ？



### 一、为什么要用 this？

#### 1、一个通俗的例子

我们看一段话：

```
从前有座山
山上有座庙被叫作神庙
神庙里有很多小和尚
小和尚们非常喜欢这座神庙
所以小和尚们都经常挑水到神庙
```

读完这段话我们发现了一些问题：

- 这段话里出现了很多次**神庙**
- 不符合我们说话和描述的习惯
- 词语很累赘

所以，我们经常会这样干：

```
从前有座山
山上有座庙被叫作神庙
这里有很多小和尚
小和尚们非常喜欢这里
所以小和尚们都经常挑水到这里
```

只在说话的开始，保留第一个名词，后面重复用到时，都用**这**来代替。现在读起来就顺口多了，其实写代码也是一样的。
<!-- more -->
现在我们把上面的例子转化为代码语言。



#### 2、用代码语言来描述

假设我们有个叫作 `person` 的对象：

```javascript
const person = {
  name: 'Deepspace',
  age: 23,
  phone: '1234567890',
  sayHi: function () {
    // ...
  },
  sayBye: function () {
    // ...
  }
};
```

这个对象有 `name` 、`age` 和 `phone` 三个属性，有 `sayHi` 和 `sayBye` 两个方法。

现在的需求是：

- 调用 `person.sayHi(...)`，打印：你好，我是 `Deepspace`，今年 23 岁。
- 调用 `person.sayBye(...)`，打印：再见，记得我叫 `Deepspace` 哦，想约我的话打电话给我，我的电话是 1234567890。

如何实现呢？我们先用比较 "笨" 一些的方法实现：

```javascript
const person = {
  name: 'Deepspace',
  age: 23,
  phone: '1234567890',
  sayHi: function (name, age) {
    console.log(`你好，我是 ${name}，今年 ${age} 岁。`);
  },
  sayBye: function (name, phone) {
    console.log(`再见，记得我叫 ${name} 哦，想约我的话打电话给我，我的电话是 ${phone}。`);
  }
};
```

调用方式是：

```javascript
person.sayHi(person.name, person.age);
person.sayBye(person.name, person.phone);
```

**改进一：**

```javascript
const person = {
  name: 'Deepspace',
  age: 23,
  phone: '1234567890',
  sayHi: function (self) {
    console.log(`你好，我是 ${self.name}，今年 ${self.age} 岁。`);
  },
  sayBye: function (self) {
    console.log(`再见，记得我叫 ${self.name} 哦，想约我的话打电话给我，我的电话是 ${self.phone}。`);
  }
};
```

调用方式是：

```javascript
person.sayHi(person);
person.sayBye(person);
```

这次改进，我们把 `person` 直接作为参数传递给 `sayHi` 和 `sayBye` 方法，稍微好了一些。

**改进二：**

为什么不把参数 `person` 直接干点，调用 `sayHi()` 或者 `sayBye` 就好呢？这样多直接啊。

那么问题来了：**如果 `person.sayHi()` 没有实参，那函数是如何接收到 `person` 的呢？**

有两种实现方案：

- 方法1：依然把第一个参数 `self` 当作 `person`，这样形参就会永远比实参多出一个 `self` 。
- 方法2：隐藏 `self`，然后用关键字 `this` 来访问 `self`。

`Python` 选择了第一种实现方案，`JavaScript` 选择了第二种实现方案。

**Python：**

```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def sit(self):
        print(self.name.title() + " is now sitting")

    def roll_over(self):
        print(self.name.title() + " rolled over!")
        
        
my_dog = Dog('willie', 6)
# 访问属性
print("My dog's name is " + my_dog.name.title() + '.')
print("My dog " + str(my_dog.age) + " years old.")

# 调用方法
my_dog.sit()
my_dog.roll_over()
```

**JavaScript：**

```javascript
const person = {
  name: 'Deepspace',
  age: 23,
  phone: '1234567890',
  sayHi: function () {
    console.log(`你好，我是 ${this.name}，今年 ${this.age} 岁。`);
  },
  sayBye: function () {
    console.log(`再见，记得我叫 ${this.name} 哦，想约我的话打电话给我，我的电话是 ${this.phone}。`);
  }
};
```

调用方式是：

```javascript
person.sayHi();
person.sayBye();
```

这就是 `JavaScript` 中 `this` 的由来。



### 二、this 的绑定规则

`JavaScript` 中的 `this` 有四种绑定规则。

#### 1、默认绑定

**当一个函数没有明确的调用对象的时候，也就是单纯作为独立函数调用的时候，将对函数的 `this` 使用默认绑定，绑定到全局的 `window` 对象。**

```javascript
function defaultBind() {
  console.log(this === window);
};

defaultBind(); // true
```

> 注意：需要在浏览器环境执行，`node` 环境下会报错：`ReferenceError: window is not defined` 。

所以，如果我们在全局环境初始化一个变量，在独立函数中可以使用 `this` 来获取到该全局变量：

```javascript
var name = 'Deepspace';

function box() {
  console.log(this.name);
};

box(); // Deepspace
```

> **这里额外提一下：**
>
> 在 `ES5` 中，顶层对象的属性和全局变量是等价的，`var` 命令和 `function` 命令声明的全局变量，自然也是顶层对象。所以：
>
> ```javascript
> var a = 12;
> function f(){};
> 
> console.log(window.a); // 12
> console.log(window.f); // f(){}
> ```
>
> 但 `ES6` 规定，`var` 命令和 `function` 命令声明的全局变量，依旧是顶层对象的属性，但 `let` 命令、`const` 命令、`class` 命令声明的全局变量，不属于顶层对象的属性。所以：
>
> ```javascript
> let a = 1;
> const f = function () {
>   return 1;
> };
> 
> console.log(window.a); // undefined
> console.log(window.f); // undefined
> ```
>
> 在全局作用域中，用 `let` 和 `const` 声明的全局变量并没有在全局对象中，只是一个块级作用域（`Script`）中（可以在浏览器中设置断点查看）。
>
> ![let debug](https://github.com/IDeepspace/ImageHosting/raw/master/FrontEnd/let-const-debug.png)
>
> 所以，要想访问用 `let` 和 `const` 声明的全局变量，就不可以使用 `window`。所以在上面演示 `this` 的默认绑定的时候，使用 `var` 来初始化变量。

我们把上面的例子改一下：

```javascript
function box() {
  function innerBox() {
    console.log(this === window);
  }
  innerBox();
};

box(); // true
```

函数 `innerBox` 在一个外部函数 `box` 里面声明且调用，它的 `this` 依然指向 `window` 。

所以，**没有明确的调用对象的时候，将对函数的 `this` 使用默认绑定：绑定到全局的 `window` 对象**。记住这一点就好。我们再改一下这个例子：

```javascript
var obj = {
  box: function () {
    function innerBox() {
      console.log(this === window);
    }
    innerBox();
  }
};

obj.box(); // true
```

结果依旧是 `true`，这里其实也用到了默认绑定。



#### 2、隐式绑定

**当函数被一个对象“包含”的时候，我们称函数的 `this` 被隐式绑定到这个对象里面了，这时候，通过 `this` 可以直接访问所绑定的对象里面的其他属性。**

每当我们调用一个对象的方法时，都会出现隐式绑定。

例如：

```javascript
var name = 'globe name';

const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  }
};

obj.sayHi(); // Deepspace
```

我们再看另一段代码：

```javascript
var name = 'globe name';

function sayHi() {
  console.log(this.name);
}

const obj = {
  name: 'Deepspace',
  sayHi: sayHi
};

obj.sayHi(); // Deepspace
```

`sayHi` 函数依旧打印的是 `Deepspace` 。也就是说：**`sayHi` 函数并不会因为它是被定义在 `obj` 对象的内部还是外部而有任何区别。** `this` 还是可以访问到 `obj` 对象中的 `name` 属性。

我们再看个例子：

```javascript
const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  }
};

var name = 'globe name';
const hello = obj.sayHi;

hello(); // globe name
```

为什么 `hello` 会输出 `globe name` 呢？

首先，我们需要明确，`this` 的绑定是动态的。

**当使用 `this` 的函数被包含在对象中时，这个函数对于对象来说是独立的，并不被这个对象所完全拥有。 它和在对象外部声明函数，然后在对象内部通过属性名称的方式取得函数的引用是完全等价的。定义在对象内部的函数只是“恰好可以被这个对象调用”而已，而不是“生来就是为这个对象所调用”的。**

所以，当把 `obj.sayHi` 这个函数赋值给变量 `hello` 时，`hello` 这个函数引用就和 `obj` 这个对象完全没有关系了。此时的 `this` 指向的是 `window` 而不是 `obj` ，所以会输出  `globe name` 。

再看个复杂点的例子：

```javascript
var name = 'globe name';

const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  }
};

function sayHello(fn) {
  fn();
}

sayHello(obj.sayHi); // globe name
```

如果函数调用位置是在一串对象属性链中呢？

```javascript
var obj = {
  a: 1,
  obj2: {
    a: 2,
    obj3: {
      a: 3,
      getA: function () {
        console.log(this.a);
      }
    }
  }
};

obj.obj2.obj3.getA();  // 输出3
```

这个时候，`this` 绑定的是最内层的对象，也就是离得最近的对象。



#### 3、显示绑定

##### call 

在上面的隐式绑定的例子中，当把 `obj.sayHi` 这个函数赋值给变量 `hello` 时，此时的 `this` 指向的是 `window` 而不是 `obj` ，所以会输出  `globe name` ，那如果一定要把 `this` 指向 `obj` 该怎么做呢？`call` 函数就派上用场了。

`call` 函数的语法：

```javascript
fn.call(object);
```

`fn` 是你调用的函数，`object` 参数是希望函数的 `this` 所绑定的对象。

`fn.call(object)` 的作用：

- 立即调用这个函数 `fn`

- 调用这个函数的时，将函数的 `this` 指向 `object` 对象

看个例子：

```javascript
const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  }
};

var name = 'globe name';
const hello = obj.sayHi;

hello(); // globe name

hello.call(obj); // Deepspace
```

现在问题来了：每次都写 `call` 去绑定 `this` 很麻烦，有没有一劳永逸的方式呢？当然有，我们可以这样做：

```javascript
const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  }
};

var name = 'globe name';
const hello = obj.sayHi;

hello(); // globe name

const greet = function () {
  hello.call(obj);   //硬绑定
};

hello.call(obj); // Deepspace
greet(); // Deepspace
```

在 `hello.call(obj)` 的外边在包一层函数就可以了，这种方式叫做**硬绑定**。

##### bind

也可以把 `bind` 方法来简化这种写法：

```javascript
const obj = {
  name: 'Deepspace',
  sayHi: function () {
    console.log(this.name);
  }
};

var name = 'globe name';
const hello = obj.sayHi;

hello(); // globe name

const regard = hello.bind(obj); // 使用 bind 绑定
regard(); // Deepspace
```

从例子可以看出：**`call` 和 `bind` 的区别在于，在绑定 `this` 到对象参数的同时，`call` 将立即执行该函数，`bind` 不执行函数，只返回一个可供执行的函数。**

##### apply

`apply` 方法的作用与 `call` 方法类似，也是改变 `this` 指向，然后再调用该函数。**唯一的区别就是，它接收一个数组作为函数执行时的参数。**看个例子：

```javascript
function getAge(gap) {
  var y = new Date().getFullYear();
  return y - this.birth - gap;
}

var chenxingxing = {
  name: '陈星星',
  birth: 1995,
  age: getAge
};

console.log(chenxingxing.age(1)); // 23
console.log(getAge.apply(chenxingxing, [1])); // 23, this 指向 chenxingxing, 参数为空
```



#### 4、new 绑定

执行 `new` 操作符来调用函数的时候，将创建一个新的对象，并且将构造函数的 `this` 指向所创建的新对象。如果函数没有返回其他对象，那么 `new` 表达式中的函数调用会自动返回这个新对象：

```javascript
function foo(a) {
  this.a = a;
}

const a1 = new foo(1);
const a2 = new foo(2);
const a3 = new foo(3);
const a4 = new foo(4);

console.log(a1.a); // 1
console.log(a2.a); // 2
console.log(a3.a); // 3
console.log(a4.a); // 4
```

但是如果函数中返回的有其他对象，此时的 `this` 绑定在其返回的对象上：

```javascript
function foo(a) {
  this.a = a;
  return {
    m: 99
  };
}

const a1 = new foo(1);
const a2 = new foo(2);

console.log(a1.a); // undefined
console.log(a2.a); // undefined
console.log(a2.m); // 99
```



### 三、不好的实践

由于 `this` 的指向是不确定的，所以使用起来尤其有注意。有几个不好的实践需要避免：

#### 1、避免在函数中包含多层的 `this`

看个函数：

```javascript
var o = {
  f1: function () {
    console.log(this);
    function temp() {
      console.log(this);
    }
    return temp;
  }
};

var c = o.f1();

c();
// Object: { f1: ƒ }
// Window
```

上面的函数包含了两层 `this` ，第一层指向对象 `o` ，第二层指向 `Window`。实际上的执行代码是：

```javascript
function temp() {
  console.log(this);
}

var o = {
  f1: function () {
    console.log(this);
    return temp;
  }
};

var c = o.f1();

c();
// Object: { f1: ƒ }
// window
```

很容易弄混淆。所以我们常用的做法是：

```javascript
var o = {
  f1: function () {
    console.log(this);
    const that = this;
    function temp() {
      console.log(that);
    }
    return temp;
  }
};

var c = o.f1();

c();
// Object: { f1: ƒ }
// Object: { f1: ƒ }
```

在第二层改用一个指向外层 `this` 的变量。

同时，`JavaScript` 提供了严格模式，也可以硬性避免这种问题。

严格模式下，当函数内部的 `this` 指向全局的 `Window` 时，会将 `this` 指向转为 `undefined`：

```javascript
function a() {
  function b() {
    console.log(this);
    function c() {
      'use strict';
      console.log(this);
    }
    c();
  }
  b();
}

a();
// Window
// undefined
```



#### 2、避免数组处理方法中的 `this`

数组的 `map ` 和 `foreach` 方法，允许提供一个函数作为参数。这个函数内部不应该使用 `this`。

```javascript
const o = {
  v: 'hello',
  p: ['a1', 'a2'],
  f: function f() {
    this.p.forEach(function (item) {
      console.log(this.v + ' ' + item);
    });
  }
};

o.f();
// undefined a1
// undefined a2
```

上面代码中，`foreach` 方法的回调函数中的 `this`，其实是指向 `window` 对象，因此取不到 `o.v` 的值。原因跟上一段的多层 `this` 是一样的，就是内层的 `this` 不指向外部，而指向顶层对象。

解决这个问题的一种方法，就是前面提到的，使用中间变量固定 `this`：

```javascript
const o = {
  v: 'hello',
  p: ['a1', 'a2'],
  f: function f() {
    const that = this;
    this.p.forEach(function (item) {
      console.log(that.v + ' ' + item);
    });
  }
};

o.f();
// hello a1
// hello a2
```



#### 3、避免回调函数中的 `this`

回调函数中的 `this` 往往会改变指向，最好避免使用。例如：

```javascript
var o = new Object();

o.f = function () {
  console.log(this === o);
};

// jQuery 的写法
$('#button').on('click', o.f); // false
```

上面代码中，点击按钮以后，控制台会显示 `false` 。原因是此时 `this` 不再指向 `o` 对象，而是指向按钮的 `DOM` 对象，因为 `f` 方法是在按钮对象的环境中被调用的。



### 四、最后

最后来演练一下 `this` 的指向吧：

```javascript
var name = '小红';

function a() {
  const name = '小白';
  console.log(this.name);
}

function d(i) {
  return i();
}

const b = {
  name: '小黄',
  detail: function () {
    console.log(this.name);
  },
  hello: function () {
    return function () {
      console.log(this.name);
    };
  }
};

var nickname = 'The Window';

var object = {
  nickname: 'My Object',

  getNameFunc: function () {
    var that = this;
    return function () {
      return that.nickname;
    };
  }
};

const c = b.detail;
b.a = a;
const e = b.hello();
a(); // 小红
c(); // 小红
b.a(); // 小黄
d(b.detail); // 小红
e(); // 小红

const f = object.getNameFunc;
f()(); // The Window
object.getNameFunc()(); // 'My Object'
```



<br>

> 转载文章请给作者署名：https://togoblog.cn/