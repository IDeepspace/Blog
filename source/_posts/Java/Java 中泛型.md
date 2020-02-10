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

  public Generic(T key) { // 泛型构造函数形参key的类型也为T，T的类型由外部指定
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

在 `JDK1.5` 之后，不仅仅可以声明泛型类，也可以声明泛型接口。声明泛型接口和声明泛型类的语法类似，也是在接口名称后面加上 `<T> `，在使用上，泛型接口与泛型类也基本相同。

泛型接口实现的两种方式：

- 实现类确定了类型；
- 实现类类型不确定。

我们通过例子来看这两种方式。

首先创建一个泛型接口：

```java
interface showInterface<T> {
  void show(T t);
}
```

**1）实现类确定了类型**

```java
class ShowClass implements showInterface<String> {
  public void show(String t) {
    System.out.println("show:" + t);
  }
}
```

在实现类实现泛型接口时，如果已将泛型类型传入实参类型，则所有使用泛型的地方都要替换成传入的实参类型。



**2）实现类不确定类型**

```java
class ShowClass1<T> implements showInterface<T> {
  public void show(T t) {
    System.out.println("show:" + t);
  }
}
```

未传入泛型实参时，与泛型类的定义相同，在声明实现类的时候，需将泛型的声明也一起加到实现类中。

**主方法：**

```java
public class Main {
  public static void main(String[] args) {
    ShowClass obj = new ShowClass();
    obj.show("java");

    ShowClass1<Integer> obj1 = new ShowClass1<Integer>();
    obj1.show(6);
  }
}
```



#### 3、泛型方法

泛型除了可以为类中的**属性**指定泛型类型外，也可以定义方法。

> 这里要注意：**泛型方法和其所在的类中是否是泛型类没有任何关系**。

下面我们看看如何定义泛型方法，会复杂一点点：

```java
[访问权限]<泛型标示> 泛型标示 方法名称([泛型标示 参数名称])
```

看个例子：

```java
public class GenericMethod {
  public static void main(String[] args) {
    String[] values = {"Java", "Hello", "World"};
    GenericMethod genericMethod = new GenericMethod();
    String firstValue = genericMethod.<String>getFirstValue(values);
    System.out.println(firstValue);
  }

  public <T> T getFirstValue(T[] values) {
    return values[0];
  }
}
```

方法调用前的 `<String>` 并不是必要的，可以省略。当我们将 `String` 类型的 `values` 传给方法时，编译器能够判断 `T` 的具体类型为 `String` 类型，所以可以省略掉。

```java
String firstValue = genericMethod.getFirstValue(values);
```

注意，下面的这个方法并不是一个泛型方法：

```java
public class GenericMethod<T> {
  private T key;

  public T getKey() {
    return key;
  }
}
```

这只是类中一个普通的成员方法，只不过它的返回值是在声明泛型类已经声明过的泛型，所以在这个方法中才可以继续使用 `T` 这个泛型。

所以，像下面这个方法，是会报错的：

```java
public E getKey(E key) {
  this.key = key;
}
```

编译器会给我们提示这样的错误信息 **"cannot reslove symbol E"**，因为在类的声明中并未声明泛型 `E`，所以在使用 `E` 做形参和返回值类型时，编译器会无法识别。



##### 3.1、定义泛型方法有什么好处呢？

现在我们来思考一下定义泛型方法有什么好处呢？

我们先从一个简单的类开始：

```java
class Test {
  public void show(String t) {
    System.out.println(t);
  }

  public void show(Integer t) {
    System.out.println(t);
  }
}
```

上面的代码，明显代码是有些冗余的，我们使用泛型类来做第一步改造：

```java
class Test<T> { // 把 Test 改造成了泛型类
  public void show(T t) { // 注意，此方法不是泛型方法！
    System.out.println(t);
  }
}

public class Main {
  public static void main(String[] args) {
    Test<String> d = new Test<String>();
    d.show("java");
    // d.show(1); // error
  }
}
```

方法是简化了，但是我们需要明确：泛型类要在实例化的时候就指明类型（必须指定），如果想换一种类型，就不得不重新 `new` 一次，生成一个新的对象。上例中的对象 `d` 只能操作 `String` 类型，如果你要操作其他类型，只能额外去创建其他泛型对象：

```java
Test<Integer> e = new Test<Integer>();
```

这是非常不灵活的。而泛型方法可以在调用的时候指明类型，我们把 `show` 方法改造成泛型方法：

```java
class Test {
  public <T>  void show(T t){
    System.out.println(t);
  }
}

public class Main {
  public static void main(String[] args) {
    Test d = new Test();
    d.show("java");
    d.show(1);
  }
}
```

类 `Test` 不再是一个泛型类，这样我们就只用创建一个对象了。

所以，泛型方法的好处是非常大的：**让不同方法操作不同类型，且类型并不需要确定。**

我们在编程的时候有一个基本原则，**无论何时，只要你能做到，你就应该尽量使用泛型方法。也就是说，如果使用泛型方法可以取代将整个类泛化，那么应该有限采用泛型方法。**



##### 3.2、泛型方法与可变参数

```java
class Test {
  public <T> void printMsg(T... args) {
    for (T t : args) {
      System.out.println("t is " + t);
    }
  }
}

public class Main {
  public static void main(String[] args) {
    Test d = new Test();
    d.printMsg("111", 222, "aaaa", "2323.4", 55.55);
  }
}
```

输出结果为：

```
t is 111
t is 222
t is aaaa
t is 2323.4
t is 55.55
```



##### 3.3、泛型数组

使用泛型方法的时候，也可以传递或返回一个泛型数组。

```java
public class Main {
  public static void main(String[] args) {
    Integer[] i = fun1(1, 2, 3, 4, 5, 6);  // 返回泛型数组
    fun2(i);
  }

  public static <T> T[] fun1(T... arg) { // 接收可变参数
    return arg; // 返回泛型数组
  }

  public static <T> void fun2(T[] param) { // 输出
    System.out.print("接收泛型数组：");
    for (T t : param) {
      System.out.print(t + " "); // 接收泛型数组：1 2 3 4 5 6
    }
  }
}
```



#### 4、类型通配符

什么是类型通配符呢？了解这个概念之前，我们先来看一个问题。

假设有个 `Box<T>` 的泛型类，我们知道 `Box<Number>` 和`Box<Integer>` 实际上都是 `Box` 类型。那么现在就有个问题：在逻辑上，`Box<Number>` 和 `Box<Integer>` 是否可以看成具有父子关系的泛型类型呢？验证一下：

```java
public class GenericTest {
  public static void main(String[] args) {
    Box<Number> age1 = new Box<Number>(24);
    Box<Integer> age2 = new Box<Integer>(25);

    getData(age1);
    // getData(age2); // error
  }

  public static void getData(Box<Number> data) {
    System.out.println("data :" + data.getData()); // data :24
  }
}



class Box<T> {
  private T data;

  public Box(T data) {
    this.data = data;
  }

  public T getData() {
    return data;
  }
}
```

我们发现执行 `getData(age2);` 时会发生报错：

```
Box<Integer> cannot be converted to Box<Number>
```

所以，`Box<Number>` 在逻辑上不能视为 `Box<Integer>` 的父类。

那么问题就来了，**通过 `getData()` 方法取出数据时到底是什么类型呢？**是 `Integer?` 、`Float?` 还是 `Number?` 呢？并且，由于在**编程过程中的顺序不可控性，导致在必要的时候需要进行类型判断，且进行强制类型转换**，这与泛型的理念矛盾。

可能有读者会想到定义一个新的函数来处理，这明显是非常不优雅的，并且和 `Java` 中的**多态理念也是相违背**的。

我们需要一个在逻辑上可以用来表示同时是 `Box<Integer>` 和 `Box<Number>` 的父类的一个引用类型。所以，这些缺点就是**「类型通配符」**出现的原因。



##### 4.1、类型通配符的使用

使用「类型通配符」我们可以很好地解决上面的问题：

```java
public class GenericTest {
  public static void main(String[] args) {
    Box<Number> age1 = new Box<Number>(24);
    Box<Integer> age2 = new Box<Integer>(25);

    getData(age1);
    getData(age2);
  }

  public static void getData(Box<?> data) {
    System.out.println("data :" + data.getData());
  }
}
```

有时候，我们还可能听到**「类型通配符上限」**和**「类型通配符下限」**。它们又是什么呢？

还是上面的例子，如果需要定义一个功能类似于 `getData()` 的方法，但对类型实参又有进一步的限制：要求参数只能是 `Number` 类及其子类。这时候，就需要用到类型通配符上限。

```java
public class GenericTest {
  public static void main(String[] args) {
    Box<String> name = new Box<String>("java");
    Box<Integer> age = new Box<Integer>(23);
    Box<Number> number = new Box<Number>(24);

    getData(name);
    getData(age);
    getData(number);

    // getUpperNumberData(name); // error
    getUpperNumberData(age);    // 2
    getUpperNumberData(number); // 3
  }

  public static void getData(Box<?> data) {
    System.out.println("data :" + data.getData());
  }

  // 类型通配符上限
  public static void getUpperNumberData(Box<? extends Number> data) {
    System.out.println("data :" + data.getData());
  }
}
```

其实限定的目的是为了**扩展**指定类型。

相对应的，类型通配符下限为 `Box<? super Number>` 形式，其含义与类型通配符上限正好相反。



##### 4.2、注意事项

使用类型通配符的注意事项：

- 在 `Java` 的集合框架中，对于**参数值是未知类型的容器类，只能读取其中元素，不能向其中添加元素**，因为编译器无法确定添加的元素的类型和集合中的类型是否兼容，但 `null` 例外，因为它是所有引用类型的实例；

- 当为需要类型形参设定多个上限时，**类上限必须位于第一位，并且最多只有一个，而接口上限数量则没有限制**，如：

  ```java
  public class Student<? extends Person & Serializable>{}
  ```



### 四、总结

实际的编程过程中，使用泛型去简化开发，且能很好的保证代码质量。所以，理解泛型背后的思想和使用方法是非常有必要的。

