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

下面我们来具体看看集合框架中的一些常见的类。



### 三、List

`List` 接口是 `Collection` 接口的子接口。

#### 1、ArrayList

`ArrayList` 是 `Java` 中我们最常使用的 `List` 接口的实现类，是基于 `Array` 的数据结构。

我们都知道数组的限制是它有一个固定的长度，所以如果数组已满，就不能再添加任何元素。而 `ArrayList` 是 `List` 接口的**可调整大小**的数组实现，可以在添加和删除元素后**动态增长和缩小长度**，所以，我们也不用在声明的时候指定大小。`ArrayList` 使用起来比 `Array` 更加方便。

**1）创建 `ArrayList`**

```java
ArrayList<String> arrList=new ArrayList<String>();
ArrayList<Integer> list = new ArrayList<Integer>();
```

**2）添加元素**

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");
fruits.add(1,"Strawberry"); // 在指定位置添加
System.out.println(Arrays.toString(fruits.toArray())); // [Apple, Strawberry, Banana]
```

**3）获取长度**

```java
System.out.println(fruits.size()); // 获取长度 3
```

**4）获取元素**

```java
System.out.println(fruits.get(1)); // 获取元素
```

**5）删除元素**

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");
fruits.add(1, "Strawberry"); // 在指定位置添加

fruits.remove("Apple"); // 删除元素
fruits.remove(1); // 在指定位置删除

System.out.println(Arrays.toString(fruits.toArray())); // [Strawberry]
```

**6）遍历**

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");
fruits.add(1, "Strawberry"); // 在指定位置添加

for (int i = 0; i < fruits.size(); i++) {
  System.out.println(fruits.get(i));
}

for (String fruit : fruits) {
  System.out.println(fruit);
}
```

**7）返回元素的索引**

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple");
fruits.add("Banana");
fruits.add(2, "Apple");

System.out.println(fruits.indexOf("Apple")); // 获取索引: 0
System.out.println(fruits.lastIndexOf("Apple")); // 获取索引: 2
System.out.println(fruits.lastIndexOf("pear")); // 获取索引: -1
```

**8）检查某个元素是否存在 `ArrayList` 中**

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple");
fruits.add("Banana");
fruits.add(2, "Apple");

System.out.println(fruits.contains("Apple")); // true
System.out.println(fruits.contains("pear")); // false

ArrayList<String> newFruits = new ArrayList<String>();
fruits.add("Apple");
fruits.add("Banana");
System.out.println(fruits.containsAll(newFruits)); // true
```

**9）一次性删除所有元素**

```java
fruits.clear();
```

**10）排序**

```java
Collections.sort(fruits); // 升序
Collections.reverse(fruits); // 降序
```

如果需要对对象进行排序，需要使用 `Comparator` 的 `compare` 方法进行排序。

`Student` 类：

```java
import java.util.Comparator;

public class Student {
  public static Comparator<Student> StuNameComparator = new Comparator<Student>() {

    public int compare(Student s1, Student s2) {
      String StudentName1 = s1.getStudentName().toUpperCase();
      String StudentName2 = s2.getStudentName().toUpperCase();

      // ascending order
      return StudentName1.compareTo(StudentName2);

      // descending order
      //return StudentName2.compareTo(StudentName1);
    }
  };
  /*Comparator for sorting the list by roll no*/
  public static Comparator<Student> StuRollNo = new Comparator<Student>() {

    public int compare(Student s1, Student s2) {

      int rollNo1 = s1.getRollNo();
      int rollNo2 = s2.getRollNo();

      /*For ascending order*/
      return rollNo1 - rollNo2;
    }
  };

  private String studentName;
  private int rollNo;
  private int studentAge;
  public Student(int rollNo, String studentName, int studentAge) {
    this.rollNo = rollNo;
    this.studentName = studentName;
    this.studentAge = studentAge;
  }

  @Override
  public String toString() {
    return "[ rollNo=" + rollNo + ", name=" + studentName + ", age=" + studentAge + "]";
  }

  public String getStudentName() {
    return studentName;
  }

  public int getRollNo() {
    return rollNo;
  }
}
```

`Main` 方法：

```java
import java.util.ArrayList;
import java.util.Collections;

public class Main {
  public static void main(String[] args) {
    ArrayList<Student> studentArrayList = new ArrayList<Student>();
    studentArrayList.add(new Student(101, "Zues", 26));
    studentArrayList.add(new Student(505, "Abey", 24));
    studentArrayList.add(new Student(809, "Vignesh", 32));

    /*Sorting based on Student Name*/
    System.out.println("Student Name Sorting:");
    studentArrayList.sort(Student.StuNameComparator);
    // 或者下面这样写
    //Collections.sort(studentArrayList, Student.StuNameComparator);

    for (Student str : studentArrayList) {
      System.out.println(str);
    }

    /* Sorting on RollNo property*/
    System.out.println("RollNum Sorting:");
    studentArrayList.sort(Student.StuRollNo);
    for (Student str : studentArrayList) {
      System.out.println(str);
    }
  }
}
```

**11）更新列表元素**

```java
public class Main {
  public static void main(String[] args) {
    ArrayList<Integer> arrayList = new ArrayList<Integer>();
    arrayList.add(1);
    arrayList.add(2);
    System.out.println("ArrayList before update: " + arrayList);
    // Updating 1st element
    arrayList.set(0, 11);
    arrayList.set(1, 22);
    System.out.println("ArrayList after Update: " + arrayList);
  }
}
```

**12）连接组合**

```java
ArrayList<Integer> arrayList = new ArrayList<Integer>();
arrayList.add(1);
arrayList.add(2);

