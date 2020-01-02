---
title: Python 基础语法
author: Deepspace
categories: Python
date: 2019-05-12
urlname: python-basic
tags:
  - Python
---

### 一、标准数据类型

#### 1、六个标准的数据类型：

- Number（数字）

  > 支持三种不同的数值类型：整型(int)、浮点型(float)和复数(complex)

- String（字符串）

  > - 使用引号( `'` 或 `"` )来创建字符串；
  > - 三引号允许一个字符串跨多行，字符串中可以包含换行符、制表符以及其他特殊字符。

- List（列表）

  > 列表用 `[ ]` 标识，支持字符，数字，字符串甚至可以包含列表（即嵌套）。

- Tuple（元组）

  > 元组用 `()` 标识，类似于 `List`（列表）。内部元素用逗号隔开。但是元组不能二次赋值，相当于只读列表。

<!-- more -->

- Dictionary（字典）

  > 字典用 `{ }` 标识。字典由索引 `key` 和它对应的值 `value` 组成。

- Set（集合）

  > 集合 `set` 是一个无序的不重复元素序列。可以使用大括号 `{ }` 或者 `set()` 函数创建集合。
  >
  > 注意：创建一个空集合必须用 `set()` 而不是 `{ }`，因为 `{ }` 是用来创建一个空字典。
  >
  > 创建格式：
  >
  > ```python
  > parame = {value01,value02,...}
  > 或者
  > set(value)
  > ```

其中：

- 不可变数据类型（3 个）：Number（数字）、String（字符串）、Tuple（元组）；
- 可变数据类型（3 个）：List（列表）、Dictionary（字典）、Set（集合）。


#### 2、不可变数据类型与可变数据类型

**不可变数据类型的不可变指的是变量引用的地址的值是不可变的。**例如 `int` 类型，改变该类型变量的值，实际是改变了该变量引用的地址值，即改变了该变量引用的对象，并没有改变之前引用的对象的值。

- 优点：不管内存中有多少个引用，相同的对象只占用一块内存；
- 缺点：当对变量进行运算从而改变变量的值时，由于是不可变数据类型，所以需要创建新对象，不断的改变就会不断的创建新对象。但是不再使用的变量会被垃圾回收器回收。

```python
>>> x = 1
>>> id(x)
31106520
>>> y = 1
>>> id(y)
31106520
>>> x = 2
>>> id(x)
31106508
>>> y = 2
>>> id(y)
31106508
>>> z = y
>>> id(z)
31106508
```

```python
>>> x += 2
>>> id(x)
31106484 
```

**可变数据类型是指具有同样值的对象是不同的对象，即在内存中保存了多个同样值的对象，地址值不同。**可变数据类型的对象，当值发生改变时，并不会创建新的对象，只是改变了原地址的值，扩充了原地址的内容，并不会改变原地址的地址值。但是对于可变数据类型的赋值操作是会改变该变量的地址值的。

```python
>>> a = [1, 2, 3]
>>> id(a)
41568816
>>> a = [1, 2, 3]
>>> id(a)
41575088
>>> a.append(4)
>>> id(a)
41575088
>>> a += [2]
>>> id(a)
41575088
>>> a
[1, 2, 3, 4, 2]
```



#### 3、判断数据类型：

- `type()` 不会认为子类是一种父类类型

```python
>>> a, b, c, d = 20, 5.5, True, 4+3j
>>> print(type(a), type(b), type(c), type(d))
<class 'int'> <class 'float'> <class 'bool'> <class 'complex'>
```

```python
>>>a = 111
>>> isinstance(a, int)
True
>>>
```

- `isinstance()` 会认为子类是一种父类类型

```python
>>> class A:
...     pass
... 
>>> class B(A):
...     pass
... 
>>> isinstance(A(), A)
True
>>> type(A()) == A 
True
>>> isinstance(B(), A)
True
>>> type(B()) == A
False
```



### 二、函数

#### 1、参数传递

##### 传不可变对象实例

```python
def change_int(a):
    a = 10

b = 2
change_int(b)
print(b)  # 结果是 2
```

##### 传可变对象实例

```python
def change_me(myList):
    myList.append([1, 2, 3, 4])
    print("函数内取值: ", myList)  # 函数内取值:  [10, 20, 30, [1, 2, 3, 4]]
    return


myList = [10, 20, 30]
change_me(myList)
print("函数外取值: ", myList)  # 函数内取值:  [10, 20, 30, [1, 2, 3, 4]]
```

