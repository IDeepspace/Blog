---
title: JavaScript 模块化
author: Deepspace
tags:
  - Ajax
categories: JavaScript
date: 2019-06-29
urlname: javascript-module
---

## JavaScript 模块化

`JavaScript` 模块化的发展历史：无模块化 --> `CommonJS` 规范 --> `AMD` 规范 --> `CMD` 规范 --> `ES6` 模块化。

下面我们根据这个发展历史来讲解 `JavaScript` 模块化的内容。



### 一、无模块化

```javascript
<script src="jquery.js"></script>
<script src="jquery_scroller.js"></script>
<script src="main.js"></script>
<script src="other1.js"></script>
<script src="other2.js"></script>
<script src="other3.js"></script>
```

即简单的将所有的 `js` 文件统统放在一起。但是这些**文件的顺序不能出错**，比如 `jquery` 需要先引入，才能引入 `jquery` 插件。缺点很明显：

- 污染全局作用域
- 维护成本高
- 依赖关系不明显

<!-- more -->

### 二、原始写法

在一些模块化的规范出现之前，我们想要达到模块化的效果可能有这么三种：

#### 1、一个函数就是一个模块

```javascript
<script>
  function m1 () {
    // ...
  }
  function m2 () {
    // ...
  }
</script>
```

缺点：污染了全局变量，无法保证不会与其它模块发生冲突，而且模块成员之间看不出直接关系。



#### 2、一个对象就是一个模块

对象写法为了解决上面的缺点，可以把模块写成一个对象，所有的模块成员都放到这个对象里面。

```javascript
<script>
  var module1 = new Object({
    _sum: 0,
    foo1: function () {},
    foo2: function () {}
  })
</script>
```

缺点：会暴露所有模块成员，内部的状态可能被改写。例如，我们如果只是想暴露出两个方法而不暴露出 `_sum`，就做不到。

而此时，`_sum` 也可能被外部改写：

```
module1._sum = 2;
```



#### 3、立即执行函数为一个模块

```javascript
<script>
  var module1 = (function() {
    var _sum = 0;
    var foo1 = function () {};
    var foo2 = function () {};
    return {
      foo1: foo1,
      foo2: foo2
    }
  })();
</script>
```

利用立即执行函数内的作用域已经闭包来实现模块功能，导出我们想要导出的成员。

此时外部代码就不能读取到 `_sum` 了：

```javascript
console.log(module1._sum) // undefined
```



### 三、CommonJS 规范

该规范最初是用在服务器端的 `node.js` 中的，下面我们看看如何使用 `CommonJS` 规范来定义和引用模块。

#### 1、定义模块

定义模块有两种方式：

- `module.exports = {}`
- `exports.xxx = 'xxx'`

第一种定义方式：

```javascript
module.exports = {
	name: 'Alex',
	sex: 'boy'
}
```

第二种定义方式：

```javascript
exports.name = 'Alex';
exports.sex = 'boy'
```



#### 2、容易混淆的定义方式

如果在代码中试图 `exports = { name: 'Alex' }`，会发现在引入的地方根本获取不到 `name` 属性。

```javascript
// m1.js
exports = {
	name: 'Alex'
}
// test.js
const math = require('./m1.js')

console.log(m1); // {}
```

在控制台执行 `node test.js`，发现打印出来的 `m1` 是一个空的对象。

所以，在 `CommonJS` 中，整个模块的导出是靠 `module.exports` 的，如果你重新对整个 `exports` 对象赋值的话，它和 `module.exports` 就不是同一个对象了，因为它们指向的引用地址都不同：

```javascript
module.exports -> {} // 指向一个空的对象
exports -> { name: 'Alex' } // 指向的是另一个对象
```

所以对 `exports = {}` 做任何操作都影响不到 `module.exports`。

**下面再看几个正确和错误的示例：**

