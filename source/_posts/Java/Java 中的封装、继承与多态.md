---
title: Java 中的封装、继承与多态
author: Deepspace
tags:
  - 封装
  - 继承
  - 多态
categories: Java
date: 2017-06-29
urlname: java-encapsulation-inheritance-polymorphism
---

在前面的[《`Java` — 面向对象的编程语言》](https://togoblog.cn/java-oop-language/)里，介绍了面向对象的三大特征：封装、继承、多态，主要是概念上的讲解，本篇文章将从代码出发，看看 `Java` 中的封装、继承与多态。



### 一、封装

在编程时，把数据（属性）和有关属性的一些操作（方法）绑定在一起，形成一个不可分开的集合（类），这个过程就是封装（`Encapsulation`）。

封装时，我们需要隐藏对象的属性和实现细节，仅对外公开接口，并控制在程序中属性的读和写的**访问级别**。
<!-- more -->
一般情况下，我们会把所有的属性都**私有化**，对每个属性提供 `getter` （读） 和 `setter`（写） 方法，供外界使用：

```java
public class Person {
  private String name;
  private int age;

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
}

public class Me {
  public static void main(String[] args) {
    Person person = new Person();
    person.setName("Deepspace");
    person.setAge(24);
    System.out.println(person.getName()); // Deepspace
    System.out.println(person.getAge()); // 24
  }
}
```

当然这只是一个很基础的封装，如果想封装出一个好的程序，还得多花很多心思。

#### 1、构造函数

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
    person.name = "陈星星";
    person.age = 1;
    System.out.println("姓名: " + person.name + ". 年龄: " + person.age); // 姓名: 陈星星. 年龄: 1
  }
}
```

**一生下来就有名字的宝宝：**

```java
public class Person {
  String name;
  int age;

  Person(String myName, int myAge) {
    this.name = myName;
    this.age = myAge;
  }

  public static void main(String[] args) {
    Person person = new Person("陈星星", 1);
    System.out.println("姓名: " + person.name + ". 年龄: " + person.age); // 姓名: 陈星星. 年龄: 1
  }
}
```

上面的代码中，`Person` 类中的 `Person()` 方法就是**构造函数**，也叫作**构造方法或者构造器**。

构造函数在类实例化的过程中自动执行，不需要手动调用。构造函数可以在类实例化的过程中做一些初始化的工作。

其实，每个类都有构造函数。如果没有显式地为类定义构造函数，**`Java` 编译器将会为该类提供一个默认的构造函数。**如：

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



#### 2、构造函数与普通函数的区别

那构造函数和普通函数有什么区别呢？

- 构造函数的**函数名要与类名**一样，而普通的函数只要符合标识符的命名规则即可；
- 一般函数是用于定义对象应该具备的功能，而构造函数定义的是，对象在在创建时，应该具备的一些内容。也就是**对象的初始化内容**；
- 构造函数是在对象建立时由 `jvm` 调用（不能被显示调用），用作对象初始化，不需要手动调用；而一般函数是对象建立后，当对象调用该功能时才会执行，需要手动调用；
- 构造函数没有返回值类型，也就是说不能有返回值。



#### 3、重载

什么是重载呢？

重载（`Overloading`）：方法名字相同，而参数（参数的个数或者类型）不同，返回类型可以相同也可以不同。

**为什么会出现重载？**

在大多数程序设计语言中要求**为每个方法提供唯一的标识符**。如：不能使用 `add ()` 的函数计算整数相加的和之后，又用一个名为 `add()` 的函数去计算浮点数的和，即每个函数（方法）都要有唯一的名称，但是我们又觉得 `add()` 这个方法名非常适合，不想更换。

若是 `add()` 函数可以被重载了，那么就既可以计算整数也可以计算浮点数。所以我们可以这样设计方法为：

```java
int add(int a, int b)
```

调用 `add(10,10)` 我们就可以知道是计算两个整数相加。此时，我们又想计算两个浮点数相加，如果想继续使用 `add` 这个方法名，那就将 `add()` 方法重载：

```java
double add(double a, double c)
```

**这是重载出现的一个原因。**

在 `Java` 里，**构造函数（也说构造器、构造方法）是强制重载方法出现的另一个原因。**构造函数的名字由类名决定，那么就只能有一个构造函数。但是，又想使用**多种方式用于初始化对象**该怎么办呢？那么就只有**重载构造函数，使得同名不同参的构造函数同时存在。**



#### 4、构造函数的重载

**通过重载，在一个类中可以定义多个构造函数，以进行不同的初始化。**比如有的孩子出生前，父母就会为他/她选择好以后要从事的职业，而有的孩子的父母会让孩子长大后自己选择喜欢的职业。看下面的例子：

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
    Person person1 = new Person("陈星星", 1); // 哇哇哇....
    Person person2 = new Person("Deepspace", 1, "software engineer"); // 哇哇哇....

    System.out.println("姓名: " + person1.name + ". 年龄: " + person1.age); // 姓名: 陈星星. 年龄: 1
    System.out.println("姓名: " + person1.name + ". 年龄: " + person1.age + ". 职业: " + person2.job); // 姓名: 陈星星. 年龄: 1. 职业: software engineer
  }

  public void cry() {
    System.out.println("哇哇哇....");
  }
}
```