传入函数的和在末尾添加新内容的对象用的是同一个引用。故输出结果如下：

```python
函数内取值:  [10, 20, 30, [1, 2, 3, 4]]
```

有的时候，我们需要禁止函数修改列表，怎么做呢？向函数传递副本而不是原件：

```python
def print_models(unprinted_designs, completed_models):
    while unprinted_designs:
        current_design = unprinted_designs.pop()
        
        print(completed_models)
        
        completed_models.append(current_design)


unprinted_designs = ['a', 'b', 'c']
completed_models = []

print_models(unprinted_designs[:], completed_models)

print(unprinted_designs)
```

使用切片表示法 `[:]` 创建列表的副本。



#### 2、关键字实参

```python
def describe_pet(animal_type, pet_name):
    print("\nI have a " + animal_type + ".")
    print("My " + animal_type + "'s name is " + pet_name.title() + '.')


describe_pet(animal_type='hamster', pet_name='harry')
```

打印结果：

```
I have a hamster.
My hamster's name is Harry.
```



#### 3、传递任意数量的实参

```python
def make_pizza(*toppings):
    print(toppings)


make_pizza('pepperoni')  # ('pepperoni',)
make_pizza('mushrooms', 'green peppers', 'extra cheese')  # ('mushrooms', 'green peppers', 'extra cheese')
```

形参名 `*toppings` 中的星号让 `Python` 创建一个名为 `toppings` 的空元组，并将接收到的所有值都封装在这个元素中(即使函数只接收到一个值)。

因为 Python 将实参封装到一个元组中了，所以我们可以使用元组的方法：

```python
def make_pizza(*toppings):
    print("\nMaking a pizza with the following toppings:")
    for topping in toppings:
        print("-" + topping)


make_pizza('pepperoni')
make_pizza('mushrooms', 'green peppers', 'extra cheese')
```

结果如下：

```
Making a pizza with the following toppings:
-pepperoni

Making a pizza with the following toppings:
-mushrooms
-green peppers
-extra cheese
```

如果要让函数接受不同类型的实参，必须在函数定义中将接纳任意数量实参的形参放在最后。`Python` 先匹配位置实参和关键字实参，再将余下的实参都收集到最后一个形参中。

```python
def make_pizza(size, *toppings):
    print("\nMaking a " + str(size) + " pizza with the following toppings:")
    for topping in toppings:
        print("-" + topping)


make_pizza(12, 'pepperoni')
make_pizza(16, 'mushrooms', 'green peppers', 'extra cheese')
```

结果：

```
Making a 12 pizza with the following toppings:
-pepperoni

Making a 16 pizza with the following toppings:
-mushrooms
-green peppers
-extra cheese
```



#### 4、将函数存储在模块中

可以将函数存储在被称为**模块**的独立文件中，再通过 `import` 语句将模块导入到主程序当中。

`helper.py` :

```python
def describe_pet(animal_type, pet_name):
    print("\nI have a " + animal_type + ".")
    print("My " + animal_type + "'s name is " + pet_name.title() + '.')


def make_pizza(size, *toppings):
    print("\nMaking a " + str(size) + " pizza with the following toppings:")
    for topping in toppings:
        print("-" + topping)
```

`index.py` :

**导入整个模块**

```python
import helper

helper.describe_pet(animal_type='hamster', pet_name='harry')
helper.make_pizza(16, 'mushrooms', 'green peppers', 'extra cheese')
```

**导入特定的函数**

```python
from helper import describe_pet
from helper import make_pizza

describe_pet(animal_type='hamster', pet_name='harry')
make_pizza(16, 'mushrooms', 'green peppers', 'extra cheese')
```

**使用 `as` 给函数指定别名**

```python
from helper import describe_pet as dp
from helper import make_pizza as mp

dp(animal_type='hamster', pet_name='harry')
mp(16, 'mushrooms', 'green peppers', 'extra cheese')
```

**使用 `as` 给模块指定别名**

```python
import helper as h

h.describe_pet(animal_type='hamster', pet_name='harry')
h.make_pizza(16, 'mushrooms', 'green peppers', 'extra cheese')
```

**导入模块中的所有函数**

```python
from helper import *

describe_pet(animal_type='hamster', pet_name='harry')
make_pizza(16, 'mushrooms', 'green peppers', 'extra cheese')
```



### 三、类

