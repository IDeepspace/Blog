---
title: Ajax
author: Deepspace
tags:
  - Ajax
categories: JavaScript
date: 2018-06-29
urlname: javascript-ajax
---


`Ajax`，是对 `Asynchronous JavaScript + XML` 的简写，也就是 **异步 `JavaScript` + `XML`。** 

它并不是 `JavaScript` 的一部分，而是网页与服务器通信的一系列技术的总称。

尽管 `X` 在 `Ajax` 中代表`XML`，但由于 `JSON` 的许多优势（更加轻量、可读性高等），并且 `JSON` 作为`Javascript`的一部分，所以现在使用 `JSON` 作为数据传输比 `XML` 更加普遍。



### 一、同步和异步

**同步：**

后一个任务需要等待前一个任务执行结束之后，才可以执行。程序的执行顺序与任务的排列顺序是一致的、同步的。也就是必须一件一件做事，等前一件做完了才能做下一件事。

就像早上起床后，先洗涮，然后才能吃饭，不能在洗涮没有完成时，就开始吃饭。

**异步：**

向服务器发送请求的时候，我们不必等待结果，而是可以同时做其他的事情，等到有了结果我们可以再来处理这个事。

就像使用微信给朋友发消息，上一条消息是一张非常大的照片，下一条消息是文字；发送文字的那条消息不用等到上一条图片消息发送成功之后才可以发送。

<!-- more -->

### 二、Ajax 的出现是为了解决什么问题？

在 `Ajax` 出现之前，网页想要和服务器通信，最常用的方式是使用 `form` 表单。工作方式如下图：

<img src="/ImageHosting/JavaScript/no-ajax.jpg" alt="no ajax" />

<p align="center">(图片来自网络)</p>
举个邮箱注册页面的例子。

如果要注册新用户的话，用户必须填写完所有必填信息，然后单击提交按钮，将数据提交到服务器之后，才能验证数据的合法性，例如验证邮箱唯一性。提交表单之后，必须经过服务器判断邮箱的唯一性，然后**刷新页面**在显示此邮箱是否是唯一的、可用来注册的。

这就带来了一些问题：

- 如果邮箱已经被注册过了，需要给用户一些提醒，尽管新页面上只有一行字和当前页面不一样，但是整个过程中用户都只能等着；
- 用户之前的操作状态会丢失，比如在当前网页里填写的其他信息可能会丢失；
- 服务器返回的新网页常常和之前网页的大部分内容是相同的，浪费带宽。

可见，使用表单来进行网页和服务器的交互，用户体验是比较差。

那 `Ajax` 是怎么解决这个问题的呢？

当邮箱输入框失去焦点时，使用 `Ajax` 向服务器发送一个验证请求，来验证此邮箱的唯一性，该请求会根据验证结果返回不同的值。`JavaScript` 根据返回结果执行相应的操作（回调），更改页面上的元素。在这个过程中，页面并不会刷新，所以用户之前的操作状态也不会消失。同时，服务器端传输的只是数据而不是网页，数据量会变小很多，节约带宽。



### 三、XMLHttpRequest 对象

浏览器为我们提供了 `XMLHttpRequest` 对象（低版本 `IE` 使用 `ActiveXObject` 对象），允许使用 `JavaScript` 发出 `HTTP` 请求。

尽管名称中带有 `XML` 一词，但它可以对任何数据进行操作，而不仅限于 `XML` 格式。我们也可以上传/下载文件等操作。

**`XMLHttpRequest` 具有两种操作模式：同步和异步。** 绝大多数情况下，我们只使用异步模式。



#### 创建请求

使用 `XMLHttpRequest` 创建一个请求需要三个步骤。

1. **创建 `XMLHttpRequest`**

   ```javascript
   let xhr = new XMLHttpRequest();
   ```

   这个构造函数没有参数。

2. **初始化**

   ```javascript
   xhr.open(method, URL, [async, user, password])
   ```

   这个方法指定请求的主要参数：

   - `method` – `HTTP` 方法，通常是 `GET` 、`POST` 等；
   - `URL` — 要请求的`URL`（字符串），可以是 `URL` 对象；
   - `async` — 如果显式设置为 `false`，则请求是同步的，这个稍后再讨论；
   - `user, password` — 基本 `HTTP` 身份验证的登录名和密码（可选）。

