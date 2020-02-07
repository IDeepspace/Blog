---
title: Java 中的比较器 —— Comparator
author: Deepspace
tags:
  - Java
  - Comparator
categories: Java
date: 2017-06-29
urlname: java-comparator
---



### 一、Comparable 接口

学习 `Comparator` 之前，我们先来看看 `Comparable` 接口。

这里先不介绍 `Comparable` 接口的相关概念，我们先看看数组和集合列表的排序。我们应该都写过，比较简单，这里再回顾一下吧。

#### 1、数组的排序

对数组排序，使用 `Arrays.sort ()`：

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    String[] fruits = new String[]{"Pineapple", "Apple", "Orange", "Banana"};

    Arrays.sort(fruits);

    for (String fruit : fruits) {
      System.out.println(fruit);
    }
  }
}
```

输出结果为：

```
Apple
Banana
Orange
Pineapple
```

<!-- more -->

#### 2、集合列表的排序

对于集合列表的排序，我们可以使用 `Collections.sort()` 方法：

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Main {
  public static void main(String[] args) {
    List<String> fruits = new ArrayList<String>();

    fruits.add("Pineapple");
    fruits.add("Apple");
    fruits.add("Orange");
    fruits.add("Banana");

    Collections.sort(fruits);

    for (String fruit : fruits) {
      System.out.println(fruit);
    }
  }
}
```

输出结果为：

```
Apple
Banana
Orange
Pineapple
```



#### 3、对象的排序

那对于对象的排序该怎么办呢？假设我们有一个 `Employee` 的 `class` ：

```java
public class Employee {
  private int id;
  private String name;
  private int age;
  private long salary;

  public Employee(int id, String name, int age, long salary) {
    this.id = id;
    this.name = name;
    this.age = age;
    this.salary = salary;
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getAge() {
    return age;
  }

  public void setAge(int age) {
    this.age = age;
  }

  public long getSalary() {
    return salary;
  }

  public void setSalary(long salary) {
    this.salary = salary;
  }
  
  @Override
  public String toString() {
    return  "id: " + id + ", name: " + name + ", age:" + age + ", salary: " + salary + "\n";
  }
}
```

我们试试数组的默认排序：

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    Employee[] empArray = new Employee[4];
    empArray[0] = new Employee(10, "Mikey", 25, 10000);
    empArray[1] = new Employee(20, "Arun", 29, 20000);
    empArray[2] = new Employee(5, "Lisa", 35, 5000);
    empArray[3] = new Employee(1, "Pankaj", 32, 50000);
    Arrays.sort(empArray);
    System.out.println("Default Sorting of Employees list:\n" + Arrays.toString(empArray));
  }
}
```

运行之后发现抛出以下运行时异常：

```
Exception in thread "main" java.lang.ClassCastException: packageOne.Employee cannot be cast to java.lang.Comparable
```

所以，使用默认的数组排序，是不能完成对象的排序的。这就需要用到 `Comparable` 接口了。



#### 4、Comparable 的作用

`Comparable` 是一个接口，仅仅只包含了一个函数：

```java
package java.lang;
import java.util.*;