构造代码块的作用就是将所有构造方法中公共的信息进行抽取，用一对花括号包裹起来，**每次创建对象时，构造代码块会对所有对象进行统一初始化。**



### 二、继承

我们先看看没有继承的时候，会怎样写代码。

以学生类和老师类为例，学生和老师都会吃饭、睡觉，如果没有继承，代码是这样的：

```java
class Teacher {
  public void eat() {
    System.out.println("吃饭");
  }

  public void sleep() {
    System.out.println("睡觉");
  }
}

class Student {
  public void eat() {
    System.out.println("吃饭");
  }

  public void sleep() {
    System.out.println("睡觉");
  }
}
```

分别定义了 `Teacher` 类和 `Student` 类，吃饭和睡觉是学生和老师共有的行为，但是却写了两遍；并且，如果需要给 `Teacher` 类和 `Student` 类再添加一个 `walk` 方法，则需要给两个类都分别添加，没有一点的复用性可言，随着逻辑变得复杂，代码的可维护性也会变差。

有了继承，上面的问题就很好解决了。



#### 1、extends

`Java` 通过 `extends` 关键字来实现继承。

学生和老师都是人类，人类都要吃饭和睡觉。所以我们可以提取一个叫作 `Person` 的类：

```java
public class Person {
  public void eat() {
    System.out.println("吃饭");
  }

  public void sleep() {
    System.out.println("睡觉");
  }
}
```

然后让 `Student` 类和 `Teacher` 类都继承 `Person` 类：

```java
class Teacher extends Person {
}

class Student extends Person {
}

public class Main {
  public static void main(String[] args) {
    Student s = new Student();
    s.eat(); // 吃饭
    s.sleep(); // 睡觉

    System.out.println("-------------");

    Teacher t = new Teacher();
    t.eat(); // 吃饭
    t.sleep(); // 睡觉
  }
}
```

这里要注意：父类中通过 `private` 修饰的变量和方法不会被继承，也就是说不能在子类中直接操作父类通过 `private` 修饰的变量以及方法。

通过继承，我们实现了下面几个好处：

- 提高了代码的复用性
  - 多个类相同的成员可以放到同一个类中
- 提高了代码的维护性
  - 如果功能的代码需要修改，修改一处即可
- 让类与类之间产生了关系（是多态的前提）

但是继承也带来了一些弊端：

- 类的耦合性很强，打破了封装性
  - `Person` 类发生了更改或者出现了错误，`Teacher` 类和 `Student` 类就无法正常工作了。

所以，我们在编程的时候，需要**优先考虑组合，谨慎使用继承**。



#### 2、单继承、多层继承

`Java` 只支持单继承，不支持多继承。也就是说一个类只能有一个父类，不可以有多个父类。

```java
class SubDemo extends Demo {} // ok

class SubDemo extends Demo1,Demo2 … // error
```

但是 `Java` 支持多层继承（单链条）：

```java
class A {}
class B extends A {}
class C extends B {}
```



#### 3、继承中成员变量之间的关系

继承时，如果子类中的成员变量和父类中的成员变量名称不一样，那就很好办，没有任何问题发生；如果子类中的成员变量和父类中的成员变量名称一样，会发生什么呢？看段代码：

```java
class Father {
  public int num = 10;
  public int num4 = 90;

  public void method() {
    int num = 50;
  }
}

class Son extends Father {
  public int num2 = 20;
  public int num = 30;

  public void show() {
    int num = 40;
    System.out.println(num); // 40
    System.out.println(num2); // 20
    // 找不到，报错
    //System.out.println(num3);
  }
}

public class ExtendsDemo {
  public static void main(String[] args) {
    // 创建对象
    Son s = new Son();
    s.show();
    System.out.println(s.num); // 30
    System.out.println(s.num4); // 90
  }
}
```

所以，在子类方法中访问一个变量的查找顺序是：

- 在子类方法的局部范围找，有就使用；
- 在子类的成员范围找，有就使用；
- 在父类的成员范围找，有就使用；
- 如果还找不到，就报错。



#### 2、重写

为什么会出现重写（`Overriding`）呢？看下面的例子：

```java
class Animal {
  public void printWhoIAm() {
    System.out.println("Animal");
  }
}

public class Dog extends Animal {
  public static void main(String[] args) {
    Dog dog = new Dog();
    dog.printWhoIAm(); // Animal
  }
}
```

继承时，当 `dog` 调用 `printWhoIAm()` 方法时，其实希望的是输出 `dog`，而不是 `Animal`。要实现输出 `Dog`，该怎么办？

