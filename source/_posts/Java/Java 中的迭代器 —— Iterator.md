---
title: Java 中的迭代器 —— Iterator
author: Deepspace
tags:
  - Java
  - Iterator
categories: Java
date: 2017-06-29
urlname: java-iterator
---



### 一、  Iterator 是什么？

#### 1、迭代器模式

迭代器模式（`Iterator Pattern`）是一种非常常见的设计模式，这种模式用于顺序访问集合对象的元素，而不需要知道集合对象内部的实现方式。

所以，迭代器模式的优点就是：**简化了聚合类**。无论是增加新的聚合类还是增加迭代器类都会很方便，无须修改原有的代码。

它的优点也导致了它的缺点：由于迭代器模式将存储数据和遍历数据的职责分离，增加新的聚合类时也需要对应增加新的迭代器类，耦合度很高，这在一定程度上增加了系统的复杂性。



#### 2、Iterator 接口

在 `Java` 中，提供了一个迭代器接口 `Iterator` ，把在集合对象中元素之间遍历的工作交给迭代器，而不是集合对象本身，迭代器为遍历不同的集合对象提供一个统一的接口。这就是 `Java` 集合框架中  `Iterable` 接口位于框架结构最顶层的原因。这其实也就是面向对象的思想。



### 二、Iterator 的使用

下面我们先看看 `Iterator` 是如何使用的。

#### 1、Iterator 中的方法

先从 `Iterator` 接口的源码来分析一下：

```java
public interface Iterator<E> {
    boolean hasNext();

    E next();

    default void remove() {
      throw new UnsupportedOperationException("remove");
    }

    default void forEachRemaining(Consumer<? super E> action) {
      Objects.requireNonNull(action);
      while (hasNext())
        action.accept(next());
    }
  }
```

可以看到，`Iterator` 接口提供的方法很少，也比较简单：

- `boolean hasNext()`：如果迭代中还有更多的元素，则返回 `true`，否则返回 `false`；
- `E next()`：返回迭代中的下一个元素；
- `default void remove()`：从集合中移除此迭代器返回的最后一个元素，它是一个可选的操作；
- `default void forEachRemaining(Consumer action)` ：对每个剩余元素执行给定的操作，直到所有元素都已处理完毕或该操作引发异常。



#### 2、Iterator 基本示例

了解了 `Iterator` 提供的方法，下面我们来使用一下：

```java
import java.util.Iterator;
import java.util.LinkedList;

public class Main {
  public static void main(String[] args) {
    LinkedList<String> names = new LinkedList<String>();
    names.add("Deepspace");
    names.add("chenxingxing");

    Iterator<String> namesIterator = names.iterator();

    while (namesIterator.hasNext()) {
      System.out.println(namesIterator.next());
    }
  }
}
```

输出结果为：

```java
Deepspace
chenxingxing
```

其实，我们也可以使用 `foreach` 方法来遍历集合：

```java
for (String name : names) {
  System.out.println(name);
}
```

我们再试试 `remove` 方法：

```java
public class Main {
  public static void main(String[] args) {

    List<String> names = new LinkedList<String>();
    names.add("E-1");
    names.add("E-2");
    names.add("E-3");
    names.add("E-n");

    Iterator<String> namesIterator = names.iterator();

    while (namesIterator.hasNext()) {
      String next = namesIterator.next();
      System.out.println(next);

      if ("E-3".equals(next)) {
        namesIterator.remove();
      }
    }
    System.out.println(names); // [E-1, E-2, E-n]
  }
}
```

可以看到 `E-3` 这个元素被移除掉了。

再看看 `forEachRemaining` 方法（注意，该方法是没有返回值的）：

```java
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Main {
  public static void main(String[] args) {

    List<String> names = new LinkedList<String>();
    names.add("E-1");
    names.add("E-2");
    names.add("E-3");
    names.add("E-n");

    List<String> targetList = new LinkedList<String>();

    Iterator<String> namesIterator = names.iterator();

    while (namesIterator.hasNext()) {
      String next = namesIterator.next();
      if ("E-3".equals(next)) {
        namesIterator.remove();
        namesIterator.forEachRemaining(targetList::add);
      }
    }
    System.out.println(targetList); // [E-3, E-n]
  }
}
```



### 三、Iterator 内部是如何工作的？

下面我们来了解下 `Java` 迭代器及其方法是如何在内部工作的。以 `LinkedList` 对象为例。

创建一个 `List` 集合，并插入几条数据：

```java
List<String> names = new LinkedList<String>();
names.add("E-1");
names.add("E-2");
names.add("E-3");
names.add("E-n");
```

现在在 `List` 对象上创建一个迭代器对象：

```java
Iterator<String> namesIterator = names.iterator();
```

可以用下面的图来表示 `nameIterator` ：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Java/iterator1.png" alt="迭代器1" style="zoom:60%;" />

这里，`Iterator` 的 `Cursor` （光标）指向 `List` 的第一个元素之前。

下面我们再运行下面两行代码：

```java
namesIterator.hasNext();
namesIterator.next();
```

这个时候，`Iterator` 的 `Cursor` 指向 `List` 中的第一个元素，如下图所示：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Java/iterator2.png" alt="迭代器2" style="zoom:60%;" />

我们再运行一下刚才的两行代码：

```java
namesIterator.hasNext();
namesIterator.next();
```

`Iterator` 的 `Cursor` 会指向 `List` 中的第二个元素：

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Java/iterator3.png" alt="迭代器3" style="zoom:60%;" />

以此类推，重复执行此过程，可将 `Iterator` 的 `Cursor` 指向 `List` 中的最后一个元素。

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Java/iterator4.png" alt="迭代器4" style="zoom:60%;" />

当读取最后一个元素后，如果继续运行下面的代码片段，它将返回 `false` 。

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Java/iterator5.png" alt="迭代器5" style="zoom:60%;" />

从上面的描述可以看出，`Java` 迭代器只支持如下图所示的**前进方向迭代**。 

<img src="https://raw.githubusercontent.com/IDeepspace/ImageHosting/master/Java/iterator6.png" alt="迭代器6" style="zoom:60%;" />

所以也被称为单向光标。