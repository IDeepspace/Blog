---
title: ES6 —— 数组的拓展
author: Deepspace
tags:
  - ES6
categories: JavaScript
date: 2017-02-11
urlname: es6-array
---

<!-- ## ES6 —— 数组的拓展 -->

`ES6` 中的数组对象有许多新扩展。让数组的使用变得更加方便、简单。下面我们一起看看新特性。

### 一、扩展运算符

扩展运算符（`Spread Syntax`）是三个点：`...` 。它好比剩余（ `rest` ）参数的逆运算，将一个数组转为用逗号分隔的参数序列。

> 简单介绍下剩余（ `rest` ）参数：**剩余参数**语法允许我们将一个不定数量的参数表示为一个数组。
>
> ```javascript
> function sum(init, ...theArgs) {
>   return init + theArgs.reduce((previous, current) => {
>     return previous + current;
>   });
> }
> 
> console.log(sum(100, 1, 2, 3));
> // expected output: 106
> 
> console.log(sum(100, 1, 2, 3, 4));
> // expected output: 110
> ```

扩展运算符刚好反过来：

```javascript
console.log(...[1, 2, 3])
// 1 2 3

console.log(1, ...[2, 3, 4], 5)
// 1 2 3 4 5

console.log([...[], 1])
// [1]
```
<!-- more -->

#### 1、复制数组

数组是复合的数据类型，直接使用 `=` 来复制的话，只是复制了指向底层数据结构的指针，而不是克隆一个全新的数组。

```javascript
const a1 = [1, 2];
const a2 = a1;

a2[0] = 2;
a1 // [2, 2]
```

`a2` 并不是 `a1` 的克隆，而是指向同一份数据的另一个指针。修改 `a2`，会直接导致 `a1` 的变化。

`ES5` 只能用变通方法来复制数组：

```javascript
const a1 = [1, 2];
const a2 = a1.concat();

a2[0] = 2;

console.log(a1) // [1, 2]
console.log(a2)
```

上面代码中，`a1 ` 会返回原数组的克隆，再修改 `a2` 就不会对 `a1` 产生影响。

使用扩展运算符会更加方便：

```javascript
const a1 = [1, 2];
// 写法一
const a2 = [...a1];
// 写法二
const [...a3] = a1;

a1[0] = 0

console.log(a1) // [0, 2]
console.log(a2) // [1, 2]
console.log(a3) // [1, 2]
```



#### 2、合并数组

可以使用扩展运算符来合并数组。

```javascript
const arr1 = ['a', 'b'];
const arr2 = ['c'];
const arr3 = ['d', 'e'];

// ES5 的合并数组
arr1.concat(arr2, arr3);
// [ 'a', 'b', 'c', 'd', 'e' ]

// ES6 的合并数组
[...arr1, ...arr2, ...arr3]
// [ 'a', 'b', 'c', 'd', 'e' ]
```

> 注意：`a3` 和 `a4` 是用两种不同方法合并而成的新数组，但是它们的成员都是对原数组成员的引用，这就是浅拷贝。如果修改了原数组的成员，会同步反映到新数组。
>
> 关于对象的深浅拷贝，可以参考：https://togoblog.cn/javascript-copy-object/



#### 3、解构赋值

扩展运算符可以和 `ES6` 的解构赋值结合使用。

以前，为变量赋值，只能直接指定值：

```javascript
let a = 1;
let b = 2;
let c = 3;
```

现在可以写成这样：

```javascript
let [a, b, c] = [1, 2, 3];
```

看更多的例子：

```javascript
let [foo, [[bar], baz]] = [1, [[2], 3]];
foo // 1
bar // 2
baz // 3

let [ , , third] = ["foo", "bar", "baz"];
third // "baz"

let [x, , y] = [1, 2, 3];
x // 1
y // 3

let [head, ...tail] = [1, 2, 3, 4];
head // 1
tail // [2, 3, 4]

let [x, y, ...z] = ['a'];
x // "a"
y // undefined
z // []
```

如果将扩展运算符用于数组赋值，只能放在参数的最后一位，否则会报错。

```javascript
const [...butLast, last] = [1, 2, 3, 4, 5];
// 报错

const [first, ...middle, last] = [1, 2, 3, 4, 5];
// 报错
```



#### 4、字符串

扩展运算符还可以将字符串转为真正的数组。

```javascript
[...'hello']
// [ "h", "e", "l", "l", "o" ]
```



### 二、Array.from()

`Array.from` 方法用于将两类对象转为真正的数组：

