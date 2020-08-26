---
title: React 中的虚拟 DOM 和 diff 算法
author: Deepspace
tags:
  - React
categories: React
date: 2017-08-12
urlname: react-virtual-dom-and-diff
---



## React 中的虚拟 DOM 和 diff 算法

本篇内容将会探究 `React` 中的虚拟 `DOM` 和 `diff` 算法，明白大致原理，并了解如何简单实现 虚拟 `DOM` 树。



### 一、真实的 DOM

为什么需要虚拟 `DOM`（`Virtual DOM`）呢？我们先来看看真实的 `DOM` 的问题。

假设页面上有一个列表，我们一般会这样写：

```html
<ul id='list'>
  <li class='item'>1</li>
  <li class='item'>2</li>
  <li class='item'>3</li>
</ul>
```

列表中的数据依次是 `1`，`2`，`3`。现在需要把数据替换成 `4`、`5`、`6`、`7`，如果不使用 `React`，直接使用原生的操作 `DOM` 的 `API`，应该怎么操作？一般会有三种做法：

1. 使用 `removeChild()` 清空列表，再使用 `appendChild()` 添加 4 个元素；
2. 针对前 3 个元素使用 `nodeValue` / `textContent` 修改，然后使用 `appendChild()` 添加 1 个元素；
3. 使用 `innerHtml` 直接对整个列表做覆盖式操作。

