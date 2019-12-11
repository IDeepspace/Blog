---
title: Vue 组件间的通讯
author: Deepspace
categories: Vue
tag:
  - vue
  - vue 组件间通讯 
date: 2019-01-25
urlname: vue-pass-data-in-components
---

<!-- ## Vue 组件间的通讯 -->

这一节我们一起看看 `vue` 中组件间的数据是如何传递的。

前面，我们已经初步建立了 `vue` 组件化的思想，知道如何创建组件、引入组件以及如何在组件里的一些功能。接下来，我们来学习怎么建立组件之间的连接，也就是组件的通讯。直白一点说就是：在一个组件中做的操作如何更新到应用程序中的其他组件。

这篇文章会从两个方便介绍 `vue` 组件间的通讯：

```htm
- 父子组件之间的通讯
- 兄弟组件之间的通讯
```

<!-- more -->

### 一、父子组件之间的通讯

#### 1、父组件向子组件通讯

在 `vue` 中，将数据从父组件传递到子组件，可以用 `props` 来实现(这一点，在 `React` 中也是如此)。

`props` 指的是从外部（父组件）设置的属性。同时，为了告诉 `vue` 子组件需要从自已的外部（父组件）接收数据，需要在子组件的 `vue` 对象中设置 `props` 属性。这个属性是一个 `String ` 数组，每个字符串表示一个可以从父组件接收的属性。

**我们需要做两件事情：父组件使用属性绑定、子组件使用 props 对象接收。** 看个例子：

- 父组件使用属性绑定 ：

```html
<template>
  <div>
    <ChildCom :list='list' :run='run' :home='this'></ChildCom>
  </div>
</template>

<script>
import ChildCom from './ChildCom';

export default {
  data() {
    return {
      list: ['我是父组件里面的数据', '我来自父组件'],
    };
  },
  components: {
    ChildCom,
  },
  methods: {
    run() {
      alert('我是父组件里面的方法'); // eslint-disable-line
    },
  },
};
</script>
```

我们在父组件 `ParentCom` 里面引入了子组件 `ChildCom` 。为了将数据从父组件传到子组件，我们在子组件 `ChildCom` 上绑定了几个属性：

```html
<childCom :list='list' :run='run' :home='this'></childCom>
```

绑定属性的时候，属性名前需要加冒号。这里我们绑定了三个属性，父组件的 `data` 中的 `list` 、`methods` 中的 `run` 方法以及指向父组件的 `this`。

- 子组件使用 props 对象接收 ：

接下来，我们创建一个 `ChildCom` 组件，通过子组件的 `props` 选项来获得父组件传过来的数据：

 ```html
<template>
  <div>
    <div class='list'>
      <ul>
        <li v-for='item in list' :key='item'>{{ item }}</li>
      </ul>
    </div>
    <div class='buttons'>
      <button @click='run'>执行父组件的方法</button>
      <button @click='getParent()'>获取父组件的数据和方法</button>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    getParent() {
      alert(this.home); // eslint-disable-line
      alert(this.home.list); // eslint-disable-line
      alert(this.home.run); // eslint-disable-line
    },
  },
  props: ['list', 'run', 'home'],
};
</script>

<style lang="postcss" scoped>
.list {
  margin-bottom: 10px;
}
li {
  margin: 10px 0;
  list-style: none;
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

子组件的 `props` 中接收了父组件传递下来的属性。**需要注意的是，`props` 字符串数组中的值（`prop`）要和在父组件中为子组件绑定属性的属性名保持一致。**

这里我们加了一些样式，在 `App.vue` 中引入父组件 `ParentCom` ，打开浏览器会看到：

![父组件向子组件传递](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-pass-data-1.png)

这样，在子组件中就拿到了父组件传递下来的数据和方法以及父组件本身，点击按钮就可以查看到父组件传递给子组件的数据。



#### 2、子组件向父组件通讯

前面我们知道了父组件如何向子组件通讯，那子组件如何向父组件通讯呢？这里介绍两种方式：

- 子组件触发事件，父组件监听事件并作出数据改变
- 父组件将变更数据的方法以 `props` 的形式传给子组件（借鉴 react 的父子通讯方式）

##### 2.1 监听事件

首先在子组件 `ChildCom` 的 `<template>` 中添加一个新的标签 `button`。在这个 `button` 上添加一个`click `事件：

```html
<div class='buttons'>
  <!-- add this -->
  <button @click='submit("我是子组件传递给父组件的数据")'>子组件触发更改父组件的数据</button>
