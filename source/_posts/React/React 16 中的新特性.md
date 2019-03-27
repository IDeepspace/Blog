---
title: React 16 中的新特性
author: Deepspace
tags:
  - React
  - Portals
  - ErrorBoundary
categories: React
date: 2019-03-23
urlname: react-new-api-in-16
---

<!-- ## React 16 中的新特性 -->

对于 `React v16` 之后版本中的一些新特性，挑选了以下几个常用的 `Api` 来讲解 :

- Render 方法优化
- 错误边界
- Portals
- Context API
- 新的生命周期

后面会持续更新。

### 一、Render 方法优化

为了符合 `React` 的 `component tree` 和 `diff` 结构设计，在组件的 `render`  方法中，顶层必须包裹为单节点，因此我们在实际组件的设计和使用中，需要注意尽量避免嵌套后的层级变深。
<!-- more -->
比如下面的内容结构就必须再嵌套一个 `div` 使其变成单节点再返回：

```jsx
render() {
  return (
    <div>
      <div>one</div>
      <div>two</div>
      <div>three</div>
    </div>
  );
}
```

`React v16` 之后，这个问题得到了改进，`render` 方法支持返回数组和字符串了: 

```jsx
render() {
  let data = [
    { value: 'One', key: '1' },
    { value: 'Two', key: '2' },
    { value: 'Three', key: '3' },
  ];
  return data.map(item => {
    // Don't forget the keys :)
    return <li key={item.key}>{item.value}</li>;
  });
}
```

支持返回数组之后，有时候我们的代码可能长成下面这个样子：

```jsx
render() {
   return [
     "Some text.",
     <h2 key="heading-1">A heading</h2>,
     "More text.",
     <h2 key="heading-2">Another heading</h2>,
     "Even more text."
   ];
}
```

虽然减少了一层嵌套，但是代码看上去不简洁：

- 数组中的元素必须以逗号分隔；
- 数组中的子节点都必须添加一个 `key` 属性来避免 `React` 的警告；
- 字符串必须用引号括起来。

所以，在 `React v16.2` 中，官方又推出了 `Fragment` 组件来代替直接 `render` 数组的方式：

```jsx
render() {
  return (
    <Fragment>
      Some text.
      <h2>A heading</h2>
      More text.
      <h2>Another heading</h2>
      Even more text.
    </Fragment>
  );
}
```

`Fragment` 虽然也是一个正常单节点写法，直接包裹里面的内容。但是 `Fragment` 本身并不会产生真实的 `DOM` 节点，因此也不会导致层级嵌套增加。`Fragment` 组件也提供了简写的方式：

```jsx
render() {
  return (
    <>
      Some text.
      <h2>A heading</h2>
      More text.
      <h2>Another heading</h2>
      Even more text.
    </>
  );
}
```

如果需要给 `Fragment` 添加 `key` 属性，是不支持使用简写的。（这也是 `Fragment` 唯一会遇到需要添加 `props` 的情况：

```jsx
function Glossary(props) {
  return (
    <dl>
      {props.items.map(item => (
        // Without the `key`, React will fire a key warning
        <Fragment key={item.id}>
          <dt>{item.term}</dt>
          <dd>{item.description}</dd>
        </Fragment>
      ))}
    </dl>
  );
}
```



### 二、错误边界

`UI` 部分的一个 `JavaScript` 错误不应该破坏整个程序。为了解决这个问题，`React v16` 引入了**错误边界**的新概念。

错误边界是**用于捕获其子组件树 `JavaScript` 异常，记录错误并展示一个回退的 UI** 的 `React` 组件，而不是整个组件树的异常。错误边界在渲染期间、生命周期方法内、以及整个组件树构造函数内捕获错误。

下面的例子是通过一个 `ErrorBoundary` 组件对其内的内容进行保护和错误捕捉，并在发生错误时进行回退的UI展示：

```jsx
class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { error: null, errorInfo: null };
  }

  componentDidCatch(error, errorInfo) {
    // Catch errors in any components below and re-render with error message
    this.setState({
      error: error,
      errorInfo: errorInfo,
    });
    // You can also log error messages to an error reporting service here
  }

  render() {
    if (this.state.errorInfo) {
      // Error path
      return (
        <div>
          <h2>Something went wrong.</h2>
          <details style={{ whiteSpace: 'pre-wrap' }}>
            {this.state.error && this.state.error.toString()}
            <br />
            {this.state.errorInfo.componentStack}
          </details>
        </div>
      );
    }
    // Normally, just render children
    return this.props.children;
  }
}
```

然后我们就可以像一个普通的组件一样使用：

```jsx
class BuggyCounter extends Component {
  constructor(props) {
    super(props);
    this.state = { counter: 0 };
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.setState(({ counter }) => ({
      counter: counter + 1,
    }));
  }

  render() {
    if (this.state.counter === 5) {
      // Simulate a JS error
      throw new Error('I crashed!');
    }
    return <h1 onClick={this.handleClick}>{this.state.counter}</h1>;
  }
}

function App() {
  return (
    <div>
      <ErrorBoundary>
        <p>
          These two counters are inside the same error boundary. If one crashes,
          the error boundary will replace both of them.
        </p>
        <BuggyCounter />
        <BuggyCounter />
      </ErrorBoundary>
      <hr />
      <p>
        These two counters are each inside of their own error boundary. So if
        one crashes, the other is not affected.
      </p>
      <ErrorBoundary>
        <BuggyCounter />
      </ErrorBoundary>
      <ErrorBoundary>
        <BuggyCounter />
      </ErrorBoundary>
    </div>
  );
}
```

错误边界工作机制类似于 `JavaScript`  中的 `catch {}` 。注意：仅有类组件可以成为错误边界。

