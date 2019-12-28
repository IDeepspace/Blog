---
title: JavaScript 面向对象编程（一）—— 创建对象
author: Deepspace
tags:
  - 面向对象编程
categories: JavaScript
date: 2018-07-03
urlname: javascript-object-oriented-programming-1
---

<!-- ## JavaScript 面向对象编程（一）---- 创建对象 -->

### 一、万物皆对象

`JavaScript` 的所有数据（非基本类型数据）都可以看成对象，所以我们常说 `JavaScript` 中万物皆对象（虽然并不完全正确）。

在 `JavaScript` 中，对象是一个泛化的概念，任何值都可以转换为对象，以对象的方式进行使用。如数字对象、布尔值对象、字符串对象、函数对象、数组对象等等，它们都继承 `Object` 类型对象。同时，`JavaScript` 也允许自定义对象。

**面向对象（`Object-Oriented，OO`）的语言有一个标志，那就是它们都有类的概念。通过类可以创建任意多个具有相同属性和方法的对象。**但 `JavaScript` 的面向对象编程和大多数其他语言（如 `Java`）都不太一样。在 `ECMAScript6` 规范之前，**`JavaScript` 中没有类的概念，仅允许通过构造函数来模拟类，通过原型实现继承。**

本篇文章将分别介绍基于 `ES5` 和 `ES6` 的 `JavaScript` 面向对象编程。

<!-- more -->

### 二、创建对象

在 `JavaScript` 中，有很多种创建对象的方式，我们先看下面两种：

- 对象字面量
-  `Object` 构造函数

下面做一个简单介绍。

#### 1、对象字面量

使用对象字面量的方式可以快速创建对象，也是最高效、最简便的方法。

```javascript
const o = {
  a: 1,
  func: function () {
    return 1;
  },
  obj: {
    b: 2
  }
};
```

#### 2、Object 构造函数

使用 `new` 操作符后跟 `Object` 构造函数，创建一个 `Object` 的实例，然后再为它添加属性和方法。早期的开发人员经常使用这种模式来创建对象。

```javascript
const person = new Object();

person.name = 'Deepspace';
person.age = 23;
person.job = 'Software Engineer';
person.sayName = function () {
  console.log(this.name);
};
```



### 三、工厂模式

#### 1、封装对象

虽然 `Object` 构造函数或对象字面量都可以用来创建对象，但这些方式有个缺点：

**如果要创建很多个相似对象，会产生大量的重复代码**，如：

```javascript
const personOne = new Object();

personOne.name = 'Deepspace';
personOne.age = 24;
personOne.job = 'Software Engineer';
personOne.sayName = function () {
  console.log(this.name);
};

const personTwo = new Object();
personTwo.name = 'chenxingxing';
personTwo.age = 23;
personTwo.job = 'Teacher';
personTwo.sayName = function () {
  console.log(this.name);
};

// ....
```

为解决这个问题，一个叫作 **工厂模式** 的创建对象的方式出现了。

```javascript
function createPerson(name, age, job) {
  const o = new Object();
  o.name = name;
  o.age = age;
  o.job = job;
  o.sayName = function () {
    console.log(this.name);
  };
  return o;
}

const person1 = createPerson('Deepspace', 24, 'Software Engineer');
const person2 = createPerson('chenxingxing', 23, 'Teacher');

console.log(person1); 
// { name: 'Deepspace', age: 24, job: 'Software Engineer', sayName: [Function] }
console.log(person2); 
// { name: 'chenxingxing', age: 23, job: 'Teacher', sayName: [Function] }
```

函数 `createPerson()` 返回一个对象，函数接受的参数用来构建对象。调用这个函数时，会返回一个包含三个属性、一个方法的对象。这种创建对象的方式就叫作**工厂模式** —— **使用统一的方法（函数）来描述对象创建的细节。**

也就是说把这个对象封装起来，每次创建类似的对象时，都使用这个工厂函数来创建。它抽象了创建一个对象的过程。



