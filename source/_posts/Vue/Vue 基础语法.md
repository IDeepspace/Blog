---
title: Vue 基础语法
author: Hazelnut Latte
categories: Vue
tag:
  - vue 
date: 2019-01-22
urlname: vue-basic
---

<!-- ## Vue 基础语法 -->

> [Vue 的官方文档](https://cn.vuejs.org/v2/guide/)写的非常棒(另一个我觉得中文文档写的很好地是 [Ant-Design](https://ant.design/docs/react/introduce-cn))。

这篇文章以使用 `vue-cli` 生成的项目为基础，以完整 `demo` 的形式讲解 `Vue` 的基础语法。关于 `vue-cli` 生成项目的讲解，可以参考：[vue-cli 构建 vue 项目详解](https://togoblog.cn/vue-cli-init-project-intro/) 。

在  `vue-cli` 生成的项目中，我们打开 `src/components` 文件夹下 `HelloWorld.vue` 组件，为便于演示，删减了一部分内容（本文中的例子都将改造 `HelloWorld.vue` 组件来演示 `Vue` 语法）：

```html
<template>
  <div class='hello'>
    <h1>{{ msg }}</h1>
    <h2>Essential Links</h2>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      msg: 'Welcome to Your Vue.js App',
    };
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
</style>
```
<!-- more -->
### 一、创建组件

> 在 `vue` 中，有好几种方式用来创建组件，后面会单独写一篇文章来介绍。

`HelloWord.vue` 文件中的内容分为三个部分：

```html
<template>
  ...
</template>

<script>
  ...
</script>

<style>
 ...
</style>
```

分别在这三类标签里面写入**结构、脚本、样式**。 这个文件以 `.vue` 结尾（注意：其他创建组件方式是以 `.js` 结尾），这是 `vue` 中创建组件的一种方式：**单文件组件**。换句话说就是每个 `.vue` 文件就是一个组件。

**有一点需要注意：`template` 只能允许一个子元素。** 



### 二、导入组件

现在的文件中，是在路由 `router/index.js` 中引入的 `HelloWorld` 组件：

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

引入的方式一目了然，不再赘述。那如何在组件中引入组件呢？下面我们在 `App` 组件中直接引入 `Helloworld` 看看：

```html
<template>
  <div id='app'>
    <img src='./assets/logo.png'>
    <HelloWorld/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld';

export default {
  name: 'App',
  components: { HelloWorld },
};
</script>

<style>
#app {
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
```

在 `script` 标签中，`HelloWorld` 组件被引入并添加到 `components` 属性中。这样，就在 `App` 组件中引入了 `HelloWorld` 组件。启动项目在浏览器中打开，会看到 `App` 组件中的内容：`Vue` 的 `Logo` 、 `HelloWorld` 组件里的内容。

那如果要引入多个组件该怎么写呢？假设我们再有个 `Demo` 组件：

```html
<template>
  <div id='app'>
    <img src='./assets/logo.png'>
    <hello-world/>
    <demo/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld';
import Demo from './components/Demo';

export default {
  name: 'App',
  components: {
    'hello-world': HelloWorld,
    demo: Demo,
  },
};
</script>
```

在 `components` 对象中定义多个属性，指向引入的组件即可。



### 三、插值和指令

#### 1、插值(Interpolation)

##### 文本插值：

`Vue` 插值最常见的形式就是使用双大括号 `{% raw %}{{ }} {% endraw %}` 的文本插值。在文章开头中的 `HelloWorld` 组件中就使用了插值的方式实现数据绑定。这里我们详细介绍一下：

在 `Vue` 组件中，都有一个 `data` 属性，`data` 必须是一个函数，该函数的返回值是一个对象。我们可以在 `template` 中通过双大括号来读取 `data` 中的属性值：

```html
<template>
    <div>
    	<h1>{{ msg }}</h1>
    	<span v-once>这个将不会改变: {{ msg }}</span>
    </div>  
</template>

<script>
export default {
  // ...
  data() {
    return {
      msg: 'Welcome to Your Vue.js App',
    };
  },
};
</script>
```

这里也通过使用 [v-once 指令](https://cn.vuejs.org/v2/api/#v-once)（下面我们要说），执行一次性地插值：当数据改变时，插值处的内容不会更新。但是要注意**一次性插值会影响到该节点上的其它数据绑定。**

##### 属性插值：

如何在 `template` 中包裹的标签的属性上插值呢？假设我们有一个 `<button>`，想通过插值的方式设置它的 `disable` 属性，需要这样做：

```html
<template>
    <div>
        // ...
        <button v-bind:disabled='btnState'>{{ name }}</button>
	</div>
</template>

<script>
export default {
  // ...
  data() {
    return {
      name: 'Vue',
      btnState: true, // Add this
    };
  },
};
</script>        
```

在属性中插值，需要通过字符串的形式读取 `data` 中的值，不可以使用双大括号。现在，这个 `button` 就被 `disable` 掉了。

##### 表达式插值：

`vue` 中也支持表达式插值：

```html
<template>
    <div>
    	<!-- Add this -->
    	{{ btnState ? 'The button is disabled' : 'The button is active'}}
        
    	<button v-bind:disabled='btnState'>{{ name }}</button>
    </div>
</template>
```

用双大括号将表达式括起来。此时页面上会显示：`The button is disabled`。当然，你可以表达式中添加更加复杂的逻辑。

#### 2、指令(Directives)

指令 (`Directives`) 是带有 `v-` 前缀的特殊特性。它的作用是什么呢？就是当表达式的值改变时，将其产生的连带影响，响应式地作用于 `DOM`。我们看看几个例子：

- `v-for` :

```html
<tamplate>
    <div>
        <ul>
          <li v-for='todo in todos' :key='todo.key'>{{ todo.text }}</li>
        </ul>
    </div>
</tamplate>

<script>
export default {
  // ...
  data() {
    return {
      todos: [
        { text: '学习 JavaScript' },
        { text: '学习 Vue' },
        { text: '学习 前端' },
      ],
    };
  },
};
</script> 
```

`v-for` 指令可以绑定数组的数据来渲染一个项目列表：

```javascript
· 学习 JavaScript
· 学习 Vue
· 学习 前端
```

- `v-if` 和 `v-else` :

```html
<tamplate>
    <div>
        <ul>
          <li v-for='todo in todos' :key='todo.key'>{{ todo.text }}</li>
        </ul>
		// add this
        <p v-if='todos.length >= 1'>You have more than 1 todo</p>
		<p v-else>You have no todos</p>
    </div>
</tamplate>
```

这里，`v-if` 指令将根据表达式的值的真假来插入/移除 `<p>` 元素。 

关于更多 `vue` 指令，可以查看 [vue 指令 api](https://cn.vuejs.org/v2/api/#%E6%8C%87%E4%BB%A4)，这里不再一一讲述。



### 四、事件处理

`vue` 中可以用 `v-on` 指令监听 `DOM` 事件，并在触发时运行相关 `JavaScript` 代码。我们通过几个例子来看看 `vue` 中的事件处理。

#### 1、计数器

```html
<template>
  <div>
    <span>{{ counter }}</span>
    <button v-on:click='counter += 1'>+ 1</button>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      counter: 0,
    };
  },
};
</script>
```

点击 `button` , 计数器递增 `+1`。`+1` 的逻辑写在了 `v-on` 指令里面，显然这是不可取的，许多事件处理逻辑会更为复杂。

在 `Vue` 组件中，都有一个 `data` 属性，也有一个 `methods` 属性。该属性是一个对象，我们可以在对象中定义方法。对于上面的例子，我们可以把点击 `button` 之后的处理逻辑放在  `methods` 中，`click` 事件调用 `methods` 中的方法：

```html
<template>
  <div>
    <span>{{ counter }}</span>
    <button v-on:click='add'>+ 1</button>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      counter: 0,
    };
  },
  methods: {
    add() {
      this.counter += 1;
    },
  },
};
</script>
```

#### 2、事件修饰符

在事件处理程序中调用 `event.preventDefault()` 或 `event.stopPropagation()` 是非常常见的需求。虽然我们可以在事件的响应函数里面来做这些事情，但是 `vue` 提供了一个更优雅的方式来实现它 —— **事件修饰符**，保证了事件处理函数的干净纯粹：只关注数据处理逻辑。

修饰符是由点开头的指令后缀来表示的，我们把相应的修饰符添加在事件名称后面就好了，如：

```html
<!-- 阻止单击事件继续传播 -->
<a v-on:click.stop="doThis"></a>

<!-- 提交事件不再重载页面 -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修饰符可以串联 -->
<a v-on:click.stop.prevent="doThat"></a>

<!-- 只有修饰符 -->
<form v-on:submit.prevent></form>

<!-- 添加事件监听器时使用事件捕获模式 -->
<!-- 即元素自身触发的事件先在此处理，然后才交由内部元素进行处理 -->
<div v-on:click.capture="doThis">...</div>

<!-- 只当在 event.target 是当前元素自身时触发处理函数 -->
<!-- 即事件不是从内部元素触发的 -->
<div v-on:click.self="doThat">...</div>
```

- `.stop`
- `.prevent`
- `.capture`
- `.self`
- `.once`
- `.passive`

> 注意：使用修饰符时，顺序很重要；相应的代码会以同样的顺序产生。因此，用 `v-on:click.prevent.self` 会阻止**所有的点击**，而 `v-on:click.self.prevent` 只会阻止对元素自身的点击。注意这一点对我们定位 `bug` 时很关键。



### 五、处理用户输入

我们可以用 `v-model` 指令来处理用户输入。 `v-model` 指令可以在表单 `<input>`、`<textarea>` 及 `<select>` 元素上创建双向数据绑定，它会根据控件类型自动选取正确的方法来更新元素。`v-model` 本质上是语法糖，它负责监听用户的输入事件以更新数据，并对一些极端场景进行一些特殊处理。

看看如何使用：

#### 1、文本

```html
<template>
  <div>
    <input type='text' placeholder='Enter a todo..' v-model='todo'>
    <div>{{ todo }}</div>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      todo: '',
    };
  },
};
</script>
```

#### 2、多行文本域

这里需要注意，在 `<textarea>` 中使用文本插值并不会生效，应用 `v-model` 来代替。

```html
<template>
  <div>
    // ...
    <!-- <textarea placeholder='add multiple lines'>{{ todo }}</textarea> // 不生效 -->
    <textarea v-model='todo' placeholder='add multiple lines'></textarea>
  </div>
</template>
```

#### 3、单选按钮 

```html
<template>
  <div>
    <input type='radio' id='one' value='One' v-model='picked'>
    <label for='one'>One</label>
    <br>
    <input type='radio' id='two' value='Two' v-model='picked'>
    <label for='two'>Two</label>
    <br>
    <span>Picked: {{ picked }}</span>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      picked: '',
    };
  },
};
</script>
```

#### 4、复选按钮

##### 单个复选框

绑定到布尔值：

```html
<template>
  <div>
    <input type='checkbox' id='checkbox' v-model='checked'>
    <label for='checkbox'>{{ checked }}</label>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      checked: '',
    };
  },
};
</script>
```

##### 多个复选框

绑定到同一个数组：

```html
<template>
  <div>
    <input type='checkbox' id='jack' value='Jack' v-model='checkedNames'>
    <label for='jack'>Jack</label>
    <input type='checkbox' id='john' value='John' v-model='checkedNames'>
    <label for='john'>John</label>
    <input type='checkbox' id='mike' value='Mike' v-model='checkedNames'>
    <label for='mike'>Mike</label>
    <br>
    <span>Checked names: {{ checkedNames }}</span>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      checkedNames: [],
    };
  },
};
</script>
```

#### 5、选择框

##### 单选

```html
<template>
  <div>
    <select v-model='selected'>
      <option disabled value>请选择</option>
      <option>A</option>
      <option>B</option>
      <option>C</option>
    </select>
    <span>Selected: {{ selected }}</span>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      selected: '',
    };
  },
};
</script>
```

##### 多选

```html
<template>
  <div>
    <select v-model='selected' multiple style='width: 50px;'>
      <option>A</option>
      <option>B</option>
      <option>C</option>
    </select>
    <br>
    <span>Selected: {{ selected }}</span>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      selected: [],
    };
  },
};
</script>
```

#### 6、动态选项

非常常见的一个场景是，用 `v-for` 渲染的动态选项：

```html
<template>
  <div>
    <select v-model='selected'>
      <option
        v-for='option in options'
        v-bind:value='option.value'
        v-bind:key='option.value'
      >{{ option.text }}</option>
    </select>
    <span>Selected: {{ selected }}</span>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      selected: 'A',
      options: [
        { text: 'One', value: 'A' },
        { text: 'Two', value: 'B' },
        { text: 'Three', value: 'C' },
      ],
    };
  },
};
</script>
```



### 六、样式

在 `HelloWorld` 组件中，有一组 `style` 标签：

```html
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
// ...
</style>
```

这就意味着我们可以在这个组件中定义任何样式。默认 `style` 标签上加了一个 `scoped` 属性，表示样式只在本组件内部生效，不用担心会影响其他组件。

#### 1、链接到外部样式表

```html
<style src="./style.css" scoped>
// ...
</style>
```

#### 2、class 绑定

在 `vue` 中 `class` 绑定和 `style` 绑定都是用 `v-bind` 指令。 `v-bind` 指令允许我们动态控制何时以及是否应用 `CSS` 类和样式，以及 `CSS` 属性和值。看看怎么使用：

```html
<template>
  <div>
    <div v-bind:class='{ banner: showBanner}'></div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showBanner: true,
    };
  },
};
</script>

<style scoped >
.banner {
  background-color: purple;
  width: 100%;
  height: 30px;
}
</style>
```

打开浏览器，我们会看到一个紫色的长方形。如果想在 `showBanner` 为 `false` 的时候显示长方形，只需要对 `showBanner` 取反即可：

```html
<div v-bind:class='{ banner: !showBanner}'></div>
```

那如果需要绑定多个 `class` ，要怎么办呢？

```html
<div v-bind:class="{ banner: showBanner, 'another-class': showClass }"></div>
```

用逗号分隔，然后在组件的 `data` 中定义另一个布尔属性，并在样式中定义 `.another-class` 即可。

但是如果 `calss` 继续增多，这种方式会让 `template` 变得很不干净，我们可以这样修改：

```html
<template>
  <div>
    <div v-bind:class='classObject'></div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      classObject: {
        banner: true,
        bannerBorder: true,
        // More classes here if you want..
      },
    };
  },
};
</script>

<style scoped >
.banner {
  background-color: purple;
  width: 100%;
  height: 30px;
}
.bannerBorder {
  border: 3px solid yellow;
}
</style>
```

 `class` 绑定的数据对象不必内联定义在模板里，抽离出来放在 `data` 函数的返回值里面。

#### 3、style 绑定

和 `class` 绑定一样，`vue` 也使用 `v-bind` 指令来绑定 `style` :

```html
<template>
  <div>
    <div v-bind:style='{ backgroundColor: bgColor, width: bgWidth, height: bgHeight }'></div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      bgColor: 'yellow',
      bgWidth: '100%',
      bgHeight: '30px',
    };
  },
};
</script>
```

为了让模板更加干净，我们也可以像下面这样调整：

```html
<template>
  <div>
    <div v-bind:style='styleObject'></div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      styleObject: {
        backgroundColor: 'yellow',
        width: '100%',
        height: '30px',
      },
    };
  },
};
</script>
```

> 注意：`css` 属性名可以用驼峰式 (`camelCase`) 或短横线分隔 (`kebab-case`) 来命名。使用短横线分割时，需要用单引号把属性名括起来。



### 七、 Todolist

学习完 `Vue` 的基础语法，我们可以写一个 `Todolist` 来检验一下自己：

![vue-todolist](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-todolist.png)

> 代码可参考：https://github.com/IDeepspace/Hello-Vue/tree/master/vue-todolist