</div>
```

当我们点击这个按钮的时候，想要执行 `submit` 方法，我们在子组件的 `<script>` 中添加这个方法：

```javascript
methods: {
  getParent() {
    alert(this.home); // eslint-disable-line
    alert(this.home.list); // eslint-disable-line
    alert(this.home.run); // eslint-disable-line
    alert(this.home.appendToList); // eslint-disable-line
  },
  // add this
  submit(text) {
    this.$emit('addItem', text);
  },
},
```

触发事件时发出（`$emit`）自定义的事件： `addItem`  ，这里我们也给 `addItem` 事件传递了一个 `text` 参数。这样就完成了**子组件发出自定义事件**的过程。

接下来需要在父组件中监听子组件传递的自定义事件 `addItem` 。怎么做呢？

在父组件中给子组件绑定监听子组件中自定义的事件的方法。这就意味着我们也需要在父组件中定义这个方法。看看代码：

```html
<template>
  <div>
    <ChildCom :list='list' :run='run' :home='this' @addItem='addItem'></ChildCom>
  </div>
</template>

<script>
import ChildCom from './ChildCom';

export default {
  data() {
    return {
      list: ['我是父组件里面的数据', '我来自父组件'],
    };
  },
  components: {
    ChildCom,
  },
  methods: {
    run() {
      alert('我是父组件里面的方法'); // eslint-disable-line
    },
    addItem(item) {
      this.list.push(item);
    },
  },
};
</script>
```

在子组件上绑定监听子组件中自定义事件的方法需要使用 `@` 符号，在 `methods` 中添加了 `addItem` 方法。这时候，我们打开浏览器，点击第三个按钮，就会看到子组件向父组件传递的数据了。

![子组件向父组件传递](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-pass-data-2.gif)



##### 2.2 传递 props

传递 `props` 的意思是说在父组件里面定义改变父组件数据的方法，然后通过 `props` 传递给子组件，这样子组件就可以触发执行从父组件传递下来的方法，达到更改父组件数据的目的。这种方法借鉴了 `React` 中组件通讯的方式。看看代码：

我们依旧使用上面的代码，在 `ParentCom` 组件中将 `addItem` 方法传递给子组件：

```html
<ChildCom :list='list' :run='run' :home='this' @addItem='addItem' :addItem='addItem'></ChildCom>

```

在子组件 `ChildCom` 中添加一个 `button` ，在它的点击事件中执行父组件的 `addItem` 方法，所以，我们也需要在子组件的 `props` 选项中把 `addItem` 方法添加进去：

```html
<template>
  <div>
    <div class='list'>
      <ul>
        <li v-for='item in list' :key='item'>{{ item }}</li>
      </ul>
    </div>
    <div class='buttons'>
      <button @click='run'>执行父组件的方法</button>
      <button @click='getParent()'>获取父组件的数据和方法</button>
      <button @click='submit("我是子组件传递给父组件的数据")'>子组件触发更改父组件的数据</button>
      <!-- add this -->
      <button @click='addItem("我是通过子组件props方式传递给父组件的数据")'>子组件触发更改父组件的数据-2</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {};
  },
  methods: {
    getParent() {
      alert(this.home); // eslint-disable-line
      alert(this.home.list); // eslint-disable-line
      alert(this.home.run); // eslint-disable-line
      alert(this.home.appendToList); // eslint-disable-line
    },
    submit(text) {
      this.$emit('addItem', text);
    },
  },
  // add this
  props: ['list', 'run', 'home', 'addItem'],
};
</script>
```

打开浏览器，点击 `button` :

![子组件向父组件传递](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-pass-data-3.gif)

### 二、兄弟组件之间的通讯

在 `vue` 中实现兄弟组件间的通讯主要有两种方法：**通过父组件进行兄弟组件之间通讯、通过 `EventHub` 进行兄弟组件间通讯。**为了不和上面讲述的父子组件之间通讯的代码混淆，这里我们重新新建组件来演示：

- 父组件： `ParentCard ` 
- 两个兄弟组件：`BrotherCard` 和 `SisterCard`

#### 1、通过父组件进行兄弟组件之间通讯

简单来说，就是让兄弟组件通过一个共同父组件进行通讯。

首先创建父组件 `ParentCard ` ：

```html
<template>
  <div class='container'>
    <h2>父组件</h2>
    <button @click='stopCommunicate' v-if='showButton'>停止通讯</button>
    <div class='card-body'>
      <brother-card :messageSon='messageson' @brotherSaid='messageDaughter' class='card-brother'></brother-card>
      <sister-card :messageDaughter='messagedaughter' @sisterSaid='messageSon' class='card-sister'></sister-card>
    </div>
  </div>
