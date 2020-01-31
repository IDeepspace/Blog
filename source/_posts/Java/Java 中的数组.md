---
title: Java 中的 数组
author: Deepspace
tags:
  - Java
categories: Java
date: 2017-06-29
urlname: java-array
---

## Java 中的数组

在 `Java` 中，数组（`array`）是一种**引用数据类型**，它是一种最简单的复合数据类型，是**有序数据的集合**。数组中的每个元素具有**相同的数据类型**，可以用一个统一的数组名和不同的下标来确定数组中唯一的元素。

根据数组的维度，可以将其分为一维数组、二维数组和多维数组等。



### 一、数组的定义

Java 中定义数组的语法有两种：

```java
type arrayName[];
type[] arrayName;
```

- `type` 为 `Java` 中的任意数据类型，包括基本类型和引用类型；这里要注意：声明数组就是要告诉计算机该数组中数据的类型是什么；
- `arrayName` 为数组名，必须是一个合法的标识符；
- `[]` 指明该变量是一个数组类型变量。

这两种形式没有区别，使用效果完全一样。

与 `C`、`C++` 不同，`Java` 在定义数组时，**只是得到了一个存放数组的变量，并没有为数组元素分配内存空间，不能使用。**

 `[]` 中不可以指定数组元素的个数（即数组长度），如果指定是会报错的，这种方式并不能为数组元素分配内存空间。

```java
int score[10]; // error
```

一定要记住：**必须要为数组分配内存空间，这样数组的每一个元素才有一个空间进行存储。**

分配内存空间需要使用 `new` 操作符：

```java
int[] arr; // 定义一个int数组变量arr
arr = new int[3]; // 为int数组变量arr指定数组元素个数为3，也就是分配内存空间
```

或者：

```java
int[] arr = new int[3]; // 这样等于是在定义int数组变量的时候，为其分配内存空间。
```

这里要注意，在 `Java` 中，数组一旦创建，其存储空间的大小是无法改变的。



### 二、数组的初始化

为数组分配完内存之后，还需要对数组赋初始值，即初始化。

> 其实，不管以哪种方式来初始化数组，只要为数组元素分配了内存空间，数组元素就具有了初始值。初始值的获得有两种形式，一种由系统自动分配，另一种由程序员指定。

在 `Java` 中，初始化数组有以下 `3` 种方式。

#### 1、动态初始化

```java
float floatArray[] = new float[3];
floatArray[0] = 1.0f;
floatArray[1] = 132.63f;
floatArray[2] = 100F;
```

使用 `new` 操作符创建数组，在创建时指定数组的大小。创建数组之后，元素的值并不确定，需要为每一个数组的元素进行赋值，其下标从 `0` 开始。

**注意**：不要在进行数组初始化时，既指定数组的长度，又为每个数组元素分配初始值，这样会报错。

```java
float floatArray[3] = new float[3]; // error
```



#### 2、静态初始化

在声明数组的同时，为数组元素分配内存并进行初始化，这种方式叫作**静态初始化**。

```java
int intArray[] = {1, 2, 3, 4};
String stringArray[] = {"Java", "OOP", "Array"}; 
```

使用这种方式时，数组的声明和初始化操作**要同步**，像下面这样就是错误的：

```java
int intArray[];
intArray = {1, 2, 3, 4}; // error
```



#### 3、默认初始化

使用 `new` 关键字创建数组，同时为数组中的元素赋值，完成初始化操作。

```java
int[] a = new int[]{1, 2, 3};
```

这里 `new` 不需要指定数组的长度，数组长度由其后的初始化操作确定，这个动作是**默认**的。



### 三、多维数组

#### 1、二维数组

在 `Java` 中二维数组被看作数组的数组，即二维数组为一个特殊的一维数组，其每个元素又是一个一维数组。

有下面三种方式可以初始化二维数组。

```java
int[][] temp1 = new int[][]{{1, 2}, {3, 4}}; // 在定义时初始化
int[][] temp2 = new int[2][2]; // 给定空间，再赋值
int[][] temp3 = new int[2][]; // 数组第二维长度为空，可变化
```

下面看几个操作二维数组的例子。

**获取单个元素**

```java
public class Main {
  public static void main(String[] args) {
    double[][] class_score = {{10.0, 99, 99}, {100, 98, 97}, {100, 100, 99.5}, {99.5, 99, 98.5}};
    System.out.println("第二行第二列元素的值：" + class_score[1][1]);
    System.out.println("第四行第三列元素的值：" + class_score[3][2]);
  }
}
```

