---
title: JavaScript 面向对象编程（三）—— ES6
author: Deepspace
tags:
  - JavaScript
categories: JavaScript
date: 2016-10-28
urlname: javascript-object-oriented-programming-3
---

<!-- ## JavaScript 面向对象编程（三）-- ES6 -->



### 一、类

在前面的几篇文章里，我们介绍了 `ES5` 的面向对象编程。我们知道：在 `ECMAScript6` 规范之前，**`JavaScript` 中没有类的概念，仅允许通过构造函数来模拟类，通过原型实现继承。** 

这种实现面向对象的方式不管是写法上还是在概念理解上，都不是那么的友好，和其他面向对象语言（如 `C++` 和 `Java`）差异很大，很容易让新学习这门语言的程序员感到困惑。

为了解决这些问题，`ES6` 提供了更接近传统语言的写法，引入了 `Class`（类）这个概念，作为对象的模板，通过 `class` 关键字可以定义类。



### 二、为何要面向对象编程？

`JavaScript` 在设计之初，并没有引入 `Class`（类），但是在 `ES6` 又引入了 `Class` 的概念，方便开发者面向对象对象编程，那为什么要面向对象编程呢？

面向过程其实最为实际的一种思考方式，因为我们总是一贯一步一步地解决问题。可以说面向过程是一种基础的方法，它考虑的是实际的实现。 所以面向过程编程其实是对新手来说是更加直观的。

但是面向对象编程因为对数据和方法进行了封装，因此类是有极强的可复用性的。所以在大型项目中面向对象几乎是必须的了。

面向对象编程跟最直观的面向过程的编程有很大的区别。任何编程都要考虑两个要素，一个是数据，一个是方法。面向对象先考虑的是数据，后考虑方法，而面向过程编程是相反的。

> 说点题外话：正因为 `JavaScript` 在设计之初，作者没有引入 `Class`，所以导致了在引入 `Class` 概念之前，使用 `JavaScript` 进行面向对象编程是如此的"非同寻常"；但是反过来讲，如果当初作者引入了  `Class`，让 `JavaScript` 直接成为一门完全的面向对象语言，反而会让这门本来只是想用来做一些网页交互的语言显得太过于正式，增加了初学者的入门难度，可能 `JavaScript` 也不会有现在的发展了。凡事有两面吧。



### 三、类的声明写法

#### 1、语法

先看看 `ES5` 中，我们常用的使用**构造函数和原型的组合模式**创建对象：

```javascript
// es5 创建一个对象
function Person(age, name) {
  this.age = age;
  this.name = name;
}
Person.prototype.toString = function () {
  return `姓名：${this.name}，年龄：${this.age}`;
};

// 创建一个小明的实例
const xiaoMing = new Person(23, '小明');
console.log(xiaoMing.toString()); // 名字：小明，年龄：23
```

在 `ES6` 中，我们可以这样做：

```javascript
// es6 创建一个类（对象）
class Person {
  constructor(age, name) {
    this.age = age;
    this.name = name;
  }
  toString() {
    return `姓名：${this.name}，年龄：${this.age}`;
  }
}

// 创建一个小明的实例
const xiaoMing = new Person(23, '小明');
console.log(xiaoMing.toString());
```

上面代码定义了一个“类”，可以看到里面有一个 `constructor` 方法，这就是构造方法，而 `this` 关键字则代表实例对象。也就是说，`ES5` 的构造函数 `Person`，对应 `ES6` 的 `Person` 类的构造方法 `constructor`。

每一个 `class` 中都有这个方法。如果不写，`JavaScript` 实际上默认会给创建一个，也就是说：

```javascript
class Person {
}

// 等同于
class Person {
  constructor() { }
}
```

`constructor` 方法默认返回实例对象（即 `this`）：

```javascript
class Foo {
  constructor() { }
}

console.log(new Foo() instanceof Foo); // true
```

我们也可以指定返回另外一个对象：

```javascript
class Foo {
  constructor() {
    return Array;
  }
}

console.log(new Foo() instanceof Foo); // false
```



#### 2、必须通过 new 调用

