---
title: Vue 实例的生命周期
author: Deepspace
categories: Vue
tag:
  - vue
  - vue 生命周期 
date: 2019-01-26
urlname: vue-lifecycle
---

<!-- ## Vue 实例的生命周期 -->

在 `Vue` 中，每个实例都有自己的一个完整的生命周期，包括开始创建 —— 初始化数据 —— 编译模板 —— 将实例挂载到 `DOM` —— 渲染 —— 更新 —— 渲染 —— 卸载等一系列过程。同时在这个过程中也会运行一些叫做**生命周期钩子**的函数，这样我们就可以在实例生命周期的不同阶段做一些需要做的事情。

### 一、vue 实例和组件的区别

这里可能会有个小疑惑，怎么突然又说是 `Vue` 实例呢？实例和组件有什么区别吗？

在 `SPA（Single Page Application）` 应用中，我们只会创建一个 `Vue` 根实例，整个应用都是通过这个根实例启动的。在通过 `vue-cli` 脚手架生成的项目中， `main.js` 里创建了 `Vue` 根实例：
<!-- more -->

```javascript
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
});
```

通过 `new Vue() `创建一个 `Vue` 实例。在实例化 `Vue` 时，需要传入一个选项对象，它可以包含挂载元素 `el`、路由`router`、模板 `template`、数据 `data`、方法 `methods`、生命周期钩子等选项。

**`Vue` 组件是被扩展的 `Vue` 实例。**同 `Vue` 实例类似，它也需要传入一个选项对象，包含数据、模板、生命周期钩子函数等等。在前面我们只介绍了**单文件组件**的方式来创建组件，也可以这样来创建一个组件：

```javascript
// 定义一个名为 button-counter 的新组件
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})
```

可以发现，和创建 `Vue` 实例非常的类似，**所有的 `Vue` 组件同时都是 `Vue` 的实例**。所以我们说：**实例的生命周期也叫做组件的生命周期。** 


### 二、Vue 实例的生命周期

`Vue` 实例从创建到销毁的过程，就是生命周期。文章的开头我们提到了**生命周期钩子函数**，它是框架提供的函数，能够让开发人员的代码参与到组件的生命周期中。也就是说，通过钩子函数，可以控制组件的行为。这里有两个点需要记住：

- 在 `Vue` 实例的的生命周期中，会自动调用这些生命周期函数，我们只需要提供这些钩子函数即可；
- 生命周期钩子函数的名字是固定的，不可更改，不可以自定义或者添加钩子函数。

**生命周期图示：**

![lifecycle](../../ImageHosting/Vue/vue-lifecycle.png)

图中，红色矩形框代表着在生命周期对应阶段的钩子函数。



### 三、生命周期函数

我们通过三种案例来学习生命周期函数：

- 单组件的生命周期
- 父子组件的生命周期
- 兄弟组件的生命周期

案例中，通过打开控制台查看钩子函数打印的内容来学习。

#### 1、单组件的生命周期

```html
<template>
  <div class='container'>
    <h3>单组件的生命周期（打开控制台查看）</h3>
    <button @click='dataVar += 1'>更新 {{dataVar}}</button>
    <button @click='handleDestroy'>销毁</button>
  </div>
</template>

<script>
const compName = 'single';

export default {
  name: 'SingleComLifecycle',
  data() {
    return {
      dataVar: 1,
    };
  },
  beforeCreate() {
    console.log(`--${compName}--beforeCreate`); // eslint-disable-line
  },
  created() {
    console.log(`--${compName}--created`); // eslint-disable-line
  },
  beforeMount() {
    console.log(`--${compName}--beforeMount`); // eslint-disable-line
  },
  mounted() {
    console.log(`--${compName}--mounted`); // eslint-disable-line
  },
  beforeUpdate() {
    console.log(`--${compName}--beforeUpdate`); // eslint-disable-line
  },
  updated() {
    console.log(`--${compName}--updated`); // eslint-disable-line
  },
  beforeDestroy() {
    console.log(`--${compName}--beforeDestroy`); // eslint-disable-line
  },
  destroyed() {
    console.log(`--${compName}--destroyed`); // eslint-disable-line
  },
  methods: {
    handleDestroy() {
      this.$destroy();
    },
  },
};
</script>


<style lang="postcss" scoped>
.container {
  width: 70%;
  margin: 0 auto;
  background-color: aliceblue;
  padding: 50px;
  text-align: center;
}
button {
  padding: 6px;
  background-color: #35b880;
  border: none;
  color: white;
  font-size: 16px;
  margin: 5px;
}
</style>
```

初始化组件时打印：

```
--single--beforeCreate
--single--created
--single--beforeMount
--single--mounted
```

`data` 中的数据变化时打印：

```
--single--beforeUpdate
--single--updated
```

组件销毁时打印：

```
--single--beforeDestroy
--single--destroyed
```

所以我们可以得出以下结论：