- 类似数组的对象（`array-like object`）：https://togoblog.cn/array-like-object/
- 可遍历（`iterable`）的对象（包括 `ES6` 新增的数据结构 `Set` 和 `Map`）

下面是一个类似数组的对象，`Array.from` 将它转为真正的数组。

```javascript
let arrayLike = {
  '0': 'a',
  '1': 'b',
  '2': 'c',
  length: 3
};

// ES5的写法
var arr1 = [].slice.call(arrayLike); // ['a', 'b', 'c']

// ES6的写法
let arr2 = Array.from(arrayLike); // ['a', 'b', 'c']
```



### 三、Array.of()

`Array.of` 方法用于将一组值，转换为数组。

```javascript
Array.of(3, 11, 8); // [3,11,8]
Array.of(3); // [3]
Array.of(3).length; // 1
```

这个方法的主要目的，是弥补数组构造函数 `Array()` 的不足。因为参数个数的不同，会导致 `Array()` 的行为有差异：

```javascript
Array(); // []
Array(3); // [, , ,]
Array(3, 11, 8); // [3, 11, 8]
```

上面代码中，`Array` 方法没有参数、一个参数、三个参数时，返回结果都不一样。只有当参数个数不少于 2 个时，`Array()` 才会返回由参数组成的新数组。参数个数只有一个时，实际上是指定数组的长度。

`Array.of` 基本上可以用来替代 `Array()` 或 `new Array()`，并且不存在由于参数不同而导致的重载。它的行为非常统一。

```javascript
Array.of(); // []
Array.of(undefined); // [undefined]
Array.of(1); // [1]
Array.of(1, 2); // [1, 2]
```

`Array.of` 总是返回参数值组成的数组。如果没有参数，就返回一个空数组。

`Array.of` 方法可以用下面的代码模拟实现。

```javascript
function ArrayOf() {
  return [].slice.call(arguments);
}
```



### 四、Array.ptototype.copyWithin()

数组实例的 `copyWithin` 方法，在当前数组内部，将指定位置的成员复制到其他位置（会覆盖原有成员），然后返回当前数组。也就是说，使用这个方法，会修改当前数组 。

语法

```javascript
Array.prototype.copyWithin(target, (start = 0), (end = this.length));
```

接受三个参数：

- `target`（必需）：从该位置开始替换数据。
- `start`（可选）：从该位置开始读取数据，默认为 0。如果为负值，表示倒数。
- `end`（可选）：到该位置前停止读取数据，默认等于数组长度。如果为负值，表示倒数。

看下面的例子 :

```javascript
let cct1 = [1, 2, 3, 4, 5].copyWithin(0, 3);
console.log(cct1); //[ 4, 5, 3, 4, 5 ]

// 将3号位复制到0号位
let cct2 = [1, 2, 3, 4, 5].copyWithin(0, 3, 4);
console.log(cct2); // [4, 2, 3, 4, 5]

// -2相当于3号位，-1相当于4号位
let cct3 = [1, 2, 3, 4, 5].copyWithin(0, -2, -1);
console.log(cct3); //[4, 2, 3, 4, 5]

// 将3号位复制到0号位
let cct4 = [].copyWithin.call({ length: 5, 3: 1 }, 0, 3);
console.log(cct4); // {0: 1, 3: 1, length: 5}

// 将2号位到数组结束，复制到0号位
let i32a = new Int32Array([1, 2, 3, 4, 5]);
let cct5 = i32a.copyWithin(0, 2);
console.log(cct5); // Int32Array [3, 4, 5, 4, 5]

// 对于没有部署 TypedArray 的 copyWithin 方法的平台
// 需要采用下面的写法
let cct6 = [].copyWithin.call(new Int32Array([1, 2, 3, 4, 5]), 0, 3, 4);
console.log(cct6); // Int32Array [4, 2, 3, 4, 5]
```



### 五、Array.prototype.find() 和 findIndex()

#### 1、find()

数组实例的 `find` 方法，用于找出第一个符合条件的数组成员。

> 它的参数是一个回调函数，所有数组成员依次执行该回调函数，直到找出第一个返回值为`true`的成员，然后返回该成员。如果没有符合条件的成员，则返回`undefined` 。

**语法**

```javascript
arr.find(callback[, thisArg])
```

**参数**

- `callback`

  在数组每一项上执行的函数，接收 3 个参数：`element` 当前遍历到的元素。`index` 当前遍历到的索引。`array ` 数组本身。