public int compareTo(T o);
```

若一个类实现了 `Comparable` 接口，就意味着 **「该类支持排序」**。 实现 `Comparable` 接口的类的对象的 `List` 列表(或数组) 就可以通过 `Collections.sort()`（或 `Arrays.sort()`）进行排序了。

所以，`Comparable` 接口相当于 **「内部比较器」**。

下面，我们来让 `Employee` 类实现 `Comparable` 接口，因为 `Comparable` 接口里面只有一个 `compareTo` 方法，那我们就需要在实现中重写 `compareTo` 方法：

```java
public class Employee implements Comparable<Employee> { // 实现接口
  // ....
  @Override
  public int compareTo(Employee employee) {
    return name.compareTo(employee.name); // 注意，这里的 compareTo 方法是 String 类的方法
  }
}
```

再运行一下上面的主方法，输出结果为：

```
[id: 20, name: Arun, age:29, salary: 20000
, id: 5, name: Lisa, age:35, salary: 5000
, id: 10, name: Mikey, age:25, salary: 10000
, id: 1, name: Pankaj, age:32, salary: 50000
]
```

没有报错了，输出结果也是按照 `name` 来排序的。



### 二、Comparator 是什么？

`Comparator` （比较器）是 `Java` 中 `java.util` 包下的一个**接口**，该接口用于**对用户定义类的对象进行排序和比较。**



#### 1、为什么会出现 Comparator？

前面我们知道了，如果需要对一组对象进行排序，就需要实现 `Comparable` 接口，也就是说在类定义的时候就需要默认实现好的接口。但是这样会有出现一个问题：

如果现在有一个类已经开发完善了，但是由于初期的设计并没有考虑到此类对象数组的排序情况，而后又突然需要实现对象数组的排序，那么这个时候，在不能修改类定义的情况下，是不能使用 `Comparable` 接口的。

还有另外一个问题： **`Comparable`  接口只允许对单个属性进行排序。**如上面的例子，如果期望在 `name` 相同的条件下，按照 `age` 来排序，是办不到的。

因此，为了解决这些问题，在 `Java` 里又出现了另一个接口：`Comparator`。



#### 2、Comparator 接口的使用

我们看看 `Comparator` 接口的部分源码：

```java
@FunctionalInterface
public interface Comparator<T> {
  public int compare(T o1, T o2);
  public boolean equals(Object obj);
  // ...
}
```

使用 `Comparator` 会有一些不同，需要定义一个专门的排序类，并且调用排序的时候也要明确的指明。

现在我们创建一个 `EmployeeComparator` 类来实现 `Comparator` 接口：

```java
import java.util.Comparator;

public class EmployeeComparator implements Comparator<Employee> {
  @Override
  public int compare(Employee employee1, Employee employee2) {
    return employee1.getName().compareTo(employee2.getName());
  }
}
```

调用的时候需要明确指定所使用的排序类：

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    Employee[] empArray = new Employee[4];
    empArray[0] = new Employee(10, "Mikey", 25, 10000);
    empArray[1] = new Employee(20, "Arun", 29, 20000);
    empArray[2] = new Employee(5, "Lisa", 35, 5000);
    empArray[3] = new Employee(1, "Pankaj", 32, 50000);
    Arrays.sort(empArray, new EmployeeComparator());
    System.out.println("Default Sorting of Employees list:\n" + Arrays.toString(empArray));
  }
}
```

如果需要对多个属性进行排序，我们可以像下面这样写：

```java
import java.util.Comparator;

public class EmployeeComparator implements Comparator<Employee> {
  @Override
  public int compare(Employee employee1, Employee employee2) {
    int nameCom = employee1.getName().compareTo(employee2.getName());
    if (nameCom != 0) {
      return nameCom;
    }
    return Integer.compare(employee1.getAge(), employee2.getAge());
  }
}
```

测试一下：

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    Employee[] empArray = new Employee[5];
    empArray[0] = new Employee(10, "Mikey", 25, 10000);
    empArray[1] = new Employee(10, "Mikey", 23, 10000);
    empArray[2] = new Employee(20, "Arun", 29, 20000);
    empArray[3] = new Employee(5, "Lisa", 35, 5000);
    empArray[4] = new Employee(1, "Pankaj", 32, 50000);
    Arrays.sort(empArray, new EmployeeComparator());
    System.out.println("Default Sorting of Employees list:\n" + Arrays.toString(empArray));
  }
}
```

输出结果为：

```
Default Sorting of Employees list:
[id: 20, name: Arun, age:29, salary: 20000
, id: 5, name: Lisa, age:35, salary: 5000
, id: 10, name: Mikey, age:23, salary: 10000
, id: 10, name: Mikey, age:25, salary: 10000
, id: 1, name: Pankaj, age:32, salary: 50000
]
```

首先按照 `name` 的自然排序来排序，如果 `name` 相同，则按照 `age` 来排序。



### 三、Comparable 和 Comparator 的区别

下面我们总结下二者的区别：

- `Comparable` 是排序接口；若一个类实现了 `Comparable` 接口，就意味着 「该类支持排序」；
- 使用 `Comparator` 时，需要自定义一个专门的排序类，并且调用排序的时候也要明确的指明；

- `Comparable` 是内部比较器，而 `Comparator` 是外部比较器；
- `Comparable`  接口只允许对单个属性进行排序，而 `Comparator` 接口可以支持多个属性排序（多级排序）。

其实，`Java8` 里新增的 `API` 可以帮助我们更好地处理这些排序问题，不过不在本文的讨论范围内，会在 `Java8` 新增 `API` 里讲解。