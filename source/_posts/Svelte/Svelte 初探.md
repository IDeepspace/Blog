---
title: Svelte 初探
author: Deepspace
tags:
  - Svelte
categories: Svelte
date: 2020-08-23
urlname: svelte-begin
---

[Svelte](https://svelte.dev/)（发音：[svelt]）是一个类似于 `React` 和 `Vue` 的前端框架，作者是 [Rich Harris](https://github.com/Rich-Harris)，同时也是 [Rollup](https://rollupjs.org/guide/en/) 的作者。

### 编译器而非框架（无运行时）

说 `Svelte` 是框架是不合适的，它其实是一个编译器，而不是像 `React` 和 `Vue` 这样的依赖项。

我们知道 `React` 和 `Vue` 这类框架，都是基于运行时 （`runtime`）的框架，应用都必须引入框架本身 —— 也就是运行时代码，这些运行时代码被用于构建虚拟 `DOM`、处理 `diff` 算法等等。并且，这些工作都是在浏览器中完成的，当用户在页面上进行各种操作改变组件的状态时，框架的 `runtime` 会根据新的组件状态（`state`）计算（`diff`）出哪些 `DOM` 节点需要被更新，从而更新视图。

而 `Svelte` 不同，它会将我们所写的 `Svelte` 组件（`Svelte` 也是组件化的思想）编译成与 `DOM` 直接交互的原生 `JavaScript` 代码，这是在构建过程中完成的，代码在运行时不需要再多加一个中间层，也就是说不需要额外引入一个所谓的框架运行时。所以说 **`Svelte` 是编译器而非框架**。

> 当然，也并不是说 `Svelte` 完全就没有运行时代码，它在编译后也是有内置的运行时代码的，它们是一些辅助函数，只是量非常少，未压缩时大约有 200 行。

因为没有运行时，所以使用 `Svelte` 开发的组件编译后不需要额外的依赖，**可以单独使用**，在 `React`、`Vue` 项目中可以非常方便地直接引入使用。

### 如何做到高性能

`React` 和 `Vue` 这类框架都采用了虚拟 `DOM`，我们知道 `Virtual DOM` 在很多场景下会提高应用性能，那没有 `Virtual DOM` 的 `Svelte` 是如何做到高性能的呢？

<!-- more -->

#### 1、模板语法 Templates

`Svelte` 使用的是模板语法，将模板编译为相对较低级别的指令以呈现内容。相比于 `JSX` 的灵活，**模板语法更加严格和具有语义性（静态）**，可以在编译的过程中给出更多空间进行优化操作。

> 当然，`JSX` 具有 `JavaScript` 的完整表达能力，可以用来构建任意复杂的逻辑（组件）。

比如下面的模板代码：

![1597320474295-337c6299-adac-4619-864d-a1498d81475e.png](https://gitee.com/IDeepspace/image-hosting/raw/master/Svelte/template-example.png)

<p align="center">（图片来自网络）</p>

我们可以非常容易地知道：

- 哪些 `p` 标签是不会变化的
- `div` 的 `id` 是不会变化的
- 哪些标签里的内容是不会变化的
- 唯一可变的就是那个 `message` 变量

在编译时，`Svelte` 会将模板编译为命令式（`imperative`）的原生 `DOM` 操作，比如下面这段模板：

```html
<a>{{ msg }}</a>
```

会被编译成与 `DOM` 直接交互的原生 `JavaScript` 代码：

```javascript
function renderMainFragment(root, component, target) {
  var a = document.createElement("a");

  var text = document.createTextNode(root.msg);
  a.appendChild(text);

  target.appendChild(a);

  return {
    update: function (changed, root) {
      text.data = root.msg;
    },

    teardown: function (detach) {
      if (detach) a.parentNode.removeChild(a);
    },
  };
}
```

相比于基于虚拟 `DOM` 的 `JSX`，这样的输出不需要相应的维护虚拟 `DOM` 和 `diff` 操作的代码，代码体积大大减少，内存占用也少了很多，性能上的表现也是非常好的。

> 代码示例摘自：《如何看待 svelte 这个前端框架？》—— 尤雨溪的回答：https://www.zhihu.com/question/53150351/answer/133912199

#### 2、虚拟 DOM 并不是什么时候都快

虚拟 `DOM` 的优势在于 `React` 的 `diff` 算法和批处理策略。`React` 在页面更新之前，把所有的 `DOM` 操作搜集起来，一次性提交给真实的 `DOM`，而无需在每次更改内容时都重新构建整个 `DOM`，这样就可以尽量减少对真实 `DOM` 的调用。

> 实际上，我们在直接操作 `DOM` 时，这个计算过程也是可以自己判断和实现的（重绘和重排的优化），但是一定会耗费非常多的精力和时间，而且往往我们自己做的是不如 `React` 好的。所以，在这个过程中 `React` 帮助我们"提升了性能"。

虚拟 `DOM` 并不是没有缺点的。使用虚拟 `DOM` 时，首次渲染 `DOM` 时候由于多了一层虚拟 `DOM` 计算，所以可能比 `HTML` 渲染慢。另外，如果组件的数据发生变化，`React` 将重新渲染该组件及其所有子组件，哪怕子组件不需要重新渲染。这就是为什么 `React` 会有 `shouldComponentUpdate`、`useMemo`、`React.PureComponent`、`useCallback` 一类的 `API`。

注意，这里提到的重新渲染（`Re-render`）并不是说原生 `DOM` 被重新渲染了，而是指自定义的类组件的 `render` 方法或者组件函数被重新执行。组件被重新渲染是因为**虚拟 `DOM` 是建立在 `diff` 算法上的**，而如果要有 `diff`，就一定要将组件重新渲染，生成一棵新的虚拟 `DOM` 树（`React` 会在内存中维护两棵虚拟 `DOM` 树），这样才能知道组件的新状态和旧状态相比有没有发生改变，进而计算出哪些 `DOM` 节点需要被更新。

![1597306267239-412d18d3-b1d1-47ff-a017-5270f9f815b6.png](D:\personal\ImageHosting\Svelte\react-virtual-dom-work.png)

<p align="center">（图片来源：https://www.youtube.com/watch?v=AdNJ3fydeao）</p>

`React` 对于这个问题的解决方案不是专注于使虚拟 `DOM` 本身变得更快，而是使感知性能更好，因此它引入了**运行时调度**、**并发模式**、**时间分片**等机制，这是一个运行时解决方案，这些工作都需要大量的运行时间，在加载 `React` 的时候也需要加载这些处理复杂的运行时调度工作所需的所有代码。

> 如果你想了解 `React` 的这些机制，可以阅读下面的文章：
>
> - https://zhuanlan.zhihu.com/p/37095662
> - https://react.iamkasong.com/process/fiber.html

**那 Svelte 的更新渲染流程是怎样的呢？**

`Svelte` 使用**位掩码（`bitMask`）**的技术来跟踪哪些数据是**脏**的 —— 即自组件最后一次更新以来，哪些数据发生了哪些更改。举个例子，假设有 `A`、`B`、`C`、`D` 四个值，那么二进制 `0000 0001` 表示第一个值 `A` 发生了改变，`0000 0010` 表示第二个值 `B` 发生了改变，以此类推。这种表示方法可以最大程度利用空间，比如十进制数字 `3` （转变为二进制 `0000 0011`）就可以表示 `A`、`B` 两个数据是脏数据，其余数据都是干净的。

![image.png](D:\personal\ImageHosting\Svelte\svelte-work-1.png)

但是，`JavaScript` 中的二进制有 `31` 位限制（`32`位，减去 `1` 位用来存放正负符号），如果采用二进制位存储的方法，那么一个 `Svelte` 组件中最多只能存放 `31` 个数据。所以，`Svelte` 采用数组（在 `Svelte` 中这个数组被叫作 `component.?.dirty`）来存放，数组中一项是二进制 `31` 位的比特位。假如超出 `31` 个数据了，超出的部分放到数组中的下一项。

![image.png](D:\personal\ImageHosting\Svelte\svelte-work-2.png)

所以，设置脏数据，就是把 `component.?.dirty` 数组二进制对应的比特位设置为 `1`。这个时候，`Svelte` 其实就已经保存好了**数据与真实 `DOM` 节点之间的对应关系**。`Svelte` 会走入不同的 if 体内直接更新对应的 `DOM` 节点，而不需要复杂虚拟 `DOM` 的 `diff` 算出需要更新哪些 `DOM` 节点。并且，在 `Svelte` 编译时，就已经分析好了数据与真实 `DOM` 节点之间的对应关系，在数据发生改变时，可以非常高效地调用更新 `DOM` 的方法来更新节点。

### 构建产物体积非常小

得益于无运行时的特性，并且对于特定功能，在编译时，如果一个功能没用到，对应的代码就根本不会被编译到结果里，所以，`Svelte` 应用的最终代码打包体积非常小。

![image.png](D:\personal\ImageHosting\Svelte\svelte-compare.png)

> 对比结果来源：https://www.freecodecamp.org/news/a-realworld-comparison-of-front-end-frameworks-with-benchmarks-2019-update-4be0d3c78075/

### 真正的响应式编程

响应式编程，是指不直接进行目标操作，而是通过**代理**的方式达到目标操作的目的。举个例子：

```javascript
let a = 3;
let b = a * 10;
console.log(b); // 30
a = 4;
// b = a * 10
console.log(b); // 30
```

这里的变量 `b` 并不会自动随着变量 `a` 的变化而变化，每次都需要再执行一遍 `b = a * 10`，`b` 的值才会发生改变。所以这个代码示例不是响应式的。

在 `React` 中，当数据发生改变时，我们需要调用 `this.setState()` 或者 `useState()` 来告诉 `React` 数据已更改，需要更新虚拟 `DOM` 了。所以，React 并不是响应式的。

`Svelte` 中的响应式非常自然且强大。在 `Svelte` 中，以 `$:` 开头的语句就是响应式语句，`Svelte` 会自动分析响应式语句所依赖的变量，当依赖变量发生变化时，`Svelte` 就会重新执行相应的响应式语句。看个例子：

```html
<script>
  let count = 0;
  $: doubled = count * 2;

  function handleClick() {
    count += 1;
  }

  $: if (count >= 10) {
    console.log(`count is dangerously high!`);
    count = 9;
  }
</script>

<button on:click="{handleClick}">
  Clicked {count} {count === 1 ? 'time' : 'times'}
</button>

<p>{count} doubled is {doubled}</p>
```

当 `Svelte` 看到任何带有 `$:` 前缀的语句时，它就知道要将右边的变量赋值给左边的变量，而不需要使用 `let` 将一个变量的值绑定到另一个变量；并且 `Svelte` 可以以响应式的方式运行任何语句，如上面的例子，在 `count` 变化时，也可以用通过响应式的 if 语句来记录并响应它的改变。

![image](D:\personal\ImageHosting\Svelte\svelte-$.gif)

但是要**注意**：`Svelte` 的响应是基于赋值操作的，数组的 `push`、`splice` 等操作不会触发响应式更新。例如：

```html
<script>
  let numbers = [1, 2, 3, 4];
  function addNumber() {
    numbers.push(numbers.length + 1);
  }
  $: sum = numbers.reduce((t, n) => t + n, 0);
</script>

<p>{numbers.join(' + ')} = {sum}</p>
<button on:click="{addNumber}">Add a number</button>
```

点击按钮时不会触发更新。需要将 push 操作改成赋值操作：

```javascript
...
numbers = [...numbers, numbers.length + 1];
...
```

### 自动订阅的 Store

`Svelte` 内置了一套状态管理功能，响应式的 `store` 在组件之间共享状态非常方便。使用的时候，`store` 放在单独的 `JS` 文件里，只需用 `writable` 封装一个值就可以创建了。

看个例子：

**store.js：**

```javascript
import { writable } from "svelte/store";

export const count = writable(0);
```

**App.svelte：**

```html
<script>
  import { count } from "./stores.js";
  import Incrementer from "./Incrementer.svelte";
  import Decrementer from "./Decrementer.svelte";
</script>

<h1>The count is {$count}</h1>

<Incrementer />
<Decrementer />
```

**Incrementer.svelte：**

```html
<script>
  import { count } from "./stores.js";

  function decrement() {
    count.update((n) => n - 1);
  }
</script>

<button on:click="{decrement}">-</button>
```

**Decrementer.svelte：**

```html
<script>
  import { count } from "./stores.js";

  function increment() {
    count.update((n) => n + 1);
  }
</script>

<button on:click="{increment}">+</button>
```

相比于 `redux`，`Svelte` 的 `store` 功能用起来非常简洁。

### 支持 TypeScript

`Svelte3` 开始支持 `TypeScript`：https://svelte.dev/blog/svelte-and-typescript

### Scoped style

和组件相关的样式代码会放在 `style` 标签里，这里的 `CSS` 是局部生效的（`scope`），不会影响到其它组件。

### 语法简洁

`Svelte` 的语法相当简洁，官方的 `REPL`（`Read Eval Print Loop`：交互式解释器）非常好用。

通过官方提供的教程，可以快速学习 `Svelte` 的语法：https://svelte.dev/tutorial/basics

### 劣势

#### 1、路由

目前官方的路由工具 `Sapper` 还并不完善，处于早期开发阶段，且一些 `API` 在未来 `1.0` 正式版中可能会发生一些变化。对于正式的交付项目来说，这是一个不小的隐患。

![1597374939437-b97c970c-8b0d-4802-ba75-ffd8ba1c25f9.png](D:\personal\ImageHosting\Svelte\sapper.png)

也有一些第三方的路由工具可以选择，目前相对完善一些的有：

- [svelte-routing](https://github.com/EmilTholin/svelte-routing#readme)
- [svelte-spa-router](https://github.com/ItalyPaleAle/svelte-spa-router#readme)

#### 2、UI 组件库

目前还没有一个比较成熟的 `UI` 组件库，这导致在需求复杂并且有交付压力的场景下，`Svelte` 并不是一个很好的选择。

下面是目前来看，相对成熟一些的 `UI` 组件库：

- https://sveltestrap.js.org/?path=/story/introduction--get-started
- https://sveltematerialui.com/

#### 3、只有 Svelte 组件才支持 Svelte 的静态模板特性

在 `JS` 中使用响应式的特性会报错：

```
function increment() {
  $count += 1; // error
}
```

#### 4、props 是可变的，并且无法验证类型

当然这也是故意这样设计的，这样 `props` 也是可以响应式的。

```
<script>
  export let answer;
</script>

<p>The answer is {answer}</p>
```

#### 5、重复代码的问题

`React` 和 `Vue` 自带的运行时代码虽然会增加首屏加载文件 `bundle.js` 的体积，但是当项目变得越来越大的时候，框架的运行时代码在 `bundle.js` 中的占比会越来越小。而一旦 `Svelte` 组件（模板代码）变多，生成的一些 "运行时" 代码也会越多，最终实际生产项目的体积有可能会超过 `React`、`Vue` 的运行时代码，这也是一个潜在的问题。

#### 6、没有构建工具

暂时没有类似于 `create-react-app` 的构建工具。

#### 7、在大型项目中的性能表现有待验证

因为是新兴前端框架，没有多少企业在一些大型项目中投入使用，最终的 `Svelte` 性能表现还有待验证。

### 参考文章

- [Svelte 更新渲染原理](https://juejin.im/post/6844904100656594957)
- [如何看待 svelte 这个前端框架？](https://www.zhihu.com/question/53150351)
- [Rich Harris - Rethinking reactivity](https://www.youtube.com/watch?v=AdNJ3fydeao&t=1881s)
