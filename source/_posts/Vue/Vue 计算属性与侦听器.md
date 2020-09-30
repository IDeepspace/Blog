---
title: Vue 计算属性与侦听器
author: Deepspace
categories: Vue
tag:
  - vue
  - vue 计算属性
  - vue 侦听器
date: 2019-01-27
urlname: vue-computed-watch
---

<!-- ## Vue 计算属性与侦听器 -->

这一节我们一起学习 `vue` 中的计算属性(`computed properties`)和侦听器(`watch`)。

在之前，我们学习过 `vue` 表达式插值：

```html
<div id="example">{{ message.split('').reverse().join('') }}</div>
```

如果在模板中放入太多的逻辑会让模板过重且难以维护。我们可以把方法写在事件处理函数里面，并且在构造器内部通过 `this` 调用。

<!-- more -->

`Html` 代码：

```html
<h1>{{ this.reversedMessageMethod() }}</h1>
```

`JS` 代码：

```javascript
methods: {
  reversedMessageMethod() {
    return this.message.split('').reverse().join('');
  },
},
```

> 这里要提醒一下，我们不可以把事件处理函数写成箭头函数，因为这里的 `this` 需要指向 `vue` 实例。

### 一、过滤器

其实，模板中的处理逻辑是不适合放在事件处理函数里的，即使可以这么做。事件处理函数应该专注于处理事件，我们应该让它变得纯粹。在 `vue` 中， 允许我们自定义过滤器(`filters`)，可被用于一些常见的文本格式化。

过滤器可以用在两个地方：**双花括号插值和 `v-bind` 表达式** (后者从 `2.1.0+` 开始支持)。过滤器应该被添加在 `JavaScript` 表达式的尾部，由 `|` 符号指示，我们看看怎么用：

```html
<template>
  <div class="hello">
    <h1>{{ message.split('').reverse().join('') }}</h1>
    <!-- add this -->
    <h1>{{ message | reverseString }}</h1>
  </div>
</template>

<script>
  export default {
    name: 'HelloWorld',
    data() {
      return {
        message: 'Welcome to Your Vue.js App',
      };
    },
    // add this
    filters: {
      reverseString(val) {
        let value = val;
        if (!value) return '';
        value = value.split('').reverse().join('');
        return value;
      },
    },
  };
</script>
```

代码增多了，但是整体的语义化却更好。从 `filters` 的用法我们可以看出：

- 它是一对一的，对**单个数据**进行过滤，可以进行传参
- 适用于同方法、不同参数的情况

所以，`filters` 的缺点就很明显了：**如果要计算结合多个数据不同变化的情况，过滤器就无法适用了**。这就要用到我们下面提到的**计算属性**了。

### 二、计算属性

在 `vue` 中，也为我们提供了`computed` 这个选项来处理数据，我们称它为计算属性。当逻辑复杂的时候，我们就应当使用 `computed` 计算属性了。计算属性使用起来非常简单，我们还是用上面的例子，使用计算属性来修改模板中的逻辑：

```html
<template>
  <div class="hello">
    <h1>{{ message.split('').reverse().join('') }}</h1>
    <h1>{{ message | reverseString }}</h1>
    <h1>{{ this.reversedMessageMethod() }}</h1>
    <!-- add this -->
    <h1>{{ reversedMessage }}</h1>
  </div>
</template>

<script>
  export default {
    name: 'HelloWorld',
    data() {
      return {
        message: 'Welcome to Your Vue.js App',
      };
    },
    filters: {
      reverseString(val) {
        let value = val;
        if (!value) return '';
        value = value.split('').reverse().join('');
        return value;
      },
    },
    // add this
    computed: {
      reversedMessage() {
        return this.message.split('').reverse().join('');
      },
    },
    methods: {
      reversedMessageMethod() {
        return this.message.split('').reverse().join('');
      },
    },
  };
</script>
```

和 `method` 选项的使用非常相似。**我们可以像绑定普通属性一样在模板中绑定计算属性。**

这两种方式的最终结果确实是完全相同的。然而，不同的是：**计算属性是基于它们的依赖进行缓存的**。什么意思呢？