3. **发送请求**

   ```javascript
   xhr.send([body])
   ```

   `send` 方法打开连接并将请求发送到服务器。



#### 监听事件

**创建请求之后，就是监听 `xhr` 的响应事件了。**经常会使用下面三个事件：

1. `load`

   当请求完成时（即使 `HTTP` 状态为 `400` 或 `500` 等） ，会下载请求的结果。

2. `error`

   当无法发出请求时的错误处理，例如网络宕机或网址无效。

3. `progress`

   在下载响应结果时触发，作用是显示已下载的数量。

```javascript
xhr.onload = function () {
  console.log(`Loaded: ${xhr.status} ${xhr.response}`);
};

xhr.onerror = function () { // only triggers if the request couldn't be made at all
  console.log('Network Error');
};

xhr.onprogress = function (event) { // triggers periodically
  // event.loaded - how many bytes downloaded
  // event.lengthComputable = true if the server sent Content-Length header
  // event.total - total number of bytes (if lengthComputable)
  console.log(`Received ${event.loaded} of ${event.total}`);
};
```



#### 完整的例子

下面是一个完整的例子，从知乎的 `public api` 中请求一个 `biancheng` 话题的信息：

```javascript
let XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;

// 1. Create a new XMLHttpRequest object
let xhr = new XMLHttpRequest();

// 2. Configure it: GET-request for the URL
xhr.open('GET', 'https://zhuanlan.zhihu.com/api/columns/biancheng/articles');

// 3. Send the request over the network
xhr.send();

// 4. This will be called after the response is received
xhr.onload = function () {
  if (xhr.status != 200) { // analyze HTTP status of the response
    console.log(`Error ${xhr.status}: ${xhr.statusText}`); // e.g. 404: Not Found
  } else { // show the result
    console.log(`Done, got ${JSON.stringify(xhr.responseText)}`); // responseText is the server
  }
};

// 5. if the network is down or other errors
xhr.onerror = function () {
  console.log('Request failed');
};
```

一旦服务器做出响应，我们就可以接收以下 `xhr` 属性中的结果:

1. `status`

   `HTTP` 状态码：`200`，`404`， `403` 等等。

2. `statusText`

   `Http` 状态消息，是一个字符串，与状态码形成对应。比如字符串  `OK` 代表 `200`。

3. `responseText`

   该属性返回从服务器接收到的字符串，该属性为只读。只有 `HTTP` 请求完成接收以后，该属性才会包含完整的数据。

我们还可以使用相应的属性指定一个超时：

```javascript
xhr.timeout = 1000; // timeout in ms, 1 seconds
```

如果请求在给定时间内未能成功，则取消该请求并触发超时事件。

更多 `XMLHttpRequest` 的实例方法和属性可以参考：

- https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest
- https://wangdoc.com/javascript/bom/xmlhttprequest.html



#### 同步请求

如果在 `open` 方法中将第三个参数 `async` 设置为 `false`，则同步发出请求。换句话说，`JavaScript` 在 `send()` 处执行暂停，并在收到响应时恢复执行。

```javascript
let XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;

// 1. Create a new XMLHttpRequest object
let xhr = new XMLHttpRequest();

// 2. Configure it: GET-request for the URL
xhr.open('GET', 'https://zhuanlan.zhihu.com/api/columns/biancheng/articles', false);

try {
  xhr.send();
  if (xhr.status != 200) {
    console.log(`Error ${xhr.status}: ${xhr.statusText}`);
  } else {
    console.log(xhr.responseText);
  }
} catch (err) { // instead of onerror
  console.log('Request failed');
}
```

所以在上面的代码中，`console.log('Done');` 的执行会等到 `send()` 执行完毕之后再执行。



### 四、封装 ajax

有很多基于原生 `JavaScript` 中的 `XMLHttpRequest` 封装的 `ajax` 库，如

- `jQuery.ajax()` ：https://api.jquery.com/jquery.ajax/

- `Axios`：https://github.com/axios/axios

- `Fetch` ：`fetch` 不是 `ajax` 的进一步封装，而是原生 `JavaScript`，没有使用 `XMLHttpRequest` 对象，是基于 `promise` 设计的，参数有点像 `jQuery ajax`。https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
