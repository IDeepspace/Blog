---
title: JavaScript 异步处理（ES6）
author: Deepspace
tags:
  - 异步
categories: JavaScript
date: 2019-09-29
urlname: javascript-async
---

### 一、Promise 是什么？

不是讲 `async/await` 吗？为什么会提到 `Promise` ？

实际上，`async/await` 是 `Promise` 的一个拓展，所以，想要更好地理解 `async/await`，需要先理解 `Promise` 。

我们先看看 `Promise` 是什么。先在浏览器中使用 `console.dir(Promise)` 打印出 `Promise` 对象的所的属性和方法：

![Promise](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/JavaScript/promise.png)

从打印结果可以看出，`Promise` 是一个构造函数，它自己本身有 `all`、`reject`、`resolve` 等方法，原型上有 `catch`、`finally`、`then` 等方法。所以 `new` 出来的 `Promise` 对象也就自然拥有 `catch`、`finally`、`then` 这些方法。从上图中可以看到，`then` 方法返回的是一个新的 `Promise` 实例（注意，不是原来那个 `Promise` 实例）。因此可以采用链式写法，即 `then` 方法后面再调用另一个 `then` 方法。

`Promise` 的中文意思是承诺，这种**“承诺将来会执行”**的对象在 `JavaScript` 中称为 `Promise` 对象。简单说就是一个容器，里面保存着某个未来才会执行的事件（通常是一个异步操作）的结果。



**`Promise` 对象有两个特点：**

1. 对象的状态不受外界影响。

   > `Promise` 对象代表一个异步操作，有三种状态：`pending`（进行中）、`fulfilled`（已成功）和 `rejected`（已失败）。**只有异步操作的结果可以决定当前是哪一种状态，任何其他操作都无法改变这个状态。** 这也是 `Promise` 这个名字的由来，它的英语意思就是“承诺”，表示其他手段无法改变。



2. 一旦状态发生了改变，就不会再变，并且任何时候都可以得到这个结果。

   > Promise 对象的状态的改变，只有两种可能：
   >
   > - 从 `pending` 变为 `fulfilled` 
   > - 从 `pending` 变为 `rejected`
   >
   > 只要这两种状况发生，状态就凝固了，不会再变，会一直保持这个结果，这时就称为 `resolved` （已定型）。
   >
   > 如果状态已经发生改变，再对 `Promise` 对象添加回调函数，也会立即得到这个结果。这与事件（`Event`）完全不同，事件的特点是，如果你错过了它，再去监听，是得不到结果的。



**`Promise` 也有一些缺点：**

1. 无法取消 `Promise` ，一旦新建 `Promise`，它就会立即执行，无法中途取消；
2. 如果不设置回调函数，`Promise` 内部抛出的错误，不会反应到外部；
3. 当 `Promise` 对象处于 `Pending` 状态时，无法得知目前进展到哪一个阶段（刚刚开始还是即将完成）。



### 二、Promise的使用

#### 1、创建Promise

那如何创建一个 `Promise` 呢，下面看一个简单的例子：

```javascript
const p = new Promise(function(resolve, reject) {
  //Do some Async
  setTimeout(function() {
    console.log('执行完成');
    resolve('数据');
  }, 2000);
});
```

`Promise` 构造函数接受一个函数作为参数，该函数的两个参数分别是 `resolve` 和 `reject`，这两个参数也是函数，由 `JavaScript` 引擎提供，不用自己实现。

- `resolve` 函数的作用是，将 `Promise` 对象的状态从“未完成”变为“成功”（即从 `pending` 变为 `resolved`），在异步操作成功时调用，并将异步操作的**结果**，作为参数传递出去；
- `reject` 函数的作用是，将 `Promise` 对象的状态从“未完成”变为“失败”（即从 `pending` 变为 `rejected`），在异步操作失败时调用，并将异步操作报出的**错误**，作为参数传递出去。

在上面的代码中，我们执行了一个异步操作，也就是 `setTimeout`，`2` 秒后，输出“执行完成”，并且调用 `resolve` 方法。运行代码的时候我们发现，我们只是 `new` 了一个 `Promise` 对象，并没有调用它，我们传进去的函数就已经执行了。

