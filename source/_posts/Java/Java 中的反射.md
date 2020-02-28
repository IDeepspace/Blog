---
title: Java 中的反射
author: Deepspace
categories: Java
date: 2018-02-27
urlname: java-reflection
tags:
  - 反射
---



### 一、什么是反射？

反射之中包含了一个「反」字，要想解释反射，我们得先从「正」开始解释。

一般情况下，我们在使用某个类时，需要先知道它是什么类，是用来做什么的。于是我们直接对这个类进行实例化，之后使用这个类对象（类对象就是类的实例化）进行操作。

```java
Person person = new Person();
person.setName = "Deepspace";
```

这种对类对象进行初始化的操作，我们可以理解为「正」。

#### 1、Class 的概念

这里要提一下 `Class` 类的概念。

`Class` 是所有类的。`Class` 的构造方法是私有的，因此不可以像普通类一样 `new`一个 `Class` 对象，只能由 `JVM` 在类加载时自动创建的 `Class` 实例；`Class` 类的一个实例表示 `Java` 的一种数据类型，包括类、接口、枚举、注解（`Annotation`）、数组、基本数据类型和 `void`。

但是我们却可以通过已有的类得到一个 `Class` 对象。在 `Java API` 中，获取 `Class` 对象有三种方法：

- 使用 `Class.forName` 静态方法，当我们知道该类的全路径名时，你可以使用该方法获取 `Class` 类对象。
- 使用 `.class` 方法，这种方法只适合在编译前就知道所操作的 `Class`。
- 使用类对象的 `.getClass()` 方法。

看下面的例子：

```java
public class Person {
  private String name;
  private Integer age;

  public Person(String name, Integer age) {
    this.name = name;
    this.age = age;
  }

  public Person() {
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  private String showMyInfo() {
    return "name: " + name + ", age: " + age + ".";
  }
}

public class Main {
  public static void main(String[] args) {
    String className = "PackageOne.Person";
    try {
      Class pClass1 = Class.forName(className);
      Class pClass2 = Person.class;
      Class pClass3 = new Person().getClass();

      System.out.println(pClass1); // class PackageOne.Person
      System.out.println(pClass1 == pClass2); // true
      System.out.println(pClass1 == pClass3); // true
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
  }
}
```

这里，`pClass1`、`pClass2`、`pClass3` 都是 `Class` 的对象，它们是完全一样的，而且有个学名，叫做 `Person` 的类类型（`class type`）。

**顾名思义，类类型就是类的类型，也就是描述一个类是什么，都有哪些东西，所以我们可以通过类类型知道一个类的属性和方法，并且可以调用一个类的属性和方法，这就是反射的基础。**



#### 2、反射的概念

那我们如何才能知道：**要操作的类是什么，类的完整构造是怎样的，怎么才能调用类中对应的方法呢？**这就是反射。

**对于任意一个类，我们都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意方法和属性；这种动态获取信息以及动态调用对象方法的功能称为 `Java` 语言的反射机制。简单来说，反射机制指的是程序在「运行时」能够获取自身的信息。在 `Java` 中，只要给定类的名字，就可以通过反射机制来获得类的所有信息。**

`Java` 反射机制主要提供了以下功能，这些功能都位于 `java.lang.reflect` 包。

- 在运行时判断任意一个对象所属的类。
- 在运行时构造任意一个类的对象。
- 在运行时判断任意一个类所具有的成员变量和方法。
- 在运行时调用任意一个对象的方法。
- 生成动态代理。



### 二、反射的例子

下面我们看个完整的例子：

```java
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

public class Main {
  public static void main(String[] args) throws Exception {
    // 正常的调用
    Person person = new Person();
    person.setName("Deepspace");
		System.out.println("Person Name: " + person.getName());

    // 使用反射
    Class clz = Class.forName("PackageOne.Person");

    // 获取 setName 方法
    Method setNameMethod = clz.getMethod("setName", String.class);
    // 获取 getName 方法
    Method getPriceMethod = clz.getMethod("getName");

    // 获取构造函数
    Constructor personConstructor = clz.getConstructor();

    // 通过构造函数实例化对象
    Object personObj = personConstructor.newInstance();

    // 调用方法操作对象
    setNameMethod.invoke(personObj, "Deepspace");

    System.out.println("Person Name: " + getPriceMethod.invoke(personObj));
  }
}

public class Person {
  private String name;
  private Integer age;

  public Person(String name, Integer age) {
    this.name = name;
    this.age = age;
  }

  public Person() {
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  private String showMyInfo() {
    return "name: " + name + ", age: " + age + ".";
  }
}
```