</template>

<script>
import BrotherCard from './BrotherCard';
import SisterCard from './SisterCard';

export default {
  name: 'ParentCard',
  data() {
    return {
      messagedaughter: '',
      messageson: '',
    };
  },
  components: { BrotherCard, SisterCard },
  methods: {
    messageDaughter(message) {
      this.messagedaughter = message;
    },
    messageSon(message) {
      this.messageson = message;
    },
    showButton() {
      return this.messagedaughter && this.messageson;
    },
    stopCommunicate() {
      this.messagedaughter = '';
      this.messageson = '';
    },
  },
};
</script>

<style scoped>
.container {
  width: 70%;
  margin: 10px auto;
  border-radius: 10px;
  box-shadow: 1px 1px 1px 1px rgba(50, 50, 93, 0.1),
    0 5px 15px rgba(0, 0, 0, 0.07) !important;
  padding: 30px;
}
.card-body {
  display: flex;
  justify-content: center;
}
.card-brother,
.card-sister {
  margin: 0 50px;
}
</style>
```

创建 `BrotherCard` 组件：

```html
<template>
  <div>
    <div>
      <p>我是子组件：Brother</p>
      <button @click='messageSister'>给妹妹发消息</button>
      <div v-if='messageSon' v-html='messageSon'></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BrotherCard',
  props: ['messageSon'],
  methods: {
    messageSister() {
      this.$emit('brotherSaid', 'Hi，妹妹');
    },
  },
};
</script>
```

创建 `SisterCard` 组件：

```html
<template>
  <div>
    <div>
      <p>我是子组件：Sister</p>
      <button @click='messageBrother'>给哥哥发消息</button>
      <div v-if='messageDaughter' v-html='messageDaughter'></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SisterCard',
  props: ['messageDaughter'],
  methods: {
    messageBrother() {
      this.$emit('sisterSaid', 'Hi，哥哥');
    },
  },
};
</script>
```

结果如下：

![兄弟组件之间的通信](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-pass-data-4.gif)

在学习完父子组件之间的通讯方法之后，通过父组件进行兄弟组件的通讯就很简单了，其实就是把兄弟之间需要共享的数据提升至他们最近的父组件当中进行管理，将他们的父组件作为中间媒介（在 `React` 中把这种方式被称为状态提升）。



#### 2、通过EventHub进行兄弟间组件通讯

在 `vue1.0` 中，组件之间的通信主要通过 `$dispatch` 沿着父链向上传播和通过 `$broadcast` 向下广播来实现。但是在 `vue2.0` 中 `$dispatch` 和 `$broadcast` 已经被[弃用](https://cn.vuejs.org/v2/guide/migration.html#events-%E9%80%89%E9%A1%B9-%E7%A7%BB%E9%99%A4)。

`vue` 中也提供了类似 `Redux` 的组件通信和状态管理方案：`vuex`。对于中大型的项目来说，使用 `vuex` 是一个很好的选择。但是对于小型的项目来说，如果一开始就引入了 `vuex` ，是完全没必要的。

`vue` 官方文档中也给出了`$dispatch`  和 `$broadcast ` 最简单的升级方式就是：**通过使用事件中心，允许组件自由交流，无论组件处于组件树的哪一层。** `vue` 文档中把这个**事件中心**命名为 `eventHub`，也有很多其他教程中将其命名为 `eventBus` 。在本教程中，我们统一命名为 `eventHub` 。

我们同样基于上面的示例来做修改：`ParentCard ` 组件包含了 `SisterCard` 和 `BrotherCard` 两个子组件，而且这两个子组件是兄弟组件。

首先在 `main.js` 文件中定义一个新的 `eventHub` 对象（`vue` 实例 ）:

```javascript
import Vue from 'vue';
import App from './App';
import router from './router';

Vue.config.productionTip = false;

// add this
export const eventHub = new Vue(); // eslint-disable-line

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>',
});
```

接着我们要做的是让  `eventHub` 实例成为 `BrotherCard` 组件中发出事件的实例，使用 `eventHub.$emit ` 来替代上例中的 `this.$emit`（因为 `eventHub` 是一个 `vue` 实例，所以它可以使用 `$emit` 方法）。

```html
<template>
  <div>
    <p>我是Brother组件</p>
    <button @click='messageSister'>给妹妹发消息</button>

    <div v-if='fromSister' v-html='fromSister'></div>
  </div>
