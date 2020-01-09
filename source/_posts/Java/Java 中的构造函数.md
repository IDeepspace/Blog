### 四、构造函数

#### 1、构造函数的作用

什么是构造函数呢？举个通俗的例子来理解。

宝宝在出生的时候，有的宝宝是出生后再取名字；而有的父母会在宝宝出生之前就取好名字，这样的宝宝一生下来就有名字了。

那在 `Java` 中，怎么在对象被创建的时候就给对象赋值呢？答案就是**通过构造函数对对象进行初始化**。还是以给宝宝取名字为例。

**出生后再取名字的宝宝**：

```java
public class Person {
  String name;
  int age;

  public static void main(String[] args) {
    Person person = new Person();
    System.out.println("姓名: " + person.name + ". 年龄: " + person.age); // 姓名: null. 年龄: 0
  }
}
```

**一生下来就有名字的宝宝：**

```java
public class Person {
  String name;
  int age;

  Person(String myName, int myAge) {
    name = myName;
    age = myAge;
  }

  public static void main(String[] args) {
    Person person = new Person("陈星星", 1);
    System.out.println("姓名: " + person.name + ". 年龄: " + person.age); // 姓名: 陈星星. 年龄: 1
  }
}
```

上面的代码中，`Person` 类中的 `Person()` 方法就是**构造函数**，也叫作**构造方法或者构造器**。

在类实例化的过程中自动执行的方法叫做**构造函数**，它不需要你手动调用。构造函数可以在类实例化的过程中做一些初始化的工作。

其实，每个类都有构造函数。如果没有显式地为类定义构造函数，`Java` 编译器将会为该类提供一个默认的构造函数。如：

```java
public class Person {
  String name;
  int age;

  // 编译器会默认加上
  Person() {
  }

  public static void main(String[] args) {
    Person person = new Person();
    System.out.println("姓名: " + person.name + ". 年龄: " + person.age); // 姓名: null. 年龄: 0
  }
}
```

这一点可以查看编译后的 `*.class` 文件来验证。

那构造函数和普通函数有什么区别呢？什么样的函数才是构造函数呢？



#### 2、构造函数与普通函数的区别

- 构造函数的**函数名要与类名**一样，而普通的函数只要符合标识符的命名规则即可；
- 一般函数是用于定义对象应该具备的功能，而构造函数定义的是，对象在在创建时，应该具备的一些内容。也就是对象的初始化内容；
- 构造函数是在对象建立时由 `jvm` 调用（不能被显示调用），给对象初始化，不需要手动调用；一般函数是对象建立后，当对象调用该功能时才会执行，需要手动调用；
- 构造函数没有返回值类型，也就是说不能有返回值。



#### 3、构造函数的重载

什么是重载？

重载：方法名字相同，而参数（参数的个数或者类型）不同，返回类型可以相同也可以不同。

**在一个类中可以定义多个构造函数，以进行不同的初始化。**比如有的孩子出生前，父母就会为他/她选择好以后要从事的职业，而有的孩子的父母会让孩子长大后自己选择喜欢的职业。看下面的例子：

```java
public class Person {
  String name;
  int age;
  String job;

  Person(String myName, int myAge) {
    name = myName;
    age = myAge;
  }

  Person(String myName, int myAge, String myJob) {
    name = myName;
    age = myAge;
    job = myJob;
  }

  public static void main(String[] args) {
    Person person1 = new Person("陈星星", 1);

    Person person2 = new Person("Deepspace", 1, "software engineer");
    System.out.println("姓名: " + person1.name + ". 年龄: " + person1.age); // 姓名: 陈星星. 年龄: 1
    System.out.println("姓名: " + person1.name + ". 年龄: " + person1.age + ". 职业: " + person2.job); // 姓名: 陈星星. 年龄: 1. 职业: software engineer
  }
}
```

多个构造函数存在于类中，是以重载的形式体现的。



#### 4、构造代码块

因为构造函数会重载，那就会有一个问题。比如：如果需要每个小孩出生都要哭的话，那就需要在不同的构造函数中都调用 `cry()` 这个方法，这就会造成代码重复的问题。怎么解决呢？—— **构造代码块。**

```java
public class Person {
  String name;
  int age;
  String job;

  // 构造代码块
  {
    cry(); // 每个 Person 对象创建出来时都会执行这里的代码
  }

  Person(String myName, int myAge) {
    name = myName;
    age = myAge;
  }

  Person(String myName, int myAge, String myJob) {
    name = myName;
    age = myAge;
    job = myJob;
  }

  public static void main(String[] args) {
    Person person1 = new Person("陈星星", 1);

    Person person2 = new Person("Deepspace", 1, "software engineer");
    System.out.println("姓名: " + person1.name + ". 年龄: " + person1.age); // 姓名: 陈星星. 年龄: 1
    System.out.println("姓名: " + person1.name + ". 年龄: " + person1.age + ". 职业: " + person2.job); // 姓名: 陈星星. 年龄: 1. 职业: software engineer
  }

  public void cry() {
    System.out.println("哇哇哇....");
  }
}
```

构造代码块的作用就是将所有构造方法中公共的信息进行抽取，用一对花括号包裹起来，每次创建对象时，构造代码块会给所有对象进行统一初始化。