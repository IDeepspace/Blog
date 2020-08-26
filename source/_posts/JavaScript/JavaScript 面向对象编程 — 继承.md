---
title: JavaScript 面向对象编程（二）—— 继承
author: Deepspace
tags:
  - 面向对象编程
  - 继承
categories: JavaScript
date: 2018-07-03
urlname: javascript-object-oriented-programming-2
---

<!-- ## JavaScript 面向对象编程（二）— 继承 -->

> 阅读本文之前，你可以先阅读下面这两篇文章：
>
> - [《`JavaScript` 中的原型和原型链》](https://togoblog.cn/javascript-prototypes-and-prototype-chains/)
> - [《`JavaScript` 面向对象编程（一）— 创建对象》](https://togoblog.cn/javascript-object-oriented-programming-1/)

 `JavaScript` 将原型链作为实现继承的主要方法。其基本思想就是利用原型让一个引用类型继承另一个引用类型的属性和方法。



### 一、构造函数、原型和实例的关系

简单回顾一下构造函数、原型和实例的关系：

- 每个构造函数都有一个指针指向（`prototype`）原型对象，原型对象都包含一个指向构造函数的指针（`constructor`）；
- 实例都包含一个指向原型对象的内部指针（`__proto__`）。

如下图：

<img src="../ImageHosting/JavaScript/prototype3.png" alt="实例原型与构造函数的关系图" style="zoom:88%;" />

### 二、原型链

那么，假如我们让原型对象等于另一个类型的实例，结果会怎么样呢？显然，此时的原型对象将包含一个指向另一个原型的指针（`__proto__`）；相应地，另一个原型中也包含着一个指向另一个构造函数的指针（`constructor`）。假如另一个原型又是另一个类型的实例，那么上述关系依然成立，如此层层递进，就构成了实例与原型的链条。这就是所谓原型链的基本概念。

<img src="../ImageHosting/JavaScript/prototype5.png" alt="原型链示意图" style="zoom:80%;" />

图中蓝色的线条就是原型链。
<!-- more -->


### 三、实现原型链继承

理解了原型链，实现起来就比较简单了：

```javascript
// 超类型
function SuperType() {
  this.superValue = 'superValue';
}

SuperType.prototype.getSuperValue = function () {
  return this.superValue;
};
// 子类型
function SubType() {
}

// 继承了 SuperType
SubType.prototype = new SuperType();

const instance = new SubType();
console.log(instance.getSuperValue()); // 'superValue' --- 继承自 SuperType 的方法
```



#### 1、给子类型添加方法

```javascript
function SuperType() {
  this.superValue = 'superValue';
}

SuperType.prototype.getSuperValue = function () {
  return this.superValue;
};

function SubType() {
  this.subValue = 'subValue';
}

// 继承了 SuperType
SubType.prototype = new SuperType();

// 添加新方法
SubType.prototype.getSubValue = function () {
  return this.subValue;
};

const instance = new SubType();
console.log(instance.getSubValue()); // 'subValue' --- SubType 的方法
console.log(instance.getSuperValue()); // 'superValue' --- 继承自 SuperType 的方法
```



#### 2、重写超类型的方法

子类型有时候需要重写超类型中的某个方法，或者需要添加超类型中不存在的某个方法。

```javascript
function SuperType() {
  this.superValue = 'superValue';
}

SuperType.prototype.getSuperValue = function () {
  return this.superValue;
};

function SubType() {
  this.subValue = 'subValue';
}

// 继承了 SuperType
SubType.prototype = new SuperType();

// 添加新方法
SubType.prototype.getSubValue = function () {
  return this.subValue;
};

// 重写超类型中的方法 
SubType.prototype.getSuperValue = function () {
  return 'newValue';
};

const instance = new SubType();
console.log(instance.getSubValue()); // 'subValue' --- SubType 的方法
console.log(instance.getSuperValue()); // 'newValue' --- 重写了 SuperType 的方法
```

**这里要特别注意，给原型添加方法的代码一定要放在继承（替换原型）的语句之后。** 因为如果继承的语句在后面的话，会把前面添加方法的代码覆盖掉。



#### 3、不能使用对象字面量创建原型方法

通过原型链实现继承时，不能使用对象字面量创建原型方法。因为这样做就会重写原型链。

```javascript
function SuperType() {
  this.superValue = 'superValue';
}

SuperType.prototype.getSuperValue = function () {
  return this.superValue;
};

function SubType() {
  this.subValue = 'subValue';
}

// 继承了 SuperType
SubType.prototype = new SuperType();

// 使用对象字面量的形式为原型添加新方法，会导致上一行代码无效
SubType.prototype = {  // <---
  getSubValue: function () {
    return this.subValue;
  },
  someOtherMethod: function () {
    return 'something';
  }
};

const instance = new SubType();
console.log(instance.getSubValue()); // 'subValue' --- SubType 的方法
console.log(instance.getSuperValue()); // TypeError: instance.getSuperValue is not a function
```

首先将 `SuperType` 的实例对象赋值给原型 `SubType.prototype`，紧接着又将原型替换成一个对象字面量，那现在的原型包含的就是一个新的的对象了，而非 `SuperType` 的实例，原型链已经被切断 —— `SubType` 和 `SuperType` 之间已经没有关系了。所以这个时候新的原型包含的对象上没有 `getSuperValue` 方法，就报错了。



### 四、原型链的问题

前面我们了解了什么是原型链、如何用原型链实现继承，但它也有一些问题。

#### 1、引用类型值的共享

包含引用类型值的原型属性会被所有实例共享，这种共享也会导致问题，比如下面的例子：

```javascript
function SuperType() {
  this.colors = ['red', 'blue', 'green'];
}

function SubType() {
}

//继承了 SuperType 
SubType.prototype = new SuperType();

const instance1 = new SubType();
instance1.colors.push('black');
console.log(instance1.colors); // [ 'red', 'blue', 'green', 'black' ]

const instance2 = new SubType();
console.log(instance2.colors); // [ 'red', 'blue', 'green', 'black' ]
```

当 `SubType` 通过原型链继承了 `SuperType` 之后，`SubType.prototype` （原型）就变成了 `SuperType` 的一个实例，因此它（原型）也拥有了一个它自己的 `colors` 属性 —— 就跟专门创建了一个 `SubType.prototype.colors` 属性一样。

这样，`SubType` 的所有实例都会共享这一个 `colors` 属性。而我们对 `instance1.colors` 的修改也会在 `instance2.colors` 反映出来，因为 `colors` 属性指向的是同一块存储区域。



#### 2、不能传递参数

由于原型模式中，所有的属性和方法都是共享的，因为**不能传递初始化参数，所有实例默认情况下都将取得相同的属性值，**会在某些情况下带来一些不便，这也是其中的一个缺点。



### 五、借助构造函数(经典继承)

#### 1、解决引用类型属性的共享问题

对于上面的问题，我们需要引入构造函数来解决。思想比较简单，即：**在子类型构造函数的内部调用超类型构造函数。**

如何在子类型的构造函数内部调用超类型的构造函数呢？

使用 `apply()` 或者 `call()` 方法可以办到：

```javascript
function SuperType() {
  this.colors = ['red', 'blue', 'green'];
}

function SubType() {
  // 继承了 SuperType
  SuperType.call(this);
}

const instance1 = new SubType();
instance1.colors.push('black');
console.log(instance1.colors); // [ 'red', 'blue', 'green', 'black' ]

const instance2 = new SubType();
console.log(instance2.colors); // [ 'red', 'blue', 'green' ]
```

通过使用 `call()` 方法（或 `apply()` 方法），当创建 `SubType` 实例时，就会调用了 `SuperType` 构造函数，执行 `SuperType()` 函数中定义的所有对象初始化代码。这样一来， `SubType` 的每个实例就都会具有自己的 `colors` 属性了，彼此互不干扰。



#### 2、传递参数

借助构造函数来实现继承，也有另一个好处，我们可以在子类型构造函数中向超类型构造函数传递参数。

```javascript
function SuperType(name) {
  this.name = name;
}
function SubType() {
  // 继承了 SuperType，同时还传递了参数 
  SuperType.call(this, 'Deepspace');
  // 实例属性
  this.age = 29;
}

const instance = new SubType();
console.log(instance.name); // Deepspace; 
console.log(instance.age); //29
```



#### 3、缺点

通过构造函数模式创建对象，每次创建实例对象时，**每个方法都要被创建一次。**

并且，方法都在构造函数中定义，因此函数复用就无从谈起了。

所以，我们也不会单独使用构造函数来实现继承。



### 六、组合继承

组合继承就是结合了原型链和构造函数来实现继承。

```javascript
function SuperType(name) {
  this.name = name;
  this.colors = ['red', 'blue', 'green'];
}

SuperType.prototype.sayName = function () {
  console.log(this.name);
};

function SubType(name, age) {
  // 继承属性 
  SuperType.call(this, name);
  this.age = age;
}

// 继承方法
SubType.prototype = new SuperType();
SubType.prototype.constructor = SubType;
SubType.prototype.sayAge = function () {
  console.log(this.age);
};

const instance1 = new SubType('Deepspace', 29);
instance1.colors.push('black');
console.log(instance1.colors); // [ 'red', 'blue', 'green', 'black' ]
instance1.sayName(); // Deepspace
instance1.sayAge(); // 29

const instance2 = new SubType('chenxingxing', 27);
console.log(instance2.colors); // [ 'red', 'blue', 'green' ]
instance2.sayName(); // chenxingxing
instance2.sayAge(); // 27
```

- `SuperType` 构造函数定义了两个属性：`name` 和 `colors`。`SuperType` 的原型定义了一个方法 `sayName()`。

- `SubType` 构造函数在调用 `SuperType` 构造函数时传入了 `name` 参数，紧接着又定义了它自己的属性 `age`。

- 然后，将 `SuperType` 的实例赋值给 `SubType` 的原型，然后又在该新原型上定义了方法 `sayAge()`。这样一来，就可以让两个不同的 `SubType` 实例既分别拥有自己属性 —— 包 括 `colors` 属性，又可以使用相同的方法了。

组合继承融合了原型链继承和构造函数的优点，并且，我们可以使用 `instanceof` 和 `isPrototypeOf()` 识别基于组合继承创建的对象。

```javascript
console.log(instance1 instanceof SubType); // true
console.log(instance1 instanceof SuperType); // true
console.log(instance2 instanceof SubType); // true
console.log(instance1 instanceof SuperType); // true

console.log(SuperType.prototype.isPrototypeOf(instance1)); // true
console.log(SubType.prototype.isPrototypeOf(instance1)); // true
console.log(SuperType.prototype.isPrototypeOf(instance2)); // true
console.log(SubType.prototype.isPrototypeOf(instance2)); // true
```

组合继承是 `JavaScript` 中最常用的继承模式。



### 七、原型式继承

这种继承方式的思想是：

- 创建一个函数（不是构造函数），函数接受一个参数，该参数是个对象；
- 在函数内部，先创建了一个临时性的构造函数，然后传递的参数作为这个构造函数的原型；
- 最后函数返回这个临时类型的一个新实例。

> 其实就是 `ES5` 中 `Object.create` 的模拟实现，将传入的对象作为创建的对象的原型。

```javascript
function createObj(o) {
  function F() { }
  F.prototype = o;
  return new F();
}

const person = {
  name: 'Deepspace',
  friends: ['chenxingxing']
};

const anotherPerson = createObj(person);
console.log(anotherPerson.name); // Deepspace
console.log(anotherPerson.friends); // [ 'chenxingxing' ]

anotherPerson.name = 'Greg';
console.log(anotherPerson.name); // Greg

anotherPerson.friends.push('Bob');
console.log(person.friends); // [ 'chenxingxing', 'Bob' ]
console.log(anotherPerson.friends); // [ 'chenxingxing', 'Bob' ]
```

**但是依旧会有缺点，包含引用类型的属性值始终都会共享相应的值，这点跟原型链继承一样。**

```javascript
const yetAnotherPerson = createObj(person);

yetAnotherPerson.name = 'Linda';
console.log(yetAnotherPerson.name); // Linda
console.log(yetAnotherPerson.friends); // [ 'chenxingxing', 'Bob' ]

yetAnotherPerson.friends.push('Barbie');
console.log(person.friends); // [ 'chenxingxing', 'Bob', 'Barbie' ]
console.log(anotherPerson.friends); // [ 'chenxingxing', 'Bob', 'Barbie' ]
console.log(yetAnotherPerson.friends); // [ 'chenxingxing', 'Bob', 'Barbie' ]
```

如果只想让一个对象与另一个对象保持类似的情况下，原型式继承是完全可以胜任的。



### 八、寄生式继承

寄生式继承（`parasitic`）的思路与寄生构造函数和工厂模式类似，即创建一个仅用于封装继承过程的函数，该 函数在内部以某种方式来增强对象，最后再返回对象。

```javascript
function createAnother(original) {
  const clone = Object.create(original); // 通过调用函数创建一个新对象
  clone.sayHi = function () {            // 以某种方式来增强这个对象
    console.log('hi');
  };
  return clone;                          // 返回这个对象
}

const person = {
  name: 'Deepspace',
  friends: ['xiaohong', 'xiaobai']
};

const anotherPerson = createAnother(person);

console.log(anotherPerson.name); // Deepspace
console.log(anotherPerson.friends); // [ 'xiaohong', 'xiaobai' ]
anotherPerson.sayHi(); // 'hi'

const yetAnotherPerson = createAnother(person);
console.log(yetAnotherPerson.sayHi === anotherPerson.sayHi); // false

anotherPerson.friends.push('xiaohuang');

console.log(person.friends); // [ 'xiaohong', 'xiaobai', 'xiaohuang' ]
console.log(anotherPerson.friends); // [ 'xiaohong', 'xiaobai', 'xiaohuang' ]
```

缺陷：包含引用类型的属性值始终都会共享相应的值，并且，创建时每个方法都会新建一遍。



### 九、寄生组合式继承

前面介绍组合继承的时候说过：组合继承是 `JavaScript` 中最常用的继承模式。为了方便阅读，这里再贴上组合继承的代码：

```javascript
function SuperType(name) {
  this.name = name;
  this.colors = ['red', 'blue', 'green'];
}

SuperType.prototype.sayName = function () {
  console.log(this.name);
};

function SubType(name, age) {
  SuperType.call(this, name); // 第二次调用SuperType()
  this.age = age;
}

SubType.prototype = new SuperType(); // 第一次调用SuperType()
SubType.prototype.constructor = SubType;
SubType.prototype.sayAge = function () {
  console.log(this.age);
};

const instance1 = new SubType('Deepspace', 29); // 调用SubType构造函数
```

但是组合继承也是有自己的缺点的：**会调用两次超类型构造函数。**

- 第一次是设置子类型实例的原型的时候
  - 在第一次调用 `SuperType` 构造函数时， `SubType.prototype` 会得到两个属性：`name` 和 `colors`；它们都是 `SuperType` 的实例属性，只不过现在位于 `SubType` 的原型中。
- 第二次在创建子类型实例的时候
  - 当调用 `SubType` 构造函数时，又会调用一次 `SuperType` 构造函数，这一次又在新对象上创建了实例属性 `name` 和 `colors`。于是，这两个属性就屏蔽了原型中的两个同名属性。

那么我们该如何避免第一次重复调用呢？

执行 `SubType.prototype = new SuperType();` 的目的只是为了**指定子类型的原型**，如果我们不调用 `SuperType` 构造函数，而是间接的让 `SubType.prototype` 可以访问到 `SuperType.prototype` 呢？

```javascript
function SuperType(name) {
  this.name = name;
  this.colors = ['red', 'blue', 'green'];
}

SuperType.prototype.sayName = function () {
  console.log(this.name);
};

function SubType(name, age) {
  SuperType.call(this, name);
  this.age = age;
}

// 添加下面三行代码
const F = function () { };
F.prototype = SuperType.prototype;
SubType.prototype = new F();

SubType.prototype.constructor = SubType;
SubType.prototype.sayAge = function () {
  console.log(this.age);
};

const instance1 = new SubType('Deepspace', 29);
instance1.colors.push('black');
console.log(instance1.colors); // [ 'red', 'blue', 'green', 'black' ]
instance1.sayName(); // Deepspace
instance1.sayAge(); // 29

const instance2 = new SubType('chenxingxing', 27);
console.log(instance2.colors); // [ 'red', 'blue', 'green' ]
instance2.sayName(); // chenxingxing
instance2.sayAge(); // 27
```

为什么不直接把 `SuperType.prototype` 赋值给 `SubType.prototype` 呢？因为这样会造成引用类型互相影响的问题，所以这里需要创建一个新对象来赋值。最后我们封装一下这个继承方法：

```javascript
function object(o) {
  function F() { }
  F.prototype = o;
  return new F();
}

function inheritPrototype(subType, superType) {
  const prototype = object(superType.prototype);
  prototype.constructor = subType;
  subType.prototype = prototype;
}

function SuperType(name) {
  this.name = name;
  this.colors = ['red', 'blue', 'green'];
}

SuperType.prototype.sayName = function () {
  console.log(this.name);
};

function SubType(name, age) {
  SuperType.call(this, name);
  this.age = age;
}

// 使用
inheritPrototype(SubType, SuperType); // 调用方法

SubType.prototype.constructor = SubType;
SubType.prototype.sayAge = function () {
  console.log(this.age);
};

const instance1 = new SubType('Deepspace', 29);
instance1.colors.push('black');
console.log(instance1.colors); // [ 'red', 'blue', 'green', 'black' ]
instance1.sayName(); // Deepspace
instance1.sayAge(); // 29

const instance2 = new SubType('chenxingxing', 27);
console.log(instance2.colors); // [ 'red', 'blue', 'green' ]
instance2.sayName(); // chenxingxing
instance2.sayAge(); // 27
```

这个例子的高效率体现在它只调用了一次 `SuperType` 构造函数，并且因此避免了在 `SubType.prototype` 上面创建不必要的、多余的属性；与此同时，原型链还能保持不变。

因此，还能够正常使用 `instanceof` 和 `isPrototypeOf()`。

开发人员普遍认为寄生组合式继承是引用类型最理想的继承方式。
