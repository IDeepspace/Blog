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

1）创建 `ArrayList`

```java
ArrayList<String> arrList=new ArrayList<String>();
ArrayList<Integer> list = new ArrayList<Integer>();
```

2）添加元素

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");
fruits.add(1,"Strawberry"); // 在指定位置添加
System.out.println(Arrays.toString(fruits.toArray())); // [Apple, Strawberry, Banana]
```

3）获取长度

```java
System.out.println(fruits.size()); // 获取长度 3
```

4）获取元素

```java
System.out.println(fruits.get(1)); // 获取元素
```

5）删除元素

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");
fruits.add(1, "Strawberry"); // 在指定位置添加

fruits.remove("Apple"); // 删除元素
fruits.remove(1); // 在指定位置删除

System.out.println(Arrays.toString(fruits.toArray())); // [Strawberry]
```

6）遍历

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

7）返回元素的索引

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple");
fruits.add("Banana");
fruits.add(2, "Apple");

System.out.println(fruits.indexOf("Apple")); // 获取索引: 0
System.out.println(fruits.lastIndexOf("Apple")); // 获取索引: 2
System.out.println(fruits.lastIndexOf("pear")); // 获取索引: -1
```

8）检查某个元素是否存在 `ArrayList` 中

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

9）一次性删除所有元素

```java
fruits.clear();
```

10）排序

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

11）更新列表元素

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

12）连接组合

```java
ArrayList<Integer> arrayList = new ArrayList<Integer>();
arrayList.add(1);
arrayList.add(2);

ArrayList<Integer> arrayList1 = new ArrayList<Integer>();
arrayList1.add(3);

arrayList1.addAll(arrayList); // [3, 1, 2]
```

13）拷贝

```java
ArrayList<Integer> arrayList = new ArrayList<Integer>();
    arrayList.add(1);
    arrayList.add(2);

    ArrayList<Integer> arrayList1 = (ArrayList<Integer>) arrayList.clone();
    arrayList1.add(3);

    System.out.println(arrayList1); // [1, 2, 3]
```

14）判空

```java
ArrayList<Integer> arrayList = new ArrayList<Integer>();
arrayList.add(1);

ArrayList<Integer> arrayList1 = new ArrayList<Integer>();

System.out.println(arrayList.isEmpty()); // false
System.out.println(arrayList1.isEmpty()); // true
```

15）将 `ArrayList` 转换为字符串数组

```java
ArrayList<String> fruits = new ArrayList<String>();
fruits.add("Apple"); // 添加元素
fruits.add("Banana");

System.out.println(Arrays.toString(fruits.toArray())); // [Strawberry]
```

16）将数组转换为 `ArrayList`

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



下面介绍下 `LinkedList` 类的方法。

1）创建

```java
LinkedList<String> list = new LinkedList<String>();
```

2）添加

```java
LinkedList<String> list = new LinkedList<String>();
list.add("hello");
list.add(0, "I love");
list.addFirst("world");
list.addLast("bye");
```

3）将指定集合的所有元素添加到列表中：`addAll`

```java
public class Main {
  public static void main(String[] args) {
    LinkedList<String> list = new LinkedList<String>();
    ArrayList<String> arrayList= new ArrayList<String>();
    arrayList.add("String1");
    arrayList.add("String2");
    list.addAll(arrayList);

    System.out.println(list); // [String1, String2]
  }
}
```

如果指定的集合为 `null`，则抛出 `NullPointerException`。

4）获取元素

- `Object get(int index)`：从列表中返回指定索引的项；
- `Object getFirst()`：从列表中取出第一个项；
- `Object getLast()`：从列表中取出最后一项；
- `int size()`：返回列表元素的数量。

5）索引

- `int indexOf(Object item)`：返回指定项的索引；
- `int lastIndexOf(Object item)`：返回指定元素最后一次出现的索引；

6）删除元素

- `Object poll()`：返回并删除列表的第一项；
- `Object pollFirst()`：与`poll()`方法相同，删除列表中的第一项；
- `Object pollLast()`：返回并删除列表的最后一个元素；
- `Object remove()`：删除列表的第一个元素；
- `Object remove(int index)`：从列表中删除指定索引处的元素；
- `Object remove(Object obj)`：从列表中删除指定的对象；
- `Object removeFirst()`：从列表中删除第一个项目；
- `Object removeLast()`：删除列表的最后一项；
- `Object removeFirstOccurrence(Object item)`：删除第一次出现的指定项；
- `Object removeLastOccurrence(Object item)`：删除最后一次出现的指定项；
- 删除列表中的所有元素：`void clear()`。

7）返回列表的副本：`Object clone()`

8）用赋值更新指定索引的项：`Object set(int index, Object item)`

9）遍历

- `for` 循环
- 高级 `For ` 循环
- 迭代器
- `while` 循环

只介绍迭代器循环：

```java
import java.util.Iterator;
import java.util.LinkedList;

