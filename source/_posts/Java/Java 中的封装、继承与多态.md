## Java 中的封装、继承与多态

在前面的[《`Java` — 面向对象的编程语言》](https://togoblog.cn/java-oop-language/)里，介绍了面向对象的三大特征：封装、继承、多态，主要是概念上的讲解，本篇文章将从代码出发，看看 `Java` 中的封装、继承与多态。



### 一、封装

在编程时，把数据（属性）和有关属性的一些操作（方法）绑定在一起，形成一个不可分开的集合（类），这个过程就是封装（`Encapsulation`）。

封装时，我们需要隐藏对象的属性和实现细节，仅对外公开接口，并控制在程序中属性的读和写的**访问级别**。

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



### 二、继承

我们先看看没有继承的时候，会怎样写代码。

以学生类和老师类为例，学生和老师都会吃饭喝、睡觉，如果没有继承，代码是这样的：

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

分别定义了 `Teacher` 类和 `Student` 类，吃饭和睡觉是学生和老师共有的行为，但是却写了两遍；并且，如果需要给 `Teacher` 类和 `Student` 类再添加一个 `walk` 的行为，需要给两个类都分别添加，没有一点的复用性可言，随着逻辑变得复杂，代码的可维护性也会变差。

有了继承，上面的问题就很好解决了。



#### 1、extends

`Java` 通过 `extends` 关键字来实现继承。

学生和老师都是人类，人类都要吃饭喝睡觉。所以我们可以提取一个叫作 `Person` 的类：

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



#### 2、单继承、多层继承

`Java` 只支持单继承，不支持多继承。也就是说一个类只能有一个父类，不可以有多个父类。

```java
class SubDemo extends Demo{} //ok

class SubDemo extends Demo1,Demo2 … //error
```

但是 `Java` 支持多层继承：

```java
class A{}
class B extends A{}
class C extends B{}
```



#### 3、继承中成员变量之间的关系

继承时，如果子类中的成员变量和父类中的成员变量名称不一样，那就很好办，没有任何问题发生；如果子类中的成员变量和父类中的成员变量名称一样，这个怎么办呢？看段代码：

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
    // 找不到符号，报错
    //System.out.println(num3);
  }
}

public class ExtendsDemo {
  public static void main(String[] args) {
    // 创建对象
    Son s = new Son();
    s.show();
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

为什么会出现重写呢？看下面的例子：

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

当 `dog` 调用 `printWhoIAm()` 方法时，其实希望的是输出 `dog`，而不是 `Animal`。要实现输出 `Dog`，该怎么办？

想到了重载，可是重载要求被重载的方法具有不同的形参列表，所以这个方法行不通。

代码中，`dog` 调用的 `printWhoIAm()` 是父类中的，在子类中若是可以重写这个方法，那么就可以实现目的了。于是，重写（覆写）便产生了。

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
> 2. 编译器可以验证 `@Override` 下面的方法名是否是父类中所有的，如果没有则报错。例如：如果没写 `@Override`，而下面的方法名又写错了，这时编译器是可以编译通过的，因为编译器以为这个方法是子类中自己增加的方法。
>
> 所以，我们在重写时，需要加上 `@override`。

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

可以看到，在 `App` 这个类中，当我们给 `getName` 传递参数时，执行的是 `Animal` 中的方法，而非 `Dog` 中的 `getName` 方法。也就是说如果参数不一致最后执行的可能就不是重写的那个方法。

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

子类中所有的构造函数默认都会访问父类中空参数的构造函数。因为子类继承父类之后，获取到了父类的内容（属性/字段），而这些内容在使用之前必须先初始化，所以**子类初始化之前，一定要先调用父类的构造函数完成父类数据的初始化**。可以用下面的代码来验证：

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
- 子类通过 `this` 去调用本类的其他构造方法；

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

大部分时候，一个方法访问其他方法、成员变量时，无须使用 `this` 前缀；但如果方法里有个**局部变量和成员变量同名**，但程序又需要在该方法里访问这个被覆盖的成员变量，则必须使用 `this` 前缀。

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

`this` 关键字最大的作用就是让类中一个方法，访问该类里的另一个方法或实例变量。

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

省略 `this` 前缀只是一种假象，虽然可以省略调用 `teaching()` 方法之前的 `this`，但实际上这个 `this` 依然是存在的。

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





### 三、多态



