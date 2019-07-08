---
title: React v16.8 Hook 功能
author: Deepspace
tags:
  - React
  - React Hook
categories: React
date: 2019-04-20
urlname: react-hook
---

## React v16.8 Hook 功能

`Hook` 是 `React v16.8` 的新增特性。它可以让你在不创建 `class`  式组件的情况下使用 `state` 以及其他的 `React` 特性。

### 一、 `React Hook` 出现的背景

我们知道，`React` 的核心思想就是：将一个页面拆分成一些独立的、可复用的组件，并且用自上而下的单向数据流的形式将这些组件串联起来。 

但是在实际项目中，很多组件式非常冗杂且难以复用的。对于那些 `class` 式的组件，因为它们本身包含了自己的状态( `state` )，所以这类组件复用起来是非常麻烦的。对于这个问题，`React` 官方也给出了两种推荐的解决方式：

- 渲染属性( [`Render Props`](<https://reactjs.org/docs/render-props.html>) )
- 高阶组件( [`Higher-Order Components` ](<https://zh-hans.reactjs.org/docs/higher-order-components.html#___gatsby>))
<!-- more -->



#### 渲染属性

渲染属性指的是使用一个值为函数的 `prop` 来传递需要动态渲染的  `nodes` 或组件。

看个例子：

```jsx
import React, { Component } from 'react';

class DataProvider extends Component {
  constructor(props) {
    super(props);
    this.state = {
      target: 'DianDian',
    };
  }

  render() {
    return <div>{this.props.render(this.state)}</div>;
  }
}

<DataProvider
  render={data => {
    return <Dog target={data.target} />;
  }}
/>
```

` DataProvider ` 组件包含了所有跟状态相关的代码，而 `Dog` 组件则可以是一个单纯的展示组件，这样一来 `DataProvider` 就可以单独复用了。



#### 高阶组件

参考：<https://togoblog.cn/react-high-order-component/>



这两种方式看起来都很好，很多 `React` 的第三方库也都在用。但是这两种方式会增加我们代码的层级关系。



#### 复杂的生命周期函数

我们通常希望一个函数只做一件事情，但是在生命周期钩子函数里面，通常会做很多事情。比如我们需要在 `componentDidMount` 中发起 `ajax` 请求来获取数据、绑定一些事件监听等等。同时，用时候我们还需要在 `componrntDidUpdate` 里面再做一遍同样的事情。随着项目越来越复杂，这部分的代码也变得越来越庞杂、不直观。



#### 令人困惑的 class

我们用创建 `class` 式组件的时候，会一直遇到一件比较麻烦的事情：`this` 的指向。为了保证 `this` 的指向正确，我们要经常写这样的代码：`this.handleClick = this.handleClick.bind(this)`，或者是这样的代码：`<button onClick={() => this.handleClick(e)}>` 。看着觉得很啰嗦，而且还要随时注意不要绑定错 `this` 。



#### 无状态组件的无奈

我们在写 `React` 组件的时候，会尽可能把组件写成无状态组件的形式，更方便复用和独立测试。但是往往，我们用 `function` 创建了一个简洁完美的组件，后来需要发生变动，该组件必须得有自己的状态，这个时候我们又得很麻烦地将函数式组件改成 `class` 式组件。



### 二、Hook 是什么？

`Hook` 是一些可以让你在函数组件里 “钩入”  `React state` 及生命周期等特性的**函数**。`Hooks` 使开发人员可以在任何地方都能够进入 `React` 的 `state` 和生命周期。它通过消除模板语法 ( `super(props)`，`componentDidMount`，函数绑定等)，简化了组件。`Hook` 还允许我们将一些逻辑封装到自定义的 `hooks` 中，并在整个应用程序中重用它们。

> 注意：`Hook` 不能在 `class` 组件中使用。

**什么时候我会用 Hook？** 

如果我们需要在函数式组件中添加一些 `state` ，以前的做法是必须将其它转化为 `class`。现在我们可以在现有的函数组件中使用 `Hook`。如果你的项目中 `React` 的版本已经升级到 `v16.8`，那完全可以使用 `React Hook` 功能来创建组件。



### 三、State Hook

`useState` 钩子是 `setState` 的替代品。`API` 允许我们通过一次调用定义状态变量和 `setter` 函数。

看一个计数器的例子：当用户点击 `button` 按钮，计数器的值就会增加。我们先看看使用  `class` 的方式：

```jsx
class Example extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0
    };
  }

  render() {
    return (
      <div>
        <p>You clicked {this.state.count} times</p>
        <button onClick={() => this.setState({ count: this.state.count + 1 })}>
          Click me
        </button>
      </div>
    );
  }
}
```

使用 `Hook` 属性：

```jsx
import React, { useState } from 'react';

function Example() {
  // 声明一个叫 "count" 的 state 变量
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
```

在类组件中，我们使用 `this.state` 来保存组件状态，并对其修改触发组件重新渲染。而在函数组件中，由于没有 `this` ，`React` 通过 `useState` 来帮我们保存组件的状态。

- `useState` 是 `React` 自带的一个 `Hook` 函数，被用来声明组件的状态变量。`useState` 这个函数接收的参数是状态初始值（`initial state`），它返回了一个数组，这个数组的第 `[0]` 项是当前当前的状态值，第 `[1]` 项是可以改变状态值的方法函数，相当于 `this.state`。

- 读取状态的时候，直接引用状态变量就可以了，再也不需要写成 `this.state.count` 这样。

- 更新状态时，我们直接调用 `setCount` 函数，这个函数接受的参数就是修改过的新的状态值。



**如果一个组件有多个状态值怎么办？**

```jsx
function ExampleWithManyStates() {
  const [age, setAge] = useState(42);
  const [fruit, setFruit] = useState('banana');
  const [todos, setTodos] = useState([{ text: 'Learn Hooks' }]);
  ...
}  
```

我们可以像上面这样写，`useState` 是可以多次调用的。并且，`useState` 接收的初始值没有规定一定要是 `string/number/boolean` 等这些简单的数据类型，也可以接受对象或者数组作为参数。



### 四、Effect Hook

我们在上面 `useState` 的例子中添加一个功能：修改 `document.title` :

`class` 式写法：

```jsx
class Example extends Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0,
    };
  }

  componentDidMount() {
    document.title = `You clicked ${this.state.count} times`;
  }

  componentDidUpdate() {
    document.title = `You clicked ${this.state.count} times`;
  }

  render() {
    return (
      <div>
        <p>You clicked {this.state.count} times</p>
        <button onClick={() => this.setState({ count: this.state.count + 1 })}>
          Click me
        </button>
      </div>
    );
  }
}
```

如果使用 `Hook` ，我们可以这样写：

```jsx
function Example() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    document.title = `You clicked ${count} times`;
  });

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

我们写的有状态的组件，通常会执行很多副作用的东西，副作用是什么？比如通过 `ajax` 请求数据、添加一些监听的注册和取消注册以及手动修改 `React` 组件中的 `DOM` 等等，都被称为副作用( `side effect` )。我们之前会把这些处理副作用的函数写在生命周期的函数里面，比如 `componentDidMount` 、`componentDidUpdate` 和 `componentWillMount` 。现在我们可以使用 `useEffect` 函数来替代它们。

合理的做法是：给每一个副作用添加一个单独的 `useEffect` ，这样一来，这些副作用就不再用堆在生命周期函数里面，代码会变得更加清晰。

我们来具体看看上面的例子里面， `useEffect`  做了什么：

- 声明了一个状态变量 `count`，将它的初始值设置为 0；
- 告诉 `React` 组件，有一个副作用。给  `useEffect` 传入一个匿名函数，这个匿名函数就是我们的副作用。在这个副作用里面，我们通过调用 `brower API` 来修改文档的标题。

> 这里需要注意：`React` 首次渲染和之后的每一次渲染都会调用一遍传给 `useEffect` 的函数。

**`useEffect api` 将函数回调作为第一个参数，将可选的条件数组作为第二个参数(待会介绍)。**



**`useEffect` 怎么解绑一些副作用** ?

这种场景也是非常常见的：当我们在 `componentDidMount` 里添加了一个注册，我们得马上在`componentWillUnmount` 中，也就是组件被注销之前清除掉添加的注册，否则就会导致内存泄漏的问题。

怎么清除呢？我们可以在 `useEffect` 函数中返回一个函数，`React` 会在组件卸载时调用这个函数，所以我们可以把清理函数放在这里。看个例子：

```jsx
import React, { useState, useEffect } from 'react';
import logo from './avatar.png';

function Scroll() {
  const [scrollDepth, setScrollDepth] = useState(0);

  function determineUserScrollDepth() {
    const scrolled =
      document.documentElement.scrollTop || document.body.scrollTop;
    setScrollDepth(scrolled);
  }

  useEffect(() => {
    window.addEventListener('scroll', determineUserScrollDepth);

    return function unbindScrollListener() {
      window.removeEventListener('scroll', null);
    };
  });

  return (
    <div className='App'>
      <header className='App-header'>
        <img src={logo} className='App-logo' alt='logo' />
        You've scrolled this far: {scrollDepth}
        <p>
          Lorem Ipsum is simply dummy text of the printing and typesetting
          industry. Lorem Ipsum has been the industry's standard dummy text ever
          since the 1500s, when an unknown printer took a galley of type and
          scrambled it to make a type specimen book. It has survived not only
          five centuries, but also the leap into electronic typesetting,
          remaining essentially unchanged. It was popularised in the 1960s with
          the release of Letraset sheets containing Lorem Ipsum passages, and
          more recently with desktop publishing software like Aldus PageMaker
          including versions of Lorem Ipsum. Why do we use it? It is a long
          established fact that a reader will be distracted by the readable
          content of a page when looking at its layout. The point of using Lorem
          Ipsum is that it has a more-or-less normal distribution of letters, as
          opposed to using 'Content here, content here', making it look like
          readable English. Many desktop publishing packages and web page
          editors now use Lorem Ipsum as their default model text, and a search
          for 'lorem ipsum' will uncover many web sites still in their infancy.
          Various versions have evolved over the years, sometimes by accident,
          sometimes on purpose (injected humour and the like).
        </p>
      </header>
    </div>
  );
}

export default Scroll;
```

这个例子在向上或向下滚动页面时打印出用户的滚动位置。我们在 `useEffect` 中返回的函数里清除掉事件监听。

> 这里需要注意：`useEffect` 里返回函数这种解绑模式跟 `componentWillUnmount` 不一样。`componentWillUnmount` 只会在组件被销毁前执行一次，而 `useEffect` 里返回函数每次组件渲染后都会执行一遍，包括返回的清理函数也会重新执行一遍。



**为什么要让副作用函数再每次组件更新的时候都执行一遍呢？**

我们看看以前的模式：

```jsx
...
componentDidMount() {
  ChatAPI.subscribeToFriendStatus(
    this.props.friend.id,
    this.handleStatusChange
  );
}

componentWillUnmount() {
  ChatAPI.unsubscribeFromFriendStatus(
    this.props.friend.id,
    this.handleStatusChange
  );
}
...
```

我们在 `componentDidMount` 里注册，再在 `componentWillUnmount` 清除注册。但假如这时候 `props.friend.id` 发生变化了怎么办？我们不得不再添加一个 `componentDidUpdate` 来处理这种情况：

```jsx
...
  componentDidUpdate(prevProps) {
    // 先把上一个friend.id解绑
    ChatAPI.unsubscribeFromFriendStatus(
      prevProps.friend.id,
      this.handleStatusChange
    );
    // 再重新注册新但friend.id
    ChatAPI.subscribeToFriendStatus(
      this.props.friend.id,
      this.handleStatusChange
    );
  }
...
```

很繁琐。因为 `useEffect` 在每个组件更新后都会重新执行一遍，所以我们用 `useEffect` 就没有这个问题。所以代码的执行顺序是这样的：

```
1. 页面首次渲染
2. 替 friend.id = 1 的朋友注册
3. 突然 friend.id 变成了 2
4. 页面重新渲染
5. 清除 friend.id = 1 的绑定
6. 替 friend.id = 2 的朋友注册
...
```

按照上面的逻辑，组件每次重新渲染都要执行一遍这些副作用函数，这样会造成性能损耗，那怎么跳过这些不必要的副作用呢？

**跳过一些不必要的副作用函数**

前面有说到，`useEffect` 将可选的条件数组作为第二个参数。我们用第二个参数来告诉 `React` 只有当这个参数的值发生改变时，才执行我们传入的副作用函数 —— 也就是 `useEffect` 的第一个参数。

```jsx
useEffect(() => {
    document.title = `You clicked ${count} times`;
  }, [count]);
```

当我们把第二个参数传入一个空数组的时候，其实就相当于只有在首次渲染的时候才执行 —— 也就是  `componentDidMount` 加 `componentWillUnmount` 的模式。



### 五、Context Hook

上面介绍了 `useState`、`useEffect` 这两个最基本的 `API`，下面我们看看 React 帮我们封装好的 `useContext` ，它被用来处理多层级数据的传递。

在兄弟组件间的通讯中，利用父组件做中转可以完成兄弟组件之间的通信，但是如果父组件结构很深，那么中间的每一层组件都要去传递 `props`，增加了复杂度，并且这些 `props` 并不是这些中间组件自己所需要的。我们可以用 `React Context API` 来帮我们做这件事，参考：<https://togoblog.cn/react-component-communication/#toc-heading-7>，代码如下：

`ThemeContext.js` :

```jsx
import React from 'react';

export const themes = {
  light: {
    foreground: '#000000',
    background: '#eeeeee',
  },
  dark: {
    foreground: '#ffffff',
    background: '#222222',
  },
};

export const ThemeContext = React.createContext(
  themes.dark, // default value
);
```

`MainSection.js` : 

```jsx
import React from 'react';
import { ThemeContext } from './ThemeContext';

class MainSection extends React.Component {
  shouldComponentUpdate() {
    return false;
  }

  render() {
    return (
      <ThemeContext.Consumer>
        {theme => (
          <div
            style={{
              backgroundColor: theme.background,
              color: theme.foreground,
              minHeight: '200px',
            }}
          >
            <h3>Hello World</h3>
          </div>
        )}
      </ThemeContext.Consumer>
    );
  }
}

export default MainSection;
```

`Main.js` :

```jsx
import React, { Component } from 'react';
import MainSection from './MainSection';
import { ThemeContext, themes } from './ThemeContext';

class Main extends Component {
  constructor(props) {
    super(props);
    this.state = {
      theme: themes.light,
    };
  }

  toggleTheme = () => {
    this.setState(state => ({
      theme: state.theme === themes.dark ? themes.light : themes.dark,
    }));
  };

  render() {
    return (
      <div>
        <button onClick={this.toggleTheme}>Toggle Theme</button>
        <ThemeContext.Provider value={this.state.theme}>
          <MainSection />
        </ThemeContext.Provider>
      </div>
    );
  }
}

export default Main;
```

而在 `React Hooks` 中，我们可以使用 `useContext` 进行改造：

```jsx
function MainSection() {
  const theme = useContext(ThemeContext);
  return (
    <div
      style={{
        backgroundColor: theme.background,
        color: theme.foreground,
        minHeight: '200px',
      }}
    >
      <h3>Hello World</h3>
    </div>
  );
}
```

使用 `useContext` 则变得十分简洁，在原来的基础上，不用再写 `Consumer` ，可读性更强且不会增加组件树深度。

### 六、Reducer Hook

`useReducer` 这个 `Hooks` 在使用上几乎 `Redux/React-Redux` 一模一样，唯一缺少的就是无法使用 `redux` 提供的中间件。我们使用 `useReducer` 编写一个计数器：

```jsx
import React, { useReducer } from 'react';

const initialState = {
  count: 0,
};

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { count: state.count + action.payload };
    case 'decrement':
      return { count: state.count - action.payload };
    default:
      throw new Error();
  }
}

function ReducerHook() {
  const [state, dispatch] = useReducer(reducer, initialState);
  return (
    <>
      Count: {state.count}
      <button onClick={() => dispatch({ type: 'increment', payload: 5 })}>
        +
      </button>
      <button onClick={() => dispatch({ type: 'decrement', payload: 5 })}>
        -
      </button>
    </>
  );
}

export default ReducerHook;
```

用法跟 `Redux` 基本上是一致的。



### 七、更多

<https://reactjs.org/docs/hooks-reference.html>



本节内容代码可参考：<https://github.com/IDeepspace/React-Workshop/tree/master/Hooks>