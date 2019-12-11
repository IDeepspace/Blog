---
title: JavaScript 中的函数与作用域
author: Deepspace
tags:
  - 函数与作用域
categories: JavaScript
date: 2018-11-03
urlname: javascript-function-context
---


<!-- ## JavaScript 中的函数与作用域 -->

### 一、声明提升

大部分编程语言都是先声明变量再使用，但在 `JavaScript` 中，有些不一样：

```javascript
console.log(username); // undefined
var username = 'JavaScript';
```

上面的代码会正常输出 `undefined` 而不是报错 `Uncaught ReferenceError: a is not defined`。就是因为声明提升（`declaration hoisting`）。

那为什么输出的是 `undefined` 而不是 `JavaScript` 呢？**因为 `JavaScript` 只有变量的声明会提升，初始化不会。**

再看段代码：

```javascript
a = 2;
var a;
console.log(a); // 2
```

同样是因为变量提升的原因，所以输出的是 `2` 而不是 `undefined` 。

`JavaScript` 引擎会在解释 `JavaScript` 代码之前首先对其进行编译。编译阶段中的一部分工作就是找到所有的声明，并用合适的作用域将它们关联起来。因此，包括变量和函数（我们后面会再次提到）在内的所有声明都会在任何代码被执行前首先被处理。

`JavaScript` 在读到 `var a = 2;` 时，会将其看成两个声明：`var a;` 和 `a = 2;` 。第一个定义声明是在编译阶段进行的；第二个赋值声明会被留在原地等待执行阶段。

为了避免这些问题，通常我们在每个作用域开始前声明这些变量，这也是正常的 `JavaScript` 解析步骤，易于我们理解。

<!-- more -->

### 二、什么是函数

在 `JavaScript` 中，引用类型的值（对象）是引用类型的一个实例。函数也是对象，每个函数都是 `Function` 类型的实例。因此函数名实际上也是一个指向函数对象的指针。

函数是完成某个特定功能的一组语句。如没有函数，完成任务可能需要五行、十行、甚至更多的代码。这时我们就可以把完成特定功能的代码块放到一个函数里，直接调用这个函数，就省重复输入大量代码的麻烦。



### 三、函数的定义与调用

#### 1、函数的定义

函数的定义有三种方式。

##### 函数声明（或者叫函数语句）

基本语法如下：

```javascript
function 函数名() {
  函数代码;
}
```

- `function` —— 定义函数的关键字；
- 函数名 —— 为函数取的名字，函数名使用动宾短语；
- 函数代码 —— 完成特定功能的代码。

例子：

```javascript
function sum(num1, num2) {
  return num1 + num2;
}
```



##### 函数表达式

使用函数表达式定义函数的方式几乎和函数声明的方式是一致的：

```javascript
var sum = function (num1, num2) {
  return num1 + num2;
};
```

`function` 关键字后面没有函数名。这是因为在使用函数表达式定义函数时，没有必要使用函数名 —— 通过变量 `sum` 即可以引用函数。另外，还要注意函数末尾有一个分号，就像声明其他变量时一样。



##### 使用 `Function` 构造函数

`Function` 构造函数可以接收任意数量的参数， 但最后一个参数始终都被看成是函数体，而前面的参数则枚举出了新函数的参数。如：

```javascript
var sum = new Function('num1', 'num2', 'return num1 + num2');
```

从技术角度讲，这是一个函数表达式。但是，不推荐使用这种方法定义函数，因为这种语法会导致解析两次代码：第一次是解析常规 `ECMAScript` 代码，第二次是解析传入构造函数中的字符串，这样会影响性能。

不过这种定义函数的方式对于理解 **“函数是对象，函数名是指针”** 的概念倒是非常直观的。



由于函数名仅仅是指向函数的指针，因此函数名与包含对象指针的其他变量没有什么不同。换句话说，一个函数可以有多个名字：

```javascript
function sum(num1, num2) {
  return num1 + num2;
}
console.log(sum(10, 10)); // 20

var anotherSum = sum;
console.log(anotherSum(10, 10)); // 20

sum = null;
console.log(anotherSum(10, 10)); // 20
console.log(sum(10, 10)); // TypeError: sum is not a function
```



##### 区别

函数声明与函数表达式的的写法看起来很像，但是解析器在执行环境中加载数据的时候，对待两者是不同的：

**解析器会率先读取函数声明，并使其在执行之前可用（可以访问）；至于函数表达式，则必须等到解析器执行到它所在的代码行，才会真正被解释执行。**