**所以，我们使用 `Promise` 的时候一般是包在一个函数中，在需要的时候去运行这个函数 :**

```javascript
function runAsync() {
  const p = new Promise(function(resolve, reject) {
    //Do some Async
    setTimeout(function() {
      console.log('执行完成');
      resolve('数据');
    }, 2000);
  });
  return p;
}
runAsync();
```

函数会 `return` 出 `Promise` 对象，也就是说，执行这个函数我们得到了一个 `Promise` 对象。在文章开始的时候，我们知道 `Promise` 对象拥有 `catch`、`finally`、`then` 这些方法，现在我们看看怎么使用它们。继续使用上面的 `runAsync` 函数 :

```javascript
function runAsync() {
  const p = new Promise(function(resolve, reject) {
    //Do some Async
    setTimeout(function() {
      console.log('执行完成');
      resolve('数据');
    }, 2000);
  });
  return p;
}
runAsync().then(
  function(data) {
    // success
    console.log(`成功拿到${data}`);
    //后面可以用传过来的数据做些其他操作
    // ......
  },
  function(error) {
    // failure
    console.log(error);
  }
);
```

`Promise` 实例生成以后，可以用 `then` 方法分别指定 `resolved` 状态和 `rejected` 状态的回调函数。`Promise`实例的状态变为 `resolved` 或 `rejected`，就会触发 `then` 方法绑定的回调函数。

```javascript
promise.then(function(value) {
  // success
}, function(error) {
  // failure
});
```

`then` 方法可以接受两个回调函数作为参数。第一个回调函数是 `Promise` 对象的状态变为 `resolved` 时调用，第二个回调函数是 `Promise` 对象的状态变为 `rejected` 时调用。其中，第二个函数是可选的，不一定要提供。这两个函数都接受 `Promise` 对象传出的值作为参数。

**结论：所以这个时候我们就会发现：原来 `then` 里面的函数和我们平时的回调函数一个意思，能够在 `runAsync` 这个异步任务执行完成之后被执行。**

这里我们就可以清楚的知道 `Promise` 的作用了：**异步执行的流程中，把原来的回调写法（执行代码和处理结果的代码）分离出来，在异步操作执行完后，用链式调用的方式执行回调函数。**

下面我们再具体看看 `Promise` 相比于回调嵌套的写法的好处。

#### 2、回调嵌套与Promise

从表面上看，`Promise` 只是能够简化层层回调的写法，而实质上，`Promise` 的精髓是“状态”，用维护状态、传递状态的方式来使得回调函数能够及时调用，它比传递 `callback` 函数要简单、灵活的多。我们来看看这种简化解决了什么问题：

以往使用回调嵌套的方式来处理异步的代码是怎么实现的呢？

```javascript
doA(function() {
  doB();
  doC(function() {
    doD();
  });
  doE();
});
doF();

//执行顺序：
//doA
//doF
//doB
//doC
//doE
//doD
```

这样组织的代码就会遇到一个问题：当项目的代码变得复杂，加上了各种逻辑判断，不断的在函数之间跳转，那排查问题的难度就会大大增加。就比如在上面这个例子中，`doD()` 必须在 `doC()` 完成后才能完成，如果 `doC()` 执行失败了呢？我们是要重试 `doC()` 吗？还是直接转到其他错误处理函数中？当我们将这些判断都加入到这个流程中，很快代码就会变得非常复杂，难以定位问题。

回调嵌套：

```javascript
request(url, function(err, res, body) {
    if (err) handleError(err);
    fs.writeFile('1.txt', body, function(err) {
        request(url2, function(err, res, body) {
            if (err) handleError(err)
        })
    })
});
```

使用 `Promise` 之后:

```javascript
request(url)
.then(function(result) {
    return writeFileAsynv('1.txt', result)
})
.then(function(result) {
    return request(url2)
})
.catch(function(e){
    handleError(e)
});
```

使用 `Promise` 的好处就非常明显了。

#### 3、catch 方法

`Promise` 对象也拥有 `catch` 方法。它的用途是什么呢？其实它和 `then` 方法的第二个参数是一样的，用来指定`reject` 的回调，和写在 `then` 里第二个参数里面的效果是一样。用法如下：

