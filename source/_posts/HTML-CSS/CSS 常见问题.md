---
title: CSS 常见问题
author: Deepspace
tags:
  - CSS
categories: HTML-CSS
date: 2016-10-12
urlname: css-basic
---



## CSS 常见问题

**标准的 CSS 的盒子模型是什么？与低版本 IE 的盒子模型有什么不同的？**

可以认为每个 html 标签都是一个方块，然后这个方块又包着几个小方块，如同盒子一层层的包裹着，这就是所谓的盒模型。

- 标准盒子模型：宽度 = 内容的宽度（content）+ border + padding + margin
  - 在标准的盒子模型中，width 指 content 部分的宽度
- 低版本 IE 盒子模型：宽度 = 内容宽度（content+border+padding）+ margin
  - 在 IE 盒子模型中，width 表示 content+padding+border 这三个部分的宽度



**切换盒模型**

- box-sizing: content-box 是 W3C 盒子模型
- box-sizing: border-box 是 IE 盒子模型

box-sizing 的默认属性是 content-box



**选择器优先级**

!important > 行内样式 > id选择器 > 类选择器 > 标签选择器 > 通配符 > 继承

- 权重算法：(0,0,0,0)  ——> 第一个 0 对应的是 important 的个数，第二个 0 对应的是id选择器的个数，第三个 0 对应的类选择器的个数，第四个 0 对应的是标签选择器的个数，合起来就是当前选择器的权重；

- 比较：先从第一个0开始比较，如果第一个0大，那么说明这个选择器的权重高，如果第一个相同，比较第二个，依次类推。



**怎么实现水平垂直居中**

https://juejin.im/post/58f818bbb123db006233ab2a



**CSS3 新增伪类有那些？**

- p:first-of-type 选择属于其父元素的首个元素
- p:last-of-type 选择属于其父元素的最后元素
- p:only-of-type 选择属于其父元素唯一的元素
- p:only-child 选择属于其父元素的唯一子元素
- p:nth-child(2) 选择属于其父元素的第二个子元素
- :enabled :disabled 表单控件的禁用状态。
- :checked 单选框或复选框被选中。



**实现左边定宽，右边自适应布局**

（1）左盒子左浮动，右盒子 `width=100%`
（2）左盒子左浮动，右盒子 `margin-left = 左盒子宽度`
（3）左盒子左浮动，右盒子右浮动，设置 `width: calc（100% - 左盒子宽度）`
（4）父容器设置 `display: flex`，右盒子 `flex：1`



**CSS3 新特性**

- 颜色：新增 RGBA、HSLA 模式
- 文字阴影（text-shadow）
- 边框：圆角（border-radius）边框阴影：box-shadow
- 盒子模型：box-sizing
- 背景：background-size 设置背景图片的尺寸，background-origin 设置背景图片的原点，background-clip设置背景图片的裁剪区域，以 ',' 分隔可以设置多背景，用于自适应布局
- 渐变：linear-gradient、radial-gradient
- 过渡：transition 可实现动画
- 自定义动画
- 在 CSS3 中唯一引入的伪元素是 ::selection
- 多媒体查询、多栏布局
- border-image
- 2D转换：transform: translate(x,y) rotate(x,y) skew(x,y) scale(x,y)
- 3D转换



**display:none 与 visibility:hidden 的区别是什么？**

(1)	`display:none;` ：`HTML` 元素（对象）的宽高等各种属性值都将"丢失"，视为不存在，而且不加载。

(2)	`visibility:hidden;` ：`HTML` 元素（对象）仅仅是在视觉上看不见（完全透明），而它所占据的空间位置仍然存在，也即是说它仍然具有高度，宽度等属性值。



**响应式布局原理**

媒体查询，查询到当前屏幕(媒介媒体)的宽度，针对不同的屏幕宽度设置不同的样式来适应不同屏幕。



**flex 布局**

（1）设置在容器上的属性

- `flex-direction：row | row-reverse | column | column-reverse` ：项目的排列方向
- `flex-wrap：nowrap | wrap | wrap-reverse`：是否换行
- `flex-flow：<flex-direction> || <flex-wrap> `：`flex-direction` 和 `flex-wrap` 的简写
- `justify-content：flex-start | flex-end | center | space-between | space-around`：在水平方向上的对齐方式
- `align-items: flex-start | flex-end | center | baseline | stretch`：定义在垂直方向上的对齐方式
- `align-content: flex-start | flex-end | center | space-between | space-around | stretch`  : 定义了多根轴线的对齐方式，如果项目只有一根轴线，那么该属性将不起作用(item有多行时)

（2）设置在项目上的属性

- `order：<number>`：定义项目在容器中的排列顺序，数值越小，排列越靠前，默认值为 0
- `flex-basis：<length> | auto`：定义了在分配多余空间之前，项目占据的主轴空间，浏览器根据这个属性，计算主轴是否有多余空间
- `flex-grow: <number> `：定义项目的放大比例。默认值为 0，即如果存在剩余空间，也不放大
- `flex-shrink: <number>`： 定义项目的缩小比例。默认值: 1，即如果空间不足，该项目将缩小，负值对该属性无效。
- `flex：none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]flex-grow, flex-shrink 和 flex-basis` ：的简写 默认值：0 1 auto， 即不放大，可缩小，大小就是项目本身的大小。
- `align-self：auto | flex-start | flex-end | center | baseline | stretch`： 允许单个项目有与其他项目不一样的对齐方式