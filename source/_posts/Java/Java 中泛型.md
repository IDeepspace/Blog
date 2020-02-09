---
title: Java 中泛型
author: Deepspace
tags:
  - Java
  - Comparator
categories: Java
date: 2017-06-29
urlname: java-comparator
---



### 一、什么是泛型

泛型（`Generics`）在 `Java` 中有很重要的地位，在面向对象编程及各种设计模式中有非常广泛的应用。

泛型，即**「参数化类型」**。什么意思呢？

一提到参数，我们就会想到的是：定义方法时有形参，调用此方法时传递实参。所以，顾名思义，参数化类型就是**把原来的具体的类型参数化**，类似于方法中的变量参数。

所以，泛型就是把类型也定义成参数形式（类型形参），在调用时传入具体的类型（类型实参）。这种参数类型可以用在类、接口和方法中，分别被称为**泛型类、泛型接口、泛型方法。**



### 二、为什么用泛型

现在我们来思考一个问题，为什么 `Java` 中要设计泛型呢？

#### 1、没有泛型的代码

看个例子：

```java
List arrayList = new ArrayList();
arrayList.add("aaaa");
arrayList.add(100);

for (Object o : arrayList) {
  System.out.println(o);
}
```

看起来没什么问题，因为我们知道 `ArrayList` 是可以存放任意类型的。例子中添加了一个 `String` 类型，添加了一个 `Integer` 类型（这里会自动装箱，`int` 类型会被装箱成 `Integer` 对象类型）。

但是我们需要明确一点，**往集合里面存值就是为了后期取出来用的**，而不仅仅只是我们演示代码时，使用 `System.out.println(first)` 打印一下而已。

如果我们像下面这样使用，都以 `String` 的方式使用：

```java
List arrayList = new ArrayList();
arrayList.add("aaaa");
arrayList.add(100);

for (Object o : arrayList) {
  String item = (String) o;
  System.out.println(item);
}
```

这个时候就会发生类型的强制转换，毫无疑问，程序会报错：

```
Exception in thread "main" java.lang.ClassCastException: java.lang.Integer cannot be cast to java.lang.String
```

调用 `ArrayList` 对象的 `add` 方法时，任何类型都是可以添加进行的，但是**编译器是无法进行错误检验的**，只有在运行时才把错误暴露出来。所以上面的代码其实埋下了安全隐患。

所以，泛型就是为了解决这个问题 —— **让错误在编译阶段就暴露出来**。



#### 2、不用泛型的缺点

通过前面的例子，我们就知道了不使用泛型的程序，会面临一些问题：

- 编译器无法进行类型检查，可以向集合中添加任意类型的对象；
- 取值时，类型转换失败会导致程序运行失败；
- 程序的可读性有所降低，程序员可以不受限制往集合中添加任意类型的对象；



### 三、泛型的使用

泛型有三种使用方式，分别为：泛型类、泛型接口、泛型方法。

#### 1、泛型类

**泛型类型用于类的定义中，被称为泛型类。**通过泛型可以完成对一组类的操作对外开放相同的接口。最典型的就是各种容器类，如：`List`、`Set`、`Map`。

下面我们看一个简单的泛型类的例子：

```java
// 此处T可以随便写为任意标识，常见的如T、E、K、V等形式的参数常用于表示泛型
// 在实例化泛型类时，必须指定T的具体类型
public class Generic<T> {
  // key这个成员变量的类型为T,T的类型由外部指定
  private T key;

  public Generic(T key) { // 泛型构造方法形参key的类型也为T，T的类型由外部指定
    this.key = key;
  }

  public T getKey() { // 泛型方法getKey的返回值类型为T，T的类型由外部指定
    return key;
  }
}
```

在 `Java` 类库中，类型变量通常用大写的字母表示，`E` 表示集合的元素类型，`K` 和 `V `分别表示映射表的关键字和值的类型，`T` （`U` 或 `S`）表示任意类型。

使用泛型类：

```java
public class Main {
  public static void main(String[] args) {
    // 泛型的类型参数只能是类类型（包括自定义类），不能是简单类型
    // 传入的实参类型需与泛型的类型参数类型相同，即为Integer.
    Generic<Integer> genericInteger = new Generic<Integer>(123456);

    // 传入的实参类型需与泛型的类型参数类型相同，即为String.
    Generic<String> genericString = new Generic<String>("key_value");
    System.out.println(genericInteger.getKey()); // 123456
    System.out.println(genericString.getKey()); // key_value
  }
}
```

这里值得一提的是：在使用泛型的时候，并不一定要传入泛型类型实参。如果不传入泛型类型实参的话，在泛型类中使用泛型的方法或者成员变量定义的类型可以为任何类型。

```java
public class Main {
  public static void main(String[] args) {
    Generic generic = new Generic("111111");
    Generic generic1 = new Generic(4444);
    Generic generic2 = new Generic(55.55);
    Generic generic3 = new Generic(false);

    System.out.println(generic.getKey()); // 111111
    System.out.println(generic1.getKey()); // 4444
    System.out.println(generic2.getKey()); // 55.55
    System.out.println(generic3.getKey()); // false
  }
}
```

只不过，在使用泛型的时候如果传入泛型实参，就会根据传入的泛型实参做相应的限制，此时泛型才会起到本应起到的限制作用。



#### 2、泛型接口



#### 3、泛型方法