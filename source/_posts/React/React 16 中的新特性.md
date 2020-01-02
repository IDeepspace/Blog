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

但是现在 `Dialog` 被包在其他组件中，那就要用 `CSS` 的 `position` 属性控制 `Dialog` 位置了，就要求从 `Dialog` 往上一直到 `body` ，没有其他 `position` 是 `relative` 的元素的干扰，显然这是比较麻烦的。同时， `Dialog` 的样式也会与其它组件混在一起。

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

#### 旧的生命周期

我们先看看 `React 16` 之前的生命周期图：

![Reactv15生命周期图](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/React/react15-lifecycle.png)

<p align="center">(图片来自网络)</p>
如上图所示，可以把组件的生命周期大致分为三个阶段：

- 挂载阶段 (Mount)
- 更新阶段 (Update)
- 卸载阶段 (Unmount)

##### 挂载阶段

**constructor()**

```
挂载之前调用一次，可以初始化state
```

**getDefaultProps()**

```
设置默认的 props ，也可以用 dufaultProps 设置组件的默认属性。
```

**getInitialState()**

```
初始化 state，可以直接在 constructor 中定义 this.state
```

**componentWillMount()**

```
componentWillMount 会在组件 render 之前执行，并且永远都只执行一次。

componentWillMount 和挂载是同步执行的，意味着执行完这个钩子，立即挂载。

由于这个方法始终只执行一次，所以如果在这里定义了 setState 方法之后，页面永远都只会在加载前更新一次。
```

**render()**

```
react 最重要的步骤，创建虚拟 dom，进行 diff 算法，更新 dom 树都在此进行
```

**componentDidMount()**

```
这个方法会在组件加载完毕之后立即执行。在这个时候之后组件已经生成了对应的 DOM 结构，可以通过 this.getDOMNode() 来进行访问。

如果你想和其他 JavaScript 框架一起使用，可以在这个方法中执行 setTimeout, setInterval 或者发送 AJAX 请求等操作(防止异部操作阻塞UI)。
```



##### 更新阶段

**componentWillReceivePorps(nextProps)**

```
在组件接收到一个新的 prop 时被执行。这个方法在初始化 render 时不会被调用。
```

**shouldComponentUpdate(nextProps, nextState)**

```
组件接收到新的 props 或者 state 时调用，在初始化时或者使用 forceUpdate 时不被执行。return true 就会更新 dom（使用diff算法更新），return false 能阻止更新（不调用render）。

可以在你确认不需要更新组件时使用，提升性能。
```

**componentWillUpdata(nextProps, nextState)**

```
组件挂载时不调用，只有在组件将要更新时才调用。

shouldComponentUpdate 生命周期钩子返回 true，或者调用 this.forceUpdate 之后，会立即执行该生命周期钩子。

要特别注意，componentWillUpdate 生命周期钩子每次更新前都会执行，所以在这里调用 this.setState 非常危险，有可能会没完没了。
```

**render()**

```
react 最重要的步骤，创建虚拟 dom，进行 diff 算法，更新 dom 树都在此进行
```

**componentDidUpdate(nextProps, nextState, snapshot)**

```
这是组件更新之后触发的生命周期钩子。

componentDidUpdate 生命周期钩子每次更新后都会执行，所以在这里调用 this.setState 也非常危险，有可能会没完没了。

搭配 getSnapshotBeforeUpdate 生命周期钩子(React 16 中的新生命周期)使用的时候，第三个参数是 getSnapshotBeforeUpdate 的返回值。
```



##### 卸载阶段

**componentWillUnmount()**

```
组件渲染之后，卸载之前的生命周期钩子，只调用一次。

React的最佳实践是，组件中用到的事件监听器、订阅器、定时器都要在这里销毁。

事件监听指的是下面这种情况：
componentDidMount() {
    document.addEventListener('click', () => {});
}

下面这种 React 会自动销毁
render(
    return (
        <button onClick={this.handleClick}>click</button>
    );
)
```



#### 新的生命周期

再来看下 `React v16.4` 的生命周期图：

![Reactv16.4生命周期图](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/React/reactv16.4-lifecycle.jpg)

<p align="center">(图片来自网络)</p>
`React16` 废弃的三个生命周期函数：

- componentWillMount

- componentWillReceiveProps

- componentWillUpdate

  目前在 `React 16` 版本中，官方并未完全删除这三个函数，而且新增了`UNSAFE_componentWillMount`， `UNSAFE_componentWillReceiveProps`，`UNSAFE_componentWillUpdate `三个函数，计划在 `React 17` 的版本中移除掉这三个函数，目的是为了做向下兼容，为什么会移除这三个生命周期函数呢？

**componentWillMount**

```
很多人会有一个误区：这个钩子是请求数据然后将数据插入元素一同挂载的最佳时机。

其实 componentWillMount 和挂载是同步执行的，意味着执行完这个钩子，立即挂载。而向服务器请求数据是异步执行的。所以无论请求多么快，都要排在同步任务之后再处理。也就是说，永远不可能在这里将数据插入元素一同挂载。

并不是说不能在这里请求数据，而是达不到你臆想的效果。

它被废弃的原因主要有：

- 。
- 如果它声明了定时器或者订阅器，在服务端渲染中，componentWillUnmount 生命周期钩子中的清除代码不会生效。因为如果组件没有挂载成功，componentWillUnmount 是不会执行的。没有挂载就没有卸载。
- 在异步渲染中，它的表现不稳定。

初始化 this.state 应该在 constructor 生命周期钩子中完成，请求数据应该在 componentDidMount 生命周期钩子中完成，所以本来它就没什么用。可能当初创造它是为了成双成对吧，所以才被完全废弃了。
```

