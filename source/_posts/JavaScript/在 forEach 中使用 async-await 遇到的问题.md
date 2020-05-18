---
title: 在 forEach 中使用 async/await 遇到的问题 
author: Deepspace
tags:
  - async/await
categories: JavaScript
date: 2019-10-25
urlname: javascript-async-await-in-foreach
---

### 一、问题描述

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
<!-- more -->
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

### 二、问题分析

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



### 三、解决方案

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



### 四、Eslint 问题

这时候 `Eslint` 又报了错：`no-await-in-loop` 。关于这一点，`Eslint`  官方文档 https://eslint.org/docs/rules/no-await-in-loop 也做了说明。

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

其实上面两种写法没有什么好坏之分，这两种写法的结果是完全不一样的。`Eslint` 推荐的 "好的写法" 在执行异步操作的时候没有顺序的，"不好的写法" 中有顺序，具体需要用哪种写法还是要根据业务需求来决定。

所以，在文档的 `When Not To Use It` 中，`Eslint` 也提到，如果需要有顺序地执行，我们是可以禁止掉该规则的：

>In many cases the iterations of a loop are not actually independent of each-other. For example, the output of one iteration might be used as the input to another. Or, loops may be used to retry asynchronous operations that were unsuccessful. Or, loops may be used to prevent your code from sending an excessive amount of requests in parallel. In such cases it makes sense to use `await` within a loop and it is recommended to disable the rule via a standard ESLint disable comment.


