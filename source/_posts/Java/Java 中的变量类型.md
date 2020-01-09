### 五、Java 中的变量

在  `Java` 中，每个变量都有一个特定的类型，这个类型决定了变量在内存中的存储大小和存储方式，变量的类型不同，操作方式也会不同。

`Java` 中的变量类型有三种：

- 静态（类）变量 `Static/Class variables`
- 成员（实例）变量 `Member/Instance variables`
- 局部变量 `Local variables`

```java
public class Variable {
  static int m = 0;    // 静态变量

  String str = "hello world";  // 成员变量

  public void method() {
    int i = 0;  // 局部变量
  }
}
```



#### 1、局部变量

局部变量在方法、构造函数或块中声明，没有声明提升；并且一旦变量退出方法、构造函数或块，就会被销毁（内存回收），所以它是有作用域的。访问修饰符（后面会讲到）不能用于局部变量。

**这里要注意：局部变量没有默认值，因此声明局部变量时，需要在第一次使用之前分配初始值。**看下面的例子：

```java
public class Variable {
  public static void main(String[] args) {
    Variable var = new Variable();
    var.sayAge();
  }

  public void sayAge() {
    int age = 0;
    age = age + 7;
    System.out.println("My age is : " + age); // My age is : 7
  }
}
```

如果不对局部变量进行初始化，就会编译报错：

```java
public class Variable {
  public static void main(String[] args) {
    Variable var = new Variable();
    var.sayAge();
  }

  public void sayAge() {
    int age;
    age = age + 7; // error: variable age might not have been initialized
    System.out.println("My age is : " + age);
  }
}
```



#### 2、成员变量

- 成员变量随着对象的创建而存在，随着对象的回收而释放；
- 成员变量在类中但在方法、构造函数或任何块之外声明；
- 成员变量可以在使用变量的代码之后声明，并不会报错；
- 成员变量对于类中的所有方法、构造函数和块都是可见的，所以在类中可以直接使用变量名来使用成员变量；
- **成员变量只能被对象调用**；

- 可以为成员变量指定访问修饰符，控制可见性；
- 成员变量具有默认值。 数字类型默认值为 `0`；布尔类型默认值为 `false`；对象引用默认值为 `null`。 

```java
public class Employee {

  // this instance variable is visible for any child class.
  public String name;

  // age variable
  int age;

  // salary variable is visible in Employee class only.
  private double salary;

  // The name variable is assigned in the constructor.
  public Employee(String empName, int empAge) {
    name = empName;
    age = empAge;
  }

  public static void main(String[] args) {
    Employee empOne = new Employee("Deepspace", 23);
    empOne.setSalary(1000);
    empOne.printEmp();
  }

  // The salary variable is assigned a value.
  public void setSalary(double empSal) {
    salary = empSal;
  }

  // This method prints the employee details.
  public void printEmp() {
    System.out.println("name: " + name + ". age: " + age); // name: Deepspace. age: 23
    System.out.println("salary: " + salary); // salary: 1000.0
  }
}
```



#### 3、静态变量

- 声明实例变量时，在前面加上 `static` 关键字，该变量就变成了静态变量；
- 静态变量可以被对象调用，还可以被类名（`ClassName.VariableName`）调用；
- 静态变量随着类的加载而存在，随着类的消失而消失；
- 静态变量的可见性类似于实例变量，也可以指定访问修饰符；
- 静态变量的默认值同实例变量。

```java
public class Employee {

  private static double salary;

  Employee(double mySalary) {
    salary = mySalary;
  }

  public static void main(String[] args) {
    salary = 1000;
    System.out.println(salary); // 1000.0

    Employee epmOne = new Employee(1000.0);

    System.out.println(epmOne.salary); // 1000.0
    System.out.println(Employee.salary); // 1000.0
  }
}
```

那为什么要多出一个 `static` 这个静态修饰符来修饰实例变量让其成为静态变量呢？有什么作用呢？



#### 4、静态变量的作用

我们知道，在程序中，任何变量或者代码都是在编译时是由系统自动分配内存来存储的。而所谓静态就是指在**编译后所分配的内存会一直存在**，直到程序退出内存才会释放这个空间。也就是说只要程序在运行，那么这块内存就会一直被占用着。

在 `Java` 程序里面，如果要使用类的成员，那么普通情况下必须先通过类实例化一个对象，通过对象的引用来访问这些成员；但是用 `static` 修饰的成员是可以通过类名（`ClassName.VariableName`）进行直接访问的，使用起来比成员变量**更加方便**。

> 当然，你也可以通过对象来访问，但是这样就把静态变量的优势给丢弃了，不推荐这样使用。

也就是说，被 `static` 修饰的成员变量（和成员方法）是独立于该类的任何对象的，它不依赖类特定的实例，被类的所有实例共享，只要这个类被加载，`Java` 虚拟机就能根据类名找到他们。对于成员变量，每创建一个实例，就会为实例变量分配一次内存，成员变量可以在内存中有多个拷贝；**而静态变量在内存中只有一个拷贝，节省内存。**

