---
title: vue-cli 构建 vue 项目详解
author: Deepspace
categories: Vue
tag:
  - vue
  - vue-cli 
date: 2019-01-21
urlname: vue-cli-init-project-intro
---

<!-- ## vue-cli 构建 vue 项目详解 -->

构建一个 `vue` 项目最简单的方式就是使用脚手架工具 `vue-cli` 。前端的三大框架都有自己的脚手架工具，其作用就是用配置好的模板迅速搭建起一个项目工程来，省去自己配置 `webpack` 配置文件的基本内容，大大降低了初学者构建项目的难度。这节我们看看如何使用 `vue-cli` 构建 `vue` 项目以及对构建项目的具体分析。

### 一、环境搭建

`node` 和 `npm` 是必不可少的，这里不再介绍。

#### 1、安装 vue-cli

```shell
$ npm install -g vue-cli
```

检查是否安装成功：

```shell
$ vue --version
3.3.0
```
<!-- more -->
#### 2、构建项目

```shell
$ vue init webpack hello-vue
```

初始化的过程中，会有一个交互式的选项让你选择项目的一些配置，根据项目需求选择即可。为了方便后面几篇教程的演示，可以统一选择以下选项：

```shell
? Project name hello-vue # 项目名称
? Project description A Vue.js project # 项目描述
? Author Deepspace <cxin1427@gmail.com> # 作者
? Vue build standalone # 运行+编译时
? Install vue-router? Yes # 安装 vue-router
? Use ESLint to lint your code? Yes # 使用 ESLint 作为代码规范
? Pick an ESLint preset Airbnb # 选择 Airbnb 的代码规范
? Set up unit tests Yes # 安装单元测试
? Pick a test runner karma # 测试模块
? Setup e2e tests with Nightwatch? Yes # 安装 e2e 测试
? Should we run `npm install` for you after the project has been created? (recommended) npm # 包管理器，npm
```

构建完成之后，会提示构建成功信息：

```shell
# Project initialization finished!
# ========================

To get started:

  cd hello-vue
  npm run dev

Documentation can be found at https://vuejs-templates.github.io/webpack
```

#### 3、启动项目

```shell
$ cd hello-vue
$ npm run dev
```

项目默认会在 8080 端口启动，如果端口有占用，会自动调整端口。打开浏览器输入：`http://localhost:8080`，会看到构建的项目的主页：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-init-project.png" alt="vue-init-project" style="zoom: 50%;" />

#### 4、目录结构

使用编辑器打开(推荐使用 `VSCode`)，下面具体看看目录结构：

**`package.json` :**

```json
{
    "scripts": {
        "dev": "webpack-dev-server --inline --progress --config build/webpack.dev.conf.js",
        "start": "npm run dev",
        "unit": "cross-env BABEL_ENV=test karma start test/unit/karma.conf.js --single-run",
        "e2e": "node test/e2e/runner.js",
        "test": "npm run unit && npm run e2e",
        "lint": "eslint --ext .js,.vue src test/unit test/e2e/specs",
        "build": "node build/build.js"
    }
}
```

在 `package.json` 中，根据我们在构建项目的时候的选项，有以下几个命令。

- `npm run dev` ：项目开发阶段，项目启动的命令；
- `npm run lint` ：使用 `eslint` 检查代码格式；
- `npm run test`：单元测试和 `e2e` 测试；
- `npm run e2e` : `e2e` 测试；
- `npm run build`：开发完成后执行，会把我们的源代码编译成最终的发布代码，生成在项目根目录中的 `dist` 文件夹下（初始化项目时不会生成）。

**`config`：** 保存一些项目初始化配置。

**`build` ：**里面保存一些 `webpack` 的初始化配置。

**`index.html` :  **是我们的首页。`index` 很多时候都被预设为首页，像 `index.htm`，`index.php` 等。

**`src` : ** 保存项目源代码的地方，我们下面会详细分析该文件夹里的文件。



### 二、代码分析

`Vue` 的核心架构分为两个部分：**路由和组件**，其实 `React` 也是一样的。我们在切入一个项目的时候，都是从这两个点出发。下面我们具体看看 `src` 文件夹。

#### 1、入口文件

如果我们打开项目根目录下 `build` 目录中的 `webpack.base.conf.js`，会看到这样的代码(第22行)：

```javascript
module.exports = {
  context: path.resolve(__dirname, '../'),
  entry: {
    app: './src/main.js'
  },
  // ...
}    
```

说明我们的入口文件就是 `src` 目录下的 `main.js` 文件。看看代码：

```javascript
// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from './router';

Vue.config.productionTip = false;

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
});
```

看看这里面做了什么事情：

