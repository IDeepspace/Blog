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
- 如果基类被继承，子类与基类不在一个包中，那么子类实例可以访问其从基类继承而来的 `protected` 修饰的方法，而不能直接通过基类实例访问 `protected` 修饰的方法。

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

`Java` 也提供了许多非访问修饰符。主要分为以下几类：

- `static`

- `final`

- `abstract`

- `synchronized` 和 `volatile`

下面详细介绍这几类非访问修饰符。



#### 1、static

在类中，使用 `static` 修饰符修饰的变量（成员变量）称为**静态变量**，也可以称为**类变量**；使用 `static` 修饰的常量称为**静态常量**；使用 `static` 修饰的方法称为静态方法或类方法，它们统称为静态成员，归整个类所有。

在 `Java` 程序里面，如果要使用类的成员，那么普通情况下必须先通过类实例化一个对象，通过对象的引用来访问这些成员；但是用 `static` 修饰的成员是可以通过类名（`ClassName.VariableName`）进行直接访问的，使用起来更加方便。

但是要注意：

- `static` 修饰的成员变量和方法，从属于类；
- 而普通变量和方法从属于对象；
- 静态方法不能调用非静态成员，编译会报错。

下面我们分别看看静态变量和静态方法。



##### 1）静态变量

类的成员变量可以分为以下两种：

1. 静态变量（或称为类变量），指被 `static` 修饰的成员变量；
2. 实例变量，指没有被 `static` 修饰的成员变量。

它们的区别如下：

1. 静态变量

- 运行时，`Java` 虚拟机只为静态变量分配一次内存，在加载类的过程中完成静态变量的内存分配；
- 在类的内部，可以在任何方法内直接访问静态变量；
- 在其他类中，可以通过类名访问该类中的静态变量；

2. 实例变量

- 每创建一个实例，`Java` 虚拟机就会为实例变量分配一次内存。
- 在类的内部，可以在非静态方法中直接访问实例变量；
- 在本类的静态方法或其他类中则需要通过类的实例对象进行访问；

所以，**静态变量可以被类的所有实例共享。**因此静态变量可以作为实例之间的共享数据，增加实例之间的交互性。
如果类的所有实例都包含一个相同的常量属性，则可以把这个属性定义为静态常量类型，从而**节省内存空间**。例如，在类中定义一个静态常量 `PI`。

看个例子：

```java
public class StaticVar {
  public static String str1 = "Hello ";

  public static void main(String[] args) {
    String str2 = "World!";
    // 直接访问 str1
    String accessVar1 = str1 + str2;
    System.out.println("第 1 次访问静态变量，结果为：" + accessVar1); // Hello World!

    // 通过类名访问 str1
    String accessVar2 = StaticVar.str1 + str2;
    System.out.println("第 2 次访问静态变量，结果为：" + accessVar2); // Hello World!

    // 通过实例对象 svt1 访问 str1
    StaticVar svt1 = new StaticVar();
    svt1.str1 = svt1.str1 + str2;
    String accessVar3 = svt1.str1;
    System.out.println("第 3 次访向静态变量，结果为：" + accessVar3); // Hello World!
    System.out.println(StaticVar.str1); // Hello World!

    // 通过实例对象 svt2 访问 str1
    StaticVar svt2 = new StaticVar();
    String accessVar4 = svt2.str1 + str2;
    System.out.println("第 4 次访问静态变量，结果为：" + accessVar4); // Hello World!World!
  }
}
```

从运行结果可以看出，在类中定义静态的属性（成员变量），在 `main()` 方法中可以直接访问，也可以通过类名访问，还可以通过类的实例对象来访问。



##### 2）静态方法

静态方法不需要通过它所属的类的任何实例就可以被调用，因此在静态方法中不能使用 `this` 关键字，也不能直接访问所属类的实例变量和实例方法，但是可以直接访问所属类的静态变量和静态方法。

另外，和 `this` 关键字一样，`super` 关键字也与类的特定实例相关，所以在静态方法中也不能使用 `super` 关键字。

```java
public class StaticMethod {
  public static int count = 1;    // 定义静态变量 count

  // 静态方法 method2
  public static int method2() {
    count += count;    // 访问静态变量 count 并赋值
    System.out.println("在静态方法 method2() 中的 count=" + count);    // count=4
    return count;
  }

  // 静态方法 PrintCount
  public static void PrintCount() {
    count += 2;
    System.out.println("在静态方法 PrintCount() 中的 count=" + count);    // 打印 count
  }

  public static void main(String[] args) {
    StaticMethod sft = new StaticMethod();
    // 通过实例对象调用实例方法
    System.out.println("method1() 方法返回值 intro1=" + sft.method1()); // intro1=2
    // 直接调用静态方法
    System.out.println("method2() 方法返回值 intro1=" + method2()); // intro1=4
    // 通过类名调用静态方法，打印 count
    StaticMethod.PrintCount(); // count=6
  }

  // 实例方法 method1
  public int method1() {
    count++;    // 访问静态变量 count 并赋值
    System.out.println("在静态方法 method1() 中的 count=" + count);    // count=2
    return count;
  }
}
```

程序中，静态变量 `count` 作为实例之间的共享数据，因此在不同的方法中调用 `count`，值是不一样的。在静态方法 `method1()` 和 `PrintCount()` 中是不可以调用非静态方法 `method1()` 的，而在 `method1()` 方法中可以调用静态方法 `method2()` 和 `PrintCount()`。



##### 3）静态代码块

静态代码块指 `Java` 类中的 `static{ }` 代码块，主要用于初始化类，为类的静态变量赋初始值。

`Java` 虚拟机在加载类时执行静态代码块，所以很多时候会将一些只需要进行一次的初始化操作都放在 `static` 代码块中进行，提升程序性能。