**componentWillReceiveProps**

```
componentWillReceiveProps 生命周期钩子只有一个参数，更新后的 props。

该声明周期函数可能在两种情况下被触发：

- 组件接收到了新的属性。
- 组件没有收到新的属性，但是由于父组件重新渲染导致当前组件也被重新渲染。

初始化时并不会触发该生命周期钩子。

因为 Fiber 机制的引入，这个生命周期钩子有可能会多次触发。
```

**componentWillUpdate**

```
shouldComponentUpdate 生命周期钩子返回 true，或者调用 this.forceUpdate 之后，会立即执行该生命周期钩子。

要特别注意，componentWillUpdate 生命周期钩子每次更新前都会执行，所以在这里调用 this.setState 非常危险，有可能会没完没了。

同样，因为Fiber机制的引入，这个生命周期钩子有可能会多次调用。
```



新增加了两个新的生命周期函数

- static getDerivedStateFromProps
- getSnapshotBeforeUpdate

##### getDerivedStateFromProps

```
static getDerivedStateFromProps(nextProps, prevState)，它是一个静态方法，所以不能再这个函数里面使用 this；

这个函数有两个参数： props 和 state，分别指接收到的新参数和当前的 state 对象；

该函数会返回一个对象用来更新当前的 state 对象，如果不需要更新状态可以返回 null 来表明不需要更新任何状态；

该函数会在挂载时，接收到新的 props，调用了 setState 和 forceUpdate 时被调用，简单点说就是：getDerivedStateFromProps 无论是在挂载阶段还是更新阶段，也无论是什么引起的更新，统统都会被调用，在首次渲染的时候也会被触发 (注意：v16.3 中，setState 时、forceUpdate 时不会执行这个方法，v16.4 修复了这个问题)。

和 componentWillReceiveProps 不同，componentWillReceiveProps 只在父组件引起的更新时才会触发。
```

一个简单的例子：

```jsx
import React, { Component } from 'react';

class A extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.name,
      counter: 0,
    };
  }

  // componentWillReceiveProps(nextProps) {
  //   console.log('Running A.componentWillReceiveProps()');
  // }

  static getDerivedStateFromProps(nextProps, prevState) {
    console.log('Being called');
    if (nextProps.name !== prevState.name) {
      console.log('Running A.getDerivedStateFromProps()');
      return {
        name: nextProps.name,
      };
    }
    return null;
  }

  handleClick = () => {
    let { counter } = this.state;
    this.setState({
      counter: counter++,
    });
  };

  render() {
    console.log('A.render()');
    return (
      <div>
        <div>Hello {this.state.name}</div>
        <button onClick={this.handleClick}>{this.state.counter}</button>
      </div>
    );
  }
}

class B extends Component {
  constructor() {
    super();
    this.state = { counter: 0 };
  }

  render() {
    return <A name='World' />;
  }

  componentDidMount() {
    setInterval(() => {
      this.setState({
        counter: this.state.counter + 1,
      });
    }, 1000);
  }
}

export default B;
```

`getDerivedStateFromProps ` 是用来替代 `componentWillReceiveProps` 的，应对 `state` 需要关联 `props` 变化的场景。它的作用就是让组件根据父组件传来的 `props`，判断是否需要更新自己的 `state` ，这种state叫做衍生state。返回的对象就是要增量更新的state。

将 `getDerivedStateFromProps` 设计成静态函数，目的是保持该方法的纯粹，它就是用来定义衍生state的，能做的操作局限在根据 `props` 和 `state` 决定新的 `state`，除此之外不应该在里面执行任何操作。

一般使用场景如下：

1. 无条件的根据 `props` 更新 `state`
2. 当 `props` 和 `state` 的不匹配情况更新 `state`



##### getSnapshotBeforeUpdate

```
顾名思义，保存状态快照用的。

它会在组件即将挂载时调用，注意，是即将挂载。它甚至调用的比 render 还晚，由此可见 render 并没有完成挂载操作，而是进行构建抽象 UI 的工作。getSnapshotBeforeUpdate 执行完就会立即调用 componentDidUpdate 生命周期钩子。

它是做什么用的呢？有一些状态，比如网页滚动位置，不需要它持久化，只需要在组件更新以后能够恢复原来的位置即可。

getSnapshotBeforeUpdate 生命周期钩子返回的值会被 componentDidUpdate 的第三个参数接收，我们可以利用这个通道保存一些不需要持久化的状态，用完即可舍弃。

很显然，它是用来取代 componentWillUpdate 生命周期钩子的。

意思就是说呀，开发者一般用不到它。
```



> 本篇内容代码：<https://github.com/IDeepspace/React-Workshop/tree/master/react-16-api>


