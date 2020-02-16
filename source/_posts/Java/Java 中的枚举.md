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

枚举就是一一列举，常用来表示那些可以**明确范围的集合**，如性别、季节、星期、月份、方向（东西南北）等。

所以枚举的使用场景就是：当变量（尤其是方法的参数）只能从一小组可能的值中取出一个时，我们就可以使用枚举。

`Java` 中的枚举（`enum`）是一个**特殊的数据类型**，它是 `Java 5` 中新增的特性。

> 这里需要注意，**枚举（`enum`）是一个类**，它的全称是 `enumeration`，但是 `Java` 中也有一个 `Enumeration` 的**接口**，这两者是没有任何关系的。



### 二、为什么会出现枚举？

假设我们需要为方位描绘出四个方向，我们看一下下面的程序，这是在没有枚举类型时定义常量常见的方式：

```java
public class Directions {
  public final static String NORTH = "NORTH";
  public final static String SOUTH = "SOUTH";
  public final static String EAST = "EAST";
  public final static String WEST = "WEST";
}
```

看起来很不错，调用的时候只要使用 `Directions.NORTH` 就可以了。但这种**常量实现的枚举**有许多不足：

- 类型不安全

  上面我们定义的方向常量的对应值是整型，在程序运行时，很可能会出现传入非法参数（类型不一致）的情况。

- 没有命名空间

  由于方向常量只是类的属性，使用的时候不得不通过类来访问。

- 一致性较差

  上面我们定义的整型常量属于**编译期常量**，就是说在程序的编译过程完成后，所有引用到该常量的地方，会直接将整数值写入。这样，**当修改旧的整数值或者增加新的常量时**，所有引用地方的代码都需要重新编译，否则就会报错。

所以，为了解决这些问题，`Java5` 中提供了枚举类型供开发者使用。



### 三、枚举的定义与使用

#### 1、枚举的定义

`Java5` 中新增的 `enum` 关键字，用来定义枚举类型。

```java
public enum Directions {
  NORTH, SOUTH, EAST, WEST
}
```

我们可以像下面这样来调用：

```java
Directions direct = Directions.WEST;
```

从定义形式来看，`Java` 中的枚举类型很简单，但实际上 `Java` 语言规范赋予枚举类型的功能是非常强大的。下面我们通过例子来详细介绍。



#### 2、在 if-else 语句中使用

```java
public enum Directions {
  NORTH, SOUTH, EAST, WEST
}

public class IfElseEnum {
  public static void main(String[] args) {
    Directions direct;
    direct = Directions.WEST;
    getDirection(direct);
  }

  public static void getDirection(Directions dir) {
    if (dir == Directions.WEST)
      System.out.println("You selected WEST !!"); // code goes here.
    else
      System.out.println("Invalid Direction !!");
  }
}
```



#### 3、在 switch 语句中使用

```java
public enum Directions {
  NORTH, SOUTH, EAST, WEST
}

public class SwitchCaseEnum {
  public static void main(String[] args) {
    Directions direct;
    direct = Directions.WEST;
    switch (direct) {
      case NORTH:
        System.out.println("You chose NORTH!");
        break;
      case SOUTH:
        System.out.println("You chose SOUTH!");
        break;
      case EAST:
        System.out.println("You chose EAST!");
        break;
      case WEST:
        System.out.println("You chose WEST!"); // code goes here.
        break;
      default:
        System.out.println("Invalid Direction....!!");
        break;
    }
  }
}
```

对比之前的常量实现枚举的方式，我们可以少写很多 `if` 语句，代码可读性更强



#### 4、在 for 循环中使用

```java
public enum Directions {
  NORTH, SOUTH, EAST, WEST
}

public class LoopEnum {
  public static void main(String[] args) {
    int flag = 1;
    for (Directions dir : Directions.values()) {
      System.out.printf("Direction -> %d = %s\n", flag++, dir);
    }
  }
}
```

`values()` 方法是枚举类的静态方法，返回一个包含全部枚举值的数组。



### 四、枚举类的方法

所有枚举类都继承了 `Enum` 的方法，下面我们详细介绍这些方法。

#### 1、`ordinal()` 方法