```javascript
// 正常运行
console.log(sum(10, 10));

function sum(num1, num2) {
  return num1 + num2;
}

// 报错
console.log(sum1(10, 10)); // TypeError: sum1 is not a function
var sum1 = function (num1, num2) {
  return num1 + num2;
};
```

解析器通过函数声明提升（`function declaration hoisting`）的过程，读取并将函数声明添加到执行环境中。对代码求值时，`JavaScript` 引擎在第一遍会声明函数并将它们放到源代码树的顶部。所以，即使声明函数的代码在调用代码后面，`JavaScript` 引擎也能把函数声明提升到顶部。

而，使用函数表达式的方式定义一个函数，也是在声明一个变量，变量有声明提升的特性。`sum1` 的声明在调用的后面，因此在调用 `sum1` 的时候，它的值是 `undefined` ，所以会报错。

**有条件的创建函数**

函数声明也可能出现在一个 `if` 语句里，但是，这种声明方式我们理解起来也是可以做到声明提升的，如下面的代码：

```javascript
foo(); // "b"

var a = true;

if (a) {
  function foo() { console.log("a"); }
}
else {
  function foo() { console.log("b"); }
}
```

但是不同的浏览器里可能有不同的效果：

```javascript
在Chrome里:
'foo' 变量名被提升，但是 typeof foo 为 undefined

在Firefox里:
'foo' 变量名被提升. 但是 typeof foo 为 undefined

在Edge里:
'foo' 变量名未被提升. 而且 typeof foo 为 undefined

在Safari里:
'foo' 变量名被提升. 而且 typeof foo 为 function
```

所以对于函数的声明提升，我们需要**谨慎使用**。



#### 2、函数的调用

函数定义好之后，是不会自动执行的。定义了函数仅仅是赋予函数一个名称并明确函数被调用时该做些什么。调用函数才会以给定的参数真正执行这些动作（这里暂不讨论立即执行函数）。

```javascript
function sum(num1, num2) {
  return num1 + num2;
}
console.log(sum(10, 10)); //20
```



### 四、函数与变量的优先级

**函数声明和变量声明都会被提升。** 

**那如果在多个重复声明的代码中，是函数会首先被提升，还是变量呢？结论是优先提升函数。**

还是从代码入手，看段代码：

```javascript
foo(); // 1

var foo;

function foo() {
  console.log(1);
}

foo = function () {
  console.log(2);
};
```

代码执行结果会输出 `1` 而不是 `2` 。这个代码片段会被 `JavaScript` 引擎理解成下面这样：

```javascript
function foo() {
  console.log(1);
}

foo(); // 1

foo = function () {
  console.log(2);
};
```

`var foo;` 这行语句虽然出现在 `function foo()` 的声明之前，但是由于**函数声明会被提升到普通变量之前**，所以相当于它是重复的声明，被忽略了。

注意：尽管重复的 `var` 声明会被忽略掉，但出现在后面的函数声明还是可以覆盖前面的：

```javascript
foo(); // 3

function foo() {
  console.log(1);
}

var foo = function () {
  console.log(2);
};

function foo() {
  console.log(3);
}
```



### 五、没有重载

重载：方法名字相同，而参数（参数的个数或者类型）不同，返回类型可以相同也可以不同。

`Java` 里是有重载的，而 `JavaScript` 中没有重载。这点很好理解：将函数名想象为指针，当把函数名指向一个新的函数（对象）的时候，则该函数名属于后定义的函数。如果没有其它的引用，这个时候先定义的函数会被垃圾回收机制回收掉。

```javascript
function addSomeNumber(num) {
  return num + 100;
}

function addSomeNumber(num) {
  return num + 200;
}

console.log(addSomeNumber(100)); //300
```



### 六、作用域

#### 1、什么是作用域

执行环境定义了变量或函数有权访问的其他数据，决定了它们各自的行为。每个执行环境都有一个与之关联的变量对象（`variable object`），环境中定义的所有变量和函数都保存在这个对象中。虽然我们编写的代码无法访问这个对象，但解析器在处理数据时会在后台使用它。

`JavaScript` 中的作用域分为全局作用域（`Global context`）和局部作用域（`Local Scope`），局部作用域又称为函数作用域（`Function context`）。



#### 2、作用域链

由很多个（`N`个）作用域按照相应的规则组成的链叫作**作用域链**。作用域链决定了函数作用域内标识符查找后返回的值。

