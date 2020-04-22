---
title: React setState 的异步与同步
author: Deepspace
tags:
  - React
categories: React
date: 2019-08-19
urlname: react-setState
---

### 一、如何使用 setState

在 `React` 中，一个很重要的点就是不要直接去修改 `state`，类似于这样的写法：`this.state.count = 1` ，这种方式是无法触发 `React` 去更新视图的。因为 `React` 的机制中规定了：一个 `state` 的更新，首先需要调用 `setState` 方法：

```jsx
this.setState({
    count: 1
})
```

稍有经验的 `React` 开发者都会知道，`setState` 方法其实是**异步**的。即 `setState` 立马执行之后，是无法直接获取到最新的 `state` 的，需要经过 `React` 对 `state` 的所有改变进行合并处理之后，才会去计算新的虚拟 `DOM`，然后再根据最新的虚拟 `DOM` 去重新渲染真实 `DOM`。
<!-- more -->
我们看个例子：

```jsx
import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0,
    };
  }

  componentDidMount() {
    const { count } = this.state;
    this.setState({ count: count + 1 });
    this.setState({ count: count + 1 });
  }

  render() {
    const { count } = this.state;
    return (
      <div>
        <h1>Demo about setState</h1>
        <h2>{count}</h2>
      </div>
    );
  }
}

const rootElement = document.getElementById('root');
ReactDOM.render(<App />, rootElement);
```

输出结果为：

```
Demo about setState
1
```

通过结果我们可以看出：`React setState` 并不是同步的。那怎么才能获取到修改后的 `state` 呢？`React` 为我们提供了一个回调去实现：

```jsx
...
this.setState({count: this.state.count + 1}, ()=>{
    console.log(this.state.count) // 1
})
...
```

回调里的 `state` 便是最新的了，原因是该回调的执行时机在于 `state` 合并处理之后。如果我们按照上面的例子那样去做：

```jsx
...
	this.setState({count: this.state.count + 1})
	this.setState({count: this.state.count + 1})
...
```

实际最终的 `count` 会等于 `1`，原因是执行到第二行代码时，得到的 `this.state.count` 为 `0`。那怎么实现结果为 `2` 呢？

```jsx
...
	this.setState(prevState => {count: prevState.count + 1});
	this.setState(prevState => {count: prevState.count + 1});
...
```

`setState()` 实际上可以接受一个函数作为参数，函数的首个参数就是上一次的 `state`。

以上介绍了 `setState ` 的三种使用方式，下面我们来看看它们的执行时机是怎样的，看段代码：

```jsx
...
	this.setState({ count: this.state.count + 1 });
  console.log('console: ' + this.state.count); // 0
  this.setState({ count: this.state.count + 1 }, () => {
    console.log('console from callback: ' + this.state.count); // 2
  });
  this.setState((prevState) => {
    console.log('console from func: ' + prevState.count); // 1
    return {
      count: prevState.count + 1,
    };
  }, () => {
    console.log(`last console: ${  this.state.count}`); // 2
  });
...
```

控制台的执行结果：

```javascript
console: 0 
console from func: 1 
console from callback: 2
last console: 2 
```

`React` 其实会维护着一个 `state` 的更新队列，每次调用 `setState` 都会先把当前修改的 `state` 推进这个队列，最后，`React` 会对这个队列进行合并处理，然后去执行回调。根据最终的合并结果再去走下面的流程（更新虚拟`DOM`，触发渲染）。



### 二、setState 为什么要设计成异步的形式

因为 `setState` 之后，无法立即获取最新的 `state` ，给人的感觉像是用**异步**的方式去设置状态。那 `setState` 到底是不是异步的呢？

看个 `demo` ：

```jsx
import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0,
    };
  }

  componentDidMount() {
    // 生命周期中调用
    this.setState({ count: this.state.count + 1 });
    console.log(`lifecycle: ${this.state.count}`);
    setTimeout(() => {
      // setTimeout中调用
      this.setState({ count: this.state.count + 1 });
      console.log(`setTimeout: ${this.state.count}`);
    }, 0);
    document.getElementById('div2').addEventListener('click', this.increment2);
  }

  increment = () => {
    // 合成事件中调用
    this.setState({ count: this.state.count + 1 });
    console.log(`react event: ${this.state.count}`);
  };

  increment2 = () => {
    // 原生事件中调用
    this.setState({ count: this.state.count + 1 });
    console.log(`dom event: ${this.state.count}`);
  };

  render() {
    return (
      <div className="App">
        <h2>
          couont:
          {this.state.count}
        </h2>
        <div id="div1" onClick={this.increment}>
          click me and count+1
        </div>
        <div id="div2">click me and count+1</div>
      </div>
    );
  }
}

const rootElement = document.getElementById('root');
ReactDOM.render(<App />, rootElement);
```

> 这里需要提前了解一下 `react` 的事件机制：`react` 为了解决跨平台，兼容性问题，自己封装了一套事件机制，代理了原生的事件，像在 `jsx` 中常见的 `onClick`、`onChange` 这些都是合成事件。

