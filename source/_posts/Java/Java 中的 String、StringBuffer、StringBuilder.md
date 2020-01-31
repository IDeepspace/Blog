---
title: Java 中的 String、StringBuffer、StringBuilder
author: Deepspace
tags:
  - String
  - StringBuffer
  - StringBuilder
  - Java
categories: Java
date: 2017-06-29
urlname: java-string-stringBuffer-stringBuilder
---

## Java 中的 String、StringBuffer、StringBuilder

`Java` 中的 `String` 属于引用类型，它是一个类，这和其他语言是不一样的。



### 一、String 对象的创建方式

我们先看创建 String 对象的两种方式。

#### 1、通过字符串常量的方式

```java
String str = "Deepspace";
```

#### 2、String() 构造函数的方式

```java
String str = new String("Deepspace");
```

> 这两种创建的方式是有区别的，这里先暂时不讲，等我们熟悉了 String 对象的操作之后，再来看它们的区别。

<!-- more -->

### 二、String 对象的不可变性

我们都知道了 `String` 对象是不可变的。那它不可变是怎么做到的呢？`Java` 这么做能带来哪些好处？

#### 1、为什么不可变？

先来看看 `String` 对象的一段源码：

```java
public final class String
        implements java.io.Serializable, Comparable<String>, CharSequence {
  /**
   * use serialVersionUID from JDK 1.0.2 for interoperability
   */
  private static final long serialVersionUID = -6849794470754667710L;
  /**
   * The value is used for character storage.
   */
  private final char value[];
  /**
   * Cache the hash code for the string
   */
  private int hash; // Default to 0
  
  // ...
}
```

从上面的源码可以分析出：

-  `String` 类是被 `final` 修饰的，也即意味着 `String` 类不能被继承，并且它的成员方法都默认为 `final` 方法，这是 `String` 对象不可变的第一点；
- `String` 类其实是通过 `char` 数组来保存字符串的，也是使用 `private final` 来声明的，我们知道对于一个被 `final` 修饰符修饰的基本数据类型的变量，其值一旦被初始化之后就不能再更改了，这是 `String` 对象不可变的第二点。



#### 2、不可变有什么好处

那 `Java` 把 `String` 对象设计成不可变的，有什么好处呢？主要有下面三个好处：

- 保证 `String` 对象的安全性；假设 `String` 对象是可变的，那么 `String` 对象将可能被恶意修改；

- 可以实现字符串常量池；

  我们知道，字符串的分配，和其他的对象分配一样，会耗费时间与内存空间；作为最基础的数据类型，如果大量且频繁地创建字符串，会极大程度地影响程序的性能。所以，`JVM` 为了提高性能和减少内存开销，在实例化字符串常量的时候进行了一些优化，优化思想是这样的：

  为字符串开辟一个字符串常量池，类似于缓存区；创建字符串常量时，首先检查字符串常量池是否存在该字符串；如果存在该字符串，就返回引用实例，如果不存在，则实例化该字符串并放入池中。

  所以，我们可以肯定的是：常量池中一定不存在两个相同的字符串。

- 加快字符串处理速度。

  因为字符串是不可变的，所以在它创建的时候， `hashcode` 就被缓存了，不需要重新计算。这就使得字符串很适合作为 `Map` 中的键，字符串的处理速度要快过其它的键对象。这就是 `HashMap` 中的键往往都使用字符串的原因。



下面再看看 `String` 类的一些方法实现：

```java
public String concat(String str) {
  int otherLen = str.length();
  if (otherLen == 0) {
    return this;
  }
  int len = value.length;
  char buf[] = Arrays.copyOf(value, len + otherLen);
  str.getChars(buf, len);
  return new String(buf, true);
}

public String replace(char oldChar, char newChar) {
  if (oldChar != newChar) {
    int len = value.length;
    int i = -1;
    char[] val = value; /* avoid getfield opcode */

    while (++i < len) {
      if (val[i] == oldChar) {
        break;
      }
    }
    if (i < len) {
      char buf[] = new char[len];
      for (int j = 0; j < i; j++) {
        buf[j] = val[j];
      }
      while (i < len) {
        char c = val[i];
        buf[i] = (c == oldChar) ? newChar : c;
        i++;
      }
      return new String(buf, true);
    }
  }
  return this;
}

// ...
```