感觉很不错，我们只要知道了这个类的路径全称，就能操作它的所有东西。

但是上面的例子中，我们事先知道了类的一些信息，有时候我们不知道，但是想获取类中所有成员信息，要怎么办？



#### 1、获取所有方法

```java
import java.lang.reflect.Method;

public class Main {
  public static void main(String[] args) {
    try {
      Class c = Class.forName("PackageOne.Person");
      Method[] methods = c.getDeclaredMethods();
      for (Method m : methods) {
        String methodName = m.getName();
        System.out.println(methodName);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
```

输出：

```
getName
setName
getAge
setAge
showMyInfo
```

这里如果把 `c.getDeclaredMethods();` 改成 `c.getMethods();` 执行结果如下：

```
getName
setName
getAge
setAge
showMyInfo
wait
wait
wait
equals
toString
hashCode
getClass
notify
notifyAll
```

多了很多方法，因为把 `Object` 里面的方法也打印出来了，`Object` 是所有类的父类。

我们甚至可以访问私有方法：

```java
import java.lang.reflect.*;

public class Main {
  public static void main(String[] args) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
    Person privateObject = new Person("Deepspace", 24);

    Method privateStringMethod = Person.class.
            getDeclaredMethod("showMyInfo");

    privateStringMethod.setAccessible(true);

    String returnValue = (String) privateStringMethod.invoke(privateObject);

    System.out.println(returnValue);
  }
}
```

<p align="center">Method 类的常用方法</p>

| 静态方法名称                       | 说明                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| `getName()`                        | 获取该方法的名称                                             |
| `getParameterType()`               | 按照声明顺序以 `Class` 数组的形式返回该方法各个参数的类型    |
| `getReturnType()`                  | 以 `Class` 对象的形式获得该方法的返回值类型                  |
| `getExceptionTypes()`              | 以 `Class` 数组的形式获得该方法可能抛出的异常类型            |
| `invoke(Object obj,Object...args)` | 利用 `args` 参数执行指定对象 `obj` 中的该方法，返回值为 `Object` 类型 |
| `isVarArgs()`                      | 查看该方法是否允许带有可变数量的参数，如果允许返回 `true`，否则返回 `false` |
| `getModifiers()`                   | 获得可以解析出该方法所采用修饰符的整数                       |



#### 2、获取所有成员变量

```java
import java.lang.reflect.Field;

public class Main {
  public static void main(String[] args) throws ClassNotFoundException {
    Class c = Class.forName("PackageOne.Person");
    Field[] fields = c.getDeclaredFields();
    for(Field field :fields){
      System.out.println(field.getName());
    }
  }
}
```

输出：

```
name
age
```

`getField` 只能获取 `public` 的，包括从父类继承来的字段。

`getDeclaredField` 可以获取本类所有的字段，包括 `private` 的，但是不能获取继承来的字段。

注意：这里只能获取到 `private` 的字段，但并不能访问该 `private` 字段的值，想要访问值，需要加上 `setAccessible(true)`。

```java
import java.lang.reflect.Field;

public class Main {
  public static void main(String[] args) throws NoSuchFieldException, IllegalAccessException {
    Person person = new Person("Deepspace", 24);

    Field privateStringField = Person.class.
            getDeclaredField("name");
    privateStringField.setAccessible(true);

    String fieldValue = (String) privateStringField.get(person);
    System.out.println("fieldValue = " + fieldValue);
  }
}
```

通过调用 `Field.setAccessible(true)`，可以关闭对此特定字段实例的访问检查，仅用于反射。 

<p align="center">Field 类的常用方法</p>