**标识符解析是沿着作用域链一级一级地搜索标识符的过程。**搜索过程始终从作用域链的前端开始， 然后逐级地向后回溯，直至找到标识符为止(如果找不到标识符，通常会导致错误发生)。



#### 3、全局作用域

全局执行环境是最外围的一个执行环境。在 `Web` 浏览器中，全局执行环境被认为是 `window` 对象，因此所有全局变量和函数都是作为 `window` 对象的属性和方法创建的。

一般来说有以下三种情形拥有全局作用域：

- **最外层函数和在最外层函数外面定义的变量拥有全局作用域；**

```javascript
var globalVariable = 'haha';

function sum(num1, num2) {
  return num1 + num2;
}

var sum1 = function (num1, num2) {
  return num1 + num2;
};

console.log(window);
```

在浏览器窗口执行之后，可以看到 `window` 对象上绑定了全局变量和函数。

由于 `ES5` 中只有全局作用域和函数作用域，所以 `if` 代码块中的变量，依然属于全局变量：

```javascript
var a = 0;

if (a < 10) {
  a++;
  var b = a;
}

console.log(b);  // 1
```

- **所有末定义直接赋值的变量自动声明为拥有全局作用域；**

```javascript
function test() {
  variable = "未定义直接赋值的变量";
  var inVariable2 = "内层变量2";
  func = function () {
    return 1;
  };
}

test(); // 要先执行这个函数
console.log(variable); // 未定义直接赋值的变量
console.log(inVariable2);  // ReferenceError: inVariable2 is not defined
console.log(func); // [Function: func]
```

- **所有 `window` 对象的属性拥有全局作用域。**

  一般情况下，`window` 对象的内置属性都拥有全局作用域，如 `window.location`、`window.top` 等。

**全局执行环境直到应用程序退出，例如关闭网页或浏览器时才会被销毁。**

所以，全局作用域就有个弊端：如果我们写了很多行 `JavaScript` 代码，变量定义都没有用函数包起来，那么它们就全部都在全局作用域中。这样就会污染全局命名空间, 容易引起命名冲突。

如果看过 `jQuery` 源码的话，会发现所有的代码都会放在 `(function(){....})()` 中，因为放在里面的所有变量，都不会被暴露，不会污染到外面的环境，对其他的库或者 `JavaScript` 代码造成影响。这是函数作用域的一个体现。https://cdn.bootcss.com/jquery/3.4.1/jquery.js



#### 5、函数作用域

和全局作用域相反，局部作用域（函数作用域）一般只在固定的代码片段内（函数内部）可访问到。看下面的例子：

```javascript
function getUsername() {
  var username = "陈星星";
  function innerFunc() {
    console.log(username);
  }
  innerFunc();
}

getUsername();
console.log(username); // ReferenceError: username is not defined
```

**函数作用域是分层的，内层作用域可以访问外层作用域的变量，反之则不行。** 

```javascript
var color = 'blue';

function changeColor() {
  var anotherColor = 'red';

  function swapColor() {
    // 这里可以访问color, anotherColor, 和 tempColor
    var tempColor = anotherColor;
    anotherColor = color;
    color = tempColor;
  }

  // 这里可以访问 color 和 anotherColor，但是不能访问 tempColor
  // console.log(tempColor); // ReferenceError: tempColor is not defined
  swapColor();
}

changeColor();

// 这里只能访问color
console.log('Color is now ' + color);
```

上面代码的作用域链简单图示如下：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/javascript-function-declaration-hoisting.jpg" alt="javascript-function-declaration-hoisting" style="zoom:67%;" />



### 七、作用域链和代码优化

在作用域链上，标识符解析是沿着作用域链一级一级地搜索标识符。在运行期上下文的作用域链中，标识符所在的位置越深，读写速度就会越慢。而全局变量总是存在于作用域链的最末端，因此在标识符解析的时候，查找全局变量是最慢的。所以，在编写代码的时候应尽量少使用全局变量，尽可能使用局部变量。

如果一个跨作用域的对象被引用了一次以上，则先把它存储到局部变量里再使用。例如：

```javascript
function changeColor() {
  document.getElementById("btnChange").onclick = function () {
    document.getElementById("targetCanvas").style.backgroundColor = "red";
  };
}
```

这个函数引用了两次全局变量 `document`，查找该变量必须遍历整个作用域链，直到最后在全局对象中才能找到。我们可以像下面这样修改：