```javascript
// m1.js
// 1. 正确
module.exports = {
  name: 'Alex',
  sex: 'boy'
}

// 2. 正确
exports.name = 'Alex';
exports.sex = 'boy'

// 3. 正确
module.exports.name = 'lindaidai';
module.exports.sex = 'boy'

// 4. 无效
exports = {
  name: 'lindaidai',
  sex: 'boy'
}
```

可以看到

- `exports.name = xxx` 是 `module.exports.name = xxx` 的缩写。
- `exports = {}` 却不是 `module.exports = {}` 的缩写。



#### 2、引用模块

对于模块的引用使用全局方法 `require()` 就可以了。

> 注意：这个全局方法 `require()` 是 `node` 中的方法，它不是 `window`下面的，所以如果没做任何处理想直接在 `html` 里用肯定就是不行的了。

例如下面这样：

```html
<body>
  <script>
		var m1 = require('./m1.js')
		console.log(m1);
	</script>
</body>
```

打开页面控制台肯定就报错了：

```javascript
Uncaught ReferenceError: require is not defined
	at index.html:11
```

而如果是在另一个 `js` 文件中引用，并在终端执行是可以用的：

```javascript
var m1 = require('./m1.js')

console.log(m1);
```

所以，**`require()` 是 `Node.js` 中的一个全局方法**，并不是 `CommonJS` 独有的，`CommonJS` 只是众多规范中的其中一种。

**小结**

`CommonJS` 规范允许我们：

- 使用 `module.exports = {}` 或者 `exports.name = xxx` 导出模块
- 使用 `const m1 = require('./m1')` 引入模块



#### 3、CommonJS 规范的特点

- 所有代码都运行在模块作用域，不会污染全局作用域；
- 模块是同步加载的，即只有加载完成，才能执行后面的操作；
- 模块在首次执行后就会缓存，再次加载只返回缓存结果，如果想要再次执行，可清除缓存；
- `CommonJS` 输出是值的拷贝，即 **`require` 返回的值是被输出的值的拷贝**，模块内部的变化也不会影响这个值。

第一个特点就不用多说了，下面我们来看看剩下的这三个特点。



##### 3.1、同步加载

写个案例验证一下。

*m1.js*

```javascript
console.log('我是m1模块')
module.exports = {
  name: 'Alex',
  sex: 'boy'
}
```

*test.js*

```javascript
var m1 = require('./m1');
console.log('我是test模块');
```

可以看到，`test ` 模块依赖于 `m1`，并且是先下载的 `m1` 模块，所以如果我执行 `node test.js`，会有以下的执行结果：

```
我是m1模块
我是test模块
```

这也就验证了`CommonJS` 中，模块是同步加载的，即只有加载完成，才能执行后面的操作。



##### 3.2、模块首次执行后会缓存

*m1.js*:

```javascript
var name = 'Alex';
var sex = 'boy';

exports.name = name;
exports.sex = sex;
```

*test.js*:

```javascript
var m1 = require('./m1');
m1.sex = 'girl';
console.log(m1);

var m2 = require('./m1');
console.log(m2);
```

`test` 同样依赖于 `m1`，但是我们在其中导入两次 `m1`，第一次导入的时候修改了 `m1.sex` 的值，第二次的时候命名为 `m2`，但是结果 `m1` 和 `m2` 竟然是相等的：

```
{ name: 'Alex', sex: 'girl' }
{ name: 'Alex', sex: 'girl' }
```

也就是说**模块在首次执行后就会缓存，再次加载只返回缓存结果**。

这里可能会有**疑惑**：因为改变了 `m1.sex` 也可能是影响原本 `m1` 模块里的 `sex` 属性，这样的话第二次 `m2` 拿到的肯定就是被改变的值了。

`CommonJS` 的下面这个特点可以解答这个疑惑。



##### 3.3、CommonJS 输出是值的拷贝

`CommonJS` 输出是值的拷贝，也就是说**用 `require()` 引入了模块，在最新的模块中怎样去改变，也不会影响到已经 `require()` 的模块**。看下面的例子：