从 `String` 类里的一些方法实现可以看出，无论是 `concat` 操作还是 `replace` 操作，都不是在原有的字符串上进行的，而是重新生成了一个新的字符串对象。也就是说进行这些操作后，最原始的字符串并没有被改变。



### 三、String 的常见操作

#### 1、字符串的比较

字符串比较是常见的操作，包括比较相等、比较大小、比较前缀和后缀串等。

我们经常使用 `==` 运算符比较的是两个对象引用，看它们是否引用相同的实例。

```java
String str1 = "Hello";
String str2 = "Hello";
System.out.println(str1 == str2); // true
```

如果我们想比较两个字符串对象的内容，`==` 运算符就不再适用了。 `Java` 提供了一些方法用来比较字符串。

**`equals()` 方法**

`equals()` 方法将逐个地比较两个字符串的每个字符是否相同。如果两个字符串具有相同的字符和长度，它返回 `true`，否则返回 `false`。并且，对于字符的大小写，也在检查的范围之内。

```java
String str1 = "abc";
String str2 = new String("abc");
String str3 = "ABC";
System.out.println(str1.equals(str2)); // true
System.out.println(str1.equals(str3)); // false
```



**`equalsIgnoreCase()` 方法**

`equalsIgnoreCase()` 方法的作用和语法与 `equals()` 方法完全相同，唯一不同的是 `equalsIgnoreCase()` 在比较时不区分大小写。当比较两个字符串时，它会认为 `A-Z` 和 `a-z` 是一样的。

```java
String str1 = "abc";
String str2 = "ABC";
System.out.println(str1.equalsIgnoreCase(str2)); // true
```



**`compareTo()` 方法**

通常，仅仅知道两个字符串是否相同是不够的。对于排序应用来说，必须知道一个字符串是大于、等于还是小于另一个字符。

> 一个字符串小于另一个字符串指的是它在字典中先出现，大于则指的是它在字典中后出现。

`compareTo()` 方法实现了这种功能。`compareTo()` 方法用于按字典顺序比较两个字符串的大小，该比较是基于字符串各个字符的 `Unicode` 值。

```java
String str = "A";
String str1 = "a";
System.out.println("str=" + str);
System.out.println("str1=" + str1);
System.out.println("str.compareTo(str1)的结果是：" + str.compareTo(str1));
System.out.println("str1.compareTo(str)的结果是：" + str1.compareTo(str));
System.out.println("str1.compareTo('a')的结果是：" + str1.compareTo("a"));
```

`"A"` 的 `Unicode` 值为 `0034`，`"a"` 的 `Unicode` 值为 `0066`。

所以输出结果为：

```
str=A
str1=a
str.compareTo(str1)的结果是：-32 
str1.compareTo(str)的结果是：32
str1.compareTo('a')的结果是：0
```

注意：如果两个字符串调用 `equals()` 方法返回 `true`，那么调用 `compareTo()` 方法会返回 `0`。



**`switch statement` 中的比较**

在 `Java 1.7` 版本之后，在 `switch statement`  中的比较，默认使用的是 `equals()` 方法。

```java
String stringToSwitch = "A";
switch (stringToSwitch) {
  case "a":
    System.out.println("a");
    break;
  case "A":
    System.out.println("A"); // the code goes here
    break;
  case "B":
    System.out.println("B");
    break;
  default:
    break;
}
```



#### 2、获取字符串的长度

```java
String string = "This is a Random String";
System.out.println(string.length()); // 23
```



#### 3、更改字符串中字符的大小写

`toUpperCase` 方法 和 `toLowerCase` 方法用于转换字符串中字符的大小写。