```javascript
runAsync()
.then(function(data){
    console.log('resolved');
    console.log(data);
})
.catch(function(error){
    console.log('rejected');
    console.log(error);
});
```

`catch` 还有另外一个作用：在执行 `resolve` 的回调（也就是上面 `then` 中的第一个参数）时，如果抛出异常了（代码出错了），那么并不会程序报错卡死，而是会进到这个 `catch` 方法中，看个例子：

```javascript
runAsync()
  .then(function(data) {
    console.log('resolved');
    console.log(data);
    console.log(somedata); //此处的somedata未定义
  })
  .catch(function(error) {
    console.log('rejected');
    console.log(error);
  });

// 执行完成
// resolved
// 数据
// rejected
// ReferenceError: somedata is not defined
```

在 `resolve` 的回调中，`somedata` 这个变量是没有被定义的。如果我们不用 `catch`，代码运行到这里就直接报错了，不往下运行了。但是在这里，会得到这样的结果。也就是说，程序执行到 `catch` 方法里面去了，而且把错误原因传到了 `error` 参数中。即便是有错误的代码也不会报错了，这与 `try/catch` 语句有相同的功能。**所以，如果想捕获错误，就可以使用 `catch` 方法。**

#### 4、Promise.all()

`Promise.all` 方法用于将多个 `Promise` 实例，包装成一个新的 `Promise` 实例。

```javascript
const p = Promise.all([p1, p2, p3]);
```

看个例子：

```javascript
function runAsync1() {
  const p = new Promise(function (resolve, reject) {
    //Do some Async
    setTimeout(function () {
      console.log('执行完成1');
      resolve('数据1');
    }, 2000);
  });
  return p;
}

function runAsync2() {
  const p = new Promise(function (resolve, reject) {
    //Do some Async
    setTimeout(function () {
      console.log('执行完成2');
      resolve('数据2');
    }, 5000);
  });
  return p;
}

function runAsync3() {
  const p = new Promise(function (resolve, reject) {
    //Do some Async
    setTimeout(function () {
      console.log('执行完成3');
      resolve('数据3');
    }, 1000);
  });
  return p;
}

Promise.all([runAsync1(), runAsync2(), runAsync3()]).then(function (results) {
  console.log(results);
});

// 执行完成1
// 执行完成2
// 执行完成3
// [ '数据1', '数据2', '数据3' ]
```

用 `Promise.all` 来执行，接收一个数组参数，里面的值最终都返回 `Promise` 对象。这样，三个异步操作的就是并行执行的，等到它们都执行完后才会进到 `then` 里面。那么，三个异步操作返回的数据哪里去了呢？都在 `then` 里面，`Promise.all` 会把所有异步操作的结果放进一个数组中传给 `then` ，就是上面的 `results` 。

**应用场景：**

`Promise.all` 方法有一个非常常用的应用场景：打开网页时，预先加载需要用到的各种资源如图片及各种静态文件，所有的都加载完后，再进行页面的初始化。

#### 5、Promise.race()

`race` 是竞赛、赛跑的意思。它的用法也就是它的字面意思：**谁跑的快，就以谁为准，执行回调**。其实再看看`Promise.all` 方法，和 `race` 方法恰恰相反。还是用 `Promise.all` 的例子，但是把 `runAsync1` 的方法 `timeout` 时间调成 `1000ms`。

```javascript
Promise.race([runAsync1(), runAsync2(), runAsync3()]).then(function(results) {
  console.log(results);
});

// 执行完成1
// 数据1
// 执行完成2
// 执行完成3
```

这三个异步操作同样是并行执行的。结果很可以猜到，1秒后 `runAsync1` 已经执行完了，此时 `then` 里面的方法就会立即执行了。但是，在 `then` 里面的回调函数开始执行时，`runAsync2()` 和 `runAsync3()` 并没有停止，仍然继续执行。所以再过1秒后，输出了他们结束的标志。这个点需要注意。

上面的这些方法就是 `Promise` 比较常用的几个方法了。

### 三、红绿灯问题