*m1.js*:

```javascript
var name = 'Alex';
var sex = 'boy';
var advantage = ['handsome']

setTimeout(function () {
  sex = 'girl';
  advantage.push('cute');
}, 500)

exports.name = name;
exports.sex = sex;
exports.advantage = advantage;
```

*test.js*:

```javascript
var m1 = require('./m1');
setTimeout(function () {
  console.log('read count after 1000ms in commonjs is', m1.sex)
  console.log('read count after 1000ms in commonjs is', m1.advantage)
}, 1000)
```

执行 `node test.js` 之后的执行结果是：

```javascript
read count after 1000ms in commonjs is boy
read count after 1000ms in commonjs is [ 'handsome', 'cute' ]
```

也就是说，在开始 `var m1 = require('./m1')` 的时候，`m1` 已经被引入进来了，但是过了 `500ms` 后改变了原本 `m1` 里的一些属性，`sex` 这种基本数据类型是不会被改变的，但是 `advantage` 这种引用类型共用的还是同一个内存地址，所以值发生了改变（**对于引用类型的数据，值的拷贝是内存地址**）。

如果这里你是这样写的话：

*m1.js*:

```javascript
var name = 'Alex';
var sex = 'boy';
var advantage = ['handsome']

setTimeout(function () {
  sex = 'girl';
  // advantage.push('cute');
  advantage = ['cute'];
}, 500)

exports.name = name;
exports.sex = sex;
exports.advantage = advantage;
```

现在的执行结果肯定就是：

```javascript
read count after 1000ms in commonjs is boy
read count after 1000ms in commonjs is [ 'handsome' ]
```

因为相当于对 `m1` 的 `advantage` 重新赋值了，地址发生了改变，这种情况下就不会影响到已经 `require()` 的模块。

**小结：**

1. 对于基本数据类型，属于复制。即会被模块缓存。同时，在另一个模块可以对该模块输出的变量重新赋值。
2. 对于引用类型，属于浅拷贝。由于两个模块引用的对象指向同一个内存空间，因此对该模块的值做修改时会影响另一个模块。



### 四、AMD 规范

#### 1、产生原因

我们知道，模块化这种概念不仅仅适用于服务器端，客户端同样也适用。

而 `CommonJS` 规范就不适合用在客户端（浏览器）环境了，比如上面的那个例子，也就是:

*test.js*

```javascript
const m1 = require('./m1.js')
console.log(m1);

// 与m1模块无关的一些代码
function other () {}
other();
```

由于 **`CommonJS` 同步加载**的特点，后面的内容要等待 `m1` 加载完才会执行，如果 `m1` 加载的很慢就造成了卡顿，这对于客户端来说肯定是不友好的。这里我们更希望的是 `other()` 的执行不需要等 `m1` 加载完才执行，也就是我们希望 `m1` 它是「异步加载」的，这就是 `AMD` 规范的特点。

**`require.js` 这个 `JavaScript` 库实现了 `AMD` 规范**，下面我们来使用它。



#### 2、定义模块

`AMD` 是 `Asynchronous Module Definition` 的缩写，也就是「**异步模块定义**」。

`AMD` 规范中使用 `define` 来定义一个模块。

*math.js*

```javascript
define(function () {
  var add = function (a, b) {
    return a + b;
  }
  return {
    add: add
  }
})
```

这里模块很简单，导出了一个加法函数。



#### 3、引用模块

在 `test.js` 中引入了 `math` 模块并调用`add()`方法：

**test.js**:

```javascript
var requirejs = require("requirejs"); //引入requirejs模块

requirejs(['math'],function(math) {
  console.log(math)
  console.log(math.add(1, 2));
})
```

在使用 `require.js` 的时候，我们必须要提前加载所有的依赖，然后才可以使用，而不是需要使用时再加载。



#### 4、依赖其它模块的 define

*m1.js*