#### 2、缺点

**工厂模式虽然解决了创建多个相似对象的问题**，但也有一些缺点：

> 对象上都有一个 `constructor` 属性，该属性可以用来标识对象类型（在下面会讲到）。

- 对象无法识别，所有实例都指向一个原型；无法通过 `constructor` 识别对象，因为都是来自 `Object` ；
- 只有开发者可以知道这个类型，通过函数名来识别；
- 每个对象都是通过工厂创建的全新的对象。比如：每次通过 `createPerson` 创建对象的时候，所有的 `sayName` 方法都是一样的，但是却存储了多次，浪费资源。

```javascript
function createPerson(name, age, job) {
  const o = new Object();
  o.name = name;
  o.age = age;
  o.job = job;
  o.sayName = function () {
    console.log(this.name);
  };
  return o;
}

const person1 = createPerson('Deepspace', 24, 'Software Engineer');
const person2 = createPerson('chenxingxing', 23, 'Teacher');

console.log(person1 === person2); // false
console.log(person1.sayName === person2.sayName); // false
console.log(person1.constructor); // [Function: Object]
console.log(person2.constructor); // [Function: Object]
```

`person1` 和 `person2` 之间没有内在联系。



### 四、构造函数模式

**构造函数是用来创建特定的类型的对象的。**比如 `JavaScript` 原生提供的 `Object`、`Array` 等，都是构造函数模式创建的原生构造函数，在运行时会自动出现在执行环境中。

我们也可以创建自定义的构造函数，从而定义自定义对象类型的属性和方法。

我们现在使用构造函数模式将前面的例子重写：

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

console.log(person1); // Person { name: 'Deepspace', age: 23, sayName: [Function] }
console.log(person2); // Person { name: 'chenxingxing', age: 24, sayName: [Function] }
person1.sayName(); // 23
person2.sayName(); // 24
```

分析下上面的代码：

- 有一个名为 `Person` 的函数（首字母大写，这只是代码风格上的变化，为了更像 `OO`）；
- 函数里没有明显的创建对象的过程（使用 `new Object()` 的过程）；
- 直接将参数赋值给了 `this`（因为没有创建明显的对象，就需要用 `this` 进行赋值）；
- 没有 `return` ；
- 执行 `new` 操作符来调用函数，这个时候将会创建一个新的对象，并且将函数的 `this` 指向所创建的新对象；



#### 1、constructor

**什么是实例？**

由构造函数创建的对象称为这个构造函数的实例。

 在实例上会存在一个 `constructor` 属性，这个属性指向创造它的构造函数（证明自己从哪里来）。**也就是说 `constructor` 属性返回创建实例对象的构造函数的引用。** 

所以，我们可以通过 `constructor` 属性来识别对象的类别：

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
}

function Cat(name, age) {
  this.name = name;
  this.age = age;
}

const person1 = new Person('Deepspace', 23);
const person2 = new Person('chenxingxing', 24);

console.log(person1.constructor === Person); // true
console.log(person2.constructor === Person); // true
console.log(person2.constructor === Cat); // false
```

其实，**所有对象(用 `Object.create (null)` 创建的对象除外)都具有 `constructor` 属性。**

在没有显式使用构造函数（如对象和数组）的情况下创建的对象，也具有 `constructor` 属性，它会指向该对象的基本对象构造函数类型，如：

```javascript
let o = {};
console.log(o.constructor === Object); // true

let a = new Object();
a.constructor === Object; // true

let b = [];
console.log(b.constructor === Array); // true

let c = new Array();
console.log(c.constructor === Array); // true

let d = new Number(3);
console.log(d.constructor === Number); // true
```



#### 2、instanceof

检测对象类型，我们也可以使用 `instanceof` 操作符：

```javascript
console.log(person1 instanceof Object);  // true
console.log(person1 instanceof Person);  // true
console.log(person2 instanceof Object);  // true
console.log(person2 instanceof Person);  // true
```