题目：红灯三秒亮一次，绿灯一秒亮一次，黄灯2秒亮一次；如何让三个灯不断交替重复亮灯？（用 `Promse` 实现）

三个亮灯函数已经存在：

```javascript
function red(){
    console.log('red');
}
function green(){
    console.log('green');
}
function yellow(){
    console.log('yellow');
}
```

利用 `then` 和递归实现：

```javascript
function red() {
  console.log('red');
}
function green() {
  console.log('green');
}
function yellow() {
  console.log('yellow');
}

const light = function(timmer, color) {
  return new Promise(function(resolve, reject) {
    setTimeout(function() {
      color();
      resolve();
    }, timmer);
  });
};

const step = function() {
  Promise.resolve()
    .then(function() {
      return light(3000, red);
    })
    .then(function() {
      return light(2000, green);
    })
    .then(function() {
      return light(1000, yellow);
    })
    .then(function() {
      step();
    });
};

step();
```



### 四、async/await 简介

`async` 函数是 `Generator` 函数的语法糖。

下面是一个 `Generator` 函数，依次读取两个文件：

```javascript
const fs = require('fs');

const readFile = function (fileName) {
  return new Promise(function (resolve, reject) {
    fs.readFile(fileName, function (error, data) {
      if (error) return reject(error);
      resolve(data);
    });
  });
};

function* ascReadFile() {
  yield readFile('./a.txt');
  yield readFile('./b.txt');
  yield readFile('./c.txt');
}

let g = ascReadFile();
g.next().value.then(data => {
  console.log(data.toString());
  return g.next().value;
}).then(data => {
  console.log(data.toString());
  return g.next().value;
}).then(data => {
  console.log(data.toString());
});
```

上面代码的函数 `gen` 可以写成 `async` 函数：

```javascript
const asyncReadFile = async function () {
  const f1 = await readFile('./a.txt');
  const f2 = await readFile('./b.txt');
  const f3 = await readFile('./c.txt');
  console.log(f1.toString());
  console.log(f2.toString());
  console.log(f3.toString());
};

asyncReadFile();
```

比较一下就会发现，`async` 函数就是将 `Generator` 函数的星号（`*`）替换成 `async`，将 `yield` 替换成 `await`。比起星号和 `yield`，`async` 和 `await`，语义上更清楚了。

**语法：**

`await` 只能出现在 `async` 函数中，`async` 用于申明一个 `function` 是异步的，而 `await` 用于等待一个异步方法执行完成。下面我们单独对 `async` 和 `await` 做一些介绍，帮助理解。



### 五、async

`async` 函数是怎么处理它的返回值的呢？我们先写段代码来试试，看它到底会返回什么：

`index.js` :

```javascript
async function testAsync() {
  return "hello async";
}

const result = testAsync();
console.log(result);
```

打印结果：

```javascript
> node index.js
Promise { 'hello async' }
```

输出的是一个 `Promise` 对象。`async` 函数（包含函数语句、函数表达式、`Lambda` 表达式）会返回一个 `Promise` 对象，如果在函数中 `return` 一个直接量，`async` 会把这个直接量通过 `Promise.resolve()` 封装成 `Promise` 对象。

由于 `async` 函数返回的是一个 `Promise` 对象，所以在最外层不能用 `await` 获取其返回值的情况下，我们可以用原来的方式：`then()` 链来处理这个 `Promise` 对象，像下面这样：

```javascript
async function testAsync() {
  return "hello async";
}

testAsync().then(v => {
  console.log(v);    // hello async
});
```

那如果 `async` 函数没有返回值，会怎么样呢？很容易想到，它会返回 `Promise.resolve(undefined)`。

联想一下 `Promise` 的特点——无等待，所以在没有 `await` 的情况下执行 `async` 函数，它会立即执行，返回一个 `Promise` 对象，并且不会阻塞后面的语句。这和普通返回 `Promise` 对象的函数是一样的。



### 六、await

`await` 操作符用于等待一个[`Promise`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise) 对象。它只能在异步函数 [`async function`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/async_function) 中使用。