这三种不同的方式在性能上是会存在差异的。我们知道，**由于[重排和重绘](https://togoblog.cn/reflow-and-repaint/)的问题，当页面变得复杂的时候，频繁地操作 `DOM` 会造成很大的性能开销**。所以，如果使用原生 `DOM API`，应当根据当前环境选用合适的 `DOM` 操作方式，小心翼翼，尽可能减少重排和重绘，但这无疑也**增加了开发的复杂度**，**不利于工程师专注实现当前业务**。

同时，真实的 `DOM` 上的属性是非常多的，一个简单的 `div` 上绑定的属性也很复杂：

```javascript
var div = document.createElement('div');
var str = '';
for (const key in div) {
  str = str += key + ' '
}
console.log(str);
```

可以在浏览器中查看打印结果。在 `div` 这个元素上，会**默认挂载大量的属性和方法**（这没办法改变，因为标准就是这么设计的），但是很多时候，我们其实并不关心也不会使用到这些内容。



### 二、什么是虚拟 DOM？

所以，浏览器处理 `DOM` 很慢，但是浏览器处理 `JavaScript` 很快。

上面的例子中的 `DOM` 结构可以使用下面这样的 `JavaScript` 对象来表示：

```javascript
const VitrualDOM = {
  tagName: 'ul', // 节点标签名
  props: { // DOM的属性，用一个对象存储键值对
    id: 'list',
  },
  children: [ // 该节点的子节点
    { tagName: 'li', props: { class: 'item' }, children: ['1'] },
    { tagName: 'li', props: { class: 'item' }, children: ['2'] },
    { tagName: 'li', props: { class: 'item' }, children: ['3'] },
  ],
};
```

如上所示，我们使用了一个 `JavaScript` 对象可以很容易地将 `DOM` 结构表示出来，这个对象中有三个属性:

1. `tagName`：用来表示这个元素的标签名；
2. `props`： 用来表示这个元素所包含的属性；
3. `children`：用来表示这个元素的 `children`。

> 虚拟 `DOM` 里每一个 `Element` 实际上只有几个最重要的、最为有用的属性，并且没有那么多乱七八糟的引用，比如一些注册的属性和函数，所以哪怕是直接把虚拟 `DOM` 删了**，**根据新传进来的数据重新创建一个新的虚拟 `DOM ` 也是非常快的。

然后给节点实现渲染方法，就可以实现虚拟节点到真是 `DOM` 的转化，将 `VitrualDOM` 对象渲染成真实 `DOM`。这就是虚拟 `DOM` 的概念。



### 三、diff 算法是什么？

使用虚拟 `DOM` 之后，我们只需要告诉 `React` 当前的视图处于什么状态，`React` 则会通过虚拟 `DOM` 的转化来确保真实的 `DOM` 与该状态相匹配。那该怎么处理状态的变化呢？

`React` 是这样做的：

1. 用 `JavaScript` 对象来表示 `DOM` 树的结构，然后用这个虚拟 `DOM` 树构建一个真正的 `DOM` 树**，**插入到文档中；
2. 当状态变更时，重新构建一个新的虚拟 `DOM` 树，然后用这个新的树和旧的树作对比，记录两个树的差异；
3. 把差异应用在步骤一所构建的真正的 `DOM` 树上，视图就更新了。

比较两颗 `DOM` 数的差异是 `Virtual DOM` 算法中最为核心的部分，这也就是 `diff` 算法。

在比较的过程中，只比较同级的节点，非同级的节点不在比较范围内，这样既可以满足更新视图的需求，又可以简化算法实现，这样算法复杂度就可以达到 `O(n)`。

<img src="../ImageHosting/React/react-diff-1.png" alt="diff 算法" style="zoom: 75%;" />

<p align='center'>（图片来自网络）</p>

比较新旧两棵树的差异时，首先会对树进行遍历。常用的有两种遍历算法，分别是深度优先遍历和广度优先遍历。一般的 `diff` 算法中都采用的是**深度优先遍历**。**对新旧两棵树进行一次深度优先的遍历，这样每个节点就都会有一个唯一的标记。**

<img src="../ImageHosting/React/react-diff-2.png" alt="diff 算法" style="zoom: 75%;" />

<p align='center'>（图片来自网络）</p>

在遍历的时候，每遍历到一个节点就把该节点和新的树的同一个位置的节点进行对比，如果有差异的话就记录到一个对象里面。

在这个差异对象中记录了有改变的节点，常见的差异包括四种，分别是：

- 替换节点
- 增加/删除子节点
- 修改节点属性
- 改变文本内容

所以在记录差异的时候要根据不同的差异类型，记录不同的内容。

得到差异之后，就可以根据这些差异的不同类型，对 `DOM` 进行针对性的更新。与四种差异类型相对应的，是更新视图时具体的更新方法，分别是：

- `replaceChild()`
- `appendChild()` / `removeChild()`
- `setAttribute()` / `removeAttribute()`
- `textContent`



### 四、虚拟 DOM 真的更快吗？

虚拟 `DOM` 可以提升性能，这个说法是不那么准确的。直接操作 `DOM` 是非常耗费性能的，这一点毋庸置疑。但是 `React` 使用虚拟 `DOM` 也是无法避免操作 `DOM` 的。

虚拟 `DOM` 的优势在于 `React` 的 `diff` 算法和批处理策略。`React` 在页面更新之前，把所有的 `DOM` 操作搜集起来，一次性提交给真实的 `DOM`，这样可以尽量减少对慢速 `DOM` 的调用。

> 实际上，这个计算过程我们在直接操作 `DOM `时，也是可以自己判断和实现的，但是一定会耗费非常多的精力和时间，而且往往我们自己做的是不如 `React` 好的。所以，在这个过程中 `React` 帮助我们"提升了性能"。

但是，使用虚拟 `DOM` 时，首次渲染 `DOM` 时候由于多了一层虚拟 `DOM` 计算，所以可能比 `html` 渲染慢。



### 五、如何简单实现虚拟 DOM 树？

有了前面的描述，下面我们来简单实现一个虚拟 `DOM`。有三个步骤：

- 用 `JavaScript` 对象来表示 `DOM` 树的结构，然后用这个虚拟 `DOM` 树构建一个真正的 `DOM` 树**，**插入到文档中；

- 当状态变更时，重新构建一个新的虚拟 `DOM` 树，然后用这个新的树和旧的树作对比，记录两个树的差异；

- 把差异应用在步骤一所构建的真正的 `DOM` 树上，视图就更新了。



#### 1、构建虚拟 DOM 树

首先，我们要在内存中存储我们的 `DOM` 树，我们能够用纯 `JavaScript` 对象来表示它，假设我们有这样的一个结构：

```html
<ul class="list">
  <li>item 1</li>
  <li>item 2</li>
</ul>
```

我们可以这样来表示：

```javascript
{
  type: 'ul',
  props: { class: 'list' },
  children: [
    { type: 'li', props: {}, children: ['item 1'] },
    { type: 'li', props: {}, children: ['item 2'] },
  ],
}
```

我们可以写一个辅助函数：

```javascript
function h(type, props, ...children) {
  return {
    type,
    props,
    children,
  };
}
```

然后就可以像下面这样表示：

```javascript
h('ul', { class: 'list' },
  h('li', {}, 'item 1'),
  h('li', {}, 'item 2'));
```

这样看起来清晰了很多，当 `h(...)` 执行之后，将会返回纯的 `JavaScript` 对象，即我们的虚拟 `DOM`。

如果你看过 `Babel JSX` 的[官方文档](https://babeljs.io/docs/plugins/transform-react-jsx/)，你就会知道，`Babel` 会把下面的代码：

```html
<ul className="list">
  <li>item 1</li>
  <li>item 2</li>
</ul>
```

编译成：

```javascript
React.createElement('ul', { className: 'list' },
  React.createElement('li', {}, 'item 1'),
  React.createElement('li', {}, 'item 2'),
)
```

如果我们能够用我们的 `h(...)` 函数代替 `React.createElement(…)`，那么我们也能使用 `JSX` 语法了。其实，我们只需要在源文件头部加上这么一句注释：

```javascript
/** @jsx h */
```

`Babel` 就会帮我们开始编译了。



#### 2、运用虚拟 DOM 构建真实的 DOM

我们需要一个真实的 `DOM` 节点：

```html
<div id="root"></div>
```

然后写一个 `createElement(…)` 函数把虚拟  `DOM` 转换成真实的 `DOM`：

```javascript
function createElement(node) {
  if (typeof node === 'string') {
    return document.createTextNode(node);
  }
  const $el = document.createElement(node.type);
  node
    .children
    .map(createElement)
    .forEach($el.appendChild.bind($el));
  return $el;
}
```

因为我们有两种类型的节点，`text` 和 `element`。因此 `createElement` 函数需要处理这两种情况。如果是 `element` 节点的话，需要递归地把它的子节点也构建起来。

现在完整的代码如下：

```html
<div id="root"></div>
```

```jsx
/** @jsx h */

function h(type, props, ...children) {
  return { type, props, children };
}

function createElement(node) {
  if (typeof node === 'string') {
    return document.createTextNode(node);
  }
  const $el = document.createElement(node.type);
  node
    .children
    .map(createElement)
    .forEach($el.appendChild.bind($el));
  return $el;
}

const a = (
  <ul class='list'>
    <li>item 1</li>
    <li>item 2</li>
  </ul>
);

const $root = document.getElementById('root');
$root.appendChild(createElement(a));
```

就像在 `React` 中，你仅仅只有一个 `root` 节点，其他所有的节点都将会在它里面。



#### 3、比较两棵虚拟 DOM 树的差异

**节点变化**

```javascript
function changed(node1, node2) {
  return typeof node1 !== typeof node2
    || typeof node1 === 'string' && node1 !== node2
    || node1.type !== node2.type;
}
```

**更新节点，编写 `updateElement`**

```javascript
function updateElement($parent, newNode, oldNode, index = 0) {
  if (!oldNode) {
    $parent.appendChild(
      createElement(newNode),
    );
  } else if (!newNode) {
    $parent.removeChild(
      $parent.childNodes[index],
    );
  } else if (changed(newNode, oldNode)) {
    $parent.replaceChild(
      createElement(newNode),
      $parent.childNodes[index],
    );
  } else if (newNode.type) {
    const newLength = newNode.children.length;
    const oldLength = oldNode.children.length;
    for (let i = 0; i < newLength || i < oldLength; i++) {
      updateElement(
        $parent.childNodes[index],
        newNode.children[i],
        oldNode.children[i],
        i,
      );
    }
  }
}
```

打开开发人员工具，观察当你按下“重新加载”按钮时，可以看到应用的变化：

<img src="../ImageHosting/React/react-diff-3.gif" alt="自己实现虚拟 DOM 树" />

> 实现的例子参考自完整代码：https://jsfiddle.net/cxin1427/cvdgtqup/



### 六、扩展阅读

以下几篇文章很不错，可以帮助我们更好地理解虚拟 `DOM` 和 `diff`  算法，推荐阅读。

- https://www.infoq.cn/article/react-dom-diff
- https://segmentfault.com/a/1190000018891454
- https://juejin.im/post/5c0c7304f265da613e22106c
- https://github.com/livoras/blog/issues/13