想到了重载，可是重载要求被重载的方法具有不同的形参列表，所以这个方法行不通。

代码中，`dog` 调用的 `printWhoIAm()` 是父类中的，在子类中如果可以重写这个方法，那么就可以实现目的了。于是，重写（覆写）便产生了。

**重写可以解决父类方法在子类中不适用的问题 —— 让子类重写父类的方法。**我们用重写解决上面的问题：

```java
class Animal {
  public void printWhoIAm() {
    System.out.println("Animal");
  }
}

public class Dog extends Animal {
  public static void main(String[] args) {
    Dog dog = new Dog();
    dog.printWhoIAm(); // Dog
  }

  @Override
  public void printWhoIAm() {
    System.out.println("Dog");
  }
}
```

> `@Override` 是伪代码,表示重写(当然不写也可以)，不过写上有如下好处：
>
> 1. 可以当注释用，方便阅读；
> 2. 编译器可以验证 `@Override` 下面的方法名是否是父类中所有的，如果没有则报错；
> 3. 如果没写 `@Override`，而下面的方法名又不是父类中的方法，这时编译器是可以编译通过的，因为编译器会认为这个方法是子类中自己增加的方法。
>
> 所以，为了避免发生错误，我们在重写时，需要加上 `@override`。

这里需要特别注意：**如果重写时，子类中的方法和父类中方法，返回值类型不一致的时候，则会发生报错。**

另外，子类中的方法和父类中方法的参数不一致，则并不会发生重写：

```java
class Animal {
  private String name;

  public void setName(String name) {
    this.name = name;
  }

  public String getName(String hello) {
    return this.name + hello;
  }
}

class Dog extends Animal {
  public String getName() {
    return "123";
  }
}

public class App {
  public static void main(String[] args) {
    Dog dog = new Dog();
    dog.setName("小黄");
    System.out.println(dog.getName("hello"));
  }
}
```

可以看到，在 `App` 这个类中，当我们给 `getName` 传递参数时，执行的是 `Animal` 中的方法，而非 `Dog` 中的 `getName` 方法。也就是说如果参数不一致最后执行的就不是重写的那个方法。

重写时也**不可以将父类公开的方法或变量改成私有**（如将 `public` 改成 `private` ），否则也会报错。也就是说重写的时候，方法的访问控制权限不能比父类更严格。



#### 3、super

重写可以解决父类方法在子类不适用的问题，但是会有另外一个问题：子类若是重写了父类的方法，那么父类原来的这个方法还可以被调用吗？答案是可以的。**可以使用 `super` 关键字**。看下面的例子：

```java
class Animal {
  public void printWhoIAm() {
    System.out.println("Animal");
  }
}

public class Dog extends Animal {
  public static void main(String[] args) {
    Dog dog = new Dog();
    dog.print();
  }

  public void print() {
    super.printWhoIAm(); // Animal
    printWhoIAm(); // Dog，这里也可以使用 this.printWhoIAm();
  }

  @Override
  public void printWhoIAm() {
    System.out.println("Dog");
  }
}
```

`super` 代表父类存储空间的标识，可以理解为父类引用，可以操作父类的成员。

访问父类中的属性也是一样的：

```java
public class Animal {
  public String name;
}

public class Cat extends Animal {
  private String name;

  public Cat(String aname, String dname) {
    super.name = aname;    // 通过 super 关键字来访问父类中的 name 属性
    this.name = dname;    // 通过 this 关键字来访问本类中的 name 属性
  }

  public static void main(String[] args) {
    Animal cat = new Cat("动物", "喵星人");
    System.out.println(cat); // 我是动物，我的名字叫喵星人
  }

  @override
  public String toString() {
    return "我是" + super.name + "，我的名字叫" + this.name;
  }
}
```



**使用 `super` 调用父类的构造函数**

既然是父类的引用，那父类里的构造函数，自然也是可以通过 `super` 来调用的：

```java
class Person {
  private String name;
  private int age;
  private String sex;

  Person(String name, int age, String sex) {
    this.name = name;
    this.age = age;
    this.sex = sex;
  }

  public Person(String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }

  public int getAge() {
    return age;
  }

  public void setAge(int age) {
    this.age = age;
  }

  public String getSex() {
    return sex;
  }

  public void setSex(String sex) {
    this.sex = sex;
  }
}

class Student extends Person {
  private String stuNo;
  private String department;

  Student(String name, String stuNo) {
    super(name);    // 调用父类中含有一个参数的构造函数
    this.stuNo = stuNo;
  }

  Student(String name, int age, String sex, String stuno, String department) {
    super(name, age, sex);    // 调用父类中含有三个参数的构造函数
    this.stuNo = stuno;
    this.department = department;
  }

  public String getStuNo() {
    return stuNo;
  }

  public void setStuNo(String stuNo) {
    this.stuNo = stuNo;
  }

  public String getDepartment() {
    return department;
  }

  public void setDepartment(String department) {
    this.department = department;
  }
}

public class Main {
  public static void main(String[] args) {
    Student stu = new Student("Deepspace", "141508926");
    System.out.println(stu.getStuNo()); // 141508926
    System.out.println(stu.getName()); // Deepspace

    Student stu1 = new Student("chenxingxing", 23, "Male", "141508927", "Sales");
    System.out.println(stu1.getStuNo()); // 141508927
    System.out.println(stu1.getDepartment()); // Sales
    System.out.println(stu1.getAge()); // 23
    System.out.println(stu1.getSex()); // Male
  }
}
```