| 方法名称                            | 说明                                                         |
| ----------------------------------- | ------------------------------------------------------------ |
| `getName()`                         | 获得该成员变量的名称                                         |
| `getType()`                         | 获取表示该成员变量的 `Class` 对象                            |
| `get(Object obj)`                   | 获得指定对象 `obj` 中成员变量的值，返回值为 `Object` 类型    |
| `set(Object obj, Object value)`     | 将指定对象 `obj` 中成员变量的值设置为 `value`                |
| `getlnt(0bject obj)`                | 获得指定对象 `obj` 中成员类型为 `int` 的成员变量的值         |
| `setlnt(0bject obj, int i)`         | 将指定对象 `obj` 中成员变量的值设置为 `i`                    |
| `setFloat(Object obj, float f)`     | 将指定对象 `obj` 中成员变量的值设置为 `f`                    |
| `getBoolean(Object obj)`            | 获得指定对象 `obj `中成员类型为 `boolean` 的成员变量的值     |
| `setBoolean(Object obj, boolean b)` | 将指定对象 `obj` 中成员变量的值设置为 `b`                    |
| `getFloat(Object obj)`              | 获得指定对象 `obj` 中成员类型为 float 的成员变量的值         |
| `setAccessible(boolean flag)`       | 此方法可以设置是否忽略权限直接访问 `private` 等私有权限的成员变量 |
| `getModifiers()`                    | 获得可以解析出该方法所采用修饰符的整数                       |



#### 3、获取构造函数

```java
import java.lang.reflect.Constructor;

public class Main {
  public static void main(String[] args) {
    try {
      Class c = Class.forName("PackageOne.Person");
      Constructor[] constructors = c.getDeclaredConstructors();
      for (Constructor constructor : constructors) {
        System.out.println(constructor);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
```

输出：

```java
public PackageOne.Person(java.lang.String,java.lang.Integer)
public PackageOne.Person()
```

访问私有构造函数：

```java
import java.lang.reflect.*;

public class Main {
  public static void main(String[] args) throws ClassNotFoundException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
    Class clazz = Class.forName("PackageOne.Person");
    Constructor cons = clazz.getDeclaredConstructor(String.class, Integer.class);

    // set accessble to access private constructor
    cons.setAccessible(true);
    cons.newInstance("Deepspace", 24);
  }
}

public class Person {
  private String name;
  private Integer age;

  private Person(String name, Integer age) {
    this.name = name;
    this.age = age;
    System.out.println("name: " + name + ", age: " + age + ".");
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  private String showMyInfo() {
    return "name: " + name + ", age: " + age + ".";
  }
}
```

<p align="center">Constructor 类的常用方法</p>

| 方法名称                         | 说明                                                         |
| -------------------------------- | ------------------------------------------------------------ |
| `isVarArgs()`                    | 查看该构造方法是否允许带可变数量的参数，如果允许，返回 `true`，否则返回 `false` |
| `getParameterTypes()`            | 按照声明顺序以 `Class` 数组的形式获取该构造方法各个参数的类型 |
| `getExceptionTypes()`            | 以 `Class` 数组的形式获取该构造方法可能抛出的异常类型        |
| `newInstance(Object … initargs)` | 通过该构造方法利用指定参数创建一个该类型的对象，如果未设置参数则表示 采用默认无参的构造方法 |
| `setAccessiable(boolean flag)`   | 如果该构造方法的权限为 `private`，默认为不允许通过反射利用 `netlnstance()` 方法创建对象。如果先执行该方法，并将入口参数设置为 `true`，则允许创建对 象 |
| `getModifiers()`                 | 获得可以解析出该构造方法所采用修饰符的整数                   |



### 三、总结

优点：

- 能够运行时动态获取类的实例，大大提高系统的灵活性和扩展性；
- 与 `Java` 动态编译相结合，可以实现无比强大的功能；
- 对于 `Java` 这种先编译再运行的语言，能够让我们很方便的创建灵活的代码，这些代码可以在运行时装配，无需在组件之间进行源代码的链接，更加容易实现面向对象。


缺点：

- 反射会消耗一定的系统资源，因此，如果不需要动态地创建一个对象，那么就不需要用反射；
- 反射调用方法时可以忽略权限检查，获取这个类的私有方法和属性，因此可能会破坏类的封装性而导致安全问题。



`Java` 反射机制在一般的 `Java` 应用开发中很少使用，一般在框架中的一些功能会使用反射来实现。