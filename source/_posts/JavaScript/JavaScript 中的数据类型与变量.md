---
title: JavaScript 中的数据类型与变量
author: Deepspace
tags:
  - 数据类型
categories: JavaScript
date: 2018-12-07
urlname: javascript-data-types-and-variables
---


<!-- ## JavaScript 中的数据类型与变量 -->

### 一、动态类型

`JavaScript` 是一种**弱类型**或者说**动态**语言。这意味着我们不用提前声明变量的类型（松散类型），在程序运行过程中，类型会被自动确定。也就是说我们可以使用同一个变量保存不同类型的数据，每个变量仅仅是一个用于保存值得占位符而已。



### 二、变量

**定义变量**

定义变量时要使用 `var` 操作符（`var` 是一个关键字），后跟变量名（即一个标识符）:

```javascript
var username;
```

> `ES6` 中新增了 `let` 和 `const` 关键字来代替 `var`，这里我们先不做过多的讨论。

这行代码定义了一个名为 `username` 的变量，该变量可以用来保存任何值。这里有一点需要注意：像这样未经过初始化的变量，会保存一个特殊的值 —— `undefined`。

<!-- more -->

**初始化变量**

我们也可以初始化变量，在定义变量的同时可以设置变量的值：

```javascript
var username = 'Deepspace';
```

> 初始化变量并不会把它标记为字符串类型，初始化的过程就是给变量赋一个值。



**修改变量**

因此，我们可以在修改变量值的同时修改值得类型：

```javascript
var username = 'Deepspace';
username = 1;
```

有一点需要注意，用 `var` 操作符定义的变量将成为该变量的作用域中的局部变量。也就是说，如果在函数中使用 `var` 定义一个变量，那么这个变量在函数退出后就会被销毁。看个例子：

```javascript
function main() {
  var username = 'Deepspace';
  console.log(username);
}

main();
console.log(username); // ReferenceError: username is not defined
```

在这个例子里，变量 `username` 是在函数中使用 `var` 定义的。当函数被调用时，就会创建该变量并且为其赋值。而在此之后，这个变量又会立即被销毁，因此最后一行代码会报错。

但是，像下面这样省略 `var` 操作符，就会创建一个全局变量，并不会报错：

```javascript
function main() {
  username = 'Deepspace';
  console.log(username);
}

main();
console.log(username); // ReferenceError: username is not defined
```

省略了 `var` 操作符，username 因此而变成了全局变量。这样，只要调用过一次 main 函数，这个变量就有了定义，就可以在函数外部的任何地方被访问到。

> 注意：虽然省略 var 操作符可以定义全局变量，但是这个做法是被严格禁止的，因为在局部作用域中定义的全局变量非常难维护。在严格模式下，给未经声明的变量赋值会导致抛出 `ReferenceError` 的错误。



### 二、数据类型

最新的 `ECMAScript` 标准定义了 `8` 种数据类型:

- `7` 种原始类型:
  - [Undefined](https://developer.mozilla.org/en-US/docs/Glossary/Undefined)
  - [Null](https://developer.mozilla.org/en-US/docs/Glossary/Null)
  - [Boolean](https://developer.mozilla.org/en-US/docs/Glossary/Boolean)
  - [Number](https://developer.mozilla.org/en-US/docs/Glossary/Number)
  - [BigInt](https://developer.mozilla.org/en-US/docs/Glossary/BigInt)
  - [String](https://developer.mozilla.org/en-US/docs/Glossary/String)
  - [Symbol](https://developer.mozilla.org/en-US/docs/Glossary/Symbol) 
-  `1` 种复杂数据类型：[Object](https://developer.mozilla.org/en-US/docs/Glossary/Object)



#### Undefined

`Undefined` 类型只有一个值，即特殊值 `undefined`。在使用 `var` 声明变量但未对其初始化的时候，这个变量的值就是 `undefined` 。

```javascript
var username;

console.log(username === undefined); // true
```

**一般情况下，我们不会显式地把一个变量设置为 `undefined` 值的情况，字面值 `undefined` 的主要目的是用于比较。**

不过，包含 `undefined` 值的变量与尚未定义的变量还是不一样的：

```javascript
var username; // 这个变量定义后默认取得了 undefined 值

// 下面这个变量并没有定义
// var age;

console.log(username); // 'undefined'
console.log(age); // 报错：ReferenceError: age is not defined
```



#### Null

`Null` 类型也只有一个值，即特殊值 `null`。从逻辑的角度来看，`null` 值表示一个空对象指针，可以把 `null` 作为尚未创建的对象来理解。所以当使用 `typeof` 操作符检测 `null` 值时会返回 `object`。

```javascript
var username = null;
console.log(typeof username);
```

> 原理：不同的对象在底层都表示为二进制， 在 `JavaScript` 中二进制前三位都为 `0` 的话会被判断为 `object` 类型。`null` 的二进制表示是全 `0`， 自然前三位也是 `0`， 所以执行 `typeof` 时会返回 `object`。

**如果定义的变量准备在将来用于保存对象，那么最好讲变量初始化为 `null` 而不是其他值。这样，只要直接检查 `null` 值就可以知道相应的变量是否已经保存了一个对象的引用。**如：

```javascript
var userInfo = null;

userInfo = {
  name: 'Deepspace',
  id: 001
};

if (userInfo !== null) {
  console.log(userInfo);
}
```

`null` 与 `undefined` 的不同点：当检测 `null` 或 `undefined` 时，前者会执行类型转换。

```javascript
console.log(typeof null);        // "object"
console.log(typeof undefined);   // "undefined"
console.log(null === undefined); // false
console.log(null == undefined); // true
console.log(null === null); // true
console.log(null == null); // true
console.log(!null); //true
console.log(isNaN(1 + null)); // false
console.log(isNaN(1 + undefined)); // true
```



#### Boolean

`Boolean` 类型只有两个字面值：`true` 和 `false`。 

> `Boolean` 类型的字面值 `true` 和 `false` 是区分大小写的。也就是说，`True` 和 `False` （以及其他的混合大小写形式）都不是 `Boolean` 值，只是标识符。 

虽然 `Boolean` 类型的字面值只有两个，但 `ECMAScript` 中所有类型的值都有与这两个 `Boolean` 值等价的值。要将一个值转换为其对应的 `Boolean` 值，可以调用转型函数 `Boolean() `：

```javascript
var username = 'Deepspace'; // 'Deepspace'
var usernameAsBoolean = Boolean(username); // true
```

`JavaScript` 中，可以对任何数据类型的值调用 `Boolean()` 函数，而且总会返回一个 `Boolean` 值。至于返回的 这个值是 `true` 还是 `false`，取决于要转换值的数据类型及其实际值。 

| 数据类型  |      转换为 true 的值      | 转换为 false 的值 |
| :-------: | :------------------------: | :---------------: |
|  Boolean  |            true            |       false       |
|  String   |       任何非空字符串       |  ''（空字符串）   |
|  Number   | 任何非零数字值(包括无穷大) |     0 和 NaN      |
|  Object   |          任何对象          |       null        |
| Undefined |           不适用           |     undefined     |



#### Number

`JavaScript` 中只有一种数字类型：基于 `IEEE 754` 标准的双精度 `64` 位二进制格式的值（`-(2^53^ -1) 到 2^53^ -1`）。**它并没有为整数给出一种特定的类型**。除了能够表示浮点数外，还有一些带符号的值：`+Infinity`，`-Infinity` 和 `NaN` (非数值，`Not-a-Number`)。

```javascript
var intNum = 55;
var floatNum1 = 1.1;
```

**`NaN` :**

`NaN`，即非数值(`Not a Number`)是一个特殊的数值，这个数值用于表示一个本来要返回数值的操作数未返回数值的情况（这样就不会抛出错误了）。

例如，在其他编程语言中，任何数值除以 `0` 都会导致错误， 从而停止代码执行。但在 `ECMAScript` 中，`0` 除以 `0` 会返回 `NaN` （正数除以 `0` 返回 `Infinity`，负数除以 `0` 返回 `-Infinity`） ，因此不会影响其他代码的执行。

`NaN` 本身有两个特点：

- 任何涉及 `NaN` 的操作(例如 `NaN/10`)都会返回 `NaN`，这 个特点在多步计算中有可能导致问题；
- `NaN` 与任何值都不相等，包括 `NaN` 本身。

针对这两个特点，`ECMAScript` 定义了 `isNaN()` 函数，该函数可以传递一个参数，来确定这个参数是否 “不是数值（`NaN`）”。

`isNaN()` 在接收到一个值之后，会尝试将这个值转换为数值。某些不是数值的值会直接转换为数值，例如字符串 `"10"` 或 `Boolean` 值。而任何不能被转换为数值的值都会导致这个函数返回 `true` 。

```javascript
console.log(isNaN(NaN)); // true
console.log(isNaN(10)); // false(10 是一个数值) 
console.log(isNaN('10')); // false(可以被转换成数值 10) 
console.log(isNaN('blue')); // true(不能转换成数值)
console.log(isNaN(true)); // false(可以被转换成数值 1)
```



#### BigInt

`BigInt` 数据类型比 `Number` 数据类型支持的范围更大的整数值，用以安全地存储和操作大整数，甚至可以超过数字的安全整数限制。使用 `BigInt`，可以避免整数溢出的问题。

**`BigInt` 是通过在整数末尾附加 `n ` 或调用构造函数来创建的。**

```javascript
console.log(9007199254740993n);    // 9007199254740993n
console.log(9007199254740993);     // 9007199254740992
console.log(BigInt("9007199254740993"));    // 9007199254740993n
```



#### String

`String` 类型用于表示由零或多个 `16` 位 `Unicode` 字符组成的字符序列，即字符串。字符串可以由双引号（`"`）或单引号（`'`）表示。不过，以双引号开头的字符串也必须以双引号结尾，以单引号开头的字符串必须以单引号结尾。

**字符字面量**

`String` 数据类型包含一些特殊的字符字面量，也叫转义序列，用于表示非打印字符，或者具有其他用途的字符。

| 字面量 | 含义                                                         |
| ------ | ------------------------------------------------------------ |
| \n     | 换行                                                         |
| \t     | 制表                                                         |
| \b     | 空格                                                         |
| \r     | 回车                                                         |
| \f     | 进制                                                         |
| `\\`   | 斜杠                                                         |
| `\'`   | 单引号(')，在用单引号表示的字符串中使用。例如：`'He said, \'hey.\''` |
| `\"`   | 双引号(")，在用双引号表示的字符串中使用。例如：`"He said, \"hey.\""` |
| \xnn   | 以十六进制代码nn表示的一个字符(其中n为0~F)。例如，\x41表示"A" |
| \unnnn | 以十六进制代码nnnn表示的一个Unicode字符(其中n为0~F)。例如，\u03a3表示希腊字符Σ |

字符串是不可变的。也就是说，字符串一旦创建，它们的值就不能改变。要改变某个变量保存的字符串，首先要销毁原来的字符串，然后再用另一个包含新值的字符串来填充该变量， 例如：

```javascript
var lang = 'Java';
lang = lang + 'Script';
```



**转换为字符串**

要把一个值转换为一个字符串有两种方式：

- `toString()` 方法
  - `toString()` 可以输出以二进制、八进制、十六进制，乃至其他任意有效进制格式表示的字符串值。
- 转型函数 `String()`
  - 在不知道要转换的值是不是 `null` 或 `undefined` 的情况下，还可以使用转型函数 `String()`，这个 函数能够将任何类型的值转换为字符串。
    - 如果值有 `toString()` 方法，则调用该方法(没有参数)并返回相应的结果; 
    - 如果值是 `null`，则返回 `"null"`;
    - 如果值是 `undefined`，则返回 `"undefined"`。

```javascript
var num = 10;
console.log(num.toString()); // "10"
console.log(num.toString(2)); // "1010"
console.log(num.toString(8)); // "12"
console.log(num.toString(10)); // "10"
console.log(num.toString(16)); // "a"


var value1 = 10;
var value2 = true;
var value3 = null;
var value4;

console.log(String(value1)); // "10"
console.log(String(value2)); // "true"
console.log(String(value3)); // "null"
console.log(String(value4)); // "undefined"
```



#### Symbol

`Symbol`，表示独一无二的值。`Symbol` 值通过`Symbol`函数生成。这就是说，对象的属性名现在可以有两种类型:

- 一种是原来就有的字符串；

- 另一种就是新增的 `Symbol` 类型。

凡是属性名属于 `Symbol` 类型，就都是独一无二的，可以保证不会与其他属性名产生冲突。

> 注意，`Symbol` 函数前不能使用 `new` 命令，否则会报错。这是因为生成的 `Symbol` 是一个原始类型的值，不是对象。也就是说，由于 `Symbol` 值不是对象，所以不能添加属性。基本上，它是一种类似于字符串的数据类型。

`Symbol ` 函数可以接受一个字符串作为参数，表示对 `Symbol` 实例的描述，相同参数的 `Symbol` 函数的返回值是不相等的。参数的目的主要是为了在控制台显示，或者转为字符串时，比较容易区分：

```javascript
var s1 = Symbol('foo');
var s2 = Symbol('bar');
var s3 = Symbol();
var s4 = Symbol();

console.log(s1); // Symbol(foo)
console.log(s2); // Symbol(bar)
console.log(s3); // Symbol()
console.log(s4); // Symbol()
console.log(s1 == s2); // false
console.log(s3 === s4); // false

console.log(s1.toString()); // "Symbol(foo)"
console.log(s2.toString()); // "Symbol(bar)"
```

更多介绍详见：https://es6.ruanyifeng.com/#docs/symbol



#### Object

对象其实就是一组数据和功能的集合。对象可以通过执行 `new` 操作符后跟要创建的对象类型的名称来创建。

```javascript
var o = new Object();
```

在 `ECMAScript` 中，`Object` 类型是所有其它的实例的基础。换句话说， `Object` 类型所具有的任何属性和方法也同样存在于更具体的对象中。

`Object` 的每个实例都具有下列属性和方法：

- `constructor`：保存着用于创建当前对象的函数。对于前面的例子而言，构造函数（`constructor`）就是 `Object()`；
- `hasOwnProperty(propertyName)`：用于检查给定的属性在当前对象实例中（而不是在实例的原型中）是否存在。其中，作为参数的属性名（`propertyName`）必须以字符串形式指定，如：`如:o.hasOwnProperty("name")` ；
- `isPrototypeOf(object)`：用于检查传入的对象是否是传入对象的原型；
- `propertyIsEnumerable(propertyName)`：用于检查给定的属性是否能够使用 `for-in` 语句来枚举。与 `hasOwnProperty()` 方法一样，作为参数的属性名必须以字符串形式指定；

- `toLocaleString()`：返回对象的字符串表示，它会根据你机器的本地环境来返回字符串，和 `toString()` 返回的值在不同的本地环境下使用的符号可能变化，为了返回时间类型的值的话，使用 `toLocaleString()`；
- `toString()`：返回对象的字符串表示；
- `valueOf()`：返回对象的字符串、数值或布尔值表示。通常与 `toString()` 方法的返回值相同；

由于在 `ECMAScript` 中 `Object` 是所有对象的基础，因此所有对象都具有这些基本的属性和方法。



#### 区别

`Object` 为引用类型，其他原始类型为基本类型，其主要区别如下：

- 基本类型的值是**不可变的**，**不能添加属性和方法**；而引用类型的值是**可变**的，**可以添加属性和方法**；
- 基本类型的比较是**值**的比较，而引用类型的比较是**内存中地址**的比较；
- 基本类型的变量是存放在**栈区**的，而引用类型的值是**同时保存在栈内存和堆内存**中的对象。

> 关于 `JavaScript` 的内存管理，可以详见：http://togoblog.cn/javascript-memory-management



### 三、typeOf 操作符

鉴于 `ECMAScript` 是松散类型的，因此需要有一种手段来检测给定变量的数据类型 —— `typeof` 就是负责提供

这方面信息的操作符。

对一个值使用 `typeof` 操作符可能返回下列某个字符串:

- `"undefined"` —— 如果这个值未定义；

- `"boolean"` —— 如果这个值是布尔值；

- `"string"` —— 如果这个值是字符串；

- `"number"` —— 如果这个值是数值；

- `"object"` —— 如果这个值是对象或 `null`；

- `"function"` —— 如果这个值是函数。

```javascript
var username;
var message = "some string";
var oNull = null;
var obj = { name: 'Deepspace' };
var func = function () { return 'Deepspace'; };

console.log(typeof username); // "undefined"
console.log(typeof message); // "string"
console.log(typeof (message)); // "string"
console.log(typeof 95); // "number"
console.log(typeof oNull); // "object"
console.log(typeof obj); // "object"
console.log(typeof (5 > 1)); // "boolean"
console.log(typeof func); // "function"
```



### 四、声明、定义、初始化、赋值

- 声明
  - 告诉编译器 / 解析器有这个变量存在，这个行为是不分配内存空间的。在 `JavaScript` 中，声明一个变量的操作是：`var a;` 。
- 定义
  - 为变量分配内存空间。在 `C` 语言中，一般声明就包含了定义，比如 `int a;` ；但是在` JavaScript` 中，`var a;` 这种形式就只是声明了。
- 初始化
  - 在定义变量之后，系统为变量分配的空间内存储的值是不确定的，所以需要对这个空间进行初始化，以确保程序的安全性和确定性。
- 赋值
  - 赋值就是变量在分配空间之后的某个时间里，对变量的值进行的刷新操作（操作存储空间内的数据）。