从上面的代码可以看出，使用 `super` 直接调用父类中的构造函数，可以使书写代码更简洁方便。

**在继承中使用构造函数时需要注意：**

**子类中所有的构造函数默认都会访问父类中空参数的构造函数。**因为子类继承父类之后，获取到了父类的内容（属性/字段），而这些内容在使用之前必须先初始化，所以**子类初始化之前，一定要先调用父类的构造函数完成父类数据的初始化**。可以用下面的代码来验证：

```java
class Father {
  int age;

  public Father() {
    System.out.println("Father 的无参构造方法");
  }

  public Father(String name) {
    System.out.println("Father 的带参构造方法");
  }
}

class Son extends Father {
  public Son() {
    //super();
    System.out.println("Son 的无参构造方法");
  }

  public Son(String name) {
    //super();
    System.out.println("Son 的带参构造方法");
  }
}

public class ExtendsDemo {
  public static void main(String[] args) {
    Son s = new Son();
    System.out.println("------------");
    Son s2 = new Son("孩子");
  }
}
```

运行结果为：

```
Father 的无参构造方法
Son 的无参构造方法
------------
Father 的无参构造方法
Son 的带参构造方法
```

如果父类没有无参构造方法，那么子类的构造方法会出现什么现象呢？直接报错了，父类无法完成初始化。**也就是说子类中一定要有一个去访问了父类的构造方法，否则父类数据就没有初始化。**

有下面几种方式解决：

- 在父类中加一个无参构造方法，必须显式定义；
- 通过使用 `super` 关键字去显示的调用父类的带参构造方法；
- 子类通过 `this` 去调用本类的其他构造方法（前提是子类这个构造方法满足了前面两者其一）；

代码如下：

```java
class Father {
  int age;

//  public Father() {
//    System.out.println("Father 的无参构造方法");
//  }

  public Father(String name) {
    System.out.println("Father 的带参构造方法");
  }
}

class Son extends Father {
  public Son() {
    super("Deepspace");
    System.out.println("Son 的无参构造方法");
  }

  public Son(String name) {
    this();
    System.out.println("Son 的带参构造方法");
  }

  public Son(String name, int age) {
    this("Deepspace");
    System.out.println("Son 的带参构造方法-1");
  }
}
```

这里要注意：**调用父类构造函数调用代码必须放在子类构造函数中的第一行**！目的是在初始化当前对象时，先保证了父类对象先初始化，防止异常。

同时，同一个构造函数里面，是不能够同时出现 `super()` 和 `this()` 的，会发生冲突。



#### 4、this

很多时候，初学者会把 `Java` 中的 `super` 和 `this` 混淆，这里也介绍下它们两个的区别。

当一个对象创建后，`JVM` 就会给这个对象分配一个引用自己的指针，这个指针就是 `this`。所以，`this` 只能用在**非静态**方法中。

`this` 的主要用途有下面三种。

**`this.<属性名>` ：**

大部分时候，一个方法访问其他方法、成员变量时，无须使用 `this` 前缀；但如果方法里有个**局部变量和成员变量同名**，则必须使用 `this` 前缀。

```java
public class Teacher {
  private String name;

  public Teacher(String name) {
    this.name = name; // 这里就需要使用到 this 来访问成员变量
  }

  public static void main(String[] args) {
    Teacher teacher = new Teacher("Deepspace");
    System.out.println(teacher.name); // Deepspace
  }
}
```



**`this.<方法名>` ：**

`this` 关键字最大的作用就是让类中一个方法，访问该类里的另一个方法或成员变量。

```java
package packageOne;

public class Teacher {
  private String name;

  public Teacher(String name) {
    this.name = name; // 这里就需要使用到 this 来访问成员变量
  }

  public static void main(String[] args) {
    Teacher teacher = new Teacher("Deepspace");
    System.out.println(teacher.name);
    teacher.calling(); // I am teaching
  }

  public void calling() {
    this.teaching(); // 通过 this 调用其他方法，this 可以省略
  }

  private void teaching() {
    System.out.println("I am teaching");
  }
}
```

虽然可以省略调用 `teaching()` 方法之前的 `this`，但实际上这个 `this` 依然是存在的。