public class Main {
  public static void main(String[] args) {
    /*LinkedList declaration*/
    LinkedList<String> linkedList = new LinkedList<String>();
    linkedList.add("Apple");
    linkedList.add("Orange");
    linkedList.add("Mango");

    /*for loop*/
    System.out.println("**For loop**");
    for (int num = 0; num < linkedList.size(); num++) {
      System.out.println(linkedList.get(num));
    }

    /*Advanced for loop*/
    System.out.println("**Advanced For loop**");
    for (String str : linkedList) {
      System.out.println(str);
    }

    /*Using Iterator*/
    System.out.println("**Iterator**");
    Iterator i = linkedList.iterator();
    // Iterator i = linkedList.descendingIterator(); // 反序遍历
    while (i.hasNext()) {
      System.out.println(i.next());
    }

    /* Using While Loop*/
    System.out.println("**While Loop**");
    int num = 0;
    while (linkedList.size() > num) {
      System.out.println(linkedList.get(num));
      num++;
    }
  }
}
```

10）获取子列表

`LinkedList `类的 `subList(int startIndex, int endIndex)` 方法可以获取 `LinkedList` 的子列表。它返回指定索引 `startIndex`（包括）和 `endIndex`（不包括）之间的 `List`。

**注意：对子列表所做的任何更改都将反映在原始列表中。**

```java
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Main {
  public static void main(String[] args) {
    // Create a LinkedList
    LinkedList<String> linkedList = new LinkedList<String>();

    // Add elements to LinkedList
    linkedList.add("Item1");
    linkedList.add("Item2");
    linkedList.add("Item3");
    linkedList.add("Item4");
    linkedList.add("Item5");
    linkedList.add("Item6");
    linkedList.add("Item7");

    // Displaying LinkedList elements
    System.out.println("LinkedList elements:");
    Iterator it = linkedList.iterator();
    while (it.hasNext()) {
      System.out.println(it.next());
    }

    // Obtaining Sublist from the LinkedList
    List sublist = linkedList.subList(2, 5);

    // Displaying SubList elements
    System.out.println("\nSub List elements:");
    Iterator item = ((List) sublist).iterator();
    while (item.hasNext()) {
      System.out.println(item.next());
    }

    sublist.remove("Item4");
    System.out.println("\nLinkedList elements After remove:");
    Iterator it2 = linkedList.iterator();
    while (it2.hasNext()) {
      System.out.println(it2.next());
    }
  }
}
```

11）`isEmpty()` 方法用于检查列表是否为空

12）将 `LinkedList` 转换为 `ArrayList` 

```java
LinkedList<String> linkedList = new LinkedList<String>();
linkedList.add("Harry");
linkedList.add("Jack");

List<String> list = new ArrayList<String>(linkedList);
```

13）将 `LinkedList` 转换为数组

```java
LinkedList<String> linkedList = new LinkedList<String>();
linkedList.add("Harry");
linkedList.add("Jack");

