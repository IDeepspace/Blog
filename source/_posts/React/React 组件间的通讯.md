---
title: React 组件间的通讯
author: Deepspace
tags:
  - React
  - React 组件通讯
categories: React
date: 2018-12-12
urlname: react-component-communication
---

<!-- ## React 组件间的通讯 -->

在使用 `React` 的过程中，不可避免的需要组件间进行消息传递（通信），组件间通信大体上有下面几种情况：

- 父组件向子组件通信
- 子组件向父组件通信
- 兄弟组件间通信
- 不在同一父级中的非兄弟组件间通信

下面细说这四种不同情况的组件之间是如何通信的。
<!-- more -->
### 一、父组件向子组件通信

`React` 是单向数据流。父组件通过向子组件传递 `props` （数据或者方法），子组件得到 `props` 后进行相应的处理。演示 `demo` 如下：

**父组件  :**

```jsx
import React, { Component } from 'react';
import Child from './Child';

class Parent extends Component {
  constructor() {
    super();
    this.value = null;
    this.state = {
      value: '',
    };
  }

  handleChange = e => {
    this.value = e.target.value;
  };

  handleClick = () => {
    this.setState({
      value: this.value,
    });
  };

  render() {
    return (
      <div>
        我是Parent
        <input onChange={this.handleChange} />
        <button onClick={this.handleClick}>传递</button>
        <Child value={this.state.value} />
      </div>
    );
  }
}

export default Parent;
```

**子组件：**

```jsx
import React, { Component } from 'react';

class Child extends Component {
  render() {
    const { value } = this.props;
    return <div>我是Child，得到父组件传下来的值：{value}</div>;
  }
}

export default Child;
```

父组件中定义好 `state` ，`input` 的事件函数 ` onChange` 中，缓存 `value` 值，然后点击 `button` 的时候，改变 `state` , 子组件只负责展示 `value` 。



### 二、子组件向父组件通信

利用回调函数，实现子组件向父组件通信：父组件将处理函数作为 `props` 传递给子组件，子组件调用该回调函数。

#### 1、State 定义在父组件

**父组件：**

```jsx
import React, { Component } from 'react';
import ChildCom from './ChildCom';

class FatherCom extends Component {
  constructor(props) {
    super(props);
    this.state = {
      list: ['我是父组件里面的数据', '我来自父组件'],
    };
  }

  addItem = item => {
    this.setState({
      list: [...this.state.list, item],
    });
  };

  method = () => {
    alert('我是父组件里面的方法');
  };

  render() {
    const { list } = this.state;
    return (
      <div>
        <ChildCom list={list} method={this.method} addItem={this.addItem} />
      </div>
    );
  }
}

export default FatherCom;
```

**子组件：**

```jsx
import React, { Component } from 'react';

class ChildCom extends Component {
  handleClick = () => {
    const { method } = this.props;
    method();
  };

  submit = () => {
    const { addItem } = this.props;
    addItem('我是通过子组件props方式传递给父组件的数据');
  };

  render() {
    const { list } = this.props;
    return (
      <div>
        <ul>
          {list.map((item, index) => (
            <li key={index}>{item}</li>
          ))}
        </ul>
        <div>
          <button onClick={this.handleClick}>执行父组件的方法</button>
          <button onClick={this.submit}>子组件改变父组件的数据</button>
        </div>
      </div>
    );
  }
}

export default ChildCom;
```



#### 2、State 定义在子组件

有的时候，`state` 也需要定义在子组件里面，比如对于弹出框、`checkBox` 这类具有开关性质的状态。这个时候，把 `state` 定义在子组件内部会更容易维护，但是子组件也需要将这个状态通知到父组件。处理逻辑也是一样的，同样执行从父组件传递下来的处理函数。在上面的 `demo` 中作出以下修改：

**父组件：**

```jsx
class FatherCom extends Component {
  onChange = value => {
    console.log(value, '来自 child 的 value 变化');
  };

  render() {
    const { list } = this.state;
    return (
      <div>
        <ChildCom onChange={this.onChange}
        />
      </div>
    );
  }
}
```

**子组件：**

```jsx
class ChildCom extends Component {
  constructor() {
    super();
    this.state = {
      childValue: '',
    };
  }

  childValChange = e => {
    const { onChange } = this.props;
    onChange(e.target.value);
  };

  render() {
    return (
      <div>
          state 定义在 child
          <input onChange={this.childValChange} />
      </div>
    );
  }
}
```



