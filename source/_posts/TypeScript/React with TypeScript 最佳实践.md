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
- `tsconfig.json`：生成的具有默认配置的 `TypeScript` 的配置文件；
- `react-app-env.d.ts`：`TypeScript` 声明文件， 注释的内容会做为编译器指令使用。



#### 2、VSCode 扩展和设置

安装插件：

- `ESLint`
- `Prettier - Code formatter`

在 `VSCode` 配置文件中（`.vscode/settings.json`，快捷命令为 `Command + Shift + P` / `Ctrl + Shift + P`）增加以下配置 ：

```json
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
    "eslint.alwaysShowStatus": true
}
```

增加这些配置的目的是让 `VSCode` 可以更好地显示 `ESLint`  的 `Error/Warning`，帮助我们更容易发现代码错误、格式化代码等。

<!-- more -->

#### 3、配置 ESLint / Prettier

- 添加 `ESlint` 相关依赖：

```bash
$ yarn add @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-react --dev
```

> 这里没有选择安装 `eslint` 的依赖是因为 `create-react-app` 脚手架中 `react-scripts` 包中，已经依赖了 `eslint`，如果重复安装，可能会版本不一致的情况。

- 在根目录下创建一个 `.eslintrc.js` 文件并添加以下内容：

```javascript
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
    'linebreak-style': 'off',
    'prettier/prettier': [
      'error',
      {
        endOfLine: 'auto',
      },
    ],
  },
  settings: {
    react: {
      version: 'detect', // 告诉 eslint-plugin-react 自动检测 React 的版本
    },
  },
};
```

- 添加 `Prettier` 依赖：

```bash
$ yarn add prettier eslint-config-prettier eslint-plugin-prettier --dev
```

- 在根目录下创建一个 `.prettierrc.js` 文件并添加以下内容：

```javascript
module.exports = {
  semi: true,
  trailingComma: 'all',
  singleQuote: true,
  printWidth: 120,
  tabWidth: 2,
};
```

- 更新 `.eslintrc.js` 文件：

```javascript
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
    'linebreak-style': 'off',
    'prettier/prettier': [
      'error',
      {
        endOfLine: 'auto',
      },
    ],
  },
  settings: {
    react: {
      version: 'detect', // 告诉 eslint-plugin-react 自动检测 React 的版本
    },
  },
};

```

- 增加 `lint` 和 `format` 命令：

```javascript
"scripts": {
  "format": "prettier --write src/**/*.ts{,x}",
  "lint": "tsc --noEmit && eslint src/**/*.ts{,x}"
}
```

建议将 `lint` 检查添加到 `commit` 的钩子中，避免一些错误代码或者一些不合规范的代码提交和推送。



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
- 第二种写法：使用了函数表达式写法，返回一个**函数**而不是值或者表达式，所以注明这个函数的返回值是 `React.FC` 类型。

开发时，两种写法都可以，但开发团队需要保持一致，只采取一种。


#### 2、Props

在 `TypeScript` 中，我们可以使用 `interface` 或者 `type` 关键字来将 `props` 声明成泛型。

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

- `OwnProps`，直接传递给当前组件的属性；

- `StateProps`，通过 `connect` 到 `redux` 中的 `store` 获取的属性；

- `DispatchProps`，也是通过 `connect` 到 `redux` 获取的属性；

- `RouteProps`，通过 `react-router-dom` 中的 `route` 路由传递的属性

多个 `props` 可以使用 `&` 符号连接起来：

```jsx
type Props = OwnProps & RouteProps & StateProps & DispatchProps;
```

关于如何选用 `interface` 和 `type` 的问题，我个人的看法是都可以，但是需要团队成员保持统一风格。如果采用 `interface`，可以使用 `extends` 关键字来连接多个 `props`：

```jsx
interface Props extends OwnProps, RouteProps, StateProps, DispatchProps {}
```



**下面介绍两个限制 `props` 属性的两个常用方法。**

- 使用 `Partial` 将所有的 `props` 属性都变为可选值

如果 `props` 所有的属性值都是可选的，我们可以借助 `Partial` 来实现。

```jsx
import React from 'react';
import { MouseEvent } from 'react';

type IProps = {
  color: 'red' | 'blue' | 'yellow';
  text: string;
  onClick(event: MouseEvent<HTMLDivElement>): void;
};

const Com: React.FC<Partial<IProps>> = ({ onClick, text, color }) => {
  return (
    <div onClick={onClick} style={{ color }}>
      {text}
    </div>
  );
};

const App: React.FC = () => {
  return <Com text="click" color={'blue'} />;
};

export default App;
```



- 使用 `Required` 将所有 `props` 属性都设为必填项

如果 `props` 所有的属性值都是必选的，我们可以借助 `Required` 来实现：