String[] array = linkedList.toArray(new String[linkedList.size()]);
```





#### 3、ArrayList 和 LinkedList 的区别

操作方面，`ArrayList` 搜索操作非常快，而 `LinkedList` 元素删除更快，插入性能也是  `LinkedList` 较好，原因在前面已经解释过了。

而在内存开销上面，`ArrayList` 维护索引和元素数据，而 `LinkedList` 维护元素数据和相邻节点的两个指针，因此 `LinkedList` 中的内存消耗比较高。

所以，在开发过程中，我们需要根据具体的需求来选择哪种集合。



#### 3、Vector

`Vector` （向量）实现 `List` 接口。与 `ArrayList` 一样，它也维护插入顺序，但是两者还是有很大的区别的。

**`Vector` 和 `ArrayList` 的区别：**

- 同步性（`Synchronization`）
  - `Vector` 是同步的，这意味着一次只有一个线程可以访问代码，而不是 `ArrayList` 同步的，这意味着多个线程可以同时在 `ArrayList` 上工作；
  - 例如，如果一个线程正在执行添加操作，这个时候可能有另一个线程在多线程环境中执行删除操作。如果多线程同时访问 `ArrayList`，可能就会发生一个线程的值覆盖另一个线程添加的值，在某些时候会导致一些错误；
  - `vector` 大部分方法都使用了 `synchronized` 修饰符，所以它是**线程安全**的集合类。
  - 如下图所示：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/ArrayList-vs-Vector-Java.png" alt="Java Vector vs ArrayList" style="zoom:87%;" />

- 性能（`Performance`）
  - `ArrayList` 更快，因为它是非同步的，而向量操作因为是同步的（线程安全的） ，所以性能更慢；
  -  如果一个线程处理一个向量，那么它就获得了一个向量的锁，这迫使任何其他想要处理它的线程必须等待，直到锁被释放。
- 数据增长（`Data Growth`）
  - `ArrayList` 和 `Vector` 都会动态地增长和缩小以保持存储空间的最佳使用 —— 但是它们的调整方式是不同的；
  - 如果元素的数量超过了当前数组的容量，`ArrayList` 的增量为当前数组大小的 `50%` ，而矢量的增量为 `100%`。
- 遍历
  - `Vector` 可以使用枚举和迭代器（`Enumeration and Iterator`）遍历 `Vector` 元素，而 ArrayList 只能使用迭代器遍历。

在开发中，我们可以根据具体的需求和 `ArrayList` 与 `Vector` 的区别来决定选取哪种集合。

常用的 `Vector` 类方法有：

1. `void addElement(Object element)`：在 `Vector` 的末尾插入元素；
2. `int capacity()`：此方法返回向量的当前容量；
3. `int size()`：返回向量的当前大小；
4. `void setSize(int size)`：使用指定的大小更改现有大小；
5. `boolean contains(Object element)`：此方法检查 `Vector` 中是否存在指定的元素；
6. `boolean containsAll(Collection c)`：如果 `Vector` 中存在集合 `c` 的所有元素，则返回 `true`；
7. `Object elementAt(int index)`：返回 `Vector` 中指定位置的元素；
8. `Object firstElement()`：用于获取向量的第一个元素；
9. `Object lastElement()`：返回数组的最后一个元素；
10. `Object get(int index)`：返回指定索引处的元素；
11. `boolean isEmpty()`：如果 `Vector` 没有任何元素，则此方法返回 `true`；
12. `boolean remove(Object element)`：从向量中移除指定的元素；
13. `boolean removeAll(Collection c)`：从向量中删除所有存在于 `Collection c` 中的元素；
14. `void setElementAt(Object element, int index)`：使用给定元素更新指定索引的元素；
15. `subList(int fromIndex, int toIndex)`：获取元素的子列表；
16. 使用 `Enumeration` 迭代 `Vector`；
17. 使用 `Iterator` 遍历 `Vector`；
18. 使用 `ListIterator` 在前进和后退方向上遍历 `Vector`

```java
import java.util.Enumeration;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.Vector;

public class Main {
  public static void main(String[] args) {
    Vector<String> vector = new Vector<String>();

    vector.add("Mango");
    vector.add("Orange");
    vector.add("Apple");

    // 使用 Enumeration 迭代 Vector
    Enumeration en = vector.elements();

    System.out.println("Vector elements are(Enumeration): ");
    while (en.hasMoreElements()) {
      System.out.println(en.nextElement());
    }

    // 使用 Iterator 遍历 Vector
    Iterator it = vector.iterator();

    System.out.println("\nVector elements are(Iterator):");
    while (it.hasNext()) {
      System.out.println(it.next());
    }

    ListIterator litr = vector.listIterator();
    System.out.println("\nTraversing in Forward Direction:");
    while (litr.hasNext()) {
      System.out.println(litr.next());
    }

    System.out.println("\nTraversing in Backward Direction:");
    while (litr.hasPrevious()) {
      System.out.println(litr.previous());
    }
  }
}
```

打印结果：

```
Vector elements are(Enumeration): 
Mango
Orange
Apple