在上面的 `demo` 中我们用了 `4` 种方式调用 `setState()`，后面紧接着去取最新的 `state`，如果按照异步原理，应该是取不到的。然而，在 `setTimeout` 中调用以及原生事件中调用的话，是可以立马获取到最新的 `state` 的。根本原因在于，`setState` 并不是真正意义上的异步操作，它只是模拟了异步的行为。

**`React` 中会去维护一个标识（`isBatchingUpdates`），判断是直接更新还是先暂存 `state` 进队列。**

**`setTimeout` 以及原生事件都会直接去更新 `state` ，因此可以立即得到最新 `state`。而合成事件和 `React` 生命周期函数中，是受 `React` 控制的，其会将 `isBatchingUpdates` 设置为 `true`，从而走的是类似异步的那一套机制**。

那么为什么 `React` 要把状态的更新设计成这种方式呢？直接 `this.state.count = 1` 不可以吗？ `FaceBook` 做了解释：https://github.com/facebook/react/issues/11527#issuecomment-360199710

原因简单总结下：

- 保证内部的一致性：即使 `state` 是同步更新，`props` 也不是。（你只有在父组件重新渲染时才能知道`props`）
- 将 `state` 的更新延缓到最后批量合并再去渲染对于应用的性能优化是有极大好处的，如果每次的状态改变都去重新渲染真实 `dom`，那么它将带来巨大的性能消耗。



### 三、函数式组件的 useState

```jsx
import React, { useState } from 'react';
import ReactDOM from 'react-dom';

const App = () => {
  const [count, setCount] = useState(0);
  const [message, setMessage] = useState('');

  function increment() {
    setCount(count + 1);
    setMessage(`count is ${count}`);
  }

  function decrement() {
    setCount(count - 1);
    setMessage(`count is ${count}`);
  }

  return (
    <div className="App">
      <h1>Update Count!</h1>
      <p>
        Count:
        {' '}
        {count}
      </p>
      <p>{message}</p>
      <button type="button" onClick={increment}>
        +
      </button>
      <button type="button" onClick={decrement}>
        -
      </button>
    </div>
  );
};

const rootElement = document.getElementById('root');
ReactDOM.render(<App />, rootElement);
```

`message` 中的值总是会比 `count` 的值少 `1`。所以，函数式组件的表现情况和 `class` 组件是一样的。那针对于函数式组件，我们怎么去拿到最新的 `state` 呢？

#### 1、使用 useEffect

```jsx
import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';

const App = () => {
  const [count, setCount] = useState(0);
  const [message, setMessage] = useState('');

  const increment = () => {
    setCount(count + 1);
    setMessage(`count is ${count}`);
  }

  const decrement = () => {
    setCount(count - 1);
    setMessage(`count is ${count}`);
  }

  // 使用 useEffect
  useEffect(() => setMessage(`count is ${count}`), [count, message]);

  return (
    <div className="App">
      <h1>Update Count!</h1>
      <p>
        Count:
        {' '}
        {count}
      </p>
      <p>{message}</p>
      <button type="button" onClick={increment}>
        +
      </button>
      <button type="button" onClick={decrement}>
        -
      </button>
    </div>
  );
};

const rootElement = document.getElementById('root');
ReactDOM.render(<App />, rootElement);
```

如果你还不清楚 `uesEffect` 如何使用，可以看这里：https://togoblog.cn/react-hook/#toc-heading-9



#### 2、封装一个 useAsyncState

使用 `Promise` 进行封装，但是不接受回调，因为这样很容易引起回调地狱。

```jsx
function useAsyncState(initialValue) {
  const [value, setValue] = useState(initialValue);
  const setter = (x) => new Promise((resolve) => {
    setValue(x);
    resolve(x);
  });
  return [value, setter];
}
```

如何使用呢？像使用 `useState` 一样去使用：

```jsx
import React, { useState } from 'react';
import ReactDOM from 'react-dom';

function useAsyncState(initialValue) {
  const [value, setValue] = useState(initialValue);
  const setter = (x) => new Promise((resolve) => {
    setValue(x);
    resolve(x);
  });
  return [value, setter];
}

const App = () => {
  const [count, setCount] = useAsyncState(0);
  const [message, setMessage] = useAsyncState('');

  const increment = () => {
    setCount(count + 1).then((count) => setMessage(`count is ${count}`));
  };

  const decrement = () => {
    setCount(count - 1).then((count) => setMessage(`count is ${count}`));
  };

  return (
    <div className="App">
      <h1>Update Count!</h1>
      <p>
        Count:
        {count}
      </p>
      <p>{message}</p>
      <button type="button" onClick={increment}>
        +
      </button>
      <button type="button" onClick={decrement}>
        -
      </button>
    </div>
  );
};

const rootElement = document.getElementById('root');
ReactDOM.render(<App />, rootElement);
```