```jsx
import React from 'react';
import { MouseEvent } from 'react';

type IProps = {
  color: 'red' | 'blue' | 'yellow';
  text: string;
  onClick(event: MouseEvent<HTMLDivElement>): void;
};

const Com: React.FC<Required<IProps>> = ({ onClick, text, color }) => {
  return (
    <div onClick={onClick} style={{ color }}>
      {text}
    </div>
  );
};

const App: React.FC = () => {
  return <Com text="click" color={'blue'} />;
};

export default App;
```



**设置  `Props` 的默认值**

有两种方式设置 `Props` 的默认值。

- 传递 `props` 时，设置默认值

```jsx
/* eslint-disable react/prop-types */
import React from 'react';

type IProps = {
  color?: 'red' | 'blue' | 'yellow';
  text: string;
};

// 传递 props 时，设置默认值
const Com: React.FC<IProps> = ({ text, color = 'red' }) => {
  return <div style={{ color }}>{text}</div>;
};

const App: React.FC = () => {
  return (
    <div>
      <Com text="click" />
      <Com text="click" color="blue" />
    </div>
  );
};

export default App;
```

- 通过 `defaultProps` 设置默认值

```jsx
import React from 'react';

type IProps = {
  color?: 'red' | 'blue' | 'yellow';
  text?: string;
};

const Com: React.FC<IProps> = ({ text, color }) => {
  return <div style={{ color }}>{text}</div>;
};

// 通过 defaultProps 设置默认值
Com.defaultProps = {
  color: 'red',
  text: 'hello',
};

const App: React.FC = () => {
  return (
    <div>
      <Com text="hi" />
      <Com color="blue" />
    </div>
  );
};

export default App;
```



#### 3、在 Hooks 中的使用

- useState

使用 `useState` 时，`TypeScript` 可以自动推断类型：

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
  email: string;
  id: number;
  error?: string;
};