Vector elements are(Iterator):
Mango
Orange
Apple

Traversing in Forward Direction:
Mango
Orange
Apple

Traversing in Backward Direction:
Apple
Orange
Mango
```

19. 将 `Vector` 转换为 `List` ；
20. 将 `Vector` 转换为 `ArrayList`；
21. 将 `Vector` 转换为字符串数组。

```java
import java.util.*;

public class Main {
  public static void main(String[] args) {
    Vector<String> vector = new Vector<String>();

    vector.add("Mango");
    vector.add("Orange");
    vector.add("Apple");

    System.out.println("Vector Elements :");
    for (String str : vector) {
      System.out.println(str);
    }

    List<String> list = Collections.list(vector.elements());

    ArrayList<String> arrayList = new ArrayList<String>(vector);

    System.out.println("\nList Elements :");
    for (String str2 : list) {
      System.out.println(str2);
    }

    System.out.println("\nArrayList Elements :");
    for (String str2 : arrayList) {
      System.out.println(str2);
    }

    String[] array = vector.toArray(new String[vector.size()]);
    System.out.println("\nString Array Elements :");
    for (String s : array) {
      System.out.println(s);
    }
  }
}
```



#### 4、Stack

在 `Java` 中 `Stack` 类表示后进先出（`Last in First out, LIFO`）的对象堆栈。

就像洗碗一样，最后洗好的碗叠在最上面，而下次拿的时候是最先拿到最后叠上去的碗，即已放置在最底部位置的碗在堆栈中保留的时间最长。像一些编辑器的撤销功能，棋牌程序的悔牌、悔棋功能，就可以选择 `Stack`。

`Stack` 类支持一个缺省构造函数堆栈 ，用于创建一个空堆栈。

下面的程序展示了 `Stack` 类提供的一些基本操作：

```java
import java.util.Stack;

public class Main {
  // Pushing element on the top of the stack
  static void stack_push(Stack<Integer> stack) {
    for (int i = 0; i < 5; i++) {
      stack.push(i);
    }
  }

  // Popping element from the top of the stack
  static void stack_pop(Stack<Integer> stack) {
    System.out.println("Pop :");

    for (int i = 0; i < 5; i++) {
      Integer y = (Integer) stack.pop();
      System.out.println(y);
    }
  }

  // Displaying element on the top of the stack
  static void stack_peek(Stack<Integer> stack) {
    Integer element = (Integer) stack.peek();
    System.out.println("Element on stack top : " + element);
  }

  // Searching element in the stack
  static void stack_search(Stack<Integer> stack, int element) {
    Integer pos = (Integer) stack.search(element);

    if (pos == -1)
      System.out.println("Element not found");
    else
      System.out.println("Element is found at position " + pos);
  }


  public static void main(String[] args) {
    Stack<Integer> stack = new Stack<Integer>();

    stack_push(stack);
    stack_pop(stack);
    System.out.println(stack.empty());
    stack_push(stack);
    stack_peek(stack);
    stack_search(stack, 2);
    stack_search(stack, 6);
  }
}
```

打印结果为：

```java
Pop :
4
3
2
1
0
true
Element on stack top : 4
Element is found at position 3
Element not found
```

- `Object push(Object element)`：将一个元素推送到堆栈顶部；
- `Object pop()` : 移除并返回堆栈的顶部元素。 注意，当调用堆栈为空时，如果我们调用 `pop ()` ，就会引发 `EmptyStackException` 异常；
- `Object peek()`：返回堆栈顶部的元素，但不删除它；
- `boolean empty()`：如果堆栈顶部没有任何内容，则返回 `true`， 否则，返回 `false`
- `int search(Object element)` : 它确定堆栈中是否存在某对象。 如果找到该元素，则返回该元素在堆栈中的索引，否则，它返回 `-1`。



### 四、Queue



### 五、Set



### 六、Hashtable 

### 七、HashMap 

### 八、WeakHashMap