**只在相关依赖发生改变时它们才会重新求值**。这就意味着只要 `message` 还没有发生改变，多次访问 `reversedMessage` 计算属性会立即返回之前的计算结果，而不必再次执行函数；而当数据有变化时，只要有一个数据发生变化，则会重新计算，来更新视图的改变。相比之下，每当触发重新渲染时，调用 `methods` 中的方法将**总会**再次执行函数。

> 我们为什么需要缓存？假设我们有一个性能开销比较大的计算属性 **A**，它需要遍历一个巨大的数组并做大量的计算。然后我们可能有其他的计算属性依赖于 **A** 。如果没有缓存，我们将不可避免的多次执行 **A** 的 `getter`！

我们来看看计算属性的具体应用场景：

**1、微博发文**

发微博的时候，有字数限制。在我们输入文字的时候，输入框会计算我们还可以输入多少字：

```html
<template>
  <div>
    <textarea v-model="content" :maxlength="totalcount"></textarea>
    <p>你还可以输入{{reduceCount}}字</p>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        totalcount: 200, // 总共只给输入200字
        content: '',
      };
    },
    computed: {
      reduceCount() {
        return this.totalcount - this.content.length;
      },
    },
  };
</script>
```

通过一直监听输入的字符的长度来触发 `computed` 里的 `reduceCount` 方法，重新计算，然后返回给视图，让视图作出相应的变化。接下来我们再看一个例子。

**2、足球比赛**

这个例子是一个足球比赛的结果播报板，我们先看看最终的效果，再看代码：

**效果 ：**

![match](https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Vue/vue-computed.gif)

**代码：**

```html
<template>
  <div>
    <h1>比赛时间：{{time}}s</h1>
    <h2>直播播报：{{result}}</h2>
    <div class="team">
      <div>
        <p>中国队进球数：{{team.china}}</p>
        <button @click="team.china++">点击中国队进一球</button>
      </div>
      <div>
        <p>韩国队进球数：{{team.korea}}</p>
        <button @click="team.korea++">点击韩国队进一球</button>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    created() {
      const time = setInterval(() => {
        this.time = this.time + 1;
        if (this.time === 90) {
          clearInterval(time);
        }
      }, 1000);
    },
    data() {
      return {
        time: 0,
        team: {
          china: 0,
          korea: 0,
        },
      };
    },
    computed: {
      result() {
        if (this.time < 90) {
          if (this.team.china > this.team.korea) {
            return '中国队领先';
          } else if (this.team.china < this.team.korea) {
            return '韩国队领先';
          }
          return '双方僵持';
        }
        if (this.team.china > this.team.korea) {
          return '中国队赢';
        } else if (this.team.china < this.team.korea) {
          return '韩国队赢';
        }
        return '平局';
      },
    },
  };
</script>

<style scoped>
  .team {
    display: flex;
    justify-content: center;
  }
  button {
    padding: 15px 60px;
    outline: none;
    background-color: #27ae60;
    display: block;
    font-size: 1rem;
    color: #fff;
    margin: 10px;
  }
</style>
```

通过上面的例子，我们就可以很清楚 `computed` 的作用了：观察一个或者多个数据，只要依赖的数据发生变化的时，这个函数就会重新计算。这样我们就可以通过观察所有数据来维护一个状态，也就是所谓的返回一个状态值。

### 三、侦听器

虽然计算属性在大多数情况下更合适，但有时也需要一个自定义的侦听器。`vue` 通过 `watch` 选项提供了一个更通用的方法，来响应数据的变化。

`computed ` 和 `watch ` 都可以做同一件事，两个选项都是对数据进行时时监听。但是它们也有不同：

- `computed ` 对**多数据**变动进行监听，**返回一个状态**，维护一个状态
- `watch` 是对**一个数据**监听，在数据变化时，会**返回两个值**，一个是 `value `(当前值)，二是 `oldvalue` 是变化前的值

我们也可以用 `watch` 选项来改造上面的足球比赛的例子，添加一个 `watch` 选项：

