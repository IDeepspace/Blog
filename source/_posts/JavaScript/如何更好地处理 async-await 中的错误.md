---
title: 如何更好地处理 async-await 中的错误
author: Deepspace
tags:
  - async/await
categories: JavaScript
date: 2020-05-18
urlname: how-to-write-async-await-without-try-catch-blocks-in-javascript
---



## 如何更好地处理 async-await 中的错误

> 原文链接：https://blog.grossman.io/how-to-write-async-await-without-try-catch-blocks-in-javascript/



在 `async / await` 函数中，通常使用 `try / catch` 来捕获错误。代码像下面这样：

```javascript
async function asyncTask(cb) {
  try {
    const user = await UserModel.findById(1);
    if (!user) return cb('No user found');
  } catch (e) {
    return cb('Unexpected error occurred');
  }

  try {
    const savedTask = await TaskModel({ userId: user.id, name: 'Demo Task' });
  } catch (e) {
    return cb('Error occurred while saving task');
  }

  if (user.notificationsEnabled) {
    try {
      await NotificationService.sendNotification(user.id, 'Task Created');
    } catch (e) {
      return cb('Error while sending notification');
    }
  }

  if (savedTask.assignedUser.id !== user.id) {
    try {
      await NotificationService.sendNotification(savedTask.assignedUser.id, 'Task was created for you');
    } catch (e) {
      return cb('Error while sending notification');
    }
  }

  cb(null, savedTask);
}
```

<!-- more -->

写了很多个 `try-catch` 语句，不是那么好看，可以像下面这样写：

```javascript
function to(promise) {
  return promise.then(data => [null, data])
    .catch(err => [err]);
}

async function asyncTask() {
  let err; let user; let savedTask;

  [err, user] = await to(UserModel.findById(1));
  if (!user) throw new CustomerError('No user found');

  [err, savedTask] = await to(TaskModel({ userId: user.id, name: 'Demo Task' }));
  if (err) throw new CustomError('Error occurred while saving task');

  if (user.notificationsEnabled) {
    const [err] = await to(NotificationService.sendNotification(user.id, 'Task Created'));
    if (err) console.error('Just log the error and continue flow');
  }
}
```

抽取一个函数，函数接受一个 `promise` 为参数，函数返回值的第一个参数用来保存错误信息。