该返回枚举值在枚举类中的顺序，这个顺序根据**枚举值声明的顺序**而定。

```java
enum Directions {
  NORTH, SOUTH, EAST, WEST
}

public class Main {
  public static void main(String[] args) {
    System.out.println(Directions.EAST.ordinal()); // 2
  }
}
```



#### 2、`values()` 方法

该方法是个静态方法，返回一个**包含全部枚举值的数组**。

```java
public enum Directions {
  NORTH, SOUTH, EAST, WEST
}

public class LoopEnum {
  public static void main(String[] args) {
    int flag = 1;
    for (Directions dir : Directions.values()) {
      System.out.printf("Direction -> %d = %s\n", flag++, dir);
    }
  }
}
```



#### 3、`toString()` 方法

该方法返回枚举常量的名称。

```java
public class Main {
  public static void main(String[] args) {
    Directions dir = Directions.EAST;
    System.out.println(dir.toString());
  }
}
```



#### 4、`valueOf()` 方法

这个方法和 `toString` 方法是相对应的，返回带指定名称的指定枚举类型的枚举常量。

```java
System.out.println(Directions.valueOf("EAST")); // EAST
```



#### 5、`equals()` 方法

用于比较两个枚举类对象的引用。

```java
public enum Directions {
  NORTH, SOUTH, EAST, WEST
}

public class Main {
  public static void main(String[] args) {
    Directions d1 = Directions.EAST;
    Directions d2 = Directions.EAST;
    Directions d3 = Directions.WEST;
    System.out.println("d1 == d2：" + (d1 == d2)); // d1 == d2：true
    System.out.println("d1.equals(d2)：" + (d1.equals(d2))); // d1.equals(d2)：true

    System.out.println("d1 == d3：" + (d1 == d3)); // d1 == d3：false
    System.out.println("d1.equals(d3)：" + (d1.equals(d3))); // d1.equals(d3)：false
  }
}
```

在 `Enum` 类里面，已经重写了 `equals` 方法，并且方法里面的比较就是直接使用 `==` 来比较两个对象的，所以两者的结果是一样的。下面是 `equals` 的源码：

```java
public final boolean equals(Object other) {
	return this==other;
}
```



#### 6、`getDeclaringClass()` 方法

```java
Directions d = Directions.EAST;
System.out.println(d.getDeclaringClass()); // class Directions
```





### 五、枚举的高级用法

与 `Java` 中的普通类一样，在声明枚举类的同时，也可以声明属性、方法和构造函数，但是，会有一些限制。

#### 1、枚举类的构造函数

**枚举类的构造函数必须是私有的**。`IDE` 中写构造函数时，自动就是 `private` 的，这是默认的，如果删除 `private` 也不会报错，所以我们一般不用显示地写 `private` 修饰符，它是多余的。这点可以查看编译后的代码来验证。

**那为什么枚举类的构造函数必须是私有的的？**

在讲解 `private` 修饰符的时候，我们提到过：**私有构造函数是为单例模式服务的。**这里再介绍下单例模式的概念：

**一个类，不可以实例化成对象，它负责创建自己的对象，同时确保只有单个对象被创建；并且这个类提供一种访问其唯一的对象的方式，可以直接通过类来访问。这种模式被称作单例模式，这个类被称作单例类。**

在开发中，很多时候有一些对象其实我们**只需要一个**，例如：线程池（`threadpool`）、缓存（`cache`）、默认设置、注册表（`registry`）、日志对象等等，这个时候把它设计为单例模式是最好的选择。

**而枚举被设计成是单例模式**，即枚举类型会由 `JVM` 在加载的时候，我们在枚举类中定义了多少个枚举值，就会实例化多少个枚举对象，`JVM` 为了保证每一个枚举类对象是唯一的实例，是不允许外部进行实例化（使用 `new`） 的，所以会把构造函数设计成 `private`，防止用户生成实例，破坏唯一性。

**枚举类的所有枚举值，就是 `JVM` 会实例化的枚举对象。**这里要注意：枚举值必须在枚举类的第一行显式地列出，否则这个枚举类将永远不能产生实例。

下面我们看一个综合的例子：