静态代码块的特点如下：

- 静态代码块类似于一个方法，但它不可以存在于任何方法体中；
- 静态代码块可以置于类中的任何地方，并且类中可以有多个静态初始化块；
- 如果类中包含多个静态代码块，则 `Java` 虚拟机将按它们在类中出现的顺序依次执行它们，每个静态代码块只会被执行一次；
- 静态代码块与静态方法一样，不能直接访问类的实例变量和实例方法，而需要通过类的实例对象来访问。

```java
package packageOne;

public class StaticCode {
  public static int count = 0;

  static {
    count++;
    System.out.println("静态代码块1 count=" + count);
  }

  static {
    count++;
    System.out.println("静态代码块2 count=" + count);
  }

  {
    count++;
    System.out.println("非静态代码块 count=" + count);
  }

  public static void main(String[] args) {
    System.out.println("*************** StaticCode1 执行 ***************");
    StaticCode sct1 = new StaticCode();
    System.out.println("*************** StaticCode2 执行 ***************");
    StaticCode sct2 = new StaticCode();
  }
}
```

运行结果为：

```
静态代码块1 count=1
静态代码块2 count=2
*************** StaticCode1 执行 ***************
非静态代码块 count=3
*************** StaticCode2 执行 ***************
非静态代码块 count=4
```



#### 2、final

`final` 的意思是最终，表示对象是最终不可改变的意思。`final` 应用于类、方法和变量时意义是不同的，但本质是一样的，都表示不可改变。

- `final` 用在变量的前面表示变量的值不可以改变，此时该变量可以被称为常量；
- `fina` 用在方法的前面表示方法不可以被重写；
- `final` 用在类的前面表示该类不能有子类，即该类不可以被继承。

> 子类中如果创建了一个与父类中相同名称、相同返回值类型、相同参数列表的方法，只是方法体中的实现不同，以实现不同于父类的功能，这种方式被称为**方法重写**，又称为方法覆盖。



##### 1）final 修饰变量

`final` 修饰的变量即成为常量，只能赋值一次，但是 `final` 所修饰局部变量和成员变量有所不同。

1. `final` 修饰的局部变量必须使用之前被赋值一次才能使用；
2. `final` 修饰的成员变量在声明时没有赋值的叫**空白 `final` 变量**。空白 `final` 变量必须在构造方法或静态代码块中初始化。

```java
public class FinalDemo {
  // 静态常量
  final static int c = 12;// 直接赋值
  final static int d; // 空白final变量

  // 静态代码块
  static {
    // 初始化静态变量
    d = 32;
  }

  // 实例常量
  final int a = 5; // 直接赋值
  final int b; // 空白final变量

  // 构造方法
  FinalDemo() {
    // 初始化实例变量
    b = 3;
    // 第二次赋值，会发生编译错误
    // b = 4;
  }

  void doSomething() {
    // 没有在声明的同时赋值
    final int e;
    // 只能赋值一次
    e = 100;
    System.out.print(e);
    // 声明的同时赋值
    final int f = 200;
  }
}
```

`final` 修饰基本类型变量和引用类型变量也是有些区别的。

当使用 `final` 修饰基本类型变量时，不能对基本类型变量重新赋值，因此基本类型变量不能被改变。

但对于引用类型变量而言，它保存的仅仅是一个引用，`final` 只保证这个引用类型变量所引用的地址不会改变，即一直引用同一个对象，但这个对象完全可以发生改变（这点和 `JavaScript` 中的 `const` 关键字是一样的）。



##### 2）final 修饰方法

`final` 修饰的方法不可被重写。有的时候，出于某些原因，我们不希望子类重写父类的某个方法，则可以使用 `final` 修饰该方法。

`Java` 提供的 `Object` 类里就有一个 `final` 方法 `getClass()`，因为 `Java` 不希望任何类重写这个方法，所以使用 `final` 把这个方法密封起来。但对于该类提供的 `toString()` 和 `equals()` 方法，都允许子类重写，因此没有使用 `final` 修饰它们。

```java
public class FinalMethodTest {
  public final void test() {
  }
}

class Sub extends FinalMethodTest {
  // 下面方法定义将出现编译错误，不能重写 final 方法
  public void test() {
  }
}
```

对于一个 `private` 修饰的方法，因为它仅在当前类中可见，其子类无法访问该方法，所以子类无法重写该方法。

注意：如果子类中定义一个与父类 `private` 方法有相同方法名、相同形参列表、相同返回值类型的方法，也不是方法重写，只是重新定义了一个新方法。因此，即使使用 `final` 修饰一个 `private` 访问权限的方法，依然可以在其子类中定义与该方法具有相同方法名、相同形参列表、相同返回值类型的方法。

```java
public class PrivateFinalMethodTest {
  private final void test() {
  }
}

class Sub extends PrivateFinalMethodTest {
  // 下面的方法定义不会出现问题
  public void test() {
  }
}
```

还有一点要注意：`final ` 修饰的方法仅仅是不能被重写，并不是不能被重载。

```java
public class FinalOverload {
  // final 修饰的方法只是不能被重写，完全可以被重载
  public final void test() {
  }

  public final void test(String arg) {
  }
}
```



##### 3）final 修饰类

`final` 修饰的类不能被继承。当子类继承父类时，将可以访问到父类内部数据，并可通过重写父类方法来改变父类方法的实现细节，这可能导致一些不安全的因素。为了保证某个类不可被继承，则可以使用 `final` 修饰这个类。

```java
final class SuperClass {
}

class SubClass extends SuperClass {    // compile error
}
```



#### 3、abstract



#### 4、synchronized 和 volatile



