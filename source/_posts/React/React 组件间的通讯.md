## React 组件间的通讯

在使用 `React` 的过程中，不可避免的需要组件间进行消息传递（通信），组件间通信大体上有下面几种情况：

- 父组件向子组件通信
- 子组件向父组件通信
- 兄弟组件间通信
- 不在同一父级中的非兄弟组件间通信

下面细说这四种不同情况的组件之间是如何通信的。

#### 一、父组件向子组件通信

`React` 是单向数据流。父组件通过向子组件传递 `props` （数据或者方法），子组件得到 `props` 后进行相应的处理。演示 `demo` 如下：

**父组件  :**

```javascript
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

```javascript
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

#### 二、子组件向父组件通信

利用回调函数，实现子组件向父组件通信：父组件将处理函数作为 `props` 传递给子组件，子组件调用该回调函数。

##### 1、State 定义在父组件

**父组件：**

```javascript
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

```javascript
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

##### 2、State 定义在子组件

有的时候，`state` 也需要定义在子组件里面，比如对于弹出框、`checkBox` 这类具有开关性质的状态。这个时候，把 `state` 定义在子组件内部会更容易维护，但是子组件也需要将这个状态通知到父组件。处理逻辑也是一样的，同样执行从父组件传递下来的处理函数。在上面的 `demo` 中作出以下修改：

**父组件：**

```javascript
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

```javascript
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



####三、兄弟组件间通信 

##### 1、通过父组件做中转

`Father` 组件：

```javascript
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

```javascript
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

```javascript
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

```javascript
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

##### 2、利用Context

利用父组件做中转可以完成兄弟组件之间的通信，但是如果父组件结构很深，那么中间的每一层组件都要去传递 `props`，增加了复杂度，并且这些 `props` 并不是这些中间组件自己所需要的。可以使用 `Context` 来解决这个问题。

`Context` 作为一个实验性质的 `Api` ，在 `React v16.3.0` 之前，一直不被官方提倡使用。原因是在子组件中使用 `Context`  会破坏 `React` 应用的分形架构。

> 分形结构是指是从理想的 `React` 应用的根组件树中抽取的任意一部分，抽取的部分仍是一个可以直接运行的子组件树。在这个子组件树之上再包一层，这样就可以将它无缝地移植到任意一个其他的根组件树中。
>
> 如果根组件树中有任意一个组件使用了支持 `props`  透传的 `Context API`，那么把包含了这个组件的子组件树单独拿出来，因为缺少了提供 `Context` 值的根组件树，这个时候这个子组件树是无法直接运行的。

下面我们看看在 `React v16.3.0` 之前，如果使用 `Context` 进行信息传递该怎么做：

我们假设 `AParent` 的子组件 `A` 需要和 `BParent` 的子组件 `B` 进行通信。

首先，我们需要创建一个顶级公共组件 `Context` ：

```javascript
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

Context.childContextTypes = {
  value: PropTypes.string,
  setValue: PropTypes.func,
};

export default Context;
```

创建 `AParent` 组件：

```javascript
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

A.contextTypes = {
  setValue: PropTypes.func,
};

export default AParent;
```

创建 `BParent` 组件：

```javascript
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

B.contextTypes = {
  value: PropTypes.string,
};

export default BParent;
```

这种方式除了会破坏 `React` 应用的分形架构之外，还有另外一个问题：如果现在新增一个组件 `C`，数据流向为 ：顶级公共组件 `Context`  ——> `A` ——> `B` ——> `C` (接收 `context`)。当数据改变时，组件 `A` 和组件 `B` 都重新 `render` 了， `C` 组件才能拿到更新后的 `Context`。

 如果中间组件 `B` 使用了`shouldComponentUpdate` 来拦截重新渲染，或者 `B` 组件是 `PureComponent`，那么它的下方组件 `C` 就拿不到更新后的 `Context`，这个时候 `React` 将认为整个子树都没有发生改变，那么组件 `C` 就不会重新渲染。

**也就是说：`Context` 的更改将不会在 `shouldComponentUpdate` 返回为 `false` 上的组件上传播。** 这篇文章提供了一个解决方案：[How to safely use React context](https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076) ，可以参考。

新的 `Context Api` 采用声明式的写法，并且可以透过 `shouldComponentUpdate` 返回 `false` 的组件继续向下传播，以保证目标组件可以接受到顶层组件中 `Context` 的更新，在 `React v16.3.0` 中官方支持。下面看个 `Demo` :

```javascript
import React, { Component } from 'react';
import ReactDOM from 'react-dom';

const themes = {
  light: {
    foreground: '#000000',
    background: '#eeeeee',
  },
  dark: {
    foreground: '#ffffff',
    background: '#222222',
  },
};

const ThemeContext = React.createContext(
  themes.dark, // default value
);

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

// 必须
MainSection.propTypes = {};
MainSection.defaultProps = {};

class App extends Component {
  state = {
    theme: themes.light,
  };

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

ReactDOM.render(<App />, document.getElementById('root'));
```

可以看到，即使 `MainSection` 组件中 `shouldComponentUpdate` 返回值为 `false` ，`Context` 依旧可以穿透它。 



##### 3、观察者模式