```java
enum Directions {
  NORTH(0, 90), SOUTH(0, -90), EAST(90, 0), WEST(-90, 0); // 注意这里的分号

  private int x;
  private int y;

  Directions(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }
}

public class Main {
  public static void main(String[] args) {
    System.out.println("下面是方位信息的坐标标记");
    for (Directions dir : Directions.values()) {
      System.out.println("方位名称: " + dir.name() + ", 坐标标记: " + "(" + dir.getX() + ", " + dir.getY() + ")");
    }
  }
}
```

输出结果为：

```
方位名称: NORTH, 坐标标记: (0, 90)
方位名称: SOUTH, 坐标标记: (0, -90)
方位名称: EAST, 坐标标记: (90, 0)
方位名称: WEST, 坐标标记: (-90, 0)
```



#### 2、重写 `toString()` 方法

我们也可以重写枚举类的 `toString()` 方法：

```java
enum Directions {
  NORTH(0, 90), SOUTH(0, -90), EAST(90, 0), WEST(-90, 0);

  private int x;
  private int y;

  Directions(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  @Override
  public String toString() {
    return "(" + this.x + ", " + this.y + ")";
  }
}

public class Main {
  public static void main(String[] args) {
    System.out.println("下面是方位信息的坐标标记");
    for (Directions dir : Directions.values()) {
      System.out.println("方位名称: " + dir.name() + ", 坐标标记: " + dir.toString());
    }
  }
}
```



#### 3、实现接口

所有的枚举都继承自 `java.lang.Enum` 类，由于 `Java` 不支持多继承，**所以枚举对象不能再继承其他类**。但是枚举可以实现接口。

```java
// 接口
public interface Behaviour {
  void print();

  String getInfo();
}

// 枚举类
public enum Color implements Behaviour {
  RED("红色", 1), GREEN("绿色", 2), BLANK("白色", 3), YELLO("黄色", 4);
  private String name;
  private int index;

  Color(String name, int index) {
    this.name = name;
    this.index = index;
  }

  @Override
  public String getInfo() {
    return this.name;
  }

  @Override
  public void print() {
    System.out.println(this.index + ":" + this.name);
  }
}
```



#### 4、使用接口组织枚举

有时候，我们需要扩展原 `enum` 中的元素，或者希望使用子类将一个 `enum` 中的元素进行分组。这个时候，我们就可以在在一个接口的内部，创建实现该接口的枚举，以此将元素进行分组，可以达到将枚举元素分类组织的目的。

举个例子，假设我们想用 `enum` 来表示不同类别的食物，同时还希望每个 `enum` 元素仍然保持 `Food` 类型。那么我们就可以这样实现：

```java
public interface Food {
  enum Appetizer implements Food {
    SALAD, SOUP, SPRING_ROLLS;
  }

  enum MainCourse implements Food {
    LASAGNE, BURRITO, PAD_THAI, LENTILS, HUMMOUS, VINDALOO;
  }

  enum Dessert implements Food {
    TIRAMISSU, GELTO, BLACK_FOREST_CAKE, FRUIT, CREAM_CARAMEL;
  }

  enum Coffee implements Food {
    BLACK_COFFEE, DECAF_COFFEE, ESPRESSO, LATTE, CAPPUCCINO, TEA, HERB_TEA;
  }
}

public class InterfaceOrganizeEnum {
  public static void main(String[] args) {
    Food food = Food.Appetizer.SALAD;
    food = Food.MainCourse.LASAGNE;
  }
}
```

对于 `enum` 而言，实现接口是使其子类化的唯一办法。所以嵌入在 `Food` 中的每个 `enum` 都实现了 `Food` 接口。现在，在 `main` 方法中，可以使用实现了 `Food` 接口的 `enum` 类型，那么我们就可以将其实例向上转型为 `Food`，所以上例中的所有东西都是 `Food`。



#### 5、关于枚举集合的使用

`java.util.EnumSet` 和 `java.util.EnumMap` 是两个枚举集合。

- `EnumSet` 保证集合中的元素不重复；

- `EnumMap` 中的 `key` 是 `enum` 类型，而 `value` 则可以是任意类型。

关于这个两个集合的使用就不在这里赘述，可以参考 `JDK` 文档。