```html
<script>
  export default {
    created() {
      const time = setInterval(() => {
        this.time = this.time + 1;
        if (this.time === 90) {
          clearInterval(time);
        }
      }, 1000);
    },
    data() {
      return {
        time: 0,
        team: {
          china: 0,
          korea: 0,
        },
      };
    },
    // add this
    watch: {
      time(value, oldval) {
        // eslint-disable-line
        if (value < 90) {
          if (this.team.china > this.team.korea) {
            this.result = '中国队领先';
          } else if (this.team.china < this.team.korea) {
            this.result = '韩国队领先';
          } else {
            this.result = '双方僵持';
          }
        } else if (this.team.china > this.team.korea) {
          this.result = '中国队赢';
        } else if (this.team.china < this.team.korea) {
          this.result = '韩国队赢';
        } else {
          this.result = '平局';
        }
      },
      team(value, oldval) {
        // eslint-disable-line
        if (this.time < 90) {
          if (value.china > value.korea) {
            this.result = '中国队领先';
          } else if (value.china < value.korea) {
            this.result = '韩国队领先';
          } else {
            this.result = '双方僵持';
          }
        } else if (value.china > value.korea) {
          this.result = '中国队赢';
        } else if (value.china < value.korea) {
          this.result = '韩国队赢';
        } else {
          this.result = '平局';
        }
      },
    },
  };
</script>
```

可以看出跟使用 `computed` 选项是差不多一致的。那 `watch` 有什么应用场景呢？

有一个很常见的场景：图片的预加载。当图片数量比较大的时候，为了保证页面图片都加载出来的时候，才把主页面给显示出来，然后再进行一些 `ajax` 请求，或者逻辑操作，这个时候用 `computed` 就无法实现了，只能用 `watch` ，看看代码：

```html
<template>
  <div v-show="show">
    <img
      src="https://img.alicdn.com/simba/img/TB14sYVQXXXXXc1XXXXSutbFXXX.jpg"
      alt
    />
    <img
      src="//img.alicdn.com/tfs/TB1iZ6EQXXXXXcsXFXXXXXXXXXX-520-280.jpg_q90_.webp"
      alt
    />
    <img
      src="https://img.alicdn.com/simba/img/TB1C0dOPXXXXXarapXXSutbFXXX.jpg"
      alt
    />
    <img
      src="//img.alicdn.com/tfs/TB1iZ6EQXXXXXcsXFXXXXXXXXXX-520-280.jpg_q90_.webp"
      alt
    />
  </div>
</template>

<script>
  export default {
    data() {
      return {
        count: 0,
        show: false,
      };
    },
    mounted() {
      const imgs = document.querySelectorAll('img');
      console.log(imgs); // eslint-disable-line
      Array.from(imgs).forEach((item) => {
        const img = new Image();
        img.onload = () => {
          this.count = this.count + 1;
        };
        img.src = item.getAttribute('src');
      });
    },
    watch: {
      count(val, oldval) {
        // eslint-disable-line
        if (val === 4) {
          this.show = true;
          alert('加载完毕'); // eslint-disable-line
          // 然后可以对后台发送一些ajax操作
        }
      },
    },
  };
</script>
```

我们可以发现等四张图片都加载完毕的时候页面才显示出来。所以当我们想要在数据变化响应时，执行异步操作或开销较大的操作，就需要使用 `watch` 了。

### 四、总结

过滤器 `filter` :

- 一对一，对单个数据进行过滤，可以进行传参
- 适用于同方法、不同参数的情况
- 不适用于结合多个数据变化的情况

计算属性 `computed` :

- 监听一个或者多个数据来维护返回一个状态值
- 只在相关依赖发生改变时它们才会重新求值

侦听器 `watch` :

- 对一个数据监听
- 在数据变化时，会返回两个值，一个是 `value `(当前值)，二是 `oldvalue` 是变化前的值

> 注：本节内容的 `demo` 均来自 [混元霹雳手](https://juejin.im/post/58d8806bac502e0058d778a1)，感谢作者！

> 本节内容代码：https://github.com/IDeepspace/Hello-Vue/tree/master/vue-computed-watch