创建的对象既是 `Person` 的实例，同时也是 `Object` 的实例（因为所有对象均继承自 `Object` ，这个我们待会讨论）。

**构造函数模式**最大的优点就是可以通过 `contructor` 或者 `instanceof` 可以识别对象实例的类别（即它的构造函数）解决了工厂模式不能识别对象类型的问题。



#### 3、将构造函数当作函数来使用

构造函数也是函数，不存在定义构造函数的特殊语法。任何函数，只要通过 `new` 操作符来调用，那它就可以作为构造函数；如果不通过 `new` 操作符来调用，那它跟普通函数是一样的。

当在全局作用域中调用一个函数时，`this` 总是指向 `Global` 对象（在浏览器中就是 `window` 对象）。因此，在调用完函数之后，可以通过 `window` 对象来调用 `sayName()` 方法。

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.sayName = function () {
    console.log(this.age);
  };
}

const person1 = Person('Deepspace', 23);

window.name; // Deepspace
window.sayName(); // 23
```



#### 4、缺点

通过构造函数模式创建对象，每次创建实例时，每个方法都要被创建一次。比如上面的例子中， 多个实例的 `sayName` 方法都是实现一样的效果，但是却存储了很多次（两个对象实例的 `sayName` 方法是不同的，因为存放的地址不同）。

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

console.log(person1.sayName === person2.sayName); // false
```

为了解决这个问题，我们把函数定义转移到构造函数外部：

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.sayName = sayName;
}

function sayName() {
  console.log(this.name);
}

const person1 = new Person('Deepspace', 23);
const person2 = new Person('chenxingxing', 24);

console.log(person1.sayName === person2.sayName); // true
```

可是新问题又来了：

- 在全局作用域中定义的函数实际上只能被某个对象调用，这让全局作用域有点名不副实；
- 如果对象需要定义很多方法，那么就要定义很多个全局函数。



### 五、原型模式

#### 1、prototype

每个函数都有一个 `prototype` 属性（只有函数有）：

```javascript
function Person() {
}

Person.prototype.name = 'Deepspace';

const person1 = new Person();
const person2 = new Person();

console.log(person1.name); // Deepspace
console.log(person2.name); // Deepspace
```

当创建函数时，`JavaScript` 会为这个函数自动添加 `prototype(原型)` 属性。这个属性是一个指针，指向另外一个对象，这个对象是**调用构造函数而创建的实例的原型，我们称之为原型对象。**这里一定要在脑海里面记住，`prototype` 指向的是原型，而不是构造函数，就是上面这个例子中的 `person1` 和 `person2` 的原型。

原型对象的所有属性和方法，都可以被构造函数的实例使用（继承）。

这就意味着，我们可以把那些不变的属性和方法，直接定义在 `prototype` 上。

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

person1.sayName(); // Deepspace
person2.sayName(); // Deepspace

console.log(person1.sayName === person2.sayName); // true
```

将 `sayName()` 方法和所有属性直接添加到了 `Person` 的 `prototype` 属性中，这些属性和方法是由所有实例共享。也就是说 `person1` 和 `person2` 访问的都是同一组属性和同一个 `sayName()` 函数（内存地址一样）。



#### 2、实例的属性和方法

如果我们在实例中添加了一个属性，并且**该属性是实例原型已有的一个属性**，这个时候新添加的属性会屏蔽掉原型中的那个属性：

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



#### 3、prototype 的验证方法

为了配合 `prototype` 属性，`Javascript` 中定义了一些辅助方法，帮助我们使用它。

使用 `hasOwnProperty()` 方法可以检测一个属性是存在于实例中，还是存在于原型中。**给定属性存在于对象实例中时，会返回 `true`，存在于原型中时，返回 `false`：**

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

console.log(person1.hasOwnProperty('name')); // true
console.log(peson2.hasOwnProperty('name')); // false