#### 1、创建和使用类

**创建 `Dog` 类**

根据 `Dog` 类创建的每个实例都将存储名字和年龄，并赋予每条小狗蹲下(`site()`) 和打滚(`roll_over`)的能力：

```python
class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def sit(self):
        print(self.name.title() + " is now sitting")
    
    def roll_over(self):
        print(self.name.title() + " rolled over!")
```

- 类中的函数成为**方法**，`__init__()` 是一个特殊的方法，每当根据 `Dog` 类创建实例时，`Python` 都会自动运行它；
- `__init__()` 方法的定义中，形参 `self` 必不可少，还必须位于其他形参前面。



#### 2、根据类创建实例

```python
my_dog = Dog('willie', 6)
# 访问属性
print("My dog's name is " + my_dog.name.title() + '.')
print("My dog " + str(my_dog.age) + " years old.")

# 调用方法
my_dog.sit()
my_dog.roll_over()
```



#### 3、给属性指定默认值

```python
class Car:
    def __init__(self, make, model, year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0
    
    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + ' ' + self.make + ' ' + self.model
        return long_name.title()
    
    def read_odometer(self):
        """打印一条支出汽车里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")


my_new_car = Car('audi', 'a4', 2016)
print(my_new_car.get_descriptive_name())
my_new_car.read_odometer()
```

打印：

```
2016 Audi A4
This car has 0 miles on it.
```



#### 4、修改属性的值  

##### 直接修改属性的值

要修改属性的值，最简单的方式是通过实例直接访问它：

```python
my_new_car = Car('audi', 'a4', 2016)
print(my_new_car.get_descriptive_name())
my_new_car.read_odometer()
my_new_car.odometer_reading = 23
my_new_car.read_odometer()
```

打印：

```
2016 Audi A4
This car has 0 miles on it.
This car has 23 miles on it.
```

##### 通过方法修改属性的值

```python
class Car:
    def __init__(self, make, model, year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0
    
    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + ' ' + self.make + ' ' + self.model
        return long_name.title()
    
    def read_odometer(self):
        """打印一条支出汽车里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")
    
    def update_odometer(self, mileage):
        """将里程表读书设置为指定的值"""
        if mileage >= self.odometer_reading:
            self.odometer_reading = mileage
        else:
            print("You can't roll back an odometer")


my_new_car = Car('audi', 'a4', 2016)
print(my_new_car.get_descriptive_name())
my_new_car.read_odometer()
my_new_car.update_odometer(23)
my_new_car.read_odometer()
my_new_car.update_odometer(22)
my_new_car.read_odometer()
```

打印：

```python
2016 Audi A4
This car has 0 miles on it.
This car has 23 miles on it.
You can't roll back an odometer
This car has 23 miles on it.
```

##### 通过方法对属性的值进行递增

```python
class Car:
    def __init__(self, make, model, year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0
    
    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + ' ' + self.make + ' ' + self.model
        return long_name.title()
    
    def read_odometer(self):
        """打印一条支出汽车里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")
    
    def update_odometer(self, mileage):
        """将里程表读书设置为指定的值"""
        if mileage >= self.odometer_reading:
            self.odometer_reading = mileage
        else:
            print("You can't roll back an odometer")
    
    def increment_odometer(self, miles):
        self.odometer_reading += miles


my_used_car = Car('subaru', 'outback', 2013)
print(my_used_car.get_descriptive_name())

my_used_car.update_odometer(23500)
my_used_car.read_odometer()

my_used_car.increment_odometer(100)
my_used_car.read_odometer()
```

打印：

```
2013 Subaru Outback
This car has 23500 miles on it.
This car has 23600 miles on it.
```



### 四、继承

如果你要编写的类是另一个现成类的特殊版本，可使用**继承**。一个类继承另一个类时，它将自动获得另一个类的所有属性和方法：原有的类称为父类，新类称为子类。子类继承了其父类所有的属性和方法，同时还可以定义的自己的属性和方法。

#### 1、子类的方法 `__init__`

下面创建一个简单的 `ElectricCar` 类版本，它具备 `Car` 类的所有功能：

`ElectricCar.py` :