**注意**：对于 `static` 修饰的方法而言，可以使用类来直接调用该方法；如果在 `static` 修饰的方法中使用 `this` 关键字，此时 `this` 就无法指向合适的对象。**所以，`static` 修饰的方法中不能使用 `this` 。并且 `Java` 语法规定，静态成员不能直接访问非静态成员。**



**`this` 访问构造方法：**

`this()` 用来访问本类的构造函数，如果括号内有参数，就是调用指定的有参构造函数。

```java
public class Student {
  String name;

  // 无参构造方法（没有参数的构造方法）
  public Student() {
    this("张三");
  }

  // 有参构造方法
  public Student(String name) {
    this.name = name;
  }

  public static void main(String[] args) {
    Student stu = new Student();
    stu.print();
  }

  // 输出 name 和 age
  public void print() {
    System.out.println("姓名：" + name); // 姓名：张三
  }
}
```

**注意：**

- `this()` 不能在普通方法中使用，只能写在构造函数中；
- 在构造函数中使用时，必须是第一条语句。



### 三、多态

先看看抽象类和接口这两个概念。

#### 1、抽象类和抽象方法

被 `abstract` 修饰的方法称为**抽象方法**，修饰的类称为**抽象类**。

抽象方法是一种特殊的方法：**它只有声明，而没有具体的实现**，该方法的的具体实现**由子类提供**。抽象方法的声明格式为：

```java
abstract void fun();
```

抽象方法必须用 `abstract` 关键字进行修饰。

如果一个类含有抽象方法，则称这个类为**抽象类**，抽象类必须在类前用 `abstract` 关键字修饰。

> 在《 `Java` 编程思想》一书中，将抽象类定义为 **包含抽象方法的类**，但是后面发现如果一个类不包含抽象方法，只是用 `abstract` 修饰的话也是抽象类。也就是说抽象类不一定必须含有抽象方法。这个问题其实并不冲突，如果一个抽象类不包含任何抽象方法，为何还要设计为抽象类？所以抽象类这个概念（包含抽象方法的类）是没有问题。

由于抽象类中含有无具体实现的方法（抽象方法），所以**不能用抽象类创建对象**。

因此，**抽象类就是为了继承而存在的**。如果定义了一个抽象类，却不去继承它，那么等于白白创建了这个抽象类，不能用它来做任何事情。



**什么时候要用到抽象类？**

对于一个父类，如果它的某个方法在类中实现出来没有任何意义，**必须根据子类的实际需求来进行不同的实现**，那么就可以将这个方法声明为 `abstract` 方法，此时这个类也就成为 `abstract` 类了。

包含抽象方法的类称为抽象类，但并不意味着抽象类中只能有抽象方法，它和普通类一样，**同样可以拥有成员变量和普通的成员方法。**

看个完整的例子：

```java
abstract class Person {
  private String name;
  private int age;

  public Person(String name, int age) {
    this.name = name;
    this.age = age;
  }

  public String getName() {
    return this.name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getAge() {
    return this.age;
  }

  public void setAge(int age) {
    this.age = age;
  }

  public abstract String getInfo(); // 抽象方法，父类实现没有意义，所以把父类变成了抽象类
};

class Student extends Person {
  private String school;

  public Student(String name, int age, String school) {
    super(name, age);    // 指定要调用抽象类中有两个参数的构造方法
    this.school = school;
  }

  public String getInfo() {
    return "姓名：" + super.getName() + "；年龄：" + super.getAge() + "；学校：" + this.getSchool();
  }

  public String getSchool() {
    return school;
  }

  public void setSchool(String school) {
    this.school = school;
  }
};

public class Main {
  public static void main(String[] args) {
    Student stu = new Student("张三", 30, "清华大学");
    System.out.println(stu.getInfo());
  }
}
```



#### 2、接口 

接口是一种引用类型，和类很相似。接口是功能的集合，同样可看作是一种数据类型，是比抽象类更为抽象的 **”类”**。

**1）接口的定义**

与定义类的 `class` 关键字不同，定义接口时需要使用 `interface` 关键字。定义接口所在的文件格式仍为 `.java` 文件，编译后仍然会产生 `.class` 文件。这点可以让我们将接口看作是一种**只包含了功能声明的特殊类**。

**接口中只描述所应该具备的方法，并没有具体实现，具体的实现由接口的实现类（相当于接口的子类）来完成。**这样将功能的定义与实现分离，优化了程序设计。

一个简单的接口：

```java
public interface USB {
  String name = "USB";

  public String getName();
}
```



**2）接口和类的区别**

但是，在接口中声明的变量和方法做了许多限制，这点和类大不相同：

- 具有 `public` 访问控制符的接口，允许任何类使用；没有指定 `public` 的接口，其访问将局限于所属的包；
- 接口中无法定义普通的成员变量，接口中声明的变量其实**都是常量**，接口中的变量声明，将隐式地声明为 `public`、`static` 和 `final`，即常量，所以接口中定义的变量**必须初始化**；
- 接口中声明的方法，将**隐式地声明为公有的（`public`）和抽象的（`abstract`）**；
- 接口中的方法不能设置成 `private` ，这样会导致使用该接口的类不能实现该方法；
- 接口没有构造方法，**不能被实例化**；