const App: React.FC = () => {
  const [user, setUser] = useState<User | null>(null);
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



- useEffect 

没有返回值，无需传递类型。



- useLayoutEffect

没有返回值，无需传递类型。



- useReducer

`useReducer` 接受两个参数：`reducer` 和 `initialState`，只需要对传入 `useReducer` 的 `reducer` 函数的入参 `state` 和 `action` 进行类型约束，就能够推断出类型。在使用 `useReducer` 或者 `redux` 的时候，联合类型是非常有用的。看下面的例子：

```jsx
import React, { useReducer } from 'react';

const initialState = { count: 0 };

/** 联合类型，使用 | 连接 */
type ACTIONTYPE =
  | { type: 'increment'; payload: number }
  | { type: 'decrement'; payload: string }
  | { type: 'reset'; payload: number };

function reducer(state: typeof initialState, action: ACTIONTYPE) {
  switch (action.type) {
    case 'increment':
      return { count: state.count + action.payload };
    case 'decrement':
      return { count: state.count - Number(action.payload) };
    case 'reset':
      return { count: action.payload };
    default:
      throw new Error();
  }
}

const Counter: React.FC = () => {
  const [state, dispatch] = useReducer(reducer, initialState);
  return (
    <>
      Count: {state.count}
      <button onClick={() => dispatch({ type: 'decrement', payload: '5' })}>-</button>
      <button onClick={() => dispatch({ type: 'increment', payload: 5 })}>+</button>
      <button onClick={() => dispatch({ type: 'reset', payload: 0 })}>reset</button>
    </>
  );
};

export default Counter;
```

将 `ACTIONTYPE` 设置为联合类型后，联合类型的变量在被赋值的时候，会根据类型推论的规则推断出一个类型。



- useRef

`useRef` 传递非空初始值的时候可以推断类型，可以通过传入第一个泛型参数来定义类型，约束 `ref.current` 的类型。

```jsx
import React, { useLayoutEffect } from 'react';

export const App: React.FC = () => {
  const h1Ref = React.useRef<HTMLDivElement | null>(null);

  function changeInnerText(el: HTMLDivElement, value: string) {
    el.innerText = value;
  }

  useLayoutEffect(() => {
    if (null !== h1Ref.current) {
      changeInnerText(h1Ref.current, 'hello world');
    }
  }, []);

  return <h1 ref={h1Ref}>My title</h1>;
};

export default App;
```

更多 `useRef` 示例：

```jsx
// <div> reference type
const divRef = React.useRef<HTMLDivElement | null>(null);

// <button> reference type
const buttonRef = React.useRef<HTMLButtonElement | null>(null);

// <br /> reference type
const brRef = React.useRef<HTMLBRElement | null>(null);

// <a> reference type
const linkRef = React.useRef<HTMLLinkElement | null>(null);
```



- useCallback

`useCallback` 无需传递类型，根据函数的返回值就能推断出类型，如果传递类型错误，`TypeScript` 就会直接报错。但是注意函数的入参需要定义类型，不然就推断为 `any` 了。

```jsx
const multiplier = 2;

const multiply = useCallback((value: number) => value * multiplier, [multiplier]);
```



- useMemo

`useMemo` 无需传递类型，根据函数的返回值就能推断出类型。

```jsx
const memoizedValue = React.useMemo(() => {
  computeExpensiveValue(a, b)
}, [a, b])
```

要在 `useMemo` 上设置类型，只需将需要记录的**返回值数据类型**传递到 `<>` 中即可。



- useContext

下面是一个例子：

```jsx
import React, { useContext } from 'react';

type IArticle = {
  id: number;
  title: string;
};

type ArticleState = {
  articles: IArticle[];
  setArticles: React.Dispatch<React.SetStateAction<IArticle[]>>;
};

const ArticleContext = React.createContext<ArticleState>({ articles: [], setArticles: (): void => {} });

const ArticleProvider: React.FC<React.ReactNode> = ({ children }) => {
  const [articles, setArticles] = React.useState<IArticle[] | []>([
    { id: 1, title: 'post 1' },
    { id: 2, title: 'post 2' },
  ]);

  return <ArticleContext.Provider value={{ articles, setArticles }}>{children}</ArticleContext.Provider>;
};

const ShowArticles: React.FC = () => {
  const { articles } = useContext<ArticleState>(ArticleContext);

  return (
    <div>
      {articles.map((article: IArticle) => (
        <p key={article.id}>{article.title}</p>
      ))}
    </div>
  );
};

const ChangeArticles: React.FC = () => {
  const { setArticles } = useContext<ArticleState>(ArticleContext);

  return <button onClick={() => setArticles([])}>Empty Acticles</button>;
};

export const Article: React.FC = () => {
  return (
    <ArticleProvider>
      <h1>My title</h1>
      <ShowArticles />
      <ChangeArticles />
    </ArticleProvider>
  );
};

export default Article;
```



#### 4、事件处理

最常见的情况之一是表单的 `onChange` 事件：

```jsx
import React from 'react';

const MyInput: React.FC = () => {
  const [value, setValue] = React.useState('');

  // 事件类型是 “ChangeEvent”
  // 我们将 “HTMLInputElement” 传递给 input
  const onChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setValue(e.target.value);
  };

  return <input value={value} onChange={onChange} id="input-example" />;
};

export default MyInput;
```

对于 `a` 标签和 `button` 标签的点击事件，也可以使用联合类型来复用事件处理：

```jsx
import React from 'react';

const MyButton: React.FC = () => {
  const handleClick = (event: React.MouseEvent<HTMLAnchorElement | HTMLButtonElement>) => {
    console.log(event);
  };

  return (
    <div>
      <button onClick={handleClick}>click</button>
      <a href="" onClick={handleClick}>
        link
      </a>
    </div>
  );
};

export default MyButton;
```

常用 `Event` 事件对象类型有：

- `ClipboardEvent<T = Element>` 剪贴板事件对象
- `DragEvent<T = Element>` 拖拽事件对象
- `ChangeEvent<T = Element>`  Change 事件对象
- `KeyboardEvent<T = Element>` 键盘事件对象
- `MouseEvent<T = Element>` 鼠标事件对象
- `TouchEvent<T = Element>`  触摸事件对象
- `WheelEvent<T = Element>` 滚轮事件对象
- `AnimationEvent<T = Element>` 动画事件对象
- `TransitionEvent<T = Element>` 过渡事件对象



#### 5、添加第三方依赖库

当我们需要在代码库中添加第三方依赖的时候，要做的第一件事就是查看这个库是否拥有一个带有 `TypeScript` 类型定义 `@types` 包，可以通过运行下面的命令：

```bash
# yarn
$ yarn add @types/<package-name>

# npm
$ npm install @types/<package-name>
```

比如我们想在项目中引入 `jest`，可以像下面这样安装 `jest` 依赖：

```bash
#yarn
$ yarn add @types/jest

#npm
$ npm install @types/jest
```

如果没有找到带有 `TypeScript` 类型定义 `@types` 包，例如 `loadsh` 在 `npm` 上是没有 `@types/loadsh` 的，该怎么办呢？

首先通过 `npm` 或者 `yarn` 正常安装 `loadsh` 的依赖：

```bash
#yarn
$ yarn add loadsh

#npm
$ npm install loadsh
```

然后在项目中的 `src` 文件夹中找到 `react-app-env.d.ts` 文件，为 `loadsh` 依赖添加 `declare`，加入以下代码：

```js
declare module 'loadsh' {
  const classes: any;
  export default classes;
}
```

然后正常引入即可：

```js
import _ from 'loadsh';
```



### 三、参考文章

- [How React and TypeScript Work Together](https://www.sitepoint.com/react-with-typescript-best-practices/)
- [Type-safe state modeling with TypeScript and React Hooks](https://thoughtbot.com/blog/type-safe-state-modeling-with-typescript-and-react-hooks)