### 三、兄弟组件间通信 

#### 1、通过父组件做中转

`Father` 组件：

```jsx
import React, { Component } from 'react';
import BrotherCom from './BrotherCom';
import SisterCom from './SisterCom';

class FatherCom extends Component {
  constructor(props) {
    super(props);
    this.state = {
      msg: 'start',
    };
  }

  componentDidUpdate() {
    console.log('Parent update');
  }

  transferMsg = msg => {
    this.setState({
      msg,
    });
  };

  render() {
    return (
      <div>
        <BrotherCom transferMsg={this.transferMsg} />
        <SisterCom msg={this.state.msg} />
      </div>
    );
  }
}

export default FatherCom;
```

`Brother` 组件：

```jsx
import React, { Component } from 'react';

class BrotherCom extends Component {
  componentDidUpdate() {
    console.log('Brother update');
  }

  handleClick = () => {
    const { transferMsg } = this.props;
    transferMsg('end');
  };

  render() {
    return (
      <div>
        <p>
          Brother Component
          <button onClick={this.handleClick}>与兄弟组件通信</button>
        </p>
      </div>
    );
  }
}

export default BrotherCom;
```

`Sister` 组件：

```jsx
import React, { Component } from 'react';

class SisterCom extends Component {
  componentDidUpdate() {
    console.log('Siser update');
  }

  render() {
    const { msg } = this.props;
    return (
      <div>
        <p>Sister Component: {msg}</p>
      </div>
    );
  }
}

export default SisterCom;
```

这个方法有一个问题，**由于父组件的 `state` 发生变化，会触发父组件及从属于父组件的子组件的生命周期。**所以我们在控制台中可以看到，各个组件中的 `componentDidUpdate` 方法均被触发。那怎么解决呢？`react` 生命周期中的 `shouldComponentUpdate` 函数就派上用场了。

> `shouldComponentUpdate` 函数会在组件重新渲染之前调用，函数的返回值确定了组件是否需要重新渲染。函数默认的返回值是 `true`，就是说只要组件的 `props` 或者 `state` 发生了变化，就会重新构建 `virtual DOM`，然后使用 `diff` 算法进行比较，再接着根据比较结果决定是否重新渲染整个组件。函数的返回值为 `false` 表示不需要重新渲染。 

所以，我们在 `Brother` 组件中使用 `shouldComponentUpdate` 函数，来决定是否需要重新渲染：

```jsx
class BrotherCom extends Component {
  componentDidUpdate() {
    console.log('Brother update');
  }

  shouldComponentUpdate(nextProps, nextState) {
    if (this.props.transferMsg !== nextProps.transferMsg) {
      return true;
    }
    return false;
  }

  handleClick = () => {
    const { transferMsg } = this.props;
    transferMsg('end');
  };

  render() {
    return (
      <div>
        <p>
          Brother Component
          <button onClick={this.handleClick}>与兄弟组件通信</button>
        </p>
      </div>
    );
  }
}
```



#### 2、利用Context

利用父组件做中转可以完成兄弟组件之间的通信，但是如果父组件结构很深，那么中间的每一层组件都要去传递 `props`，增加了复杂度，并且这些 `props` 并不是这些中间组件自己所需要的。可以使用 `Context` 来解决这个问题。

`Context` 设计目的是为共享那些被认为对于一个组件树而言是“全局”的数据，例如当前认证的用户、主题或首选语言。

 在 `React v16.3.0` 之前，`Context` 作为一个实验性质的 `Api`，一直不被官方提倡使用。原因是在子组件中使用 `Context`  会破坏 `React` 应用的分形架构。

> 分形结构是指是从理想的 `React` 应用的根组件树中抽取的任意一部分，抽取的部分仍是一个可以直接运行的子组件树。在这个子组件树之上再包一层，这样就可以将它无缝地移植到任意一个其他的根组件树中。
>
> 如果根组件树中有任意一个组件使用了支持 `props`  透传的 `Context API`，那么把包含了这个组件的子组件树单独拿出来，因为缺少了提供 `Context` 值的根组件树，这个时候这个子组件树是无法直接运行的。

##### - React v16.3.0 之前：

下面我们看看在 `React v16.3.0` 之前，如果使用 `Context` 进行信息传递该怎么做：