ArrayList<Integer> arrayList1 = new ArrayList<Integer>();
arrayList1.add(3);

arrayList1.addAll(arrayList); // [3, 1, 2]
```

**13）拷贝**

```java
ArrayList<Integer> arrayList = new ArrayList<Integer>();
    arrayList.add(1);
    arrayList.add(2);

    ArrayList<Integer> arrayList1 = (ArrayList<Integer>) arrayList.clone();
    arrayList1.add(3);

    System.out.println(arrayList1); // [1, 2, 3]
```

**14）判空**

```java
ArrayList<Integer> arrayList = new ArrayList<Integer>();
arrayList.add(1);

ArrayList<Integer> arrayList1 = new ArrayList<Integer>();

System.out.println(arrayList.isEmpty()); // false
System.out.println(arrayList1.isEmpty()); // true
```

**15）将 `ArrayList` 转换为字符串数组**

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");

System.out.println(Arrays.toString(fruits.toArray())); // [Strawberry]
```

**16）将数组转换为 `ArrayList`**

```java
String cityNames[] = {"Agra", "Mysore", "Chandigarh", "Bhopal"};
ArrayList<String> cityList = new ArrayList<String>(Arrays.asList(cityNames));
```

或者：

```java
String[] cityNames = {"Agra", "Mysore", "Chandigarh", "Bhopal"};
ArrayList<String> arrayList = new ArrayList<String>();
Collections.addAll(arrayList, cityNames);
```

`Collections.addAll()` 方法性能更好。



#### 2、LinkedList

与 `Java` 中的数组类似，`LinkedList` （链表）是线性数据结构。但是，`LinkedList` 元素不存储在像数组这样的连续位置中，它们使用指针相互链接。

`LinkedList`中的每个元素称为**节点**。`LinkedList`的每个节点包含两个部分：

- 元素的内容
- 指向链表中的下一节点的指针（地址/引用）

如下图：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/singly-linked-list.png" alt="Java 单链表" />

**注意：**

- `LinkedList` 的头仅包含 `List` 的第一个元素的地址；
- `LinkedList` 的最后一个元素在节点的指针部分包含 `null`，因为它是`List`的结尾，因此它不指向任何内容；
- 上图所示的图表示**单链表**。`LinkedList` 的另一种复杂类型变体称为**双向链表**，双向链表的节点包含三部分：
  - 指向链表的前一节点的指针；
  - 元素的内容；
  - 指向链表的下一个节点的指针。

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/doubly-linked-list.png" alt="Java 双链表"  />

为什么会出现 `LinkedList` 这样的一个数据结构呢？也就是为什么需要链表呢？

你必须知道数组也是一个线性数据结构，但数组有一些限制，如下：

1. 数组的大小是固定的。因此我们在创建一个数组时，很难预先预测元素的数量，如果声明的内存空间大小不足，那么我们就不能增加数组的大小；但是如果我们声明一个大型数组，并且不需要存储那么多的元素时，又会浪费空间（`ArrayList` 已经解决了这个问题）；

2. 数组元素**需要连续的存储单元**来存储它们的值，也就是说**数组（和 `ArrayList`） 总是将元素加入数组中的第一个非空位置**，由于这个特点，就导致了下面的第三个问题；

3. **在数组中插入一个元素是性能上昂贵的**，因为我们必须移动几个元素来为新元素腾出空间。比如：假设我们有一个具有以下元素的数组：`10,12,15,20,4,5,100`，现在如果我们想要在值为 `12` 的元素之后插入新元素 `99`， 那么我们必须将 `12` 之后的所有元素移到右边，为新元素腾出空间。类似地，**从数组中删除元素**也是性能上昂贵的操作，因为删除元素之后的所有元素都必须向左移位。

`LinkedList` 就是为了解决上面的问题而出现的。链表是这样来处理的：

1. 链表允许**动态内存分配**，这意味着内存分配在运行时由编译器完成，在链表声明中我们不需要声明列表的大小；
2. 链表元素**不需要连续的存储单元**，因为列表中的节点（元素）使用包含列表的下一个节点（元素）的地址相互链接；
3. 在链表中插入和删除操作的性能并不昂贵，因为从链表中添加和删除元素不需要元素移位，只需要更改前一个节点和下一个节点的指针。



#### 3、ArrayList 和 LinkedList 的区别





#### 3、Ventor



#### 4、Stack





### 四、Queue



### 五、Set



### 六、Hashtable 

### 七、HashMap 

### 八、WeakHashMap