```java
public interface MyInterface {
  String name;    // 不合法，变量 name 必须初始化
  int age = 20;    // 合法，等同于 public static final int age = 20;

  MyInterface() {
  }

  void getInfo();    // 方法声明，等同于 public abstract void getInfo();
}
```



**3）接口的实现**

接口无法被实例化，但是可以被实现。一个实现接口的类，**必须实现接口内所描述的所有方法**，**否则该类就必须声明为抽象类。**

实现接口使用 `implements` 关键字：

```java
public interface IMath {
  int sum();    // 完成两个数的相加

  int maxNum(int a, int b);    // 获取较大的数
}

public class MathClass implements IMath {
  private int num1;    // 第 1 个操作数
  private int num2;    // 第 2 个操作数

  public MathClass(int num1, int num2) {
    // 构造方法
    this.num1 = num1;
    this.num2 = num2;
  }

  // 实现接口中的求和方法
  public int sum() {
    return num1 + num2;
  }

  // 实现接口中的获取较大数的方法
  public int maxNum(int a, int b) {
    if (a >= b) {
      return a;
    } else {
      return b;
    }
  }
}

public class NumTest {
  public static void main(String[] args) {
    // 创建实现类的对象
    MathClass calc = new MathClass(100, 300);
    System.out.println("100 和 300 相加结果是：" + calc.sum()); // 100 和 300 相加结果是：400
    System.out.println("100 比较 300，哪个大：" + calc.maxNum(100, 300)); // 100 比较 300，哪个大：300
  }
}
```

一个接口不能够实现另一个接口，但它可以**继承多个其他接口**。子接口可以对父接口的方法和常量进行重写。例如：

```java
public interface A {
  void printA();
}

public interface B {
  void printB();
}

public interface C extends A, B {
  void printC();
}

class X implements C {
  public void printA() {
    System.out.println("A、Hello World!!!");
  }

  public void printB() {
    System.out.println("B、Hello Java");
  }

  public void printC() {
    System.out.println("C、Hello OOP");
  }
}

public class Main {
  public static void main(String[] args) {
    X x = new X();
    x.printA(); // A、Hello World!!!
    x.printB(); // B、Hello Java
    x.printC(); // C、Hello OOP
  }
}
```



**接口的默认实现**

从 `JDK1.8` 开始，接口的方法可以有默认实现了，而且不需要实现类去实现其方法，这样的方法称为默认方法。

**为什么要有这个新特性呢？**

当需求变化，需要修改接口时候，那就要修改全部实现该接口的类，没办法在修改的同时不影响已有的实现，所以就引进了默认方法。

有了接口的默认实现，这样子类对于该方法就不需要强制来实现，可以选择使用默认的实现，也可以重写自己的实现。当为接口扩展方法时，只需要提供该方法的默认实现即可，至于对应的实现类可以重写也可以使用默认的实现，这样所有的实现类就不会报语法错误了。

```java
public interface InterfaceA {
  default String getName() {
    return "a";
  }
}
```

使用 `default` 修饰符，可以实现添加接口的默认实现。接口的默认实现也使得接口的功能跟抽象类更为接近。



**"多继承接口"**

虽然 `Java` 不支持多继承，但是一个类也可以同时实现多个接口。我么先看下面的例子：

```java
interface InterfaceA {
  default String getName() {
    return "a";
  }
}

interface InterfaceB {
  default String getName() {
    return "b";
  }
}

public class ImpClass implements InterfaceA, InterfaceB {
  public static void main(String[] args) {
    ImpClass c = new ImpClass();
    System.out.println(c.getName()); // ab
    System.out.println(((InterfaceA) c).getName()); // ab
    System.out.println(((InterfaceB) c).getName()); // ab
  }

  @Override
  public String getName() {
    //必须提供自己的实现
    return InterfaceA.super.getName() + InterfaceB.super.getName();
  }
}
```

使用接口可以实现 "多继承" 。但是这样会造成**菱形问题**，这也是 `Java` 没有提供多继承的原因。



**菱形问题**

`Java` 语言中一个类只能继承一个父类，但是一个类可以实现多个接口。这样就造成了**菱形问题**。

什么是[【菱形问题（ `diamond problem` ）】](https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem)呢？

假设我们有一个父接口 `A`，子接口 `B` 和 `C` 都重写了 `A` 中的方法 `test()`。此时又有一个 `D` 接口，同时继承了 `B` 和 `C`，那么当 `D` 调用 `test()` 时，继承的是哪个父接口的方法呢？如果没有给出进一步的说明，编译器是无法给出答案的。如图所示：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/multiple-inheritance-diamond.png" alt="multiple-inheritance-diamond" style="zoom:70%;" />