因为 `async` 函数返回一个 `Promise` 对象，所以 `await` 可以用于等待一个 `async` 函数的返回值——这也可以说是 `await` 在等 `async` 函数。

但要清楚，`await` 等的实际是一个返回值 —— 一个 [`Promise`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise) 对象或者任何要等待的值， `await` 不仅仅用于等 `Promise` 对象，它可以等任意表达式的结果，所以，`await` 后面实际是可以接普通函数调用或者直接量的。

> 实际上，当 `await` 等待的不是一个 `Promise` 的时候，它就有一个隐式调用：`Promise.resolve("hello async");`

```javascript
function getSomething() {
  return "something";
}

async function testAsync() {
  return Promise.resolve("hello async");
}

async function test() {
  const v1 = await getSomething();
  const v2 = await testAsync();
  console.log(v1, v2);
}

test();
```

`await` 等到了它要等的东西 —— 一个 `Promise` 对象，或者其它值，然后呢？首先我们需要明确的是：**await 是个运算符，用于组成表达式，await 表达式的运算结果取决于它等的东西。**

- 如果 `await` 等到的不是一个 `Promise` 对象，那 `await` 表达式的运算结果就是它等到的东西。
- 如果它等到的是一个 `Promise` 对象，`await` 就忙起来了，它会阻塞后面的代码，等着 `Promise` 对象 `resolve`，然后得到 `resolve` 的值，作为 `await` 表达式的运算结果。这就是 `await` 必须用在 `async` 函数中的原因，`async` 函数调用不会造成阻塞，它内部所有的阻塞都被封装在一个 `Promise` 对象中异步执行。



### 七、async/await 的优势

#### 1、简洁

使用 `async/await` 明显节约了不少代码。我们：

- 不需要写 `.then`；
- 不需要写匿名函数处理 `Promise` 的 `resolve` 值；
- 不需要定义多余的 `data` 变量；
- 避免了嵌套代码。

#### 2、错误处理

`async/await` 使得最终可以使用相同的代码结构来处理同步和异步错误。

在下面带有 `promises` 的示例中，如果 `JSON.parse` 失败，则 `try/catch` 将无法处理，因为它发生在 `promise` 中。我们需要在 `promise` 上调用 `.catch` 并复制我们的错误处理代码，这会让代码变得非常冗杂。在实际生产中，会更加复杂。

```javascript
const makeRequest = () => {
  try {
    getJSON().then(result => {
      // JSON.parse可能会出错
      const data = JSON.parse(result);
      console.log(data);
    });
    // 取消注释，处理异步代码的错误
    // .catch((err) => {
    //   console.log(err)
    // })
  } catch (err) {
    console.log(err);
  }
};
```

如果我们使用 `async/await` 的话，`catch` 就能很好地处理 `JSON.parse` 错误：

```javascript
const makeRequest = async () => {
  try {
    // JSON.parse可能会出错
    const data = JSON.parse(await getJSON());
    console.log(data);
  } catch (err) {
    console.log(err);
  }
};
```

#### 3、条件语句

下面的代码示例当中，异步请求 `getJSON` 获取数据，然后根据返回的数据来判断决定是直接返回还是继续获取更多的数据：

```javascript
const makeRequest = () => {
  return getJSON().then(data => {
    if (data.needsAnotherRequest) {
      return makeAnotherRequest(data).then(moreData => {
        console.log(moreData);
        return moreData;
      });
    } else {
      console.log(data);
      return data;
    }
  });
};
```

上面的代码看着就会觉得很头疼，嵌套了 6 层。`return` 语句很容易让人感到迷茫，而它们只是需要将最终结果传递到最外层的 `Promise`。如果我们使用 `async/await` 来改写代码，代码的可读性会大大提高：

```javascript
const makeRequest = async () => {
  const data = await getJSON();
  if (data.needsAnotherRequest) {
    const moreData = await makeAnotherRequest(data);
    console.log(moreData);
    return moreData;
  } else {
    console.log(data);
    return data;
  }
};
```

#### 4、中间值

开发中我们经常会遇到这样一个场景：调用 `promise1`，使用 `promise1` 返回的结果去调用 `promise2`，然后使用两者的结果去调用 `promise3`。你的代码很可能是这样的:

