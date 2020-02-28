---
title: Java 中的注解
author: Deepspace
categories: Java
date: 2020-02-27
urlname: java-annotation
tags:
  - 注解
---



### 一、什么是注解

`Java` 注解（`Annotation`）是 `JDK 1.5` 引入的特性，与类、接口、枚举是在同一等级。它可以作用在类、属性、方法、局部变量、方法参数上，用于对这些元素进行说明、解释。

> `Annotation` 中文译过来就是注解、注释的意思，但是我们一般都都用它来指代注解，因为「注释」一词已经表示说明 `//`、`/*...*/` 等符号了。

在学习重写的时候，我们其实已经接触过注解了：

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

`@Override` 就是一个注解。我们知道，`@Override` 是伪代码，表示重写（当然不写也可以），不过写上有如下好处：

1. 可以当注释用，方便阅读；
2. 编译器可以验证 `@Override` 下面的方法名是否是父类中所有的，如果没有则报错；
3. 如果没写 `@Override`，而下面的方法名又不是父类中的方法，这时编译器是可以编译通过的，因为编译器会认为这个方法是子类中自己增加的方法。

所以，为了避免发生错误，我们在重写时，需要加上 `@override`。

<!-- more -->

那 `@Override` 是如何定义的呢？我们看下 `JDK` 对于这个内置注解的定义：

```java
package java.lang;

import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
```

其实它本质上是这样的：

```java
public interface Override extends Annotation {
    
}
```

注解的本质就是一个继承了 `Annotation` 接口的接口。`Annotation` 位于 `java.lang.annotation.*` 包中，所有的注解类型都继承于它。

`Java` 支持我们写注解，但是如果没有解析注解的代码，它就只不过是一种特殊的注释而已。解析一个类或者方法的注解往往有两种形式：

- 一种是编译期扫描；
- 一种是运行期反射。

编译器的扫描指的是：编译器在对 `Java` 代码编译成字节码的过程中，会检测到某个类或者方法被一些注解修饰，这时它就会对于这些注解进行某些处理。前面我们说的重写的注解 ——  `@Override` ，它就是在编译编译期扫描的例子。一旦编译器检测到某个方法被 `@Override` 注解修饰了，编译器就会检查当前方法的方法签名是否真正重写了父类的某个方法，也就是比较父类中是否具有一个同样的方法签名。

而另外一种方式「反射」，待会再介绍，下面我们来看看 `Java` 内置的一些注解。



### 二、基本注解

在 `java.lang` 包下有比较常见的几个 `Annotation` 。

#### 1、Override

`@Override` 是重写注解，它的作用就是告诉编译器要**检查当前方法的方法签名是否真正重写了父类的某个方法**，也就是比较父类中是否具有一个同样的方法签名。可以帮我们避免一些低级的错误。

比如，我们在子类中实现 `sayHello()` 方法的时候，把  `sayHello()` 方法写成了  `sayHolle()` ，那么编译器就会按照注解的要求去检查，发现该方法并不是实现父类的，与注解 `@Override` 冲突，就会报出错误。



#### 2、Deprecated

这个注解也非常常见，我们在设计的时候，可能觉得某些方法设计得不好，**为了兼容以前的程序，是不能直接把它抛弃的，于是就设置它为 `@Deprecated`（过时）**，不被鼓励使用。如果使用或者进行重写，程序会发出警告。

例如：

```java
@Deprecated
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

这个时候，继承 `Animal` 类时，会发出警告，`IDE` 会划出一个中横线：

<img src="https://github.com/IDeepspace/ImageHosting/raw/master/Java/annotation-deprecated.png" alt="Deprecated" style="zoom:50%;" />

由于已经被标注了 `@Deprecated` ，但是 `Animal` 依然在被使用，所以 `Animal` 类会报出一个 `Deprecated member 'Animal' is still used` 的警告。如果没有被使用，则不会发出警告。



#### 3、SuppressWarnings

`@SuppressWarnings` 是一个抑制编译器警告的注解。

比如我们在使用 `ArrayList` 的时候，如果没有添加泛型，则会发出警告。这个时候我们就可以使用这个注解来抑制编译器的警告。

```java
import java.util.ArrayList;