- `thisArg` 可选

  可选，指定 `callback 的 this 参数。`

看下面的例子 :

```javascript
let cct = [1, 4, -5, 10].find(n => n < 0);
console.log(cct); //-5

let cct2 = [1, 5, 10, 15].find(function(value, index, arr) {
  return value > 9;
});
console.log(cct2); // 10
```



#### 2、findIndex()

`findIndex` 方法的用法与 `find` 方法非常类似，返回第一个符合条件的数组成员的位置，如果所有成员都不符合条件，则返回 `-1` 。

```javascript
let cct3 = [1, 5, 10, 15].findIndex(function(value, index, arr) {
  return value > 9;
});
console.log(cct3); // 2
```

另外，这两个方法都可以用来寻找 `NaN`，弥补了数组的 `IndexOf` 方法的不足。

```javascript
console.log([NaN].indexOf(NaN)); // -1

console.log([NaN].findIndex(y => Object.is(NaN, y))); // 0
```

上面代码中，`indexOf` 方法无法识别数组的 `NaN` 成员，但是 `findIndex` 方法可以借助 `Object.is` 方法做到。



### 七、Array.prototype.fill()

`fill` 方法使用给定值，填充一个数组。

```javascript
let cct4 = ['a', 'b', 'c'].fill(7);
console.log(cct4); // [7, 7, 7]

let cct5 = new Array(3).fill(7);
console.log(cct5); // [7, 7, 7]
```

上面代码表明，`fill ` 方法用于空数组的初始化非常方便。数组中已有的元素，会被全部抹去。

`fill` 方法还可以接受第二个和第三个参数，用于指定填充的**起始位置**和**结束位置**。

```javascript
let cct6 = ['a', 'b', 'c'].fill(7, 1, 2);
console.log(cct6); // ['a', 7, 'c']
```

上面代码表示，`fill` 方法从 `1` 号位开始，向原数组填充 `7`，到 `2` 号位之前结束。



### 八、entries()，keys() 和 values()

1、`entries()` 方法返回一个新的 `Array Iterator` 对象，该对象包含数组中每个索引的键/值对 。

2、`keys()`方法返回一个新的 `Array` 迭代器，它包含数组中每个索引的键。

3、`values()` 方法返回一个新的 `Array Iterator` 对象，该对象包含数组每个索引的值。

```javascript
for (let index of ['a', 'b'].keys()) {
  console.log(index);
}
// 0
// 1

for (let elem of ['a', 'b'].values()) {
  console.log(elem);
}
// 'a'
// 'b'

for (let [index, elem] of ['a', 'b'].entries()) {
  console.log(index, elem);
}
// 0 'a'
// 1 'b'
```

如果不使用`for...of`循环，可以手动调用遍历器对象的`next`方法，进行遍历。

```javascript
let letter = ['a', 'b', 'c'];
let entries = letter.entries();
console.log(entries.next().value); // [0, 'a']
console.log(entries.next().value); // [1, 'b']
console.log(entries.next().value); // [2, 'c']
```



### 九、includes()

`includes()` 方法用来判断一个数组是否包含一个指定的值，如果是，返回 `true`, 反之则返回 `false`。

**语法：**

```javascript
arr.includes(searchElement);
arr.includes(searchElement, fromIndex);
```

**参数：**

- `searchElement`：需要查找的元素值。
- `fromIndex` （可选）：从该索引处开始查找 `searchElement`。如果为负值，则按升序从 `array.length + fromIndex` 的索引开始搜索。默认为 `0`。

**返回值：**

返回一个 [`Boolean`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Boolean)。

```javascript
[1, 2, 3].includes(2); // true
[1, 2, 3].includes(4); // false
[1, 2, NaN].includes(NaN); // true
```

`includes()` 方法的第二个参数表示搜索的起始位置，默认为 `0`。如果第二个参数为负数，则表示倒数的位置，如果这时它大于数组长度（比如第二个参数为 `-4`，但数组长度为 `3`），则会重置为从 `0` 开始。

```javascript
[1, 2, 3].includes(3, 3); // false
[1, 2, 3].includes(3, -1); // true
```

**注意 :** 没有该方法之前，我们通常使用数组的`indexOf`方法，检查是否包含某个值。

```javascript
if (arr.indexOf(el) !== -1) {
  // ...
}
```

`indexOf`方法有两个缺点：

- 不够语义化，它的含义是找到参数值的第一个出现位置，所以要去比较是否不等于`-1`，表达起来不够直观
- 它内部使用严格相等运算符（`===`）进行判断，这会导致对 `NaN` 的误判。