```javascript
const makeRequest = () => {
  return promise1()
    .then(value1 => {
      // do something
      return promise2(value1)
        .then(value2 => {
          // do something          
          return promise3(value1, value2);
        });
    });
};
```

我们可以做些改变，减少嵌套：将 `value1` 和 `value2` 放进 `Promise.all` 来避免深层嵌套：

```javascript
const makeRequest = () => {
  return promise1()
    .then(value1 => {
      // do something
      return Promise.all([value1, promise2(value1)])
    })
    .then(([value1, value2]) => {
      // do something          
      return promise3(value1, value2)
    })
}
```

代码看起来减少了嵌套，但是为了可读性却牺牲了语义。除了避免嵌套，并没有其他理由将 `value1` 和 `value2` 放在一个数组中。

如果我们使用 `async/await` 的话，代码会变得非常简单、直观：

```javascript
const makeRequest = async () => {
  const value1 = await promise1();
  const value2 = await promise2(value1);
  return promise3(value1, value2);
}
```

#### 5、错误栈

假设有一段代码在一个链中调用多个 `promise`，而在链的某个地方会抛出一个错误。

```javascript
const makeRequest = () => {
  return callAPromise()
    .then(() => callAPromise())
    .then(() => callAPromise())
    .then(() => callAPromise())
    .then(() => callAPromise())
    .then(() => {
      throw new Error('oops');
    });
};

makeRequest()
  .catch(err => {
    console.log(err);
    // output
    // Error: oops at callAPromise.then.then.then.then.then (index.js:8:13)
  });
```

`Promise` 链中返回的错误栈不会给出错误发生位置的详细原因。更糟糕的是，它会误导我们：错误栈中唯一的函数名为 `callAPromise`，然而它和错误没有关系。(当然文件名和行号还是有用的)。

然而，`async/await` 中的错误栈会指向错误所在的函数：

```javascript
const makeRequest = async () => {
  await callAPromise()
  await callAPromise()
  await callAPromise()
  await callAPromise()
  await callAPromise()
  throw new Error("oops");
}

makeRequest()
  .catch(err => {
    console.log(err);
    // output
    // Error: oops at makeRequest (index.js:7:9)
  })
```

在开发环境中，这一点优势可能并不大。但是，当我们分析生产环境的错误日志时，它将非常有用。

#### 6、调试

`async/await` 能够使得代码调试更简单。

由于我们不能在返回表达式的箭头函数中设置断点，所以如果使用 `Promise` 的话，就无法进行断点调试：

```javascript
const makeRequest = () => {
  return callAPromise()
    .then(() => callAPromise())
    .then(() => callAPromise())
    .then(() => callAPromise())
    .then(() => callAPromise())
    .then(() => {
      throw new Error('oops');
    });
};
```

并且，如果我们在 `.then` 代码块中设置断点，使用 `Step Over` 快捷键时，调试器不会跳到下一个 `.then`，它会跳过异步代码。

如果使用 `await/async`，我们就不再需要那么多箭头函数了，这样就可以像调试同步代码一样跳过 `await` 语句：

```javascript
const makeRequest = async () => {
  await callAPromise()
  await callAPromise()
  await callAPromise()
  await callAPromise()
  await callAPromise()
}
```



### 八、总结

- `async/await` 是写异步代码的新方式，以前的方法有**回调函数**和 `Promise`。
- `async/await` 是基于 `Promise` 实现的，它不能用于普通的回调函数。
- `async/await` 与 `Promise` 一样，是非阻塞的。
- `async/await` 使得异步代码看起来像同步代码，看起来更加清楚明了。
- `async/await` 相比于 `Promise` ，更加有优势。



### 九、await in loops

下面我们看看在 `for` 循环中如何正确的使用 `await`。

我们调用一个知乎的 `api` ：

