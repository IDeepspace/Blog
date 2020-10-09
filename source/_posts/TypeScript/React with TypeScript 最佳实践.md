---
title: React with TypeScript 最佳实践
author: Deepspace
categories: Tool
date: 2020-09-24
urlname: typescript-react-bset-practice
---

## React with TypeScript 最佳实践

### 一、项目初始化

#### 1、构建项目

初始化一个 `React with TypeScript` 应用程序的最快方法就是使用 `facebook` 官方脚手架 `create-react-app`， 它提供了 `TypeScript` 模板。运行以下面的命令：

```bash
$ npx create-react-app my-app --template typescript
```

生成后的项目文件有一些不同，主要增加了以下配置：

- `.tsx`：使用 `TypeScript` 的 `JSX` 文件扩展；
- `tsconfig.json`：`TypeScript` 的配置文件；
- `react-app-env.d.ts`：`TypeScript` 声明文件， 注释的内容会做为编译器指令使用。

#### 2、VSCode 扩展和设置

安装插件：

- `ESLint`
- `Prettier - Code formatter`

在 `VSCode` 配置文件中（`.vscode/settings.json`，快捷命令为 `Command + Shift + P` / `Ctrl + Shift + P`）增加以下配置 ：

```bash
{
    "eslint.options": {
        "configFile": ".eslintrc.js"
    },
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true
    },
    "files.autoSave": "onFocusChange",
    "editor.formatOnType": true,
    "editor.formatOnSave": true,
    "eslint.enable": true,
    "eslint.alwaysShowStatus": true
}
```

增加这些配置的目的是让 `VSCode` 可以更好地显示 `ESLint`  的 `Error/Warning`，帮助我们更好地格式化代码。

<!-- more -->

#### 3、配置 ESLint / Prettier

添加 `ESlint` 依赖：

```bash
$ npm i eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-react --save-dev
```

在根目录下创建一个 `eslintrc.js` 文件并添加以下内容：

```bash
module.exports = {
  parser: '@typescript-eslint/parser', // 指定ESLint解析器
  extends: [
    'plugin:react/recommended', // 使用来自 @eslint-plugin-react 的推荐规则
    'plugin:@typescript-eslint/recommended', // 使用来自@typescript-eslint/eslint-plugin的推荐规则
  ],
  parserOptions: {
    ecmaVersion: 2018, // 允许解析最新的 ECMAScript 特性
    sourceType: 'module', // 允许使用 import
    ecmaFeatures: {
      jsx: true, // 允许对JSX进行解析
    },
  },
  rules: {
    // 自定义规则
    // e.g. "@typescript-eslint/explicit-function-return-type": "off",
  },
  settings: {
    react: {
      version: 'detect', // 告诉 eslint-plugin-react 自动检测 React 的版本
    },
  },
};
```

添加 `Prettier` 依赖：

```bash
$ npm i prettier eslint-config-prettier eslint-plugin-prettier --save-dev
```

在根目录下创建一个 `.prettierrc.js` 文件并添加以下内容：

```bash
module.exports = {
  semi: true,
  trailingComma: 'all',
  singleQuote: true,
  printWidth: 120,
  tabWidth: 2,
};
```

更新 `.eslintrc.js` 文件：

```bash
module.exports = {
  parser: '@typescript-eslint/parser', // 指定ESLint解析器
  extends: [
    'plugin:react/recommended', // 使用来自 @eslint-plugin-react 的推荐规则
    'plugin:@typescript-eslint/recommended', // 使用来自@typescript-eslint/eslint-plugin的推荐规则
    'prettier/@typescript-eslint', // 使用 ESLint -config-prettier 禁用来自@typescript-eslint/ ESLint 与 prettier 冲突的 ESLint 规则
    'plugin:prettier/recommended',
  ],
  parserOptions: {
    ecmaVersion: 2018, // 允许解析最新的 ECMAScript 特性
    sourceType: 'module', // 允许使用 import
    ecmaFeatures: {
      jsx: true, // 允许对JSX进行解析
    },
  },
  rules: {
    // 自定义规则
    // e.g. "@typescript-eslint/explicit-function-return-type": "off",
  },
  settings: {
    react: {
      version: 'detect', // 告诉 eslint-plugin-react 自动检测 React 的版本
    },
  },
};
```

### 二、最佳实践

#### 1、组件的书写方式

对于函数式组件，通常有两种书写方式：

```jsx
import React from 'react';

// 函数声明式写法
function Heading(): React.ReactNode {
  return <h1>My Website Heading</h1>;
}

// 函数扩展式写法
const OtherHeading: React.FC = () => <h1>My Website Heading</h1>;
```

- 第一种写法：使用了函数声明式写法，注明了这个函数的返回值是 `React.ReactNode` 类型；
- 第二种写法：使用了函数表达式写法，注明了这个函数的返回值是 `React.FC` 类型。

开发时，两种写法都可以，但团队需要保持一致，只采取一种。

#### 2、组件泛型化

在 `TypeScript` 中，我们可以使用 `interface` 或者 `type` 关键字来将类型声明成泛型。

```jsx
type RowProps<Type> = {
  input: Type | Type[],
  onClick: () => void,
  color?: string,
};

const Row: React.FC<RowProps<number | string>> = ({
  input,
  onClick,
  color = 'blue',
}) => {
  if (Array.isArray(input)) {
    return (
      <div>
        {input.map((i, idx) => (
          <div key={idx} onClick={onClick}>
            {i}
          </div>
        ))}
      </div>
    );
  }
  return <div style={{ color }}>{input}</div>;
};

const Rows = () => {
  return (
    <Fragment>
      <Row input={[1]} onClick={() => {}} />
      <Row input={1} onClick={() => {}} color={'red'} />
      <Row input={1} onClick={() => {}} />
      <Row input='1' onClick={() => {}} />
      <Row input={['1']} onClick={() => {}} />
    </Fragment>
  );
};
```

其中 `Props` 可以分成几个子集，根据实际使用场景，一般可以分为以下四类：

- `OwnProps`，直接传递给该组件的属性；

- `StateProps`，通过 `connect` 到 `redux` 中的 `store` 获取的属性；

- `DispatchProps`，也是通过 `connect` 到 `redux` 获取的属性；

- `RouteProps`，通过 `react-router-dom` 中的 `route` 路由传递的属性

多个 `props` 可以使用 `&` 符号连接起来：

```react
type Props = OwnProps & RouteProps & StateProps & DispatchProps;
```

#### 3、在 Hooks 中的使用

**useState**

使用 `useState` 时，`TypeScript` 的类型推断非常好用，它可以自动推断所使用的值：

```jsx
const App: React.FC = () => {
  const [value, setValue] = useState('');
  return (
    <button
      onClick={() => {
        setValue(1); // Error: Argument of type 'number' is not assignable to parameter of type 'SetStateAction<string>'
      }}
    >
      click
    </button>
  );
};
```

有时候，我们需要初始化带有空值的 `state`，可以使用泛型来传递：

```jsx
type User = {
  email: string,
  id: number,
  error?: string,
};

const App: React.FC = () => {
  const [user, setUser] = (useState < User) | (null > null);
  return (
    <button
      onClick={() => {
        setUser({
          email: 'cxin1427@gmail.com',
          id: 1427,
        });
      }}
    >
      click
    </button>
  );
};
```

**useReducer**

在使用 useReducer 或者 redux 的时候，联合类型是非常有用的。