**获取整行元素**

```java
import java.util.Scanner;

public class Main {
  public static void main(String[] args) {
    double[][] class_score = {{100, 99, 99}, {100, 98, 97}, {100, 100, 99.5}, {99.5, 99, 98.5}};
    Scanner scan = new Scanner(System.in);
    System.out.println("当前数组只有" + class_score.length + "行，您想查看第几行的元素？请输入：");
    int number = scan.nextInt();
    for (int i = 0; i < class_score[number - 1].length; i++) {
      System.out.println("第" + number + "行的第[" + i + "]个元素的值是：" + class_score[number - 1][i]);
    }
  }
}
```

**获取整列元素**

```java
import java.util.Scanner;

public class Main {
  public static void main(String[] args) {
    double[][] class_score = {{100, 99, 99}, {100, 98, 97}, {100, 100, 99.5}, {99.5, 99, 98.5}};
    Scanner scan = new Scanner(System.in);
    System.out.println("您要获取哪一列的值？请输入：");
    int number = scan.nextInt();
    for (int i = 0; i < class_score.length; i++) {
      System.out.println("第 " + (i + 1) + " 行的第[" + number + "]个元素的值是" + class_score[i][number-1]);
    }
  }
}
```

**获取全部元素**

```java
public class Main {
  public static void main(String[] args) {
    double[][] class_score = {{100, 99, 99}, {100, 98, 97}, {100, 100, 99.5}, {99.5, 99, 98.5}};
    for (int i = 0; i < class_score.length; i++) { // 遍历行
      for (int j = 0; j < class_score[i].length; j++) {
        System.out.println("class_score[" + i + "][" + j + "]=" + class_score[i][j]);
      }
    }
  }
}
```



#### 2、更多维数组

多维数组的声明、初始化和使用都与二维数组相似。以三维数组为例，可以将三维数组理解为一个一维数组，其内容的每个元素都是二维数组。依此类推，可以获取任意维数的数组。



### 三、Arrays 工具类

`Arrays` 类是一个 `JDK` 提供的专门用于操作数组的工具类，其中包含了数组操作的很多方法，位于 `java.util` 包中。这个 `Arrays` 类里均为 `static` 修饰的方法，所以可以直接**通过类名调用**。

下面介绍一些 `Arrays` 类的常用方法。

#### 1、数组比较

数组相等的条件不仅要求数组元素的**个数必须相等**，而且要求**对应位置的元素也相等**。`Arrays` 类提供了 `equals()` 方法比较整个数组。

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    String[] str1 = {"1", "2", "3"};
    String[] str2 = {"1", "2", new String("3")};
    System.out.println(Arrays.equals(str1, str2)); // true
  }
}
```



#### 2、数组转换字符串

```java
public class Main {
  public static void main(String[] args) {
    int[] a = {1, 2, 3};
    System.out.println(a); // 打印出的是hashcode码
    System.out.println(Arrays.toString(a)); // 打印出的是数组[1, 2, 3]
  }
}
```



#### 3、数组的排序

`Arrays` 类中的 `sort()` 方法可以对数组进行升序：

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    int[] score = {79, 65, 93, 64, 88};
    Arrays.sort(score);
    String str = Arrays.toString(score);
    System.out.println(str); // [64, 65, 79, 88, 93]
  }
}
```

如果想要进行降序排序呢？有两种方法。

**利用 `Collections.reverseOrder()` 方法：**

```java
import java.util.Arrays;
import java.util.Collections;

public class Main {
  public static void main(String[] args) {
    Integer[] score = {79, 65, 93, 64, 88};
    Arrays.sort(score, Collections.reverseOrder());
    String str = Arrays.toString(score);
    System.out.println(str); // [93, 88, 79, 65, 64]
  }
}
```

**实现 `Comparator` 接口的复写 `compare()` 方法：**

```java
import java.util.Comparator;

class MyComparator implements Comparator<Integer> {
  @Override
  public int compare(Integer o1, Integer o2) {
    return o2 - o1;
  }
}


import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    Integer[] score = {79, 65, 93, 64, 88};
    Arrays.sort(score, new MyComparator());
    String str = Arrays.toString(score);
    System.out.println(str); // [93, 88, 79, 65, 64]
  }
}
```

注意：使用以上两种方法时，**数组必须是包装类型**，否则会编译不通过。



#### 4、数组填充

`Arrays` 类提供了一个 `fill()` 方法，可以在指定位置进行数值填充。`fill()` 方法虽然可以填充数组，但是它的功能有限制，只能把数组中的所有元素替换成一个值。