- 初始化组件时，仅执行了 `beforeCreate/Created/beforeMount/mounted` 四个钩子函数

- 当改变 `data` 中定义的变量（响应式变量）时，会执行 `beforeUpdate/updated` 钩子函数

- 当切换组件（当前组件未缓存）时，会执行 `beforeDestory/destroyed` 钩子函数

- 初始化和销毁时的生命钩子函数均只会执行一次，`beforeUpdate/updated` 可多次执行



#### 2、父子组件的生命周期

创建一个父组件：

```html
<template>
  <div class='container'>
    <h3>父子组件的生命周期（打开控制台查看）</h3>
    <child-com :compName='dataVar.toString()'></child-com>
    <button @click='dataVar += 1'>父组件更新 {{dataVar}}</button>
    <button @click='handleDestroy'>父组件销毁</button>
  </div>
</template>

<script>
import ChildCom from './ChildCom';

const COMPONENT_NAME = 'parent';
export default {
  data() {
    return {
      dataVar: 1,
    };
  },
  components: {
    'child-com': ChildCom,
  },
  beforeCreate() {
    console.log(`--${COMPONENT_NAME}--beforeCreate`); // eslint-disable-line
  },
  created() {
    console.log(`--${COMPONENT_NAME}--created`); // eslint-disable-line
  },
  beforeMount() {
    console.log(`--${COMPONENT_NAME}--beforeMount`); // eslint-disable-line
  },
  mounted() {
    console.log(`--${COMPONENT_NAME}--mounted`); // eslint-disable-line
  },
  beforeUpdate() {
    console.log(`--${COMPONENT_NAME}--beforeUpdate`); // eslint-disable-line
  },
  updated() {
    console.log(`--${COMPONENT_NAME}--updated`); // eslint-disable-line
  },
  beforeDestroy() {
    console.log(`--${COMPONENT_NAME}--beforeDestroy`); // eslint-disable-line
  },
  destroyed() {
    console.log(`--${COMPONENT_NAME}--destroyed`); // eslint-disable-line
  },
  methods: {
    handleDestroy() {
      this.$destroy();
    },
  },
};
</script>


<style lang="postcss" scoped>
.container {
  width: 70%;
  margin: 20px auto;
  background-color: aliceblue;
  padding: 50px;
  text-align: center;
}
button {
  padding: 6px;
  background-color: #2196f3;
  border: none;
  color: white;
  font-size: 16px;
  margin: 5px;
}
</style>
```

创建一个子组件：

```html
<template>
  <div>
    <div>父组件传递的props：{{compName}}</div>
    <button @click='dataVar += 1'>子组件更新 {{dataVar}}</button>
    <button @click='handleDestroy'>子组件销毁</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dataVar: 1,
    };
  },
  props: {
    compName: {
      type: String,
      default: 'single',
    },
  },
  beforeCreate() {
    console.log(` --此时data未初始化--child--beforeCreate`); // eslint-disable-line
  },
  created() {
    console.log(`--${this.compName}--child--created`); // eslint-disable-line
  },
  beforeMount() {
    console.log(`--${this.compName}--child--beforeMount`); // eslint-disable-line
  },
  mounted() {
    console.log(`--${this.compName}--child--mounted`); // eslint-disable-line
  },
  beforeUpdate() {
    console.log(`--${this.compName}--child--beforeUpdate`); // eslint-disable-line
  },
  updated() {
    console.log(`--${this.compName}--child--updated`); // eslint-disable-line
  },
  beforeDestroy() {
    console.log(`--${this.compName}--child--beforeDestroy`); // eslint-disable-line
  },
  destroyed() {
    console.log(`--${this.compName}--child--destroyed`); // eslint-disable-line
  },
  methods: {
    handleDestroy() {
      this.$destroy();
    },
  },
};
</script>

<style lang="postcss" scoped>
button {
  padding: 6px;
  background-color: #35b880;
  border: none;
  color: white;
  font-size: 16px;
  margin: 5px;
}
</style>
```

初始化组件时打印：

```
--parent--beforeCreate
--parent--created
--parent--beforeMount
--此时data未初始化--child--beforeCreate
--1--child--created
--1--child--beforeMount
--1--child--mounted
--parent--mounted
```

当子组件 `data` 中的值变化时打印：

```
--1--child--beforeUpdate
--1--child--updated
```

当父组件 `data` 中的值变化时打印（子组件接受了父组件传递的 `props`）：

```
--parent--beforeUpdate
--2--child--beforeUpdate
--2--child--updated
--parent--updated
```

当子组件销毁时打印：

```
--1--child--beforeDestroy
--1--child--destroyed
```

当父组件销毁时打印：

```
--parent--beforeDestroy
--1--child--beforeDestroy
--1--child--destroyed
--parent--destroyed
```

结论：

- 仅当子组件完成挂载后，父组件才会挂载
- 父子组件在 `data` 变化中是分别监控的，但是在更新 `props` 中的数据是关联的
- 销毁父组件时，先将子组件销毁后才会销毁父组件



