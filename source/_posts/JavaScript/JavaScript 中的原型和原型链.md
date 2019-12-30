---
title: JavaScript 中的原型和原型链
author: Deepspace
tags:
  - 原型
  - 原型链
categories: JavaScript
date: 2018-07-03
urlname: javascript-prototypes-and-prototype-chains 
---

## JavaScript 中的原型和原型链

### 一、通过 new 创建对象

我们知道，使用 `new` 操作符可以创建并初始化一个新对象。关键字 `new` 后跟随一个函数调用，这里的函数称为构造函数（`constructor`）。

```javascript
const person = new Object();

person.name = 'Deepspace';
person.age = 23;
person.job = 'Software Engineer';
person.sayName = function () {
  console.log(this.name);
};
```

并且，`JavaScript` 中的原始类型都包含内置构造函数，在运行时会自动出现在执行环境中。如：

```javascript
const arr = new Array(); // 创建一个空数组，和 [] 一样
console.log(arr instanceof Array); // true

const d = new Date(); // 创建一个表示当前时间的 Date 对象
console.log(d instanceof Date); // true
```

除了这些内置的构造函数，我们也可以自定义构造函数来初始化一个新对象。

> 注意，构造函数也是函数，不存在定义构造函数的特殊语法。任何函数，只要通过 `new` 操作符来调用，那它就可以作为构造函数；如果不通过 `new` 操作符来调用，那它跟普通函数是一样的。



### 二、为什么是 new？

为什么是 `new` 呢？这得从 `JavaScript` 的设计说起。

在 `Javascript` 里，所有的数据类型都是对象，这一点和 `Java` 非常相似。既然都是对象，那必须有一种机制，将所有对象联系起来，所以在设计时也设计了 **"继承"**。

但是，作者不打算引入"类"（`class`）的概念，因为一旦有了"类"，`Javascript` 就是一种完整的面向对象编程语言了，这有点太正式了，增加了初学者的入门难度，并且当时也只是希望 `JavaScript` 可以作为一个能够实现和网页互动的脚本语言。

在 `C++` 和 `Java` 语言中，都使用 `new` 命令，生成实例。

**`C++` 的写法：**

```c++
ClassName *object = new ClassName(param);
```

**`Java` 的写法：**

```java
Foo foo = new Foo();
```

所以，作者就把 `new` 命令引入了 `Javascript`，用来从原型对象生成一个实例对象。但是，`Javascript` 没有"类"，怎么来表示原型对象呢？

`C++` 和 `Java` 使用 `new` 命令时，都会调用"类"的构造函数（`constructor`）。于是，作者就做了一个简化的设计，在 `Javascript` 语言中，`new` 命令后面跟的不是类，而是构造函数。

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
}

const person1 = new Person('Deepspace', 23);
```

构造函数中的 `this` 关键字代表了新创建的实例对象，也就是 `person1`。



### 三、new 的缺点

用构造函数生成实例对象，有一个缺点，那就是无法共享属性和方法。

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.sayName = function () {
    console.log(this.age);
  };
}

const person1 = new Person('Deepspace', 23);
const person2 = new Person('chenxingxing', 24);

console.log(person1 === person2); // false
person1.name = 'JavaScript';
console.log(person1.name); // JavaScript
console.log(person2.name); // chenxingxing

console.log(person1.sayName === person2.sayName); // false
```

比如上面的例子，`person1` 和 `person2` 是两个独立的实例对象，修改其中一个实例对象的属性，另一个不受干扰。

并且，因为创建的实例对象都是独立的，所以每个方法都要被创建一次。在上面的例子中，多个实例的 `sayName` 方法都是实现一样的效果，但是却存储了很多次（两个对象实例的 `sayName` 方法是不同的，因为存放的地址不同）。

所以，基于这个原因，作者为构造函数设置一个 `prototype` 属性。



### 四、prototype

当创建函数时，`JavaScript` 会为这个函数自动添加 `prototype` 属性。这个属性是一个指针，指向**另外一个对象**，这个对象是**调用构造函数而创建的实例的原型，我们称之为原型对象。**

有了 `prototype` 之后，所有实例对象需要共享的属性和方法，都放在这个对象里面；那些不需要共享的属性和方法，就放在构造函数里面。实例对象一旦创建，将自动引用原型对象的属性和方法。

```javascript
function Person(name) {
  this.name = name;
}

Person.prototype.age = 18;
Person.prototype.sayHello = function () {
  console.log('hello');
};

const person1 = new Person('Deepspace');
const person2 = new Person('chenxingxing');

console.log(person1.name); // Deepspace
console.log(person2.name); // chenxingxing

console.log(person1.age); // 18
console.log(person2.age); // 18

person1.sayHello(); // hello
person2.sayHello(); // hello

console.log(person1.sayHello === person2.sayHello); // true
```

将 `sayHello()` 方法和 `age` 属性直接添加到了 `Person` 的 `prototype` 属性中，这些属性和方法将由所有实例共享。也就是说 `person1` 和 `person2` 访问的都是同一组属性和同一个 `sayName()` 函数（内存地址一样）。

下面用一张图表示构造函数和实例原型之间的关系：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/prototype1.png" alt="构造函数和实例原型的关系图" style="zoom:88%;" />

重复一遍前面开头的描述，加深理解：

> 当创建函数时，`JavaScript` 会为这个函数自动添加 `prototype` 属性。这个属性是一个指针，指向**另外一个对象**，这个对象是**调用构造函数而创建的实例的原型，我们称之为原型对象。**