delete person1.name;
console.log(person1.hasOwnProperty('name')); // false 恢复访问原型属性
```



#### 3、缺点

由于原型模式中，所有的属性和方法都是共享的，因为**不能传递初始化参数，所有实例默认情况下都将取得相同的属性值。**这会在某些情况下带来一些不便。

原型模式的这种共享对于函数（引用类型）来说非常合适，对于那些属性值是**基本数据类型的属性**来说，也说得过去。但是对于那些**属性值是引用类型的属性**来说，就会出现问题了：

```javascript
function Person() {
}

Person.prototype.name = 'Deepspace';
Person.prototype.age = 29;
Person.prototype.job = 'Software Engineer';
Person.prototype.friends = ['xiaoming'];

const person1 = new Person();
const person2 = new Person();

console.log(person1.friends); // [ 'xiaoming' ]
console.log(person2.friends); // [ 'xiaoming' ]

person1.friends.push('daming');

console.log(person1.friends); // [ 'xiaoming', 'daming' ]
console.log(person2.friends); // [ 'xiaoming', 'daming' ]
```

因为 `person1` 和 `person2` 的 `friends` 属性指向的是同一块存储区域。

> 你可以在这里查看 JavaScript 中的内存管理机制：https://togoblog.cn/javascript-memory-management/

所以，如果我们需要实例拥有自己的属性时，单纯的原型模式显然是不合适的。



#### 4、优化

在上面的代码里，通过 `prototype` 添加属性和方式时，代码的**封装性很差**，我们可以**重写原型**来优化：

```javascript
function Person() {
}

Person.prototype = {
  name: 'Deepspace',
  age: 23,
  sayName: function () {
    console.log(this.name);
  }
};

const person1 = new Person();

console.log(person1.name); // Deepspace
console.log(person1.age); // 23
```

既然重写了原型，那么实例上会存在一个 `constructor` 属性自然而然就改变了：

```javascript
function Person() {
}

Person.prototype = {
  name: 'Deepspace',
  age: 23,
  sayName: function () {
    console.log(this.name);
  }
};

const person1 = new Person();

console.log(person1.name); // Deepspace
console.log(person1.age); // 23
console.log(person1.constructor); // 这里打印的是 object,它的 constructor 不指向 Person 对象了
console.log(person1.constructor === Person); // false
```

对于这个问题，我们可以手动指定 `constructor` 的指向：

```javascript
function Person() {
}

Person.prototype = {
  constructor: Person, // <---
  name: 'Deepspace',
  age: 23,
  sayName: function () {
    console.log(this.name);
  }
};

const person1 = new Person();

console.log(person1.name); // Deepspace
console.log(person1.age); // 23
console.log(person1.constructor); // Person
console.log(person1.constructor === Person); // true
```

但是，原型模式该有的缺点还是存在，上面只是对封装性做了优化而已。



#### 5、原型的动态性

在上面的优化中，我们重写了整个原型对象，但这也会带来一些问题，看个例子：

```javascript
function Person() {
}

const friend = new Person();

Person.prototype = {
  constructor: Person,
  name: 'Nicholas',
  age: 29,
  job: 'Software Engineer', sayName: function () {
    console.log(this.name);
  }
};

console.log(friend.name); // undefined
friend.sayName(); // TypeError: friend.sayName is not a function
```

为什么会这样呢？

需要知道，**`JavaScript` 创建一个对象时是先建立原型关系，而后执行构造函数。**

前面我们介绍 `prototype` 的时候提到过，`prototype` 指向的是原型，而不是构造函数。而把原型修改为另外一个对象就等于切断了构造函数与最初原型之间的联系。因为 `person1` 指向的原型中不包含 `name` 和 `sayName`，所以会报错。如下图所示：

<img src="/Users/cxin/Library/Application Support/typora-user-images/image-20191228193303928.png" alt="image-20191228193303928" style="zoom: 67%;" />

重写原型对象切断了现有原型与任何之前已经存在的对象实例之间的联系，实例引用的仍然是最初的原型。那怎么解决这个问题呢？很简单，把调用构造函数的代码放在往 `prototype` 上添加属性和方法的后面就可以了：

```javascript
function Person() {
}