#### 3、兄弟组件的生命周期

创建一个单组件：

```html
<template>
  <div class='container'>
    <button @click='dataVar += 1'>更新 {{dataVar}}</button>
    <button @click='handleDestroy'>销毁</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dataVar: 1,
    };
  },
  props: {
    compName: {
      type: String,
      default: 'single',
    },
  },
  beforeCreate() {
    console.log(`--此时data未初始化--beforeCreate`); // eslint-disable-line
  },
  created() {
    console.log(`--${this.compName}--created`); // eslint-disable-line
  },
  beforeMount() {
    console.log(`--${this.compName}--beforeMount`); // eslint-disable-line
  },
  mounted() {
    console.log(`--${this.compName}--mounted`); // eslint-disable-line
  },
  beforeUpdate() {
    console.log(`--${this.compName}--beforeUpdate`); // eslint-disable-line
  },
  updated() {
    console.log(`--${this.compName}--updated`); // eslint-disable-line
  },
  beforeDestroy() {
    console.log(`--${this.compName}--beforeDestroy`); // eslint-disable-line
  },
  destroyed() {
    console.log(`--${this.compName}--destroyed`); // eslint-disable-line
  },
  methods: {
    handleDestroy() {
      this.$destroy();
    },
  },
};
</script>


<style lang="postcss" scoped>
.container {
  width: 70%;
  margin: 0 auto;
  background-color: aliceblue;
  padding: 10px;
  text-align: center;
}
button {
  padding: 6px;
  background-color: #35b880;
  border: none;
  color: white;
  font-size: 16px;
  margin: 5px;
}
</style>
```

引入两个单组件，构建兄弟组件：

```html
<template>
  <div class='container'>
    <h3>兄弟组件的生命周期（打开控制台查看）</h3>
    <div>兄弟1
      <single compName='cihld1'></single>
    </div>
    <div>兄弟2
      <single compName='child2'></single>
    </div>
    <div>
      <p>兄弟两个的父亲</p>
      <button @click='dataVar += 1'>更新 {{dataVar}}</button>
      <button @click='handleDestroy'>销毁</button>
    </div>
  </div>
</template>

<script>
import Single from './Single';

const COMPONENT_NAME = 'parent';
export default {
  data() {
    return {
      dataVar: 1,
    };
  },
  components: {
    single: Single,
  },
  beforeCreate() {
    console.log(`--${COMPONENT_NAME}--beforeCreate`); // eslint-disable-line
  },
  created() {
    console.log(`--${COMPONENT_NAME}--created`); // eslint-disable-line
  },
  beforeMount() {
    console.log(`--${COMPONENT_NAME}--beforeMount`); // eslint-disable-line
  },
  mounted() {
    console.log(`--${COMPONENT_NAME}--mounted`); // eslint-disable-line
  },
  beforeUpdate() {
    console.log(`--${COMPONENT_NAME}--beforeUpdate`); // eslint-disable-line
  },
  updated() {
    console.log(`--${COMPONENT_NAME}--updated`); // eslint-disable-line
  },
  beforeDestroy() {
    console.log(`--${COMPONENT_NAME}--beforeDestroy`); // eslint-disable-line
  },
  destroyed() {
    console.log(`--${COMPONENT_NAME}--destroyed`); // eslint-disable-line
  },
  methods: {
    handleDestroy() {
      this.$destroy();
    },
  },
};
</script>

<style lang="postcss" scoped>
.container {
  width: 70%;
  margin: 5px auto;
  background-color: aliceblue;
  padding: 50px;
  text-align: center;
}
button {
  padding: 6px;
  background-color: #2196f3;
  border: none;
  color: white;
  font-size: 16px;
  margin: 5px;
}
</style>
```

初始化组件时打印：

```
--parent--beforeCreate
--parent--created
--parent--beforeMount
--此时data未初始化--beforeCreate
--cihld1--created
--cihld1--beforeMount
--此时data未初始化--beforeCreate
--child2--created
--child2--beforeMount
--cihld1--mounted
--child2--mounted
--parent--mounted
```

当 `child1` 更新和销毁时，打印：

```
--cihld1--beforeUpdate
--cihld1--updated
--cihld1--beforeDestroy
--cihld1--destroyed
```

当 `child2` 更新和销毁时，打印：

```
--cihld2--beforeUpdate
--cihld2--updated
--cihld2--beforeDestroy
--cihld2--destroyed
```

当父组件销毁时，打印：

```
--parent--beforeDestroy
--cihld1--beforeDestroy
--cihld1--destroyed
--child2--beforeDestroy
--child2--destroyed
--parent--destroyed
```

结论：

- 组件的初始化（mounted之前）分开进行，挂载是从上到下依次进行
- 当没有数据关联时，兄弟组件之间的更新和销毁是互不关联的

 