```java
String string = "This is a Random String";
String upper = string.toUpperCase();
String lower = string.toLowerCase();
System.out.println(string); // "This is a Random String"
System.out.println(lower); // "this is a random string"
System.out.println(upper); // "THIS IS A RANDOM STRING"
```



#### 4、截取（提取）子字符串

在 `String` 中提供了 `substring()` 方法用于截取字符串，它有两种形式：

- 一个是从指定位置截取到字符串结尾：`substring(int beginIndex)` 形式；

- 另一个是截取指定范围的内容：`substring(int beginIndex，int endIndex)` 形式。

```java
public class Main {
  public static void main(String[] args) {
    String day = "Today is Monday";
    System.out.println("substring(0)结果：" + day.substring(0));
    System.out.println("substring(2)结果：" + day.substring(2));
    System.out.println("substring(10)结果：" + day.substring(10));
    System.out.println("substring(2,10)结果：" + day.substring(2, 10));
    System.out.println("substring(0,5)结果：" + day.substring(0, 5));
  }
}
```

输出结果为：

```
substring(0)结果：Today is Monday
substring(2)结果：day is Monday
substring(10)结果：onday
substring(2,10)结果：day is M
substring(0,5)结果：Today
```



#### 5、去除字符串中的空格

`trim()` 方法用于去掉字符串中的首尾空格。

```java
String str = " hello ";
System.out.println(str.length()); // 7
System.out.println(str.trim().length()); // 5
```



#### 6、分割字符串

`String` 类的 `split()` 方法可以按指定的分割符对目标字符串进行分割，分割后的内容存放在字符串数组中。

```java
public class Main {
  public static void main(String[] args) {
    String Colors = "Red,Black,White,Yellow,Blue";
    String[] arr1 = Colors.split(","); // 不限制元素个数
    String[] arr2 = Colors.split(",", 3); // 限制元素个数为3
    System.out.println("所有颜色为：");
    for (String s : arr1) {
      System.out.println(s);
    }
    System.out.println("前三个颜色为：");
    for (String s : arr2) {
      System.out.println(s);
    }
  }
}
```

输出结果为：

```
所有颜色为：
Red
Black
White
Yellow
Blue
前三个颜色为：
Red
Black
White,Yellow,Blue
```



#### 7、字符串拼接

**使用 `+` 号连接**

```java
public class Main {
  public static void main(String[] args) {
    String str = "Welcome to " + "Beijing" + "!";
    System.out.println(str);
  }
}
```

**使用 `concat()` 方法**

```java
public class Main {
  public static void main(String[] args) {
    String book = "三国演义、";
    book = book.concat("西游记、");
    book = book.concat("水浒传、");
    book = book.concat("红楼梦");
    System.out.println(book); // 三国演义、西游记、水浒传、红楼梦
  }
}
```

**连接其他类型的数据**

前面的例子都是字符串与字符串进行连接，其实字符串也是可以同其他基本数据类型进行连接。如果将字符串同这些基本数据类型数据进行连接，此时会将这些数据直接转换成字符串。

```java
public class Main {
  public static void main(String[] args) {
    String book = "三国演义"; // 字符串
    int price = 59; // 整型变量
    float readTime = 2.5f; // 浮点型变量
    System.out.println("我买了一本图书，名字是：" + book + "\n价格是：" + price + "\n我每天阅读" + readTime + "小时");
  }
}
```

上述代码实现的是将字符串变量 `book` 与整型变量 `price` 和浮点型变量 `readTime` 相连后将结果输出。在这里定义的 `price` 和 `readTime` 都不是字符串，当它们与字符串相连时会自动调用自身的 `toString()` 方法将其转换成字符串形式，然后再参与连接运算。

输出结果为：

```
我买了一本图书，名字是：三国演义
价格是：59
我每天阅读2.5小时
```



#### 8、查询字符串

我们经常会查找一个字符串中是否包含另一个字符串，`Java` 也提供了一些方法来处理。

**`contains()` 方法**