Person.prototype = {
  constructor: Person,
  name: 'Nicholas',
  age: 29,
  job: 'Software Engineer', sayName: function () {
    console.log(this.name);
  }
};

const friend = new Person();

console.log(friend.name); // Nicholas
friend.sayName(); // Nicholas
```

把 `new` 关键字的顺序从重写原型构建之前调整在重写原型构建之后，就没这个问题了。



### 六、构造函数和原型的组合模式

一句话概括这种模式，就是：该共享的共享，不该共享的不共享。

#### 1、组合模式的优点

**用构造函数定义对象的所有非函数属性，用原型方式定义方法和共享的属性。**

```javascript
function Person(name, age) {
  this.name = name;
  this.age = age;
  this.friends = ['xiaoming', 'daming'];
}

Person.prototype.job = 'Software Engineer';

Person.prototype.sayName = function () {
  console.log(this.name);
};


const person1 = new Person('xiaobai', 29);
const person2 = new Person('dabai', 27);

person1.friends.push('chenxingxing');

console.log(person1.friends); // [ 'xiaoming', 'daming', 'chenxingxing' ]
console.log(person2.friends); // [ 'xiaoming', 'daming' ] 
console.log(person1.friends === person2.friends); // false
console.log(person1.sayName === person2.sayName); // true
```

这种组合方式解决了前面的三个问题：

- 解决了原型模式对于引用类型属性的缺点；
- 解决了原型模式没有办法传递参数的缺点；
- 解决了构造函数模式不能共享方法的缺点。

**这样，每个实例都会有自己的一份实例属性的拷贝，但同时又共享着对方法的引用，最大限度地节省了内存。**



#### 2、封装性差的缺点

当然，缺点也是有的。我们可以发现上面的代码封装性很差，**构造函数和原型方式是分开的**。



### 七、动态原型模式

#### 1、在构造函数中初始化原型

```javascript
function Person(name, age, job) {
  //属性
  this.name = name;
  this.age = age;
  this.job = job;
  //方法
  if (typeof this.sayName !== 'function') {
    Person.prototype.sayName = function () {
      console.log(this.name);
    };
  }
}

const person1 = new Person('Deepspace', 29, 'Software Engineer');
person1.sayName(); // Deepspace
```

`if` 语句检查的可以是初始化之后应该存在的任何属性或方法 —— 不必用一大堆 `if` 语句检查每个属性和每个方法，只要检查其中一个即可。

对于采用这种模式创建的对象，还可以使 用 `instanceof` 操作符确定它的类型：

```javascript
console.log(person1 instanceof Object);  // true
```



#### 2、缺点

**不能用在构造函数中初始化原型的时候，用对象字面量的方式来重写原型。**看下面的代码：

```javascript
function Person(name, age, job) {
  this.name = name;
  if (typeof this.sayName !== 'function') {
    Person.prototype = {
      constructor: Person,
      sayName: function () {
        console.log(this.name);
      }
    };
  }
}

const person1 = new Person('Deepspace');
const person2 = new Person('chenxingxing');

person1.sayName(); // TypeError: person1.sayName is not a function
// 注释掉上面的代码，下面这行代码是可以运行的
person2.sayName(); // chenxingxing
```

发现 `person1.sayName()` 报了一个不是函数的错误，如果把 `person1.sayName()` 注释掉，`person2.sayName()` 是可以正常输出 `chenxingxing` 的。为什么会这样呢？依旧是因为**原型的动态性**的关系。

需要知道，**`JavaScript` 创建一个对象时是先建立原型关系，而后执行构造函数。**

构造函数的 `prototype` 属性本来是指向了实例的原型，执行 `const person1 = new Person('Deepspace');` 的时候，`person1` 首先会指向最开始的原型，使用字面量方式直接覆盖原型，只是将一个新的值赋值给 `Person.prototype`，并不会更改原型的值，`person1` 依然是指向了以前的原型，之前的原型是没有 `getName` 方法的，所以 `person1.sayName();` 就报错了！

后来执行 `const person2 = new Person('chenxingxing');` 的时候，再修改 `Person.prototype`，只会使得以后 `new` 的对象指向这个新的字面量值，已经 `new` 的不会再发生改变，所以 `person2.sayName();` 不会报错。

可以简化成下面的例子来理解：

```javascript
let obj = { name: 'Deepspace' };
const c = obj;