为了解决这个问题，实现类必须**显示地指定要使用的方法**，当然也可以重写共享方法并提供自己的实现。

```java
interface InterfaceA {
  default String getName() {
    return "a";
  }
}

interface InterfaceB extends InterfaceA {
  default String getName() {
    return "b";
  }
}

interface InterfaceC extends InterfaceA {
  default String getName() {
    return "c";
  }
}

public class ImpClass implements InterfaceB, InterfaceC {
  public static void main(String[] args) {
    ImpClass c = new ImpClass();
    System.out.println(c.getName()); // bc
    System.out.println(((InterfaceA) c).getName()); // bc
    System.out.println(((InterfaceB) c).getName()); // bc
  }

  @Override
  public String getName() {
    //必须显示地指定要使用的方法
    return InterfaceB.super.getName() + InterfaceC.super.getName();
  }
}
```

`Java 8` 中引入了一种新的语法 `X.super.method()`，其中 `X` 是希望调用的 `method` 方法所在的父接口。



#### 3、多态

简单点说，**多态就是某一个事物，在不同时刻表现出来的不同状态。**比如：水在不同环境下的状态不同（液体，固体，气体）。

`Java` 中的多态分为两种：

- 编译时多态（又称静态多态）
- 运行时多态（又称动态多态）

重载就是**编译时多态**的一个例子，在编译时就知道要调用的方法是哪个，所以「编译时多态」的概念就是在编译时就已经确定。

而我们通常所说的多态指的都是**运行时多态**，也就是编译时不确定究竟调用哪个具体方法，一直到运行时才能确定。这也是为什么有时候多态方法又被称为**延迟方法**的原因。



**怎么理解运行时才能确定呢？**

一个引用变量到底会指向哪个类的实例对象，该引用变量发出的方法调用到底是哪个类中实现的方法，必须在由程序运行期间才能决定。

这样，我们不用修改源代码，就可以**让引用变量绑定到各种不同的类上，从而让该引用调用的具体方法随之改变**，让程序可以选择多个运行状态，这就是多态性。



**那要怎么让引用变量绑定到不同的类上呢？**

答案是**向上转型**。我们可以让子类 `Child` 继承父类 `Father`，然后编写一个**指向子类的父类类型引用**，也就是：

```java
Father son = new Son();
```

定义了一个对象 `son` ，它在编译时的类型是 `Father`，而实际运行时的类型是 `Son`。这样就相当于把引用变量 `son` 绑定到了两个不同的类上面 —— `Father` 类 和 `Son` 类。



`Java` 中实现多态有两种方式：

- 基于继承实现的多态
- 基于接口实现的多态

下面我们通过具体的例子继续理解多态。



**基于继承实现的多态**

```java
class Animal {
  private String name = "Animal";

  public static void barking() {
    System.out.println("Animal正在叫...");
  }

  public void eat() {
    System.out.println(name + "正在吃东西...");
    sleep();
  }

  public void sleep() {
    System.out.println(name + "正在睡觉...");
  }

  public void run() {
    System.out.println(name + "正在奔跑...");
  }
}

class Cat extends Animal {
  private String name = "Cat";

  public static void barking() {
    System.out.println("Cat正在叫...");
  }

  // 重载
  public void eat(String name) {
    System.out.println(name + "吃完了");
    sleep();
  }

  // 重写
  @Override
  public void sleep() {
    System.out.println(name + "正在睡觉");
  }

  public void catchMouse() {
    System.out.println("抓老鼠");
  }
}

public class Main {
  public static void main(String[] args) {
    Animal miao = new Cat();
    miao.eat();

    miao.barking();

    miao.run();

//    animal.catchMouse(); // 不能调用 catchMouse
  }
}
```

分析下上面的代码：

- `Animal` 类中有 `eat`、`sleep`、`run` 三个普通方法和一个静态方法 `barking` ；

- `Cat` 类继承了 `Animal`， 重载了 `eat` 方法，重写了非静态方法 `sleep`，同时 `Cat` 内部也实现了一个 `catchMouse` 方法，也有一个静态方法 `barking`。

打印结果为：

```
Animal正在吃东西...
Cat正在睡觉
Animal正在叫...
Animal正在奔跑...
```

看了打印结果，可能就有疑惑了，下面我们来逐一分析：

创建了一个对象 `miao`，它在编译时的类型是 `Animal`，而实际运行时的类型是 `Cat`；

在使用 `miao` 这个对象时，程序知道它是个 `Animal`，所以在调用对象成员的时候，可以调用 `eat()` 方法，所以打印的第一句很好理解；那为什么打印的第二句不是 `Animal` 中的方法，而是 `Cat` 中的方法呢？

代码中，`Cat` 重载了 `eat()` 方法，重写了 `sleep()` 方法。我们需要知道：