```javascript
function changeColor() {
  var doc = document;
  doc.getElementById("btnChange").onclick = function () {
    doc.getElementById("targetCanvas").style.backgroundColor = "red";
  };
}
```

这段代码比较简单，重写后不会显示出巨大的性能提升，但是如果程序中有大量的全局变量被从反复访问，那么重写后的代码性能会有显著改善。



### 八、闭包

#### 1、闭包的定义

闭包是一个特别抽象的概念，我们先从代码看起，之后再去理解它的概念。看一个最简单原始的闭包 `demo`：

```javascript
function A() {
  function B() {
    console.log("Hello Closure!");
  }
  return B;
}

var c = A();

c(); // Hello Closure!
```

我们简单分析一下它和普通函数有什么不同。上面代码翻译成自然语言如下：

1. 定义了一个普通函数 `A`；

2. 在 `A` 中定义了普通函数 `B`；

3. 在 `A` 中返回 `B`（确切地讲，在 `A` 中返回 `B` 的引用）；

4. 把 `A` 的返回结果赋值给变量 `c` （此时 `c` 指向 `B` 的引用）；

5. 执行 `c()` 。

总结成一句话就是：函数 `A` 的内部函数 `B` 被函数 `A` 外的一个变量 `c` 引用。

所以，闭包的定义就是：**当一个内部函数被其外部函数之外的变量引用时，就形成了一个闭包。**



#### 2、闭包的作用

我们知道，[`JavaScript` 的内存管理](https://togoblog.cn/javascript-memory-management/)里，堆区内存的垃圾机制是：`Javascript` 程序会对数组等引用数据（对象）的引用数量计数，一旦没有引用，就会被清除释放，否则这个一直会保存在内存中。

在上面例子中，`B` 定义在 `A` 中，因此 `B` 依赖于 `A` ，而外部变量 `c` 又引用了 `B`， 所以 `A` 间接的被 `c` 引用，也就是说，`A` 不会被回收，会一直保存在内存中。

我们可以把上面的例子改动一下，验证这个观点：

```javascript
function A() {
  var count = 0;
  function B() {
    count++;
    console.log(count);
  }
  return B;
}

var c = A();

c(); // 1
c(); // 2
c(); // 3
```

`count` 是 `A` 中的一个变量，它的值在 `B` 中被改变，执行 `c` 时（ `c` 指向 `B` 的引用），每执行一次，`count` 的值就在原来的基础上累加 `1` 。因此，`A` 中的 `count` 一直保存在内存中。

这个就是闭包的作用：**当需要一个模块中定义这样一个变量，并且希望这个变量一直保存在内存中但又不会污染全局的变量的时候，我们就可以用闭包来定义这个模块。**

下面我们看一个闭包的常见应用场景：

有一个组件，这个组件的功能是：可以初始化一个容器，可以给这个容器添加子容器，也可以移除一个容器。

```javascript
(function (document) {
  var viewport;
  var obj = {
    init: function (id) {
      viewport = document.querySelector("#" + id);
    },
    addChild: function (child) {
      viewport.appendChild(child);
    },
    removeChild: function (child) {
      viewport.removeChild(child);
    }
  };
  window.jView = obj;
})(document); // 这里用到了立即执行函数
```

便于理解，可以拆分成下面这样：

```javascript
var f = function (document) {
  var viewport;

  var obj = {
    init: function (id) {
      viewport = document.querySelector("#" + id);
    },
    addChild: function (child) {
      viewport.appendChild(child);
    },
    removeChild: function (child) {
      viewport.removeChild(child);
    }
  };

  window.jView = obj; // <---
};

f(document);
```

问题来了，函数 `f` 中并没有返回值啊，似乎不符合闭包的条件。注意代码中的这行代码：

```javascript
window.jView = obj;
```

`obj` 是在函数 `f` 中定义的一个对象，这个对象中定义了一系列方法。

执行 `window.jView = obj` 就是在 `window` 全局对象定义了一个变量 `jView`，并将这个变量指向 `obj` 对象，也就是说全局变量 `jView` 引用了 `obj` 。而 `obj` 对象中的函数又引用了 `f` 中的变量 `viewport` ，因此 `f` 中的 `viewport` 不会被回收，会一直保存到内存中，所以这种写法满足闭包的条件。 



### 九、块级作用域

`ES5` 中没有块级作用域，这部分内容请参考：https://togoblog.cn/es6-let-const/