- 引入 `vue` 并起名叫作 `Vue`
- 引入 根目录下的 `App.vue` 文件(后缀名可不要)
- 引入 `router` 文件下的 `index.js` 文件(文件夹后没有具体的文件，默认引入的就是 `index.js` 文件)
- 通过 `new ` 实例化 `Vue` 实例 ，实例化的时候声明了几个属性：
  - `el：'#app'`：意思是将所有视图放在 `id` 值为 `app` 这个 `dom` 元素中，也就是项目根目录下的 `index.html` 中的那个 `div` : `<div id="app"></div>`；
  - `components: { App }`：意思是将上面引入的 `App.vue` 文件的内容将以 `<App/>` 这样的标签写进 `<div id="app"></div>` 中；

在开始的时候，我们并没有介绍说 **`Vue` 使用的是虚拟 `DOM`** ，那么，从这里我们看出，`Vue` 使用的也是虚拟 `DOM` (和`React`是一样的)。

> 这里对**虚拟 `DOM`** 作下简单介绍：当我们修改应用程序时，不会对 ` DOM` 进行更改，而是创建以 `JavaScript` 数据结构形式存在的 `DOM` 副本，然后插到文档当中。无论何时进行任何更改，都将对 `JavaScript` 数据结构进行更改，并将后者与原始数据结构进行比较（`diff`算法），然后将最终更改更新为真实 `DOM`。我们都知道 `DOM` 是非常重的，所以**虚拟 `DOM`** 是非常省性能的。

#### 2、App.vue

通过入口文件中做的事情，我们其实已经知道 `App.vue` 的作用了：**单页面应用的主组件**。所有页面都是在 `App.vue` 下通过路由进行切换的。所以，我们可以理解为所有的路由（`route`）也是 ` App.vue` 的子组件。我们看看代码：

```javascript
<template>
  <div id="app">
    <img src="./assets/logo.png">
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App',
};
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
```

> 这里需要提一下：`node` 之所以可以识别出 `*·vue` 格式的文件，是因为 `webpack` 在编译时将 `*.vue` 文件中的 `html` 、`js` 、`css` 都抽出来形成新的单独文件。可通过 `npm run build` 命令编译源代码，查看 `dist` 文件下的文件来验证。

`App.vue` 的内容分为三个部分：`<template>...</template>`、`<script>...</script>`、`<style>...</style>` ，分别在这三类标签里面写入**结构、脚本、样式**。

我们先从 ` <template>` 看起：里面一个 `div` 包裹着 `img` 标签和 `router-view` 标签。前面提到过： **`App.vue` 是单页面应用的主组件**。对照着前面在浏览器中打开的应用主页面，`img` 标签就是页面上方的 `Vue` 的 `logo`。那下面的内容去哪了呢？和 `<router-view/>` 有关系吗？这就要去看路由了。

#### 3、router/index.js

```javascript
import Vue from 'vue';
import Router from 'vue-router';
import HelloWorld from '@/components/HelloWorld';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld,
    },
  ],
});
```

前面先引入了路由插件 `vue-router`，然后显式声明要用路由 `Vue.use(Router)` 。路由的配置非常地明了：给不同 `path` 分配不同的组件（或者页面），参数 `name` 只是用来识别。

当我访问根路由 `http://localhost:8080/#/` 时，`App.vue` 中的 `<router-view/>` 就会把引入的 `HelloWorld` 组件分配给我，放在了 `img` 标签的下面，打开 `components` 目录下的 `HelloWorld.vue` 就可以看到具体内容了。

> 我们在看到浏览器中的 `url`  的时候会觉得奇怪，为什么在后面加了一个 `#` 号呢？这是因为 `vue-router` 默认 `hash` 模式 —— 使用 `URL` 的 `hash` 来模拟一个完整的 `URL`，当 URL 改变时，页面不会重新加载。详见：https://router.vuejs.org/zh/guide/essentials/history-mode.html 。这里可先跳过这点内容。

现在，我们在浏览器访问 `http://localhost:8080/#/vue` 这个地址，会发现只出现了  `Vue` 的 `logo`。这是因为我们并没有配置 `/vue` 这个路由，找不到路由，那`<router-view/>` 这个标签就不会加载出来。

到这里，我们就知道路由是如何根据 `url` 来分配不同的组件了。配置多个路由就很简单了：

```javascript
export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
	},
    {
      path: '/about',
      name: 'about',
      component: About
	},
    {
      path: '/vue',
      name: 'vue',
      component: Vue
	}
  ]
})
```

那如果要访问 `http://localhost:8080/#/vue/demo` 怎么办呢？

```javascript
export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld,
    },
    {
      path: '/about',
      name: 'about',
      component: About,
    },
    {
      path: '/vue',
      name: 'vue',
      component: Vue,
      children: [
        {
          path: '/demo',
          component: demo,
        },
        {
          path: '/project',
          component: project,
        },
      ],
    },
  ],
});
```

给路由加多一个子路由配置即可。

#### 4、assets

用来存放一些图片、样式等静态文件。



### 三、总结

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-core-structure.png" alt="vue-core-structure" style="zoom:50%;" />
