---
title: HTML 常见问题
author: Deepspace
tags:
  - HTML
categories: HTML-CSS
date: 2016-10-12
urlname: html-basic
---



## HTML 常见问题

**什么是 <!DOCTYPE>？**

`DOCTYPE` 是 `HTML5` 标准网页声明，且必须声明在 `HTML` 文档的第一行。来告知浏览器的解析器用什么文档标准解析这个文档。



**HTML5 有哪些新特性，移除了哪些元素？**

新特性：

- 用于绘画的 canvas 元素；
- 用于媒介回放的 video 和 audio 元素；
- 对本地离线存储有更好的支持，localStorage 长期存储数据，浏览器关闭后数据不丢失；sessionStorage 的数据在浏览器关闭后自动删除；
- 语意化更好的内容元素，比如 header, nav, section, article, footer；
- 新的表单控件：calendar, date, time, email, url, search；
- 新的技术 webworker, websockt, Geolocation；

移除元素：

- 纯表现的元素：basefont, big, center, font, s, strike, tt, u;
- 对可用性产生负面影响的元素：frame, frameset, noframes;



**如何处理 HTML5 新标签的浏览器兼容问题？**

IE8/IE7/IE6 支持 document.createElement 方法产生的标签，可以利用这一特性让这些浏览器支持 HTML5 新标签，浏览器支持新标签后，还需要添加标签默认的样式。



**defer 和 async 的区别**

- **defer 渲染完再执行：**要等到整个页面在内存中正常渲染结束（DOM 结构完全生成，以及其他脚本执行完成），才会执行。多个 defer 脚本会按照它们在页面出现的顺序加载。
- **async 下载完就执行：** 一旦下载完，渲染引擎就会中断渲染，执行这个脚本以后，再继续渲染。多个 async 脚本是不能保证加载顺序的。



**html5 哪些标签可以做 SEO 优化？**

title、meta、header、footer、nav、article、aside



 **HTML语义化**

- 用正确的标签做正确的事情。
- `HTML` 语义化让页面的内容结构化，结构更清晰，便于对浏览器，搜索引擎解析；
- 即使在没有样式 `CSS` 情况下也以一种文档格式显示，并且是容易阅读的；
- 搜索引擎的爬虫也依赖于 `HTML` 标记确定上下文和各个关键字的权重，利于 `SEO`;
- 使阅读源代码的人更容易将网站分块，便于阅读维护理解。



**行内元素和块级元素的区别？行内块级元素的兼容性使用？（IE8以下）**

- 块级元素：`div`、`p`、`h1`、`form`、`ul`、`li`

（1）各占一行，垂直方向排列；
（2）可以包含其他块级或者行内元素；
（3）高度、行高以及外边距和内边距都可控制；
（4）默认宽度是它本身父容器的 100%（和父元素的宽度一致），与内容无关。

- 行内元素：`span`、`a`、`label`、`input`、`img`、`strong`、`em`

（1）水平方向排列，不会自动换行；
（2）不可以包含块级元素，但是可以包含其他行内元素或者文本；
（3）行内元素设置 `width`、`height` 无效(可以设置 `line-height`)，`margin` 和 `paddin`g 上下无效；
（4）宽度就是它的文字和图片的宽度，不可改变。





**对 BFC 规范(块级格式化上下文：block formatting context)的理解？**

BFC 规定了内部的 Block Box 如何布局。
定位方案：

1. 内部的 Box 会在垂直方向上一个接一个放置。
2. Box 垂直方向的距离由 margin 决定，属于同一个 BFC 的两个相邻 Box 的 margin 会发生重叠。
3. 每个元素的 margin box 的左边，与包含块 border box 的左边相接触。
4. BFC 的区域不会与 float box 重叠。
5. **BFC 是页面上的一个隔离的独立容器，容器里面的子元素不会影响到外面的元素**。
6. 计算 BFC 的高度时，浮动元素也会参与计算。

满足下列条件之一就可触发 BFC

1. 根元素，即 html
2. float 的值不为 none（默认）
3. overflow 的值不为 visible（默认）
4. display 的值为 inline-block、table-cell、table-caption
5. position 的值为 absolute 或 fixed



**为什么会出现浮动和什么时候需要清除浮动？清除浮动的方式？**

浮动元素碰到包含它的边框或者浮动元素的边框停留。由于浮动元素不在文档流中，所以文档流的块框表现得就像浮动框不存在一样。浮动元素会漂浮在文档流的块框上。
浮动带来的问题：

1. 父元素的高度无法被撑开，影响与父元素同级的元素
2. 与浮动元素同级的非浮动元素（内联元素）会跟随其后
3. 若非第一个元素浮动，则该元素之前的元素也需要浮动，否则会影响页面显示的结构。

清除浮动的方式：

1. 父级 div 定义 height
2. 最后一个浮动元素后加空 div 标签 并添加样式 clear:both。
3. 包含浮动元素的父标签添加样式 overflow 为 hidden 或 auto。
4. 父级 div 定义 zoom