在实际开发中，大多数情况下，我们可以只定义一个错误边界组件，并将它贯穿整个应用。

> 注意：错误边界**无法**捕获如下错误:
>
> - 事件处理 （[了解更多](https://reactjs.org/docs/error-boundaries.html#how-about-event-handlers)）
> - 异步代码 （例如 `setTimeout` 或 `requestAnimationFrame` 回调函数）
> - 服务端渲染
> - 错误边界自身抛出来的错误 （而不是其子组件）



### 三、Portals

`createPortal `  这个 `Api` 用于将子节点渲染到父组件以外的 `DOM` 节点上。`createPortal` 的出现为弹窗、对话框等脱离文档流的组件开发提供了很大的便利。

现在我们来想一下，如果需要显示一个对话框(`Dialog`)，该怎么做呢？

最直观的做法，就是直接在 `JSX` 中把 `Dialog` 画出来，像下面代码的样子：

```jsx
<div>
   <div> ... </div>
   { needDialog ? <Dialog /> : null }
</div>
```

那么这样就有一个问题：这样渲染的话，`Dialog` 最终渲染产生的 `HTML` 就和上面非 `Dialog` 内容的 `JSX` 产生的`HTML` 混在一起了，像下面这样：

```jsx
<div>
   <div> ... </div>
   <div class="dialog">Dialog Content</div>
</div>
```

而对于对话框，从用户的感知角度来说，它应该是一个独立的组件。

但是现在 `Dialog` 被包在其他组件中，那就要用 `CSS` 的 `position` 属性控制 `Dialog` 位置了，就要求从 `Dialog` 往上一直到 `body` ，没有其他 `postion` 是 `relative` 的元素的干扰，显然这是比较麻烦的。同时， `Dialog` 的样式也会与其它组件混在一起。

解决这个问题，我们可以在 `React` 组件树的最顶层创建一个专属于 `Dialog` 的元素，然后通过 `Redux` 或者其他什么通讯方式给这个 `Dialog` 发送信号，来控制 `Dialog` 显示或者不显示。但是这样又会造成 "杀鸡焉用牛刀" 的问题：我们只是为了一个 `Dialog` 却引入了 `Redux` 。

在 `React 16` 之前，也有实现 "传送门" 的方式，但是官方一直并不鼓励使用，所以这里也不作深入讨论。`React 16` 后，使用 `createPortal Api` 创建 `Dialog` 组件就简单多了，不需要牵扯到 `componentDidMount`、`componentDidUpdate` 等生命周期问题，也不用调用 `API` 清理 `Portal`，关键代码在 `render` 中，我们看一下 [官方给的 `demo` ](<https://codepen.io/gaearon/pen/yzMaBd>) :

首先在 `public/index.html` 中新建一个根节点：

```jsx
<body>
	<div id="root"></div>
	<div id="modal-root"></div>
</body>
```

通过  `createPortal Api`  创建一个 "传送门"：

```jsx
import { Component } from 'react';
import ReactDOM from 'react-dom';

const modalRoot = document.getElementById('modal-root');

class Modal extends Component {
  constructor(props) {
    super(props);
    // Create a div that we'll render the modal into. Because each
    // Modal component has its own element, we can render multiple
    // modal components into the modal container.
    this.el = document.createElement('div');
  }

  componentDidMount() {
    // Append the element into the DOM on mount. We'll render
    // into the modal container element (see the HTML tab).
    modalRoot.appendChild(this.el);
  }

  componentWillUnmount() {
    // Remove the element from the DOM when we unmount
    modalRoot.removeChild(this.el);
  }

  render() {
    // Use a portal to render the children into the element
    return ReactDOM.createPortal(
      // Any valid React child: JSX, strings, arrays, etc.
      this.props.children,
      // A DOM element
      this.el,
    );
  }
}
export default Modal;
```

使用 `Modal` :

```jsx
import React, { Component } from 'react';
import Modal from './Modal';
import './style.css';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { showModal: false, clicks: 0 };
  }

  handleShow = () => {
    this.setState({ showModal: true });
  };

  handleHide = () => {
    this.setState({ showModal: false });
  };

  handleClick = () => {
    // This will fire when the button in Child is clicked,
    // updating Parent's state, even though button
    // is not direct descendant in the DOM.
    this.setState(prevState => ({
      clicks: prevState.clicks + 1,
    }));
  };

  render() {
    // Show a Modal on click.
    // (In a real app, don't forget to use ARIA attributes
    // for accessibility!)
    const modal = this.state.showModal ? (
      <Modal>
        <div className='modal'>
          <button onClick={this.handleHide}>Hide modal</button>
          <button onClick={this.handleClick}>Click</button>
        </div>
      </Modal>
    ) : null;

    return (
      <div className='app'>
        <p>Number of clicks: {this.state.clicks}</p>
        This div has overflow: hidden.
        <button onClick={this.handleShow}>Show modal</button>
        {modal}
      </div>
    );
  }
}

export default App;
```

上面的代码中，`App` 组件通过 `Portal` 把里面的内容渲染到了一个独立的节点上，在实际的 `DOM` 结构中，`modal` 里面的内容已经脱离了 `App` 组件本身的 `DOM` 树而存在于另一个独立节点。对于要通过 `createPortal()  ` "分离" 出去的内容，它的数据传递，生命周期，甚至事件冒泡，依然存在于原本的抽象组件树结构当中。这里实际依赖于 `React` 代理和重写了整套事件系统，让整个抽象组件树的逻辑得以保持同步。

运行上面的代码可以查看效果。



### 四、Context API

参考：<https://togoblog.cn/react-component-communication/#toc-heading-5>



### 五、新的生命周期
。。。。。。



> 本篇内容代码：<https://github.com/IDeepspace/React-Workshop/tree/master/react-16-api>

