---
title: Java 中的 String、StringBuffer、StringBuilder
author: Deepspace
tags:
  - String
  - Java
categories: Java
date: 2017-06-29
urlname: java-string-stringBuffer-stringBuilder
---

## Java 中的 String、StringBuffer、StringBuilder

`Java` 中的 `String` 属于引用类型，它是一个类，这和其他语言是不一样的。

既然 `String` 属于类，那 `String` 的实例就是不可变的对象，因此在每次对 `String` 类型进行改变的时候，都会生成一个新的 `String` 对象，然后将指针指向新的 `String` 对象，所以经常改变内容的字符串最好不要用 `String` ，因为每次生成对象都会对系统性能产生影响，特别当内存中无引用对象多了以后， `JVM` 的 `GC`（ 垃圾回收 `Garbage Collection`） 就会开始工作，性能就会降低。

下面通过查看 `String` 类的源码来分析一些它的特性。

`String` 类的源码：

```java
public final class String
        implements java.io.Serializable, Comparable<String>, CharSequence {
  /**
   * use serialVersionUID from JDK 1.0.2 for interoperability
   */
  private static final long serialVersionUID = -6849794470754667710L;
  /**
   * The value is used for character storage.
   */
  private final char value[];
  /**
   * Cache the hash code for the string
   */
  private int hash; // Default to 0
  
  // ...
}
```

从上面的源码可以分析出：

-  `String` 类是被 `final` 修饰的，也即意味着 `String` 类不能被继承，并且它的成员方法都默认为 `final` 方法；
- `String` 类其实是通过 `char` 数组来保存字符串的，并且成员变量是使用 `private final` 来声明的。

下面再看看 `String` 类的一些方法实现：

```java

```