```python
class Car:
    def __init__(self, make, model, year):
        """初始化描述汽车的属性"""
        self.make = make
        self.model = model
        self.year = year
        self.odometer_reading = 0
    
    def get_descriptive_name(self):
        """返回整洁的描述性信息"""
        long_name = str(self.year) + ' ' + self.make + ' ' + self.model
        return long_name.title()
    
    def read_odometer(self):
        """打印一条支出汽车里程的消息"""
        print("This car has " + str(self.odometer_reading) + " miles on it.")
    
    def update_odometer(self, mileage):
        """将里程表读书设置为指定的值"""
        if mileage >= self.odometer_reading:
            self.odometer_reading = mileage
        else:
            print("You can't roll back an odometer")
    
    def increment_odometer(self, miles):
        self.odometer_reading += miles


class ElectricCar(Car):
    """电动汽车的特殊之处"""
    
    def __init__(self, make, model, year):
        super().__init__(make, model, year)


my_tesla = ElectricCar('tesla', 'model s', 2016)
print(my_tesla.get_descriptive_name())
```

打印：

```
2016 Tesla Model S
```

定义子类时，必须在括号内指定父类的名称。方法 `__init__()` 接受创建 `Car`  实例所需要的信息。

`super()` 是一个特殊的函数，帮助 `Python` 将父类和子类关联起来。这行代码让 `Python` 调用 `ElectricCar` 的父类的方法 `__init__() ` ，让 `ElectricCar` 实例包含父类的所有属性。父类也称为**超类**(`superclass`)，名称 `super` 因此而得名。



#### 2、Python 2.7 中的继承

在 `Python 2.7` 中，继承的语法稍有不同：

```python
class Car(object):
    def __init__(self, make, model, year):
        --snip--

class ElectricCar(Car):
    """电动汽车的特殊之处"""
    
    def __init__(self, make, model, year):
        super(ElectricCar, self).__init__(make, model, year)
```

函数 `super()` 需要两个实参：子类名和对象 `self` 。另外，在 `Python 2.7` 中使用继承时，务必在定义父类时在括号内指定 `object`。



#### 3、给子类定义属性和方法

让一个类继承另一个类后，可添加区分子类和父类所需的新属性和方法。

下面添加一个电动汽车的特有属性(电瓶)，以及一个描述该属性的方法：

```python
class ElectricCar(Car):
    """电动汽车的特殊之处"""
    
    def __init__(self, make, model, year):
        super().__init__(make, model, year)
        self.battery_size = 70
    
    def describe_battery(self):
        """打印一条描述电瓶容量的消息"""
        print("This car has a " + str(self.battery_size) + "-kwh battery.")


my_tesla = ElectricCar('tesla', 'model s', 2016)
print(my_tesla.get_descriptive_name())
my_tesla.describe_battery()
```



#### 4、重写父类的方法

对于父类的方法，可以在子类中定义同名方法来重写它。这样，`Python` 将不会考虑父类方法，而只关注在子类中定义的方法。

假设 `Car` 类有一个名为 `fill_gas_tank()` 的方法，这个方法对全电动汽车毫无意义，因此我们可以重写它：

```python
class ElectricCar(Car):
    --snip--
        
    def fill_gas_tank(self):
        """电动汽车没有邮箱"""
        print("This car doesn't need a gas tank!")
```

使用继承时，取其精华，弃其糟粕。



#### 5、将实例用作属性

使用代码模拟实物时，我们会发现自己给类添加的细节越来越多：属性和方法清单以及文件都会越来越长。在这种情况下，可能需要将类的一部分作为一个独立的类提取出来，将大型类拆分为多个协同工作的小类。

```python
class Battery:
    def __init__(self, battery_size=70):
        """初始化电瓶的属性"""
        self.battery_size = battery_size
    
    def describe_battery(self):
        """打印一条描述电瓶容量的消息"""
        print("This car has a " + str(self.battery_size) + "-kwh battery.")


class ElectricCar(Car):
    """电动汽车的特殊之处"""
    
    def __init__(self, make, model, year):
        super().__init__(make, model, year)
        self.battery = Battery()


my_tesla = ElectricCar('tesla', 'model s', 2016)
my_tesla.battery.describe_battery()
```

我们定义了一个名为 `Battery` 的新类。在 `ElectricCar` 类中，添加了一个名为 `self.battery` 的属性。这行代码让 `Python` 创建一个新的 `Battery` 实例(由于没有指定尺寸，因此为默认值70)，并将实例存储在属性 `self.battery` 中，每当方法 `__init__()` 被调用时，都将执行该操作；因此现在每个 `ElectricCar` 实例都包含一个自动创建的 `Battery` 实例。