类必须使用 `new` 调用，否则会报错。这是它跟普通构造函数的一个主要区别，后者不用 `new` 也可以执行。

```javascript
class Person { }

const person = Person(); // TypeError: Class constructor Person cannot be invoked without 'new'
```



#### 3、严格模式

实际上，`ES6` 把整个语言升级到了严格模式。所以我们不需要使用 `use strict;` 指定运行模式。



#### 4、不存在变量提升

```javascript
const person = new Person(); // ReferenceError: Person is not defined

class Person { }
```



#### 5、this 的指向

类的方法内部如果含有 `this`，它默认指向类的实例。但是，必须非常小心，一旦单独使用该方法，会导致报错。

```javascript
class Person {
  constructor(name) {
    this.name = name;
  }

  sayName() {
    this.print(`Hello ${this.name}`);
  }

  print(text) {
    console.log(text);
  }
}

const person = new Person('Deepspace');
person.sayName(); // Hello Deepspace

const { sayName } = person;
sayName(); // TypeError: Cannot read property 'print' of undefined
```

一个比较简单的解决方法是，在构造方法中绑定 `this`：

```javascript
class Person {
  constructor(name) {
    this.name = name;
    this.sayName = this.sayName.bind(this);
  }

  sayName() {
    this.print(`Hello ${this.name}`);
  }

  print(text) {
    console.log(text);
  }
}

const person = new Person('Deepspace');
person.sayName(); // Hello Deepspace

const { sayName } = person;
sayName(); // Hello Deepspace
```

另一种解决方法是使用箭头函数：

```javascript
class Person {
  constructor(name) {
    this.name = name;
  }

  sayName = () => {
    this.print(`Hello ${this.name}`);
  }

  print(text) {
    console.log(text);
  }
}

const person = new Person('Deepspace');
person.sayName();

const { sayName } = person;
sayName(); // Hello Deepspace
```

> 上面的代码请在 `Chrome` 中运行，因为 `ES6` 官方提案目前没有这种写法，但在实际应用中 这种写法很常见，我们一般都会配置对应的 `babel plugin` 。

**箭头函数内部的 `this` 总是指向定义时所在的对象。**上面代码中，箭头函数位于构造函数内部，它的定义生效的时候，是在构造函数执行的时候。这时，箭头函数所在的运行环境，就是实例对象了，所以 `this` 会总是指向实例对象。





### 四、类的实例

生成类的实例的写法，与 `ES5` 完全一样，使用 `new` 命令。前面说过，如果忘记加上 `new`，像函数那样调用 `Class`，将会报错。

#### 1、类和实例上的属性和方法

与 `ES5` 一样，实例的属性除非显式定义在其本身（即定义在 `this` 对象上），否则都是定义在原型上（即定义在 `class` 上）。

> 使用 `hasOwnProperty()` 方法可以检测一个属性是存在于实例中，还是存在于原型中。**给定属性存在于对象实例中时，会返回 `true`，存在于原型中时，返回 `false`：**

```javascript
class Person {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  toString() {
    console.log(`(${this.x}, ${this.y})`);
  }
}

const person = new Person(2, 3);

person.toString(); // (2, 3)

console.log(person.hasOwnProperty('x')); // true
console.log(person.hasOwnProperty('y')); // true
console.log(person.hasOwnProperty('toString')); // false
console.log(person.__proto__.hasOwnProperty('toString')); // true
```

`x` 和 `y` 都是实例对象 `person` 自身的属性（因为定义在 `this` 变量上），所以 `hasOwnProperty` 方法返回 `true`，而 `toString` 是原型对象的属性（因为定义在 `Person` 类上），所以 `hasOwnProperty` 方法返回`false`。

如果我们在实例中添加了一个属性，并且**该属性是类上已经有的一个属性**，这个时候新添加的属性会屏蔽掉类上的那个属性：

```javascript
class Person {
  sayName() {
    console.log('Deepspace');
  }
}

const person1 = new Person();
const person2 = new Person();

person1.sayName = function () {
  console.log('chenxingxing');
};

person1.sayName(); // chenxingxing
person2.sayName(); // Deepspace

delete person1.sayName;
person1.sayName(); // Deepspace
```



