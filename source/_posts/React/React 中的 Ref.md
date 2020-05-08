---
title: React 中的 Refs
author: Deepspace
tags:
  - React
categories: React
date: 2019-10-12
urlname: react-ref
---



## React 中的 Refs

在典型的 `React` 数据流中，[props](https://zh-hans.reactjs.org/docs/components-and-props.html) 是父组件与子组件交互的唯一方式。要修改一个子组件，需要使用新的 `props` 来重新渲染它。但是，在某些情况下，我们需要在典型数据流之外强制修改子组件。被修改的子组件可能是一个 `React` 组件的实例，也可能是一个 `DOM` 元素。对于这种情况，该怎么办呢？`React` 提供 `Refs` 来解决。

下面是几个适合使用 `refs` 的场景：

- 管理焦点，文本选择或媒体播放；
- 触发强制动画；
- 集成第三方 `DOM` 库。

但是要**注意**：如果能使用 `props` 实现，应该尽量避免使用 `refs` 实现。



### 一、为 DOM 元素添加 Ref

使用 `React.createRef()` 可以创建 `Refs`，并通过 `ref` 属性附加到 `React` 元素。在构造组件时，通常将 `Refs` 分配给实例属性，以便可以在整个组件中引用它们。

当 `ref` 被传递给 `render` 中的元素时，对该节点的引用可以在 `ref` 的 `current` 属性中被访问。

```javascript
const node = this.myRef.current;
```

看个完整的例子：

```jsx
class CustomTextInput extends Component {
  constructor(props) {
    super(props);
    // 创建一个 ref 来存储 textInput 的 DOM 元素
    this.textInput = React.createRef();
    this.focusTextInput = this.focusTextInput.bind(this);
  }

  focusTextInput() {
    // 直接使用原生 API 使 text 输入框获得焦点
    // 注意：我们通过 "current" 来访问 DOM 节点
    this.textInput.current.focus();
  }

  render() {
    // 告诉 React 我们想把 <input> ref 关联到
    // 构造器里创建的 `textInput` 上
    return (
      <div>
        <input
          type="text"
          ref={this.textInput} />
        <input
          type="button"
          value="Focus the text input"
          onClick={this.focusTextInput}
        />
      </div>
    );
  }
}
```

注意：`React.createRef() API` 是在 `React 16.3` 版本中引入的。如果你正在使用一个较早版本的 `React`，推荐使用[回调形式的 refs](https://zh-hans.reactjs.org/docs/refs-and-the-dom.html#callback-refs)。



### 二、为 class 组件添加 Ref

如果我们想包装上面的 `CustomTextInput` 组件，来模拟它挂载之后立即被点击的操作，我们可以使用 `ref` 来获取这个自定义的组件并手动调用它的 `focusTextInput` 方法：

```javascript
class AutoFocusTextInput extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = React.createRef();
  }

  componentDidMount() {
    this.textInput.current.focusTextInput();
  }

  render() {
    return (
      <CustomTextInput ref={this.textInput} />
    );
  }
}
```



### 三、不能在函数式组件中使用

像上面的例子，如果我们把 `CustomTextInput` 组件写成函数式组件，`ref` 属性是不生效的。

默认情况下，我们**不能在函数组件上使用 `ref` 属性**，因为它们没有实例。

```jsx
function MyFunctionComponent() {
  return <input />;
}

class Parent extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = React.createRef();
  }
  render() {
    // This will *not* work!
    return (
      <MyFunctionComponent ref={this.textInput} />
    );
  }
}
```

如果要在函数组件中使用 `ref`，你可以使用 [`forwardRef`](https://zh-hans.reactjs.org/docs/forwarding-refs.html)（可与 [`useImperativeHandle`](https://zh-hans.reactjs.org/docs/hooks-reference.html#useimperativehandle) 结合使用），或者可以将该组件转化为 `class` 组件。

**但是在函数式组件内部，我们是可以同构 `useRef` 使用的**：

```jsx
import React, { useRef } from 'react';

function CustomTextInput() {
  // 这里必须声明 textInput，这样 ref 才可以引用它
  const textInput = useRef(null);

  function handleClick() {
    textInput.current.focus();
  }

  return (
    <div>
      <input
        type="text"
        ref={textInput} />
      <input
        type="button"
        value="Focus the text input"
        onClick={handleClick}
      />
    </div>
  );
}
```



### 四、将 DOM Refs 暴露给父组件

在极少数情况下，我们可能希望在父组件中引用子节点的 `DOM` 节点，但是 `React` 官方通常不建议这样做，因为它会打破组件的封装性，但它偶尔可用于触发焦点或测量子 `DOM` 节点的大小或位置。虽然我们可以通过向子组件添加 `ref` 的方式来解决，但这并不是一个理想的解决方案，因为我们只能获取组件实例而不是 `DOM` 节点。并且它还在函数组件上无效。

对于这种情况，如果使用的是 `16.3` 或更高版本的 `React`， 可以使用 [ref 转发](https://zh-hans.reactjs.org/docs/forwarding-refs.html)。**Ref 转发使组件可以像暴露自己的 `ref` 一样暴露子组件的 `ref`**。详细例子：

```jsx
const ref = React.createRef();

const BtnComp = React.forwardRef((props, ref) => (
    <div>
      <button ref={ref} className='btn'>
        { props.children }
      </button>
    </div>
));

class TestComp extends React.Component {
  clickEvent() {
    if (ref && ref.current) {
      ref.current.addEventListener('click', () => {
        console.log('hello click!');
      });
    }
  }

  componentDidMount() {
    console.log('当前按钮的class为：', ref.current.className); // btn
    this.clickEvent(); // hello click!
  }

  render() {
    return (
      <div>
        <BtnComp ref={ref}>点击我</BtnComp>
      </div>
    );
  }
}
```



### 五、回调 Refs

`React` 也支持另外一种使用 `refs` 的方式 —— 回调 `refs`，可以帮助我们更精准的控制何时 `refs` 被设置和解除。这个回调函数中接受 `React` 组件实例或 `HTML DOM` 元素作为参数，以使它们能在其他地方被存储和访问。

看个例子：

```jsx
class TestComp extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = null;
    // 使用'ref'的回调函数将 text 输入框 DOM 节点的引用绑定到 React 实例 this.textInput 上
    this.inputRef = element => {
      this.textInput = element;
    };
    this.focus = () => {
      if (this.textInput) {
        this.textInput.focus();
      }
    };
  }

  componentDidMount() {
    this.focus();
  }

  render() {
    return (
      <div>
        <input type='text' ref={ this.inputRef } />
      </div>
    );
  }
}
```

`React` 将在组件挂载时会调用 `ref` 回调函数并传入`DOM` 元素，当卸载时调用它并传入 `null`。 在  `componentDidMount` 或 `componentDidUpdate` 触发前，`React` 会保证 `refs` 一定是最新的。 

在类组件中，通常父组件把它的 `refs` 回调函数通过 `props` 的形式传递给子组件，同时子组件把相同的函数作为特殊的 `ref` 属性传递给对应的 `DOM` 元素。像下面这样：

```jsx
function CustomTextInput(props) {
  return (
    <div>
      <input ref={props.inputRef} />
    </div>
  );
}

class Parent extends React.Component {
  render() {
    return (
      <CustomTextInput
        inputRef={el => this.inputElement = el}
      />
    );
  }
}
```



**避免使用内联函数的方式定义 `ref`**

如果 `ref` 回调函数是以内联函数的方式定义的，组件更新的时候，这个函数实际上会执行两遍，因为函数的引用变了，`react` 要清除掉老的 `ref`，创建一个新的。清除掉老的 `ref` 时，给回调传入的参数是 `null`，新建 `ref` 时，传入的是组件或者 `DOM` 的引用。

```jsx
class TestComp extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = null;
    // 初始化 flag 值为 init
    this.state = {
      flag: 'init',
    };
    this.focus = () => {
      if (this.textInput) {
        this.textInput.focus();
      }
    };
  }

  componentDidMount() {
    this.focus();
    // 当执行完 render 首次渲染之后，更新状态 flag 值 为 update
    this.setState({
      flag: 'update',
    });
  }

  render() {
    return (
      <div>
        {/* 通过内联回调形式定义 ref  */}
        <input type='text' value={this.state.flag} ref={(element) => {
          console.log('element', element); // 将传入的 element 输出控制台
          this.textInput = element;
        }} />
      </div>
    );
  }
}
```

打开控制台查看打印结果，可以发现执行了两遍。

如果想避免两次代码的执行，可以把 `ref` 中的回调定义成一个全局函数即可。像前面回调 `Refs` 中的例子那样。



### 五、为什么推荐 ref 使用函数而不是字符串？

使用函数 `ref`，`react` 可以**更优雅的完成对组件销毁时的变量回收**，例如：

```jsx
<Test ref={(test) => this.test = test}></Test>
```

`react` 在销毁组件时，`this.test` 很方便的就可以被清理变为 `null`。

并且，`ref` 是一个回调函数，使得我们能在这个函数中做更多的事情，比如说，我们可以借助这种函数的机制，让父组件直接获取子组件的 `DOM`。而如果你让 `ref` 是一个字符串，实现这个功能是不可能的。

除了不如函数模式强大，使用字符串模式也有一些其他缺点，如：**针对静态类型检测不支持**等。

**`Refs` 字符串模式已经废弃，`React` 不建议使用并且会提示警告，开发中推荐使用 `React.forwardRef` 方式，简单优雅，回调函数模式应用在复杂场景中**。

