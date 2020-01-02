---
title: Java 中的数据类型与变量
author: Deepspace
tags:
  - Java
categories: Java
date: 2017-06-29
urlname: java-data-type
---

<!-- ## Java 中的数据类型与变量 -->

### 一、强类型语言

`Java` 是一种强类型语言。这就意味着必须为每一个变量声明一种类型。



### 二、数据类型

在 `Java` 中，把数据分为两大类：基本数据类型、引用数据类型。

#### 1、基本数据类型

基本数据类型有 `8` 种，可以分为 `4` 类：

- 整数类型：`byte`，`short`，`int`，`long`；

- 浮点数类型：`float`，`double`

- 字符类型：`char`

- 布尔类型：`boolean`

不同的数据类型占用的字节数不一样。
<!-- more -->

##### 1.1、整数类型

整型用于表示没有小数部分的数值， 它**允许是负数**。 `Java` 提供了 `4` 种整型。

**int**

- 存储需求：`4` 字节
- 取值范围：`-2147483648 ~ 2147483647` ( 正好超过 `20` 亿 )

**short**

- 存储需求：`2` 字节
- 取值范围：`-32768 ~ 32767`

**long**

- 存储需求：`8` 字节
- 取值范围：`-9223372036854775B08 ~ 9223372036854775807`

**byte**

- 存储需求：`1` 字节
- 取值范围：`-128 ~ 127`



##### 1.2、浮点类型

浮点类型用于表示有小数部分的数值。在 `Java` 中有两种浮点类型。

**float**

- 存储需求：`4` 字节
- 取值范围：大约 `± 3.40282347E+38F` (有效位数为 `6 ~ 7` 位)

**double**

- 存储需求：`8` 字节
- 取值范围：大约 `± 1.79769313486231570E+308` (有效位数为 `15` 位)

`double` 表示这种类型的数值精度是 `float` 类型的两倍（有人称之为双精度数值）。 绝大部分应用程序都采用 `double` 类型。 

`float` 类型的数值有一个后缀 `F` 或 `f`（例如：`3.14F`） 。没有后缀 `F` 的浮点数值（如`3.14`）默 认为 `double` 类型。当然，也可以在浮点数值后面添加后缀 `D` 或 `d` （例如：`3.14D`）。

从我们生活意义上看，整数是浮点数的子集；从计算机底层上来看，整数和浮点数在内存中的保存形式区别很大，他们的操作方法差别也很大，这就是为什么整数可以进行逻辑运算，而浮点数不行。



##### 1.3、布尔型 `boolean`

`boolean`（布尔）类型有两个值：`false` 和 `true`， 用来判定逻辑条件的真假。**注意：整型值和布尔值之间不能进行相互转换。** 

`Java` 语言对布尔类型的存储并没有做规定，因为理论上存储布尔类型只需要一个字节，但是通常 `JVM` 内部会把 `boolean` 表示为 `4` 个字节整数。



##### 1.4、字符型 `char`

字符类型 `char` 表示一个字符。

`Java` 的 `char` 类型除了可表示标准的 `ASCII` 外，还可以表示一个 `Unicode` 字符。

`char` 类型的字面量值要用单引号括起来。 例如：`'A'` 是编码值为 `65` 所对应的字符常量。

```java
public class Test {
  public static void main(String[] args) {
    char a = 'A';
    char zh = '中';
    System.out.println(a); // A
    System.out.println(zh); // 中
  }
}
```

> 注意：它与 `"A"` 不同，`"A"` 是包含一个字符 `A` 的字符串。

```java
String str = "JavaBeginners";
```



#### 2、引用数据类型

引用数据类型和基本数据类型，最大区别就是在存储形式上。

在栈中，**只保存有基本类型的变量和对象引用**。**引用所指向的对象保存在堆中**。(引用可能为 `Null` 值，即不指向任何对象)

- `null`、类、对象
- 接口
- 数组
- `String`



### 三、数据类型转换

`java` 里面数据类型转换主要遵循两个原则：

- 同语义转换，语义相同的数据类型之间可以转换，主要是指数值类型之间可以转换；
- 同存储转换，存储方式相同的数据类型之间可以转换，主要是 `char` 和 整型之间可以转换。

**而引用类型之间，父子类之间可以转换。按照定义，也是满足以上两个规则的。**

**类型转换的时候，会涉及到范围问题。**`java` 编译器会判断有没有越界，有越界就会报错。



### 四、变量

在 `Java` 中， 每个变量都有一个类型(`type`)。在使用变量之前，要声明变量的类型，变量的类型位于变量名之前。 并且不像 `JavaScript` 里面存在变量提升。

```java
public class Test {
  public static void main(String[] args) {
    System.out.println("Declare in the middle:");
    int a;
    a = 5;
    System.out.println(a);  // print an integer

    boolean done = true;
    System.out.println(done); // true

    b = 3.14; // error: cannot find symbol
    double b;
  }
}
```



### 五、常量

定义变量的时候，如果加上 `final` 修饰符，这个变量就变成了常量：

```java
public class Test {
  public static void main(String[] args) {
    final double PI = 3.14; // PI是一个常量
    double r = 5.0;
    double area = PI * r * r;
    PI = 300; // compile error!
  }
}
```



### 六、变量的作用范围

在 `Java` 中，多行语句用 `{ }` 括起来。很多控制语句，例如条件判断和循环，都以 `{ }` 作为它们自身的范围。只要正确地嵌套这些 `{ }`，编译器就能识别出语句块的开始和结束。

而在语句块中定义的变量，它有一个作用域，就是从定义处开始，到语句块结束。超出了作用域引用这些变量，编译器会报错。

```java
public class Test {
  public static void main(String[] args) {
    int i = 0;
    if (2 > 1){ // if开始
      int x = 1;
    }
    System.out.println(i);
    System.out.println(x); // error
  }
}
```

**定义变量时，要遵循作用域最小化原则，尽量将变量定义在尽可能小的作用域。并且，不要重复使用变量名。**