#### 2、实例共享原型对象

与 `ES5` 一样，类的所有实例共享一个原型对象。

```javascript
class Person { }

const person1 = new Person();
const person2 = new Person();

console.log(person1.__proto__ === person2.__proto__); // true
```

这也意味着，可以通过实例的 `__proto__` 属性为类添加方法：

```javascript
class Person { }

const person1 = new Person();
const person2 = new Person();

person1.__proto__.sayHello = function () {
  console.log('Hello');
};

person1.sayHello(); // Hello
person2.sayHello(); // Hello
```

由于实例共享原型，所以 `person2` 也是可以访问到 `sayHello` 方法的。



#### 3、实例属性的新写法

实例属性除了定义在 `constructor()` 方法里面的 `this` 上面，也可以定义在类的最顶层。

```javascript
class Person {
  constructor(name) {
    this.name = name;
  }

  sayName() {
    console.log(this.name);
  }
}

const person = new Person('Deepspace');
person.sayName(); // Deepspace
```







### 五、仅仅是语法糖

虽然 `ES6` 中增加了类的概念，但它仅仅只是一个语法糖。为什么这么说呢？

#### 1、类型依旧是 function

我们看下面的代码：

```javascript
class Person { }

console.log(typeof Person); // function
```

使用 `typeof` 操作符查看 `Person` 的类型，发现它是 `function` 类型，变相的说明 `JavaScript` 中是没有 `Class` 类型的，只是通过 "化妆" 的形式，让其变得和其他面向对象语言的写法相似而已。

`ES6` 的类，完全可以看作构造函数的另一种写法，类本身就指向构造函数。

使用的时候，也是直接对类使用 `new` 命令，跟构造函数的用法完全一致。

```javascript
class Person {
  sayName() {
    console.log('Deepspace');
  }
}

const person = new Person();
person.sayName(); // Deepspace
```



#### 2、prototype 属性依旧存在

构造函数的 `prototype` 属性，在 ES6 的"类"上也继续存在。事实上，类的所有方法都定义在类的 `prototype` 属性上面：

```javascript
class Person {
  constructor() {
    // ...
  }

  toString() {
    // ...
  }

  toValue() {
    // ...
  }
}

// 等同于

Person.prototype = {
  constructor() { },
  toString() { },
  toValue() { },
};
```

在类的实例上面调用方法，其实就是调用原型上的方法：

```javascript
class Person { }
let person = new Person();

console.log(person.constructor === Person.prototype.constructor); // true
```

`person` 是 `Person` 类的实例，它的 `constructor` 方法就是 `Person` 类原型的 `constructor` 方法。

由于类的方法都定义在 `prototype` 对象上面，所以类的新方法可以添加在 `prototype` 对象上面。使用 `Object.assign` 方法可以一次向类添加多个方法：

```javascript
class Person {
  constructor() {
    // ...
  }
}

Object.assign(Person.prototype, {
  toString() { },
  toValue() { }
});
```

`prototype` 对象的 `constructor` 属性，直接指向“类”的本身（这与 `ES5` 的行为是一致的）：

```javascript
class Person { }

console.log(Person === Person.prototype.constructor); // true
```



#### 3、不可枚举的类中的方法

但是 `ES6` 里面，类也是有不一样的地方的：**类的内部所有定义的方法，都是不可枚举的（`non-enumerable`）。**

```javascript
class Person {
  constructor(x, y) {
    // ...
  }

  toString() {
    // ...
  }
}

console.log(Object.keys(Person.prototype)); // []
console.log(Object.getOwnPropertyNames(Person.prototype)); // [ 'constructor', 'toString' ]
```

但是在 `ES5` 中，原型上的属性是可以枚举的：

```javascript
const Person = function (x, y) {
  // ...
};

Person.prototype.toString = function () {
  // ...
};

console.log(Object.keys(Person.prototype)); // [ 'toString' ]
console.log(Object.getOwnPropertyNames(Person.prototype)); // [ 'constructor', 'toString' ]
```