使用 `Context` ，需要用到两种组件：

- 一个是 `Context` 生产者(`Provider`)，通常是一个父节点；
- 另一个是 `Context` 的消费者(`Consumer`)，通常是一个或者多个子节点。

所以 `Context  ` 的使用基于**生产者消费者模式**。

对于父组件，也就是 `Context` 生产者，需要通过一个静态属性 `childContextTypes` 声明提供给子组件的`Context `对象的属性，并实现一个实例 `getChildContext` 方法，返回一个代表 `Context` 的纯对象 (`plain object`) 。

我们假设 `AParent` 的子组件 `A` 需要和 `BParent` 的子组件 `B` 进行通信。

首先，我们需要创建一个顶级公共组件 `Context` ：

```jsx
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import AParent from './AParent';
import BParent from './BParent';

class Context extends Component {
  constructor() {
    super();
    this.state = {
      value: '',
    };
  }

  setValue = value => {
    this.setState({
      value,
    });
  };

  // 返回Context对象，方法名是约定好的
  getChildContext() {
    return {
      value: this.state.value,
      setValue: this.setValue,
    };
  }

  render() {
    return (
      <div>
        <AParent />
        <BParent />
      </div>
    );
  }
}

// 声明Context对象属性
Context.childContextTypes = {
  value: PropTypes.string,
  setValue: PropTypes.func,
};

export default Context;
```

而对于 `Context` 的消费者，子组件需要通过一个静态属性 `contextTypes` 声明后，才能访问父组件 `Context`对象的属性。否则，即使属性名没写错，拿到的对象也是 `undefined`。

创建 `AParent` 组件：

```jsx
import React, { Component } from 'react';
import PropTypes from 'prop-types';

class A extends Component {
  handleChange = e => {
    this.value = e.target.value;
  };

  handleClick = () => {
    const { setValue } = this.context;
    setValue(this.value);
  };

  render() {
    return (
      <div>
        我是 parentA 的子组件 A <input onChange={this.handleChange} />
        <button onClick={this.handleClick}>传递</button>
      </div>
    );
  }
}

class AParent extends Component {
  render() {
    return <A />;
  }
}

// 声明需要使用的Context属性
A.contextTypes = {
  setValue: PropTypes.func,
};

export default AParent;
```

创建 `BParent` 组件：

```jsx
import React, { Component } from 'react';
import PropTypes from 'prop-types';

class B extends Component {
  render() {
    return (
      <div>
        我是 parentB 的子组件 B, A传递给我的值是：
        {this.context.value}
      </div>
    );
  }
}

class BParent extends Component {
  render() {
    return <B />;
  }
}

// 声明需要使用的Context属性
B.contextTypes = {
  value: PropTypes.string,
};

export default BParent;
```

这种方式除了会破坏 `React` 应用的分形架构之外，还有另外一个问题：如果现在新增一个组件 `C`，数据流向为 ：顶级公共组件 `Context`  ——> `A` ——> `B` ——> `C` (接收 `context`)。当数据改变时，组件 `A` 和组件 `B` 都重新 `render` 了， `C` 组件才能拿到更新后的 `Context`。

 如果中间组件 `B` 使用了`shouldComponentUpdate` 来拦截重新渲染，或者 `B` 组件是 `PureComponent`，那么它的下方组件 `C` 就拿不到更新后的 `Context`，这个时候 `React` 将认为整个子树都没有发生改变，那么组件 `C` 就不会重新渲染。

**也就是说：`Context` 的更改将不会在 `shouldComponentUpdate` 返回为 `false` 上的组件上传播。** 这篇文章提供了一个解决方案：[How to safely use React context](https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076) ，可以参考。

##### - React v16.3.0 之后：

新的 `Context Api` 采用声明式的写法，并且可以透过 `shouldComponentUpdate` 返回 `false` 的组件继续向下传播，以保证目标组件可以接受到顶层组件中 `Context` 的更新，更加明确了生产者消费者模式的使用方式。在 `React v16.3.0` 中得到官方推荐支持。

下面看个 `Demo` :

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

通过静态方法 `React.createContext()` 创建一个`Context`对象。这个 `Context` 对象包含两个组件，`<Provider />` 和 `<Consumer />`：

```jsx
import React, { Component } from 'react';
import MainSection from './MainSection';
import { ThemeContext, themes } from './ThemeContext';

class App extends Component {
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

export default App;
```