对于一个指向子类对象的父类引用，如果子类中**重写**了父类的方法，那么在通过父类引用调用这个方法的时候，编译器会在编译时把这个父类的方法引用动态绑定到**实际类型**的方法上去（也就是重写之后的方法上）；而那些没有被子类重写的方法，则会静态绑定到父类的方法上去。

所以，当调用 `Animal` 中的 `eat()` 方法时，`eat()` 方法内调用的 `sleep()` 方法是 `Cat` 中的 `sleep()` 方法，这就是第二个打印结果为 **"`Cat` 正在睡觉"** 的原因。

第三句打印结果输出的依旧是 `Animal` 中的方法，这个就很好理解了，`barking` 是静态方法，静态方法不会被重写。用 `static` 关键字修饰的方法和变量都是属于类自己本身的，即使子类和父类中都有同样的 `static` 方法和变量，他们是没有任何关系的，是相互独立的，不存在多态性。

第四句打印调用 `Animal` 类中的 `run()` 方法，这个就没什么多说的了。

那为什么程序无法调用 `Cat` 中的 `catchMouse()` 方法呢？因为我们声明的对象 `miao` 是 `Animal` 类型，到了运行时期，`miao` 调用 `catchMouse` 方法时，`Animal` 中没有这个方法，所以就会编译不通过，而 `eat` 方法和 `sleep` 方法是存在的，所以不会报错。也就是：**声明时的类型决定你「能不能调」那个方法。**



**结论：**

所以，当父类引用指向子类对象时，只能调用那些父类中存在的方法，如果子类中对该方法进行了重写，那么在运行时就会动态调用子类中的方法，这样一来，这个父类引用就既可以调用父类中的方法，也可以调用子类中的方法了（**前提是重写**）。这就是多态的体现。

所以，从前面的描述中，我们可以总结出**发生多态的条件**：

- 继承
- 重写
- 父类引用指向子类对象（向上转型）



**多态的缺点：**

当我们去调用子类中特有的属性和方法时，会发生报错，这个就是多态的缺点，即：**即多态后不能使用子类特有的属性和方法**。这其实就是**向上转型的缺点**。

如果我们想要使用子类中特有的属性和方法该怎么办呢？答案是**强制类型转换 —— 向下转型。**

```java
public class Main {
  public static void main(String[] args) {
    Animal miao = new Cat();
    miao.eat();

    miao.barking();

    miao.run();

    Cat mew = (Cat)miao; // 强制类型转换
    mew.catchMouse(); // 抓老鼠
  }
}
```



**基于接口实现的继承**

接口的灵活性就在于**「规定一个类必须做什么，而不管你如何做」**。我们可以定义一个接口类型的引用变量来引用实现接口的类的实例，当这个引用调用方法时，它会根据实际引用的类的实例来判断具体调用哪个方法。看下面的例子：

```java
interface Animal {
  public void eat();

  public void walk();
}

class Cat implements Animal {
  public void eat() {
    System.out.println("猫在吃！！");
  }

  public void walk() {
    System.out.println("猫在走！！");
  }
}

public class Dog implements Animal {
  public void eat() {
    System.out.println("狗在吃！！");
  }

  public void walk() {
    System.out.println("狗在走！！");
  }
  
  public void sleep() {
    System.out.println("狗睡觉！！");
  }
}

public class Main {
  public static void main(String[] args) {
    // 向上转型
    Animal d = new Dog(); // 接口的引用类型变量(d)指向了接口实现类的对象(Dog)。
    d.eat(); // 狗在吃！！
    d.walk(); // 狗在走！！
    // d.sleep(); // error

    Animal c = new Cat();
    c.eat(); // 猫在吃！！
    c.eat(); // 猫在吃！！
  }
}
```

充分体现了 **"一个接口，多个实现"** 的特点。



#### 4、经典例子

检验自己是否掌握了多态，看看下面的经典例子吧：

```java
class A {
  public String show(D obj) {
    return "A and D";
  }

  public String show(A obj) {
    return "A and A";
  }
}

class B extends A {
  public String show(B obj) {
    return "B and B";
  }

  public String show(A obj) {
    return "B and A";
  }
}

class C extends B {

}

class D extends B {

}

public class Main {
  public static void main(String[] args) {
    A a1 = new A();
    A a2 = new B();
    B b = new B();
    C c = new C();
    D d = new D();

    System.out.println(a1.show(b)); // 1 
    System.out.println(a1.show(c)); // 2 
    System.out.println(a1.show(d)); // 3 
    System.out.println(a2.show(b)); // 4 
    System.out.println(a2.show(c)); // 5 
    System.out.println(a2.show(d)); // 6 
    System.out.println(b.show(b)); // 7 
    System.out.println(b.show(c)); // 8 
    System.out.println(b.show(d)); // 9 
  }
}
```

输出结果是：

```java
A and A 
A and A 
A and D 
B and A 
B and A 
A and D 
B and B 
B and B 
A and D
```