### 六、静态属性/静态方法

类相当于实例的原型，所有在类中定义的方法，都会被实例继承。

如果在一个方法前，加上 `static` 关键字，就表示该方法**不会被实例继承，而是直接通过类来调用**，这就称为“静态方法”。

```javascript
class Person {
  static classMethod() {
    console.log('hello');
  }
}

Person.classMethod(); // 'hello'

const person = new Person();
person.classMethod(); // TypeError: person.classMethod is not a function
```

#### 1、静态方法中的 this

因此，如果静态方法包含 `this` 关键字，这个 `this` 指的是类，而不是实例：

```javascript
class Foo {
  static bar() {
    this.baz();
  }
  static baz() {
    console.log('hello');
  }
  baz() {
    console.log('world');
  }
}

Foo.bar(); // hello
```

因为 `this` 指向了类，而不是实例，所以 `bar` 方法内只能访问到类中的静态方法，这里的 `this.baz();` 相当于 `Foo.baz();` 。从上面的例子中也可以看出**静态方法可以与非静态方法重名。**



#### 2、子类可以继承父类的静态方法

父类的静态方法，可以被子类继承。

```javascript
class Foo {
  static classMethod() {
    console.log('hello');
  }
}

class Bar extends Foo {
}

Bar.classMethod(); // 'hello'
```

静态方法也是可以从 `super` 对象上调用的。

```javascript
class Foo {
  static classMethod() {
    return 'hello';
  }
}

class Bar extends Foo {
  static classMethod() {
    return `${super.classMethod()}, too`;
  }
}

console.log(Bar.classMethod()); // 'hello, too'
```



#### 3、静态属性

静态属性指的是 `Class` 本身的属性，即 `Class.propName`，而不是定义在实例对象（`this`）上的属性。

`ES6` 中， `static` 只能用在方法，`es6` 目前只支持静态方法不支持静态属性。但是下面的写法是可以支持的：

```javascript
class Point {
  constructor() {
    this.x = 0;
  }
}

Point.y = 2;
const p = new Point();

console.log(p.x); // 0
console.log(p.y); // undefined ,类属性而不是而不是实例的属性，因此实例调用打印是 undefined
```

只不过写起来没那么好看。现在有一个[提案](https://github.com/tc39/proposal-class-fields)提供了类的静态属性：在实例属性的前面，加上 `static` 关键字：

```javascript
// 老写法
class Foo {
  // ...
}
Foo.prop = 1;

// 新写法
class Foo {
  static prop = 1;
}
```

新写法是显式声明，而不是赋值处理，语义更好。



### 七、私有属性/私有方法

**私有方法和私有属性指的是只能在类的内部访问的方法和属性，外部不能访问。**这是一个非常常见需求，有利于代码的封装。但比较可惜的是 `ES6` 不提供，只能通过变通方法模拟实现。

有一个比较鸡肋的方式（自己骗自己）是在方法前面加下划线，在命名上加以区分（因为有其它语言的私有方法是这样写的），表示这是一个只限于内部使用的私有方法。

```javascript
class Point {
  constructor() {
    this.x = 0;
  }
  // 自己骗自己这是私有方法，就看大家遵不遵守了
  _fun() {
    console.log('pravite');
  }
}

const point = new Point();
point._fun(); // pravite
```

在类的外部，还是可以调用到这个方法。

还有另外一种可以满足功能的方式是：将私有方法放在类的外边（因为类内部的所有方法都是对外可见的），利用 `call` 指向，但是最终只导出类，而不导出方法，这样就无法在类的外部调用到这个方法了。

```javascript
// 私有方法 不导出别人也用不了
function praviteFun() { }

// 只把class 导出
export default class Point {
  constructor() {
    this.x = 0
  }
  // 私有方法
  fun() {
    praviteFun.call(this)
  }
}
```





### 八、总结

通过上面的讲述，`ES6` 中的 "类" 并不是那么地完美，依旧有很多地方需要完善。但是这不影响我们去用类去组织我们的代码，让代码的复用性变得更好、更易维护。