```javascript
const fetch = require('node-fetch');
const bluebird = require('bluebird');

const getZhihuColumn = async (id) => {
  await bluebird.delay(1000);
  const url = `https://zhuanlan.zhihu.com/api/columns/${id}`;
  const response = await fetch(url);
  return await response.json();
};
```

现在有一个 `id` 列表，遍历里面的 `id`，在循环中调用 `getZhihuColumn`：

```javascript
const showColumnInfo = async () => {
  console.time('showColumnInfo');

  const names = ['feweekly', 'toolingtips'];

  for (const name of names) {
    const column = await getZhihuColumn(name);
    console.log(`Name: ${column.title} `);
    console.log(`Intro: ${column.intro} `);
  }

  console.timeEnd('showColumnInfo');
};

showColumnInfo();
```

运行结果：

```
Name: 前端周刊 
Intro: 在前端领域跟上时代的脚步，广度和深度不断精进 
Name: tooling bits 
Intro: 工欲善其事必先利其器 
showColumnInfo: 2446.938ms
```

可以看到上面的这种写法也是串行，只不过是在循环中串行。那怎么把串行改成并行，让代码运行的更快呢？思路是：**先触发所有的请求，拿到一个 Promise 的数组，然后遍历这个数组，等待里面的结果。** 实现如下：

```javascript
const showColumnInfo = async () => {
  console.time('showColumnInfo');

  const names = ['feweekly', 'toolingtips'];

  const promises = names.map(name => getZhihuColumn(name));

  for (const promise of promises) {
    const column = await promise;
    console.log(`Name: ${column.title} `);
    console.log(`Intro: ${column.intro} `);
  }

  console.timeEnd('showColumnInfo');
};

showColumnInfo();
```

运行结果：

```javascript
Name: 前端周刊 
Intro: 在前端领域跟上时代的脚步，广度和深度不断精进 
Name: tooling bits 
Intro: 工欲善其事必先利其器 
showColumnInfo: 1255.428ms
```

可以看到运行时间节省了不少。



### 十、forEach 的问题

#### 1、问题描述

前几天，项目中遇到一个 `JavaScript` 异步问题：

> 有一组数据，需要对每一个数据进行一个异步处理，并且希望处理的时候是同步的。

用代码描述如下：

```javascript
// 生成数据
const getNumbers = () => {
  return Promise.resolve([1, 2, 3])
}

// 异步处理
const doMulti = num => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (num) {
        resolve(num * num)
      } else {
        reject(new Error('num not specified'))
      }
    }, 2000)
  })
}

// 主函数
const main = async () => {
  console.log('start');
  const nums = [1, 2, 3];
  nums.forEach(async (x) => {
    const res = await doMulti(x);
    console.log(res);
  });
  console.log('end');
};