图中的 `Person.prototype` 就是实例的原型 —— 原型对象。



### 五、`__proto__`

那实例与实例原型直接是怎么联系的呢？

调用构造函数创建一个新实例后，该实例的内部将包含一个指针（内部属性），指向构造函数的原型对象。这个指针被称为 `__proto__` 。

> 注意：这个连接存在于实例与构造函数的原型对象之间，而不是存在于实例与构造函数之间。

所以，我们可以把上面的图更新成下面这样：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/prototype2.png" alt="实例与实例原型的关系图" style="zoom:88%;" />

问题来了，既然实例对象（`person`）和构造函数（`Person`）都可以指向原型（`Person.prototype`），那原型（`Person.prototype`）是否有属性指向构造函数（`Person`）或者实例（`person`）呢？

**原型指向实例**

从原型指向实例的属性是没有的，因为一个构造函数可以生成多个实例，多个实例是共享一个原型的。

**原型指向构造函数**

但是原型指向构造函数倒是有的：`constructor` 属性。



### 六、constructor

每个原型都有一个 `constructor` 属性指向关联的构造函数。

可以使用代码来验证：

```javascript
function Person() {
}

console.log(Person === Person.prototype.constructor); // true
```

所以，我们可以再更新一下上面的图：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/prototype3.png" alt="实例原型与构造函数的关系图" style="zoom:88%;" />

这个图可以用代码描述如下：

```javascript
function Person() {
}

function Dog() {
}

const person1 = new Person();
const person2 = new Person();

// 实例对象通过 __proto__ 指向原型
console.log(person1.__proto__ === Person.prototype); // true
console.log(person2.__proto__ === Person.prototype); // true

// 原型通过 constructor 指向构造函数
console.log(Person.prototype.constructor === Person); // true

// getPrototypeOf 方法可以获得实例对象的原型
console.log(Object.getPrototypeOf(person1) === Person.prototype); // true
console.log(Object.getPrototypeOf(person2) === Person.prototype); // true

// isPrototypeOf 方法可以判断一个原型是否是一个实例对象的原型
console.log(Person.prototype.isPrototypeOf(person1)); // true
console.log(Dog.prototype.isPrototypeOf(person1)); // false
```



### 七、实例上的属性与原型上的属性

每当代码读取某个对象的某个属性时，都会执行一次搜索，目标是具有给定名字的属性。

搜索首先从对象实例本身开始。如果在实例中找到了具有给定名字的属性，则返回该属性的值；如果没有找到， 则继续搜索指针（`__proto__`）指向的原型对象，在原型对象中查找具有给定名字的属性。如果在原型对象中找到了这个属性，则返回该属性的值。

```javascript
function Person() {
}

Person.prototype.name = 'Deepspace';

const person = new Person();

person.age = 23;
console.log(person.age); // 23
console.log(person.name); // Deepspace
```

如果我们在实例中添加了一个属性，并且**该属性是实例的原型上已经有的一个属性**，这个时候新添加的属性会屏蔽掉原型上的那个属性：

```javascript
function Person() {
}

Person.prototype.name = 'Deepspace';
Person.prototype.age = 29;
Person.prototype.job = 'Software Engineer';
Person.prototype.sayName = function () {
  console.log(this.name);
};

const person1 = new Person();
const person2 = new Person();

person1.name = 'chenxingxing';

console.log(person1.name); // chenxingxing -- 来自实例
console.log(person2.name); // Deepspace -- 来自原型
```

使用 `delete` 操作符则可以删除实例属性，让我们能够重新访问原型上的属性：

```javascript
function Person() {
}

Person.prototype.name = 'Deepspace';
Person.prototype.age = 29;
Person.prototype.job = 'Software Engineer';
Person.prototype.sayName = function () {
  console.log(this.name);
};

const person1 = new Person();
const person2 = new Person();

person1.name = 'chenxingxing';

console.log(person1.name); // chenxingxing -- 来自实例
console.log(person2.name); // Deepspace -- 来自原型

delete person1.name;
console.log(person1.name); // Deepspace -- 恢复访问原型属性
```

那么新问题又来了，如果在原型上没找到会怎么办呢？原型也是对象，那原型有原型吗？



### 八、原型的原型

原型也是一个对象，既然是对象，我们就可以用最原始的方式创建它：

```javascript
const obj = new Object();
obj.name = 'Deepspace';
console.log(obj.name); // Deepspace
```

所以，**原型对象**其实就是通过 `Object` 构造函数生成的，它也是一个**实例对象**。

再和前面的内容联系起来：实例对象的 `__proto__` 指向构造函数的 `prototype` （原型）。

我们可以把图更新成下面这样：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/prototype4.png" alt="原型的原型关系图" style="zoom:88%;" />

问题又来了，原型的原型还有原型吗？也就是 `Object.prototype` 的原型是什么呢？

```javascript
console.log(Object.prototype.__proto__ === null); // true
```

`null` 表示 "没有对象"，即该处不应该有值。所以， `Object.prototype` 没有原型了，查找属性时，查到 `Object.prototype` 就停止查找了。

我们可以再更新一下图：

![原型链示意图](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/prototype5.png)



### 九、原型链

上图中的蓝色的线，其实就是原型链。

我们知道，不管是 `JavaScript` 内置的对象还是自定义的对象，都可以使用 `toString()`、 `valueOf()` 等默认方法，就是因为 `Object.prototype` 这个原型上面有这些方法，自定义对象通过原型链继承过去使用的。

```javascript
const obj = new Object();
obj.name = 'Deepspace';

console.log(obj.valueOf());
```

