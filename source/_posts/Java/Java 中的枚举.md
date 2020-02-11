---
title: Java 中的枚举
author: Deepspace
tags:
  - 枚举
  - Java
categories: Java
date: 2017-06-29
urlname: java-enum
---



### 一、什么是枚举？

枚举就是一一列举，常用来表示那些可以**明确范围的集合**，如性别，季节，星期，月份等。

`Java` 中的枚举（`enum`）是一个**特殊的数据类型**，它是 `Java 5` 中新增的特性，之所以特殊是因为它**既是一种类类型，却又比类类型多了些特殊的约束**，但是这些约束的存在也造就了枚举类型的简洁性、安全性以及便捷性。

> 这里需要注意，**枚举（`enum`）是一个类**，它的全称是 `enumeration`，但是 `Java` 中也有一个 `Enumeration` 的**接口**，这两者是没有任何关系的。



### 二、为什么会出现枚举？

我们看一下下面的程序，这是在没有枚举类型时定义常量常见的方式：

```java
public class Weekday {
  public final static int SUN = 0;
  public final static int MON = 1;
  public final static int TUE = 2;
  public final static int WED = 3;
  public final static int THU = 4;
  public final static int FRI = 5;
  public final static int SAT = 6;
}
```

看起来很不错，调用的时候只要使用 `Weekday.SUN` 就可以了。

但它有许多不足，如果存在定义 `int` 值相同的变量，开发人员就很容易混淆，并且编译器也不会提出任何警告。