```javascript
define(function () {
  console.log('我是m1, 我被加载了...');
  return {
    name: 'Alex',
    sex: 'boy',
  };
});
```

*math.js*

```javascript
define(['m1'], function (m1) {
  console.log('我是math, 我被加载了...');
  const add = function (a, b) {
    return a + b;
  };
  const print = function () {
    console.log(m1.name);
  };
  return {
    add,
    print,
  };
});
```

*test.js*

```javascript
const requirejs = require('requirejs'); // 引入requirejs模块

requirejs(['math'], function (math) {
  console.log('我是test, 我被加载了...');
  console.log(math.add(1, 2));
  math.print();
});
function other() {
  console.log('我是test模块内的, 但是我不依赖math');
}
other();
```

执行结果：

```bash
$ node test.js
我是test模块内的, 但是我不依赖math
我是m1, 我被加载了...
我是math, 我被加载了...
我是test, 我被加载了...
3
Alex
```



#### 5、特点

优点：适合在浏览器环境中异步加载模块、并行加载多个模块；

缺点：不能按需加载、开发成本大



### 五、CMD 规范

`AMD` 推崇依赖前置、提前执行，`CMD` （`Common Module Definition`）推崇依赖就近、延迟执行。

> `CMD` 是 `SeaJS` 在推广过程中对模块定义的规范化产出。

来看段代码，大概感受一下它是怎样用的：

```
define(function(require, exports, module) {
  var math = require('./math');
  math.print()
})
```

和 `AMD` 很像。`AMD` 和 `CMD` 最大的区别是**对依赖模块的执行时机处理不同**。

> 注意不是加载的时机或者方式不同，二者皆为异步加载模块。

还是前面的例子，同样是 `math` 模块中需要加载 `m1` 模块。

在 `AMD` 中我们会这样写：

*math.js*

```javascript
define(['m1'], function (m1) {
  console.log('我是math, 我被加载了...');
  const add = function (a, b) {
    return a + b;
  };
  const print = function () {
    console.log(m1.name);
  };
  return {
    add,
    print,
  };
});
```

但是对于 `CMD`，我们会这样写：

*math.js*

```javascript
define(function (require, exports, module) {
  console.log('我是math, 我被加载了...');
  const m1 = require('m1');
  const add = function (a, b) {
    return a + b;
  };
  const print = function () {
    console.log(m1.name);
  };
  module.exports = {
    add,
    print,
  };
});
```

假如此时 `m1.js` 中有一个语句是在 `m1` 模块被加载的时候打印出 `"我是m1, 我被加载了..."`。

执行结果区别：

- `AMD`，会先加载 `m1`，`console.log('我是m1, 我被加载了...');` 会先执行；
- `CMD`，`console.log('我是math, 我被加载了...')` 会先执行，因为它放在 `require('m1')` 前面。

现在可以很明显的看到区别了。

- `AMD` 依赖前置，`js` 很方便的就知道要加载的是哪个模块了，因为已经在 `define` 的 `dependencies` 参数中就定义好了，会立即加载它。

- `CMD` 是就近依赖，需要使用把模块变为字符串解析一遍才知道依赖了那些模块。



### 六、ES6 Modules规范

`ES6`标准出来后，`ES6 Modules` 规范算是成为了前端的主流吧，以 `import` 引入模块，`export` 导出模块的方式被越来越多的人使用。

> 但是由于 `ES6` 目前无法在浏览器中执行，所以，我们只能通过 `babel` 将不被支持的 `import` 编译为当前受到广泛支持的 `require`。 

#### 1、export 导出模块

`export` 有两种模块导出方式：

- 命名式导出
- 默认导出

**命名式导出**

来看几种正确和错误的写法吧：

```javascript
// 以下两种为错误
// 1.
export 1;
// 2.
const a = 1;
export a;

// 以下为正确
// 3.
const a = 1;
export { a };

// 4. 接口名与模块内部变量之间，建立了一一对应的关系
export const a = 1, b = 2;

// 5. 接口名与模块内部变量之间，建立了一一对应的关系
export const a = 1;
export const b = 2;

// 或者用 as 来命名
const a = 1;
export { a as outA };

const a = 1;
const b = 2;
export { a as outA, b as outB };
```