`<Provider />` 的 `value` 相当于老版本 `Context api` 中的 `getChildContext()`。

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

可以看到，即使 `MainSection` 组件中 `shouldComponentUpdate` 返回值为 `false` ，`Context` 依旧可以穿透它。 

> PS：如果你觉得有了新 `Context api` 就能不用 `Redux` 的话，说明你也许根本就不需要 `Redux` ，你只是需要一个全局`Store` 就好了。



#### 3、发布订阅模式

这种模式是通过使用事件中心的方式，允许组件自由交流，一个地方发送消息，另一个地方接收做出变化的需求，无论组件处于组件树的哪一层。实现的方式有很多，下面是淘宝前端团队的实现方式：

创建一个发布订阅类 `eventEmitter`：

```javascript
const eventEmitter = {
  onObj: {},
  oneObj: {},
  on: function(key, fn) {
    if (this.onObj[key] === undefined) {
      this.onObj[key] = [];
    }

    this.onObj[key].push(fn);
  },
  one: function(key, fn) {
    if (this.oneObj[key] === undefined) {
      this.oneObj[key] = [];
    }

    this.oneObj[key].push(fn);
  },
  off: function(key) {
    this.onObj[key] = [];
    this.oneObj[key] = [];
  },
  trigger: function() {
    let key, args;
    if (arguments.length === 0) {
      return false;
    }
    key = arguments[0];
    args = [].concat(Array.prototype.slice.call(arguments, 1));

    if (this.onObj[key] !== undefined && this.onObj[key].length > 0) {
      for (let i in this.onObj[key]) {
        this.onObj[key][i].apply(null, args);
      }
    }
    if (this.oneObj[key] !== undefined && this.oneObj[key].length > 0) {
      for (let i in this.oneObj[key]) {
        this.oneObj[key][i].apply(null, args);
        this.oneObj[key][i] = undefined;
      }
      this.oneObj[key] = [];
    }
  },
};

export default eventEmitter;
```

公共父类 `Container` :

```jsx
import React from 'react';
import A from './A';
import B from './B';

const Container = () => {
  return (
    <div>
      <A />
      <B />
    </div>
  );
};
export default Container;
```

子组件 `A` :

```jsx
import React, { Component } from 'react';
import eventEmitter from './eventEmitter';

class A extends Component {
  handleChange = e => {
    this.value = e.target.value;
  };

  handleClick = () => {
    eventEmitter.trigger('dispatch', this.value);
  };

  render() {
    return (
      <div>
        我是Brother A, <input onChange={this.handleChange} />
        <button onClick={this.handleClick}>发送</button>
      </div>
    );
  }
}

export default A;
```

子组件 `B` :

```jsx
import React, { Component } from 'react';
import eventEmitter from './eventEmitter';

class B extends Component {
  state = {
    value: '',
  };

  componentDidMount() {
    eventEmitter.on('dispatch', this.valueChange);
  }

  componentWillUnmount() {
    eventEmitter.off('dispatch', this.valueChange);
  }

  valueChange = value => {
    this.setState({
      value,
    });
  };

  render() {
    return (
      <div className='card'>
        我是Brother B, 我从A接受到的value是：
        {this.state.value}
      </div>
    );
  }
}

export default B;
```

- 组件 `A` 用于分发消息，组件 `B` 接收消息。这里的中间者其实就是 `event` 对象。

- 组件 `A` 在内部的表单被点击的时候发布事件，将 `value` 传递出去。

- 需要接收消息的 `B` 在 `componentDidMount`  中去订阅 `dispatch` 事件，并把回调函数 `valueChange` 传入。另外， `B` 定义了自己的 `state`，方便得到 `value` 值的时候自动渲染。



### 四、Redux

`React` 中自上而下的单向数据流，和 `state` 的特性，除去发布订阅和 `Redux` 等方式，其他的都是通过 `props` 自上而下传递数据，子组件需要的数据总是通过父组件传递下来的。如果你的项目的状态更加复杂，那就需要用上 `Redux` 了，参考：<https://togoblog.cn/redux-basic/> 。



> 本篇文章中的代码示例可参考：<https://github.com/IDeepspace/React-Workshop/tree/master/examples>



<br>

> 转载文章请给作者署名：https://togoblog.cn/