```java
public class Main {
  public static void main(String[] args) {
    String str1 = "Hello World";
    String str2 = "Hello";
    String str3 = "helLO";
    System.out.println(str1.contains(str2)); // true
    System.out.println(str1.contains(str3)); // false
  }
}
```

`contains()` 方法区分大小写。



**`indexOf()` 方法**

`indexOf()` 方法用于返回字符（串）在指定字符串中首次出现的索引位置，如果能找到，则返回索引值，否则返回 `-1`。

```java
public class Main {
  public static void main(String[] args) {
    String words = "today,monday,sunday";
    System.out.println(words.indexOf("day")); // 2
    System.out.println(words.indexOf("day", 5)); //9
    System.out.println(words.indexOf("o")); // 1
    System.out.println(words.indexOf("o", 6)); // 7
    System.out.println(words.indexOf("today")); // 0
    System.out.println(words.indexOf("z")); // -1
  }
}
```

`indexOf()` 方法返回索引，如果没找到，则返回 `-1`。



**lastlndexOf() 方法**

`lastIndexOf()` 方法用于返回字符（串）在指定字符串中最后一次出现的索引位置，如果能找到则返回索引值，否则返回 `-1`。

```java
public class Main {
  public static void main(String[] args) {
    String words = "today,monday,Sunday";
    System.out.println(words.lastIndexOf("day")); // 16
    System.out.println(words.lastIndexOf("day", 5)); // 2
    System.out.println(words.lastIndexOf("o")); // 7
    System.out.println(words.lastIndexOf("o", 6)); // 1
  }
}
```

`lastIndexOf()` 方法的查找策略是从右往左查找，如果不指定起始索引，则默认从字符串的末尾开始查找。



**`charAt()` 方法**

`charAt()` 方法可以在字符串内根据指定的索引查找字符。

```java
public class Main {
  public static void main(String[] args) {
    String words = "today,monday,sunday";
    System.out.println(words.charAt(0)); // t
    System.out.println(words.charAt(1)); // o
    System.out.println(words.charAt(8)); // n
  }
}
```

字符串本质上是字符数组，因此它也有索引，索引从零开始。



###四、StringBuffer

通过前面的内容，我们知道了 `String` 对象**不可变**的特性，这在一些情况下会带来不便，如拼接字符串时候会产生很多无用的中间对象，如果频繁的进行这样的操作对性能有所影响。

所以，`Java` 提供了两个可变字符串类 `StringBuffer` 和 `StringBuilder`，中文翻译为 **"字符串缓冲区"**。

`StringBuffer` 就是为了解决大量拼接字符串时产生很多中间对象的问题而提供的一个类。使用 `StringBuffer` 类时，每次都会对 `StringBuffer` 对象本身进行操作，而不是生成新的对象并改变对象引用。

每个 `StringBuffer` 类的对象都能够存储指定容量的字符串，如果字符串的长度超过了 `StringBuffer` 类对象的容量，则该对象的容量会**自动扩大**。

#### 1、创建 StringBuffer 类

`StringBuffer` 类提供了 `3` 个构造方法来创建一个字符串：

```java
public class Main {
  public static void main(String[] args) {
    // 定义一个空的字符串缓冲区，含有16个字符的容量
    StringBuffer str1 = new StringBuffer();

    // 定义一个含有10个字符容量的字符串缓冲区
    StringBuffer str2 = new StringBuffer(10);

    // 定义一个含有(16+4)的字符串缓冲区，"Java"为4个字符
    StringBuffer str3 = new StringBuffer("Java");
    /*
     *输出字符串的容量大小
     *capacity() 方法返回字符串的容量大小
     */
    System.out.println(str1.capacity());  // 输出 16
    System.out.println(str2.capacity());  // 输出 10
    System.out.println(str3.capacity());  // 输出 20
  }
}
```

`capacity()` 方法返回 `StringBuffer` 对象字符串的容量大小。



#### 2、追加字符

使用 `append()` 方法用于向原有 `StringBuffer` 对象中追加字符串。

