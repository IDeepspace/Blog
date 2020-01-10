---
title: Java 中的修饰符
author: Deepspace
tags:
  - 修饰符
categories: Java
date: 2017-06-29
urlname: java-modifiers
---



## Java 中的修饰符

`Java` 提供了一系列的修饰符，用于控制访问机制，防止滥用。修饰符是一些关键字。

`Java` 中的修饰符可以分为两类：

- 访问修饰符 `Access Modifiers`
- 非访问修饰符 `Non Access Modifiers`



### 一、访问修饰符

访问修饰符的作用是可以让我们指定**哪些类可以访问给定的类及其变量、构造函数和方法**。 

我们可以为类、类的构造函数、变量和方法分别指定访问修饰符，修饰符通常放在语句的最前面。

类、变量、构造函数和方法可以有四种不同的 `Java` 访问修饰符，：

- `no modifier` (即默认，什么也不写）
- `private`
- `public`
- `protected`

下面是四种访问修饰符的访问权限表：

| `Access Modifiers`                                    | `private` | `no modifier` | `protected` | `public` |
| :---------------------------------------------------- | :-------- | :------------ | :---------- | :------- |
| `Same class` — 同一个类                               | `Yes`     | `Yes`         | `Yes`       | `Yes`    |
| `Subclass (same package)` — 子类（同一个包中）        | `No`      | `Yes`         | `Yes`       | `Yes`    |
| `Non-subclass (same package)` — 非子类（同一个包中）  | `No`      | `Yes`         | `Yes`       | `Yes`    |
| `Subclass (different package)` — 子类（不同包）       | `No`      | `No`          | `Yes`       | `Yes`    |
| `Non-subclass (different package)` — 非子类（不同包） | `No`      | `No`          | `No`        | `Yes`    |

`class` （类）只能用 `public` 修饰符来修饰，也可以什么都不写（`no modifier`）。

接下来我们详细介绍这些访问修饰符。



#### 1、no modifier

使用默认访问修饰符声明的类、类的构造函数、变量和方法（也就是什么都不写的情况下），对**同一个包内的类**都是可见的。如果两个类属于不同的包，那么他们之间是不可见的。



#### 2、public

被声明为 `public` 的类、方法、构造方法和变量能够被任何其他类访问。

所以，每个 `Java` 程序的主类都必须是 `public` 类，作为公共工具供其他类和程序使用的类也应该定义为 `public` 类。

类中被设定为 `public` 的方法是这个类对外的接口部分，避免了程序的其他部分直接去操作类内的数据，实际这就是数据封装思想的体现。



#### 3、private

`private` 修饰符**不可以用来修饰类和接口**。但是可以修饰类的构造函数、变量和方法。

声明为 `private` 的构造函数、变量和方法只能在声明的类本身中访问。

**private constructor —— 私有构造函数** 

被 `private` 修饰的构造函数叫作**私有构造函数**（也有叫作私有构造器的）。由于类的构造函数时私有的，所以此类**不能被实例化**，同时也**不能被继承**。那不仅要问，还要私有构造函数干嘛呢？

别忘了，我们还有 `static` 修饰符。用 `static` 修饰符修饰的变量或方法是独立于对象的而存在的，可以直接使用类名（`ClassName.VariableName`）调用访问的。看个简单的例子：

```java
public class SingleTonClass {

  // 创建 SingleTonClass 的一个对象
  private static SingleTonClass instance = new SingleTonClass();

  // 让构造函数为 private，这样该类就不会被实例化
  private SingleTonClass() {
  }

  // 静态方法，获取唯一可用的对象
  public static SingleTonClass getInstance() {
    return instance;
  }

  // 使用
  public static void main(String[] args) {
    // 对象不能直接通过私有构造函数来创建，所以这里我们调用类的静态方法来创建
    SingleTonClass myObject = SingleTonClass.getInstance();
    myObject.display();
  }

  public void display() {
    System.out.println("Singleton class Example");
  }
}
```

- `instance` 是 `Singleton` 类的私有静态成员，在类的内部可以调用私有方法（也包括构造函数），所以我们可以在内的内部实例化一个对象；

- `getInstance` 是静态方法，是获取唯一对象的方法；
- 这样，我们就可以通过 `SingleTonClass.getInstance();` 拿到创建的唯一对象了。

像上面这样，**一个类，不可以实例化成对象，它负责创建自己的对象，同时确保只有单个对象被创建；并且这个类提供一种访问其唯一的对象的方式，可以直接通过类来访问。这种模式被称作单例模式，这个类被称作单例类。**

所以，私有构造函数是为单例类服务的。

那我们现在知道了私有构造函数可以创建单例类，那有什么应用场景需要我们这样做呢？

这样的场景有很多，比如一个电脑连接的有两台打印机，在输出的时候就要处理不能两台打印机打印同一个文件。

回到 `Java` 里，假设我们有一个工具类 `Utils`，里面含有很多静态函数或者静态变量，由于静态的原因，我们完全可以通过类名来访问，这样，我们就没有必要实例化它们，所以我们可以将其构造函数设置为私有，这样就防止用户滥用。`Java` 的工具类中，有很多就是利用这种方法。

> 上面，我们只是简单的创建了一个单例类，它是有很多缺点的，具体内容会在介绍单例模式里讲解。



**私有变量**

被声明为 `private` 的变量，只能被所属类访问。声明为私有访问类型的变量，只能通过类中公共的 `getter` 方法被外部类访问，这样可以隐藏类的具体实现细节和保护类中的数据。

```java
public class Logger {
  private String format;

  public String getFormat() {
    return this.format;
  }

  public void setFormat(String format) {
    this.format = format;
  }
}
```

`Logger` 类中的 `format` 变量为私有变量，所以其他类不能直接得到和设置该变量的值。为了使其他类能够操作该变量，定义了两个 `public` 方法：`getFormat()` （返回 `format` 的值）和 `setFormat(String)`（设置 `format` 的值）。



**私有方法**

和私有变量一样，被声明为 `private` 的方法，也只能被所属类访问。在开发中，有一个方法，我们只希望在类的内部使用，不共享出去，那么就可以把该方法声明为 `private`。

```java
public class Test {

  public static void main(String[] args) {

  }

  private static void sayHello() {
    System.out.println("Hello!");
  }

  public void greeting() {
    Test.sayHello();
  }
}

public class Test1 {
  public static void main(String[] args) {
    Test test = new Test();
    test.greeting(); // Hello!
  }
}
```



#### 4、protected

`protected` 是用来修饰类的变量和方法的，意思是受到保护的，**类中被 `protected` 修饰的变量和方法对于本包和其子类可见**。很多书上介绍 `protected` 的时候，都用了这句话来描述，对于初学者有些混淆。其实这句话包含两层意思：

- 基类中被 `protected` 修饰的成员（变量和方法）对于包内其他的类可见的，不管类之间有没有继承关系；
- 如果基类被继承，子类与基类不在一个包中，那么子类实例可以访问其从基类继承而来的 `protected` 方法，而不能直接通过基类实例访问 `protected` 方法。

看下面的例子。

**同一个包中：**

```java
package packageOne;

public class Test {

  protected int m = 1;

  protected void sayHello() {
    System.out.println("Hello!");
  }
}

package packageOne;

public class Test1 {
  public static void main(String[] args) {
    Test test = new Test();
    System.out.println(test.m); // 1
    test.sayHello(); // Hello!
  }
}


package packageOne;

public class Test2 extends Test {
  public static void main(String[] args) {
    Test test = new Test();
    System.out.println(test.m); // 1
    test.sayHello(); // Hello!
  }
}
```



**不同包中：**

```java
package packageOne;

public class Test {

  protected int m = 1;

  protected void sayHello() {
    System.out.println("Hello!");
  }
}

package packageTwo;

import packageOne.Test;

public class Test3 extends Test {
  public static void main(String[] args) {
    Test test = new Test();
    Test3 test3 = new Test3();

    System.out.println(test3.m); // 1
    test3.sayHello(); // Hello!

    System.out.println(test.m); // compile error
    test.sayHello(); // compile error
  }
}
```



### 二、非访问修饰符