@SuppressWarnings(value = "unchecked")
public class Main {
  public static void main(String[] args) {
    ArrayList words = new ArrayList();
    words.add("hello"); // 如果没有添加注解，这一行会发出警告
  }
}
```



#### 4、FunctionalInterface

`Java 8` 中专门为函数式接口引入了一个新的注解：`@FunctionalInterface` 。该注解可用于一个接口的定义上,一旦使用该注解来定义接口，编译器将会强制检查该接口是否确实有且仅有一个抽象方法，否则将会报错。但是这个注解不是必须的，只要符合函数式接口的定义，那么这个接口就是函数式接口。

虽然 `@FunctionalInterface` 注解不是必须的，但是自定义函数式接口时最好还是都加上，一是养成良好的编程习惯，二是防止他人修改。编程的时候，一看到这个注解就知道是函数式接口，避免他人往接口内添加抽象方法，造成不必要的麻烦。

```java
@FunctionalInterface
public interface MyFunction {
	// static不是抽象方法
  public static void staticMethod() {
  }

  // 抽象方法
  public void sub();

  // 抽象方法2
  // public void sub2(); // error

  // java.lang.Object中的方法不是抽象方法
  public boolean equals(Object var1);

  // default不是抽象方法
  public default void defaultMethod() {

  }
}
```

接口中的方法中**没有声明为默认或静态的方法**是隐式抽象的，所以一般 `abstract` 修饰符不用于修饰接口方法，可以使用，但没有必要。



#### 5、SafeVarargs

堆污染警告。什么是堆污染呢？

当一个 **可变泛型参数** 指向一个 **无泛型参数** 时，这个时候就很容易发生堆污染（`Heap Pollution`）。不是很常用。



### 三、元注解

作用于其他注解的注解称为**元注解** 。在 `java.lang.annotation` 中定义了几个元注解类型：

1、`@Retention` 

指定标记注解的存储方式：

- `RetentionPolicy.SOURCE` - 标记的注解仅在源级别保留，并被编译器忽略。
- `RetentionPolicy.CLASS` - 标记的注解由编译器在编译时保留，但被 `Java` 虚拟机（`JVM`）忽略。
- `RetentionPolicy.RUNTIME` - 标记的注解由 `JVM` 保留，因此可以由运行时环境使用。



2、`@Documented`

注解是否应当被包含在 `JavaDoc` 文档中，默认情况下，注解不包括在 `Javadoc` 中。



3、`@Target`

标记另一个注解，以限制注解可应用于哪种类型的 `Java` 元素。目标注解指定以下元素类型之一作为其值：

- `ElementType.ANNOTATION_TYPE` 可以应用于注解类型。
- `ElementType.CONSTRUCTOR` 可以应用于构造函数。
- `ElementType.FIELD` 可应用于字段。
- `ElementType.LOCAL_VARIABLE` 可以应用于局部变量。
- `ElementType.METHOD` 可以应用于方法级注解。
- `ElementType.PACKAGE` 可以应用于一个包的声明。
- `ElementType.PARAMETER` 可以应用于一个方法的参数。
- `ElementType.TYPE` 可以应用于类的任何元素。



4、`@Inherited`

表示注解类型可以从超级类继承（默认情况下不是这样）。当用户查询注解类型并且类没有此类型的注解时，会为该类的超类查询注解类型。此注解仅适用于类声明。



5、`@Repeatable`

在 `Java SE 8` 中引入，表示标记的注解可以被多次应用于相同的声明或类型使用。



### 四、自定义注解

我们也可以自己来写注解，给方法或类注入信息。

#### 1、定义注解

前面提到了元注解，它可以用来标注 `Annotation`，所以，我们自定义注解时，会用到元注解。

自定义注解格式为：

```java
public @interface 注解名 { 定义体 }
```

下面我们自定义一个注解：

```java
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
public @interface ClassInfo {
  String author() default "Deepspace";

  String date();

  String comments();
}
```

- 根据 `@Retention` 可以得知这个注解会一直存在，也就是在程序运行中时候，这个注解还是有效的；
- `@Target(ElementType.TYPE)` 说明 `ClassInfo` 注解的是作用于类、接口或 `enum` 声明的；
- `@Documented` 说明 `ClassInfo`信息可以被写入 `JavaDoc` 文档中的。

再来看一下自定义注解中的一些注解参数，里面有三个注解参数，注解参数是可以设置默认值，例如 `author` 注解参数，默认值为 `Deepspace`，其他两个参数没有默认值。

再来看另一个自定义的注解：

```java
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MethodInfo {
  String description() default "No Description";

  String name();
}
```

这个自定义的注解 `MethodInfo` 是作用于方法的，在程序运行中时候，这个注解也会存在；里面有两个注解参数。

下面我们再添加一个作用于字段的注解：

```java
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface FieldInfo {
  String type();
  
  String name();
}
```

这个自定义的注解 `MethodInfo` 是作用于字段的，在程序运行中时候，这个注解也会存在；里面有两个注解参数。



#### 2、注解的参数类型

注解参数的定义（方法的定义），只能用 `public` 或者 `default` 两个访问权限修饰符，参数的类型支持以下几种：

- 八种基本数据类型（`byte`，`int`，`short`，`long`，`float`，`double`，`char`，`boolean`）
- `String` 类型
- `Class` 类型
- `enum` 类型
- `Annotation` 类型
- 以上所有类型的数组



#### 3、使用注解

下面我们定义一个类，使用上面我们自定义的注解加以标注：

```java
@ClassInfo(author = "Deepspace",
        date = "2020/02/27",
        comments = "annotation demo")