```java
public class Main {
  public static void main(String[] args) {
    int[] num = {1, 2, 3};
    Arrays.fill(num, 6);
    System.out.println(Arrays.toString(num)); // [6, 6, 6]
  }
}
```



#### 5、查找元素

使用 `Arrays` 类的 `binarySearch()` 方法可以实现数组的查找，该方法返回要搜索元素的索引值。

```java
public class Main {
  public static void main(String[] args) {
    char[] a = {'a', 'b', 'c', 'd', 'e'};
    int i = Arrays.binarySearch(a, 'd');
    System.out.println(i); // 3

    char[] b = {'e', 'a', 'c', 'b', 'd'};
    Arrays.sort(b);
    int j = Arrays.binarySearch(b, 'e');
    System.out.println(j); // 4
  }
}
```



#### 6、数组的拷贝

在 `Java` 中实现数组拷贝分别有以下 `4` 种方法：

- `Arrays` 类的 `copyOf()` 方法

- `Arrays` 类的 `copyOfRange()` 方法

- `System` 类的 `arraycopy()` 方法

- `Object` 类的 `clone()` 方法

**1）、`copyOf()` 方法是从数组的第一个元素开始，拷贝至指定长度。**

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    int[] scores = new int[]{57, 81, 68, 75, 91};
    System.out.println(Arrays.toString(scores)); // [57, 81, 68, 75, 91]

    int[] newScores = Arrays.copyOf(scores, 5);
    System.out.println(Arrays.toString(newScores)); // [57, 81, 68, 75, 91]

    System.out.println(scores == newScores); // false
    System.out.println(Arrays.equals(scores, newScores)); // true
  }
}
```

在拷贝的同时，也可以增加新数组的内存空间，供以后使用：

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    int[] scores = new int[]{57, 81, 68, 75, 91};
    int[] newScores = (int[])Arrays.copyOf(scores,8);
    System.out.println(Arrays.toString(newScores)); // [57, 81, 68, 75, 91, 0, 0, 0]
    newScores[5] = 100;
    newScores[6] = 200;
    newScores[7] = 300;
    System.out.println(Arrays.toString(newScores)); // [57, 81, 68, 75, 91, 100, 200, 300]
  }
}
```



**2）、`copyOfRange()` 方法则将指定数组的指定长度复制到一个新数组中。**

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    int[] scores = new int[] { 57, 81, 68, 75, 91, 66, 75, 84 };
    int[] newScores = (int[]) Arrays.copyOfRange(scores, 0, 5);
    System.out.println(Arrays.toString(newScores)); // [57, 81, 68, 75, 91]
  }
}
```

`copyOfRange()` 方法也是深拷贝。



**3）、arraycopy() 方法**

`arraycopy()` 方法位于 `java.lang.System` 类中，语法如下：

```java
System.arraycopy(dataType[] srcArray,int srcIndex,int destArray,int destIndex,int length)
```

- `srcArray` 表示原数组；

- `srcIndex` 表示原数组中的起始索引；
- `destArray` 表示目标数组；
- `destIndex` 表示目标数组中的起始索引；
- `length` 表示要复制的数组长度。

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    // 原数组，长度为8
    int[] scores = new int[]{100, 81, 68, 75, 91, 66, 75, 100};

    // 目标数组
    int[] newScores = new int[]{80, 82, 71, 92, 68, 71, 87, 88, 81, 79, 90, 77};

    System.arraycopy(scores, 0, newScores, 2, 8);
    System.out.println(Arrays.toString(newScores));
  }
}
```

相当于替换目标数组中的部分元素。

**注意**：使用此方法复制数组时，`length+srcIndex` 必须小于等于 `srcArray.length`，同时 `length+destIndex` 必须小于等于 `destArray.length`。



**4）、clone() 方法**

`clone()` 方法也可以实现复制数组。该方法是类 `Object` 中的方法，可以创建一个有单独内存空间的对象。因为数组也是一个 `Object` 类，因此也可以使用数组对象的 `clone()` 方法来复制数组。

```java
import java.util.Arrays;

public class Main {
  public static void main(String[] args) {
    int[] scores = new int[]{100, 81, 68, 75, 91, 66, 75, 100};

    int[] newScores = (int[]) scores.clone();

    System.out.println(Arrays.toString(newScores)); // [100, 81, 68, 75, 91, 66, 75, 100]
  }
}
```

这里需要特别注意：数组的拷贝是浅拷贝，对于基本类型可以，对于引用类型是不适合的。