obj = { name: 'chenxingxing' };

console.log(c); // { name: 'Deepspace' }
console.log(obj); // { name: 'chenxingxing' }
```

如果非要用用字面量方式写代码，可以像下面这样：

```javascript
function Person(name, age, job) {
  this.name = name;
  if (typeof this.sayName !== 'function') {
    Person.prototype = {
      constructor: Person,
      sayName: function () {
        console.log(this.name);
      }
    };
    return new Person(name);
  }
}

const person1 = new Person('Deepspace');
const person2 = new Person('chenxingxing');

person1.sayName(); // Deepspace
person2.sayName(); // chenxingxing
```



### 八、寄生构造函数模式

```javascript
function Person(name, age, job) {
  const o = new Object();
  o.name = name;
  o.age = age;
  o.job = job;
  o.sayName = function () {
    console.log(this.name);
  };
  return o;
}

const person1 = new Person('Deepspace', 24, 'Software Engineer');

console.log(person1);
// { name: 'Deepspace', age: 24, job: 'Software Engineer', sayName: [Function] }

console.log(person1 instanceof Person); // false
console.log(person1 instanceof Object); // true
```

除了使用 `new` 操作符并把使用的包装函数叫做构造函数之外，这个模式跟工厂模式其实是一模一样的。创建的实例使用 `instanceof` 也无法指向构造函数！

这种方式可以在一些特殊情况下使用。比如我们想创建一个具有额外方法的特殊数组，但是又不想直接修改原生的 `Array` 构造函数，我们可以这样写：

```javascript
function SpecialArray() {
  const values = new Array();

  for (let i = 0, len = arguments.length; i < len; i++) {
    values.push(arguments[i]);
  }

  values.toPipedString = function () {
    return this.join('|');
  };
  return values;
}

const colors = new SpecialArray('red', 'blue', 'green');
const colors2 = SpecialArray('red2', 'blue2', 'green2');


console.log(colors); // [ 'red', 'blue', 'green', toPipedString: [Function] ]
console.log(colors.toPipedString()); // red|blue|green

console.log(colors2); // [ 'red2', 'blue2', 'green2', toPipedString: [Function] ]
console.log(colors2.toPipedString()); // red2|blue2|green2
```

虽然把 `SpecialArray` 当成函数也一样能用，但是作者可能是希望能像使用普通 `Array` 一样使用 `SpecialArray`，让代码变得更加优雅。所以，在可以使用其他模式的情况下，不要使用这种模式。



### 九、稳妥构造函数模式

```javascript
function person(name) {
  const o = new Object();
  o.sayName = function () {
    console.log(name);
  };
  return o;
}

const person1 = person('Deepspace');

person1.sayName(); // Deepspace

person1.name = 'chenxingxing';

person1.sayName(); // Deepspace

console.log(person1.name); // chenxingxing
```

如上面的代码示例中，这样创建的对象叫作稳妥对象。所谓稳妥对象，指的是没有公共属性，而且其方法也不引用 `this` 的对象。

与寄生构造函数模式有两点不同：

1. 新创建的实例方法不引用 `this`
2. 不使用 `new` 操作符调用构造函数

稳妥构造函数模式也跟工厂模式一样，无法识别对象所属类型。它非常适合在某些安全执行环境下使用。