public class AnnotationDemo {
  @FieldInfo(type = "public", name = "firstField")
  public int firstField;

  @FieldInfo(type = "private", name = "secondField")
  private String secondField;

  @MethodInfo(description = "method in AnnotationDemo", name = "firstMethod")
  public void firstMethod(String value) {
    System.out.print("first method involved");
  }

  @MethodInfo(description = "method in AnnotationDemo", name = "secondMethod")
  private void secondMethod() {
    System.out.print("first method involved");
  }
}
```



#### 4、获取注解信息

要获取注解信息，首先得保证注解在程序运行时候会存在，所以一般会给自定义的注解添加了 `@Retention(RetentionPolicy.RUNTIME)` 元注解，这样在程序运行过程中，我们可以通过反射去获取一些注解信息。

```java
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class AnnotationTest {
  public static void main(String[] args) {
    resolveClassAnnotationInfo(AnnotationDemo.class);
    resolveFieldAnnotationInfo(AnnotationDemo.class);
    resolveMethodAnnotationInfo(AnnotationDemo.class);
  }

  private static void resolveClassAnnotationInfo(Class<?> clz) {
    // 判断该类是否有ClassInfo注解
    if (clz.isAnnotationPresent(ClassInfo.class)) {
      ClassInfo classInfo = (ClassInfo) clz.getAnnotation(ClassInfo.class);
      System.out.println(classInfo.author() + " " + classInfo.comments() + " " + classInfo.date());
    }
  }

  private static void resolveFieldAnnotationInfo(Class<?> clz) {
    Field[] fields = clz.getDeclaredFields();
    for (Field field : fields) {
      // 判断字段
      if (field.isAnnotationPresent(FieldInfo.class)) {
        FieldInfo fieldInfo = (FieldInfo) field.getAnnotation(FieldInfo.class);
        System.out.println(fieldInfo.type() + " " + fieldInfo.name());
      }
    }
  }

  private static void resolveMethodAnnotationInfo(Class<?> clz) {
    Method[] methods = clz.getDeclaredMethods();
    for (Method method : methods) {
      // 判断方法
      if (method.isAnnotationPresent(MethodInfo.class)) {
        MethodInfo methodInfo = (MethodInfo) method.getAnnotation(MethodInfo.class);
        System.out.println(methodInfo.name() + " " + methodInfo.description());
      }
    }
  }
}
```

通过反射获取类中的 `Field/Method` 等等，通过 `getAnnotation()` 或者 `getAnnotations()` 获取相关注解，拿到具体注解就可以获取具体的信息了。

输出结果如下：

```
Deepspace annotation demo 2020/02/27
public firstField
private secondField
firstMethod method in AnnotationDemo
secondMethod method in AnnotationDemo
```



### 五、总结

其实，就算在实际开发中，使用注解的场景也并不是非常多的，如果不用，也并不会造成很大的麻烦。那为什么要引入注解呢？

首先，我们还是需要牢牢记住注解的作用：**说明、描述代码**。

在使用 `Annotation` 描述之前，`XML` 被广泛的应用于描述元数据（描述数据的数据，又称中介数据、中继数据）。`XML` 的思想是**配置集中化**，统一管理维护。

慢慢地，开发人员发现 `XML` 的维护非常麻烦，配置文件过多会导致管理变得困难；并且，编译期无法对其配置项的正确性进行验证，要查错只能在运行期，往往配置的一个手误就会导致很多莫名其妙的错误。

这个时候，开发人员就希望使用一些**和代码紧耦合**的东西，而不是像 `XML` 那样和代码是松耦合的（在某些情况下甚至是完全分离的）来描述代码。所以，`Annotation` 就诞生了，它**保存在 `class` 文件中，降低了维护成本，编译期即可验证正确性，查错变得非常容易**。

所以，我们看到的是 `Spring` 框架的设计中就使用了`Annotation` 。

但是也并不是说 `XML` 就没有优势了，得看实际的使用场景。假如你想为应用设置很多的常量或参数，这种情况下，`XML` 是一个很好的选择，因为它不会同特定的代码相连。

目前，许多框架将 `XML` 和 `Annotation` 两种方式结合使用，我们在开发程序时，也需要平衡两者之间的利弊。

