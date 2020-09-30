---
title: React 中的受控组件和非受控组件
author: Deepspace
tags:
  - React
categories: React
date: 2017-10-12
urlname: react-uncontrolled-and-controlled-components
---



## React 中的受控组件和非受控组件

在 `React` 中，所谓受控组件和非受控组件，是针对表单而言的。

### 一、受控组件

- 表单元素依赖于状态，表单元素需要默认值实时映射到状态。
- 受控组件必须要在表单上使用 `onChange` 事件来绑定对应的事件。

<!-- more -->

如：

```jsx
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: '' };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({ value: event.target.value });
  }

  handleSubmit(event) {
    alert(`提交的名字: ${this.state.value}`);
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          名字:
          <input type="text" value={this.state.value} onChange={this.handleChange} />
        </label>
        <input type="submit" value="提交" />
      </form>
    );
  }
}
```



### 二、非受控组件

- 非受控组件即不受状态的控制，获取数据就是相当于操作 `DOM`。
- 非受控组件的好处是很容易和第三方组件结合。
- 如何获取非受控组件的值？通过 `ref` 获取 `DOM` 元素，然后通过 `value` 属性获取该表单元素的值。

如：

```jsx
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.input = React.createRef();
  }

  handleSubmit(event) {
    alert(`A name was submitted: ${this.input.current.value}`);
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Name:
          <input type="text" ref={this.input} />
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}
```