```javascript
[NaN].indexOf(NaN);
// -1
```

`includes` 使用的是不一样的判断算法，就没有这个问题。

```javascript
[NaN].includes(NaN);
// true
```

下面代码用来检查当前环境是否支持该方法，如果不支持，部署一个简易的替代版本。

```javascript
const contains = (() =>
  Array.prototype.includes
    ? (arr, value) => arr.includes(value)
    : (arr, value) => arr.some(el => el === value))();
contains(['foo', 'bar'], 'baz'); // => false
```

另外，`Map` 和 `Set` 数据结构有一个 `has` 方法，需要注意与`includes`区分。

- `Map` 结构的`has`方法，是用来查找键名的，比如`Map.prototype.has(key)`、`WeakMap.prototype.has(key)`、`Reflect.has(target, propertyKey)`。
- `Set` 结构的`has`方法，是用来查找值的，比如`Set.prototype.has(value)`、`WeakSet.prototype.has(value)`。



### 十、flat()，flatMap()

#### 1、flat()

> 如果开发环境不支持，你可以先自定义一个 `flat()` 方法来代替：
>
> ```javascript
> Object.defineProperty(Array.prototype, 'flat', {
>   value: function (depth = 1) {
>     return this.reduce(function (flat, toFlatten) {
>       return flat.concat((Array.isArray(toFlatten) && (depth > 1)) ? toFlatten.flat(depth - 1) : toFlatten);
>     }, []);
>   }
> });
> ```

数组的成员有时候还是数组，`Array.prototype.flat()` 用于将嵌套的数组“拉平”，变成一维的数组。该方法返回一个新数组，对原数据没有影响。

```javascript
[1, 2, [3, 4]].flat(); // [1, 2, 3, 4]
```

上面代码中，原数组的成员里面有一个数组，`flat()` 方法将子数组的成员取出来，添加在原来的位置。

`flat()` 默认只会“拉平”一层，如果想要“拉平”多层的嵌套数组，可以将`flat()`方法的参数写成一个整数，表示想要拉平的层数，默认为1。

```javascript
[1, 2, [3, [4, 5]]].flat(); // [1, 2, 3, [4, 5]]

[1, 2, [3, [4, 5]]].flat(2); // [1, 2, 3, 4, 5]
```

上面代码中，`flat()` 的参数为2，表示要“拉平”两层的嵌套数组。

如果不管有多少层嵌套，都要转成一维数组，可以用 `Infinity` 关键字作为参数。

```javascript
[1, [2, [3]]].flat(Infinity); // [1, 2, 3]
```

如果原数组有空位，`flat()` 方法会跳过空位。

```javascript
[1, 2, , 4, 5].flat(); // [1, 2, 4, 5]
```



#### 2、flatMap()

> 如果开发环境不支持，你可以先自定义一个 `flatMap()` 方法来代替：
>
> ```javascript
> Array.prototype.flatMap = function (lambda) {
>   return Array.prototype.concat.apply([], this.map(lambda));
> };
> ```

`flatMap()` 方法的参数是一个遍历函数，该函数可以接受三个参数，分别是当前数组成员、当前数组成员的位置（从零开始）、原数组。

```javascript
arr.flatMap(function callback(currentValue[, index[, array]]) {
  // ...
}[, thisArg])
```

`flatMap()`方法还可以有第二个参数，用来绑定遍历函数里面的`this`。

`flatMap()` 方法对原数组的每个成员执行一个函数（相当于执行`Array.prototype.map()`），然后对返回值组成的数组执行 `flat()` 方法。与 `map()` 连着深度值为 `1` 的 `flat()` 几乎相同效果是一样的。

该方法返回一个新数组，不改变原数组。

```javascript
[2, 3, 4].flatMap((x) => [x, x * 2]); // [2, 4, 3, 6, 4, 8]
// 相当于 [[2, 4], [3, 6], [4, 8]].flat()
```

`flatMap()` 只能展开一层数组。

```javascript
[1, 2, 3, 4].flatMap(x => [[x * 2]]); // [[2], [4], [6], [8]]
// 相当于 [[[2]], [[4]], [[6]], [[8]]].flat()
```

上面代码中，遍历函数返回的是一个双层的数组，但是默认只能展开一层，因此 `flatMap()` 返回的还是一个嵌套数组。


> 参考: http://es6.ruanyifeng.com/#docs/array
