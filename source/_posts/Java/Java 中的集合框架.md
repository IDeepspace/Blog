---
title: Java 中的集合框架
author: Deepspace
tags:
  - 集合框架
  - Java
categories: Java
date: 2017-06-29
urlname: java-collection-framework
---

<!-- ## Java 中的集合框架 -->

### 一、什么是集合？

什么是集合（`Collection`）呢？集合就是**由若干个确定的元素所构成的整体**，它是一个容器。集合是 `Java` 中最最重要的一部分，使用频率非常高。

在前面我们其实已经接触过 `Java` 中的容器了，比如 `StringBuffer`、数组。

**那为什么会出现集合类呢？**

我们知道，面向对象的语言对事物的体现都是以对象的形式来呈现的。虽然数组也可以存储对象，但是**数组的长度是固定的，并且只能按索引顺序存取**，所以，数组不一定能满足我们的需求，更加无法适应变化的需求。

所以为了方便**存储对象**、对多个对象进行操作，就出现了集合类。集合类的特点就是：**提供一种存储空间可变的存储模型，存储的数据容量可以发生改变。**

但是这里要注意，集合中不可以存储基本数据类型值，它是**为对象服务**的。



### 二、集合框架的层次结构

集合容器因为内部的数据结构不同，也就有了不同的**具体容器**；然后经过不断地向上抽取，就形成了集合框架（`collection framework`）。

在向上抽取的过程中，因为数据的结构不同，所以就出现了两个不同的顶层接口：`Collection` 接口和 `Map` 接口。在集合框架中，接口 `Map` 和 `Collection` 在层次结构没有任何亲缘关系，它们是截然不同的。

`Java` 中的集合框架的所有类和接口都包含在 `java.util` 包中。

#### 1、Collection 接口

在 `Collection` 的接口的分支下，`Java` 又通过 `Set`、 `List` 和 `Queue` 接口进行扩展，然后在这三个分支中还有大量的其他类。

> 注意一个区别：
>
> - `Collection` 是个 `java.util` 下的接口，它是各种集合框架中的一个父接口；
> - `Collections` 是个 `java.util` 下的类，它包含有各种有关集合操作的静态方法。

下面看看集合框架中基于 `Collection` 接口的结构层次：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/java-collection-hierarchy.png" alt="Java 集合框架的结构" style="zoom:80%;" />

在 `Collection` 接口中声明了许多方法，具体方法及作用可以在 `Collection` 接口中查看。

上图中，我们发现 `Collection` 接口的上方还有一个 `Iterable` 接口，`Iterable` 接口是 `java` 集合框架的顶级接口，它的作用就是提供了统一的语法进行集合对象（`Collection`）遍历操作。



#### 2、Map 接口

`Map` 接口提供了一种映射关系，所有的元素都是以键值对的方式存储的，所以能够根据 `key` 快速查找 `value`，`key` 是映射关系的索引，`value` 是 `key` 所指向的对象。

`Map` 接口中，它有两个接口用于实现 ：`Map` 和 `SortedMap` 接口，以及三个类: `HashMap`、 `LinkedHashMap` 和  `TreeMap`。` Java` 中 `Map` 分支下的层次结构如下:

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/java-map-hierarchy.png" alt="Java 集合框架的结构" style="zoom:70%;" />