</template>

<script>
import { eventHub } from '../../main';

export default {
  name: 'BrotherCard',
  data: () => ({
    fromSister: '',
  }),
  methods: {
    messageSister() {
      eventHub.$emit('brotherSaid', 'Hi，妹妹');
    },
  },
  /* eslint-disable */
  created() {
    eventHub.$on('sisterSaid', message => {
      this.fromSister = message;
    });
  },
};
</script>
```

引入 `main.js`，并且将 `created() ` 生命周期钩子添加到 `BrotherCard` 组件中。在 `created()` 钩子函数中添加 `eventHub` 启动自定义事件的监听器，监听 `sisterSaid` 这个动作。

接下来我们改造下 `SisterCard` 组件，和 `BrotherCard` 组件的改造是一样的：

```html
<template>
  <div>
    <p>我是Sister组件</p>
    <button @click='messageBrother' class='btn'>给哥哥发消息</button>
    <div v-if='fromBrother' v-html='fromBrother'></div>
  </div>
</template>

<script>
import { eventHub } from '../../main';

export default {
  name: 'SisterCard',
  data: () => ({
    fromBrother: '',
  }),
  methods: {
    messageBrother() {
      eventHub.$emit('sisterSaid', 'Hi，哥哥');
    },
  },
  /* eslint-disable */
  created() {
    eventHub.$on('brotherSaid', message => {
      this.fromBrother = message;
    });
  },
};
</script>
```

这时候，我们就不用在父组件 `ParentCard ` 做任何操作了：

```html
<template>
  <div class='container'>
    <h2>父组件</h2>
    <div class='card-body'>
      <brother-card class='card-brother'></brother-card>
      <sister-card class='card-sister'></sister-card>
    </div>
  </div>
</template>

<script>
import BrotherCard from './BrotherCard';
import SisterCard from './SisterCard';

export default {
  name: 'ParentCard',
  components: {
    'brother-card': BrotherCard,
    'sister-card': SisterCard,
  },
};
</script>
```

打开浏览器，可以看到这样也实现了兄弟组件之间的通讯。

### 三、全局模式

这里的全局模式指的是**创建全局变量和全局方法，让其他组件之间共享数据存储的模式**。我们看看怎么操作：

先创建一个 `store.js` ，在这个 `JS` 文件里创建全局的变量和方法：

```javascript
const store = {
  state: { numbers: [1, 2, 3] },
  addNumber(newNumber) {
    this.state.numbers.push(newNumber);
  },
};

export default store;
```

在 `store` 的 `state` 中存放了一个 `numbers` 数组和一个 `addNumber` 方法。接下来我们创建两个组件：

-  `NumberDisplay ` 组件：用来显示来自 `store` 的 `numbers` 数组
- `NumberSubmit` 组件：允许用户向数据数组中添加一个新的数字

创建 `NumberDisplay ` 组件：

```html
<template>
  <div>
    <h2>{{ storeState.numbers }}</h2>
  </div>
</template>

<script>
import store from './store';

export default {
  name: 'NumberDisplay',
  data() {
    return {
      storeState: store.state,
    };
  },
};
</script>
```

创建 `NumberSubmit` 组件：

```html
<template>
  <div class='form'>
    <input v-model='numberInput' type='number'>
    <button @click='addNumber(numberInput)'>Add new number</button>
  </div>
</template>

<script>
import store from './store';

export default {
  name: 'NumberSubmit',
  data() {
    return {
      numberInput: 0,
    };
  },
  methods: {
    addNumber(numberInput) {
      store.addNumber(Number(numberInput));
    },
  },
};
</script>
```

接着在 `GlobalMode.vue` 中引用刚才创建的组件：

```html
<template>
  <div>
    <NumberDisplay/>
    <NumberSubmit/>
  </div>
</template>

<script>
import NumberDisplay from '../components/pass-data-3/NumberDisplay';
import NumberSubmit from '../components/pass-data-3/NumberSubmit';

export default {
  name: 'GlobalMode',
  components: { NumberDisplay, NumberSubmit },
};
</script>
```

效果如下：

![全局模式](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-pass-data-5.gif)

可以看到，我们使用这种方式也可以实现组件间的通讯。



### 四、总结

最后，我们画个图总结一下 `Vue` 组件间的通讯：

![Vue组件间的通讯](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-pass-data-in-components.png)

> 本节内容代码地址：https://github.com/IDeepspace/Hello-Vue/tree/master/vue-component-communication



<br>

> 转载文章请给作者署名：https://togoblog.cn/