```java
public class Main {
  public static void main(String[] args) {
    String str = "study";
    str.concat("tonight");
    System.out.println(str); // study

    StringBuffer strB = new StringBuffer("study");
    strB.append("tonight");
    strB.append("!");
    System.out.println(strB); // studytonight!
  }
}
```

也可以使用链式调用的方式来书写：

```java
strB.append("tonight").append("!");
```



#### 3、替换字符

`setCharAt()` 方法用于在字符串的指定索引位置替换一个字符。

```java
public class Main {
  public static void main(String[] args) {
    StringBuffer sb = new StringBuffer("hello");
    sb.setCharAt(1, 'E');
    System.out.println(sb);    // hEllo
    sb.setCharAt(0, 'H');
    System.out.println(sb);    // HEllo
    sb.setCharAt(2, 'p');
    System.out.println(sb);    // HEplo
  }
}
```

也可以使用 `replace()` 方法来替换：

```java
public class Main {
  public static void main(String[] args) {
    StringBuffer sb = new StringBuffer("hello java");
    sb.replace(1, 5, "tttt");
    System.out.println(sb); // htttt java
  }
}
```



#### 4、反转字符串

`reverse()` 方法用于将字符串序列用其反转的形式取代。

```java
public class Main {
  public static void main(String[] args) {
    StringBuffer sb = new StringBuffer("java");
    sb.reverse();
    System.out.println(sb); // avaj
  }
}
```



#### 5、删除字符串

`StringBuffer` 类提供了 `deleteCharAt()` 和 `delete()` 两个删除字符串的方法。

`deleteCharAt()` 方法的作用是删除指定位置的字符，然后将剩余的内容形成一个新的字符串：

```java
StringBuffer sb = new StringBuffer("She");
sb.deleteCharAt(2);
System.out.println(sb); // Sh
```



`delete()` 方法用于删除指定区域以内的所有字符，语法是：

```java
new StringBuffer().delete(int start,int end);
```

`start` 表示要删除字符的起始索引值（包括索引值所对应的字符），`end` 表示要删除字符串的结束索引值（不包括索引值所对应的字符）。

```java
public class Main {
  public static void main(String[] args) {
    StringBuffer sb = new StringBuffer("hello java");
    sb.delete(2, 5);
    System.out.println(sb); // he java
    sb.delete(2, 5);
    System.out.println(sb); // heva
  }
}
```



#### 6、插入数据

`insert()` 方法用于将数据插入 `StringBuffer` 对象中。

```java
public class Main {
  public static void main(String[] args) {
    StringBuffer sb = new StringBuffer("hello java");
    sb.insert(3, "1234");
    System.out.println(sb); // hel1234lo java
  }
}
```



#### 7、截取数据

`substring()` 方法可以截取 `StringBuffer` 对象，返回值不在是缓冲区本身，而是一个新的**字符串**。

```java
public class Main {
  public static void main(String[] args) {
    StringBuffer sb = new StringBuffer("hello java");
    String sb1;
    sb1 = sb.substring(1, 3);
    System.out.println(sb); // hello java
    System.out.println(sb1); // el
  }
}
```



#### 8、StringBuffer 与 String 的相互转化

```java
public class Main {
  public static void main(String[] args) {
    String s1 = "java";
    System.out.println("String  " + s1); // String  java

    // 将string转成StringBuffer
    StringBuffer s2 = new StringBuffer(s1);
    System.out.println("StringBuffer " + s1); // StringBuffer java

    // 将StringBuffer转成String
    String s3 = s2.toString();
    System.out.println("String " + s3); // String java
  }
}
```



### 五、StringBuilder

在很多情况下，字符串拼接操作不需要线程安全，所以 `StringBuilder` 登场了。`StringBuilder` 是在 `JDK1.5` 中发布的，它和 `StringBuffer` 本质上没什么区别，就是去掉了保证线程安全的那部分，减少了开销。所以，在没有线程安全的需求下，优先使用 `StringBuilder` 。

在方法的使用上面，`StringBuilder` 和 `StringBuffer` 是一样的，这里就不再重复。

关于线程安全，会在后面讲到。