**默认导出**

默认导出会在 `export` 后面加上一个 `default`：

```javascript
// 1.
const a = 1;
export default a;

// 2.
const a = 1;
export default { a };

// 3.
export default function() {}; // 可以导出一个函数
export default class(){}; // 也可以出一个类
```



#### 2、import 导入模块

`import` 模块导入与 `export` 模块导出功能相对应，也存在两种模块导入方式：命名式导入和默认导入。

来看看写法：

```javascript
// 某个模块的导出 moudule.js
export const a = 1;

// 模块导入
// 1. 这里的a得和被加载的模块输出的接口名对应
import { a } from './module'

// 2. 使用 as 换名
import { a as myA } from './module'

// 3. 若是只想要运行被加载的模块可以这样写，但是即使加载2次也只是运行一次
import './module'

// 4. 整体加载
import * as module from './module'

// 5. default接口和具名接口
import module, { a } from './module'
```

第四种写法会获取到 `module` 中所有导出的东西，并且赋值到 `module` 这个变量下，这样我们就可以用 `module.a` 这种方式来引用 `a` 了。



#### 3. export ... from...

还有一种写法，可以将 `export` 和 `from` 结合起来用。

例如，我有三个模块 `a、b、c`。

`c` 模块现在想要引入 `a` 模块，但是它不直接引用 `a`，而是通过 `b` 模块来引用，那么可能会认为 `b` 应该这样写：

```javascript
import { someVariable } from './a';

export { someVariable };
```

引入 `someVariable` 然后再导出。

但是这会有一个问题：这还只是一个变量，我们得导入再导出，若是有很多个变量需要这样，那无疑会增加很多代码量。

所以这时候可以用下面这种方式来实现 `b`：

```javascript
export { someVariable } from './a';
```



#### 4、CommonJS 与 ES6 Modules 规范的区别

- `CommonJS` 模块是运行时加载，`ES6 Modules` 是编译时输出接口
  - 因为 `CommonJS` 加载的是一个对象（即 `module.exports` 属性），该对象只有在脚本运行完才会生成
  - 而 `ES6` 模块不是对象，它的对外接口只是一种静态定义，在代码静态解析阶段就会生成
- **`CommonJS` 输出是值的拷贝；`ES6 Modules` 输出的是值的引用，被输出模块的内部的改变会影响引用的改变**
- `ES6 Modules` 模块中的值属于动态只读引用
  - 对于只读来说，即不允许修改引入变量的值，`import` 的变量是只读的，不论是基本数据类型还是复杂数据类型
  - 当模块遇到 `import` 命令时，就会生成一个只读引用。等到脚本真正执行时，再根据这个只读引用，到被加载的那个模块里面去取值
  - 对于动态来说，原始值发生变化，`import` 加载的值也会发生变化。不论是基本数据类型还是复杂数据类型。
- `CommonJS ` 中的 `this` 指向当前模块，`ES6 Modules ` 中的 `this` 指向 `undefined`
- `ES6 Modules` 中没有这些顶层变量：`arguments`、`require`、`module`、`exports`、`__filename`、`__dirname`

对于 `ES6 Modules` 输出的是值的引用，可以看下面这个例子：

```javascript
// a.js
import { foo } from './b';
console.log(foo);
setTimeout(() => {
  console.log(foo);
  import('./b').then(({ foo }) => {
    console.log(foo);
  });
}, 1000);

// b.js
export let foo = 1;
setTimeout(() => {
  foo = 2;
}, 500);
// 执行：babel-node a.js
// 执行结果：
// 1
// 2
// 2
```



### 七、最后

参考：

- [这一次，我要弄懂javascript的模块化](https://juejin.im/post/5b4420e7f265da0f4b7a7b27)