// 执行
main();
```

在这个例子中，通过 `forEach` 遍历地将每一个数字都执行 `doMulti` 操作。代码执行的结果是：首先会立即打印 `start`、`end` 。`2` 秒后，一次性输出 `1，4，9`。

这个结果和我们的预期有些区别，我们是希望每间隔 `2` 秒，执行一次异步处理，依次输出 `1，4，9`。所以当前代码应该是并行执行了，而我们期望的应该是串行执行。

我们尝试把 `forEach` 循环替换成 `for` 循环：

```javascript
const main = async () => {
  console.log('start');
  const nums = await getNumbers();
  for (const x of nums) {
    const res = await doMulti(x);
    console.log(res);
  }
  console.log('end');
};
```

执行结果完全符合了预期：依次输出：`start`、`1`， `4`， `9`， `end` 。



#### 2、问题分析

思路都是一样的，只是使用的遍历方式不一样而已，为什么会出现这样的情况呢？在 `MDN` 上查找了一下 `forEach` 的 `polyfill` 参考 [MDN-Array.prototype.forEach()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach) :

```javascript
// Production steps of ECMA-262, Edition 5, 15.4.4.18
// Reference: http://es5.github.io/#x15.4.4.18
if (!Array.prototype.forEach) {

  Array.prototype.forEach = function(callback, thisArg) {

    var T, k;

    if (this == null) {
      throw new TypeError(' this is null or not defined');
    }

    // 1. Let O be the result of calling toObject() passing the
    // |this| value as the argument.
    var O = Object(this);

    // 2. Let lenValue be the result of calling the Get() internal
    // method of O with the argument "length".
    // 3. Let len be toUint32(lenValue).
    var len = O.length >>> 0;

    // 4. If isCallable(callback) is false, throw a TypeError exception. 
    // See: http://es5.github.com/#x9.11
    if (typeof callback !== "function") {
      throw new TypeError(callback + ' is not a function');
    }

    // 5. If thisArg was supplied, let T be thisArg; else let
    // T be undefined.
    if (arguments.length > 1) {
      T = thisArg;
    }

    // 6. Let k be 0
    k = 0;

    // 7. Repeat, while k < len
    while (k < len) {

      var kValue;

      // a. Let Pk be ToString(k).
      //    This is implicit for LHS operands of the in operator
      // b. Let kPresent be the result of calling the HasProperty
      //    internal method of O with argument Pk.
      //    This step can be combined with c
      // c. If kPresent is true, then
      if (k in O) {

        // i. Let kValue be the result of calling the Get internal
        // method of O with argument Pk.
        kValue = O[k];

        // ii. Call the Call internal method of callback with T as
        // the this value and argument list containing kValue, k, and O.
        callback.call(T, kValue, k, O);
      }
      // d. Increase k by 1.
      k++;
    }
    // 8. return undefined
  };
}
```

从上面的 `polyfill` 中的 `setp 7` ，我们可以简单地理解成下面的步骤：

```javascript
Array.prototype.forEach = function (callback) {
  // this represents our array
  for (let index = 0; index < this.length; index++) {
    // We call the callback for each entry
    callback(this[index], index, this);
  };
};
```

相当于 `for` 循环执行了这个异步函数，所以是并行执行，导致了一次性全部输出结果：`1，4，9` 。

```javascript
const main = async () => {
  console.log('start');
  const nums = await getNumbers();
  // nums.forEach(async (x) => {
  //   const res = await doMulti(x);
  //   console.log(res);
  // });
  for (let index = 0; index < nums.length; index++) {
    (async x => {
      const res = await doMulti(x)
      console.log(res)
    })(nums[index])
  }
  console.log('end');
};
```



#### 3、解决方案

现在，我们把问题分析清楚了。前面用 `for-of` 循环来代替 `forEach` 作为解决方案 ，其实我们也可以改造一下 `forEach` :

```javascript
const asyncForEach = async (array, callback) => {
  for (let index = 0; index < array.length; index++) {
    await callback(array[index], index, array);
  }
}

const main = async () => {
  console.log('start');
  const nums = await getNumbers();
  await asyncForEach(nums, async x => {
    const res = await doMulti(x)
    console.log(res)
  })
  console.log('end');
};

main();
```



#### 4、Eslint 问题

这时候 `Eslint` 又报了错：`no-await-in-loop` 。关于这一点，`Eslint` 官方文档 https://eslint.org/docs/rules/no-await-in-loop 也做了说明。

好的写法：

```javascript
async function foo(things) {
  const results = [];
  for (const thing of things) {
    // Good: all asynchronous operations are immediately started.
    results.push(bar(thing));
  }
  // Now that all the asynchronous operations are running, here we wait until they all complete.
  return baz(await Promise.all(results));
}
```

不好的写法：

```javascript
async function foo(things) {
  const results = [];
  for (const thing of things) {
    // Bad: each loop iteration is delayed until the entire asynchronous operation completes
    results.push(await bar(thing));
  }
  return baz(results);
}
```

其实上面两种写法没有什么好坏之分，这两种写法的结果是完全不一样的。`Eslint` 推荐的 “好的写法” 在执行异步操作的时候没有顺序的，”不好的写法” 中有顺序，具体需要用哪种写法还是要根据业务需求来决定。

所以，在文档的 `When Not To Use It` 中，`Eslint` 也提到，如果需要有顺序地执行，我们是可以禁止掉该规则的：

> In many cases the iterations of a loop are not actually independent of each-other. For example, the output of one iteration might be used as the input to another. Or, loops may be used to retry asynchronous operations that were unsuccessful. Or, loops may be used to prevent your code from sending an excessive amount of requests in parallel. In such cases it makes sense to use `await` within a loop and it is recommended to disable the rule via a standard ESLint disable comment.
