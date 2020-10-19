---
title: Java 中多线程编程
author: Deepspace
tags:
  - Java
  - 进程
  - 线程
  - 并行
  - 并发
categories: Java
date: 2017-06-29
urlname: java-multithreading-program
---

在学习 `Java` 中的多线程编程之前，我们需要先了解一下**进程和线程**的概念。

### 一、概念

#### 1、进程

**进程是一个应用程序的一次执行过程 —— 从创建、运行到消亡的过程。**所以，一个进程就是一个运行中的程序，它在计算机中按照一个接着一个的指令地执行着。

**每个进程都有自己独立的地址空间**（内存空间），比如用户打开一个软件，这就相当于启动了一个进程，操作系统就会为该进程分配独立的地址空间。当用户打开另一个软件，相当于又启动了一个进程，操作系统将为新的进程分配新的独立的地址空间。目前的操作系统基本上都支持多进程。

除了内存空间外，每个进程还占有其它系统资源，如 `CPU` 、文件资源、输入和输出设备的使用权、网络等等。

> 注意，并不是说一个应用程序只能有一个进程，一个应用程序是可以开启多个进程的，比如 `Chrome`。
>
> `Chrome` 会拥有一个主进程，其他几个进程都是这个进程的子进程，由它来管理和调配（比如插件进程、网络进程、渲染进程等）；同时我们看到的浏览器的整个窗口，包含地址输入栏，书签栏这些东西也都是主要进程来展示的。

<!-- more -->

#### 2、多进程

比如将键盘、鼠标分别写出两个独立的应用程序，独立运行，这就是多进程。

进程是独立的地址空间。正因为进程之间是独立的，所以在保护模式下，一个进程崩溃后，不会对其他进程产生影响，**可靠性更强**。所以，多进程适用于网络通信，分布式计算等应用场景。

但是多进程间的通信会比较麻烦，需要很多步骤，效率低。

#### 3、线程

线程与进程相似，但线程是一个比进程更小的执行单位。**一个进程在其执行的过程中可以产生多个线程**。

与进程不同的是：**同类的多个线程共享同一块内存空间和一组系统资源**，所以系统在产生一个线程，或是在各个线程之间作切换工作时，负担要比进程小得多 —— 因为不需要操作系统层面来划分新的资源。也正因为如此，线程也被称为轻量级进程。

#### 4、多线程

多线程就是**（几乎）同时**执行多个线程，多个线程可以**共享进程的内存资源，相互间切换更加快速**，支持更细粒度的任务控制，使进程中的子任务得以并发执行。

线程之间的交互的方式可以分为**互斥和同步**两种。怎么理解呢？

类比班级，在同一班级之内，同学之间通过相互的协作才能完成某些任务，有时这种协作是需要竞争的。比如学习，班级里的公共学习资料是有限的，需要竞争，当一个同学使用完了之后另一个同学才可以使用，如果一个同学正在使用，那么其他新来的同学只能等待。另一方面也需要同步协作，比如拔河比赛，同学们需要齐心协力相互配合，才能取得胜利。这就是线程交互。

#### 5、并发与并行

并发和并行是两个不同的概念。

##### 5.1、并发

并发的概念是：**在一个时间段内发生若干事件**。

对于单核 `CPU` 而言，同一时间，`CPU` 只能处理 `1` 个线程。多线程 "同时执行" 指的是 `CPU` 快速地在多个线程之间切换，调度线程的时间足够快，就造成了多线程的 "同时" 执行（**时间片轮转机制、分时复用**）。

如果线程数非常多，`CPU` 就会在 `n` 个线程之间切换，消耗大量的 `CPU` 资源；这时，每个线程被调度的次数就会降低，线程的执行效率也会降低。

##### 5.2、并行

并行的概念是：**在同一时刻发生若干事件**。

使用多核 `CPU` 时，可以将任务分配到不同的核同时运行，真正地实现**并行**。单核 `CPU` 是无法真正支持并行的。

可以用下面的一张图来描述**并发与并行的区别**：

<img src="https://gitee.com/IDeepspace/image-hosting/raw/master/Java/java-concurrency-parallel.jpg" alt="Java 并发与并行" />

<p align="center">（图片来自 Joe Armstrong）</p>

#### 6、多进程与多线程的区别

基于上面的描述，我们可以总结出下面选择原则：

- 需要频繁创建销毁的优先用线程；
- 需要进行大量计算的优先使用线程；
- 强相关的处理用线程，弱相关的处理用进程；

#### 7、什么是线程安全

如果代码在多线程下执行和在单线程下执行永远都能获得一样的结果，那么这个代码就是线程安全的。

### 二、线程的状态

`Java` 中线程的生命周期由 `JVM` 控制，线程的状态分为 `6` 种，可以用下面的图来表示：

<img src="https://gitee.com/IDeepspace/image-hosting/raw/master/Java/java-thread-lifecycle.jpg" alt="Java 线程的状态" />

1. 初始（`NEW`）：新创建了一个线程对象，但还没有调用 `start()` 方法；

2. 可运行（`RUNNABLE`）：`Java` 线程中将就绪（`ready`）和运行中（`running`）两种状态都称为「运行」；

3. 阻塞（`BLOCKED`）：当一个线程试图获取一个对象锁，而该对象锁又被其他的线程持有时，该线程就进入 `Blocked` 状态；当该线程持有锁时，该线程将变成 `Runnable` 状态；

   > 任何一个对象都有一个内置锁，锁的作用是保证线程同步，解决线程安全问题。关于锁的问题，这里暂不讨论。

4. 等待（`WAITING`）：进入该状态的线程需要等待其他线程做出一些特定动作（通知或中断）；

5. 超时等待（`TIMED_WAITING`）：该状态不同于 `WAITING`，它可以在指定的时间后自行返回；

6. 终止（`TERMINATED`）：表示该线程已经执行完毕。

### 三、多线程的多种实现方式

`Java` 给多线程编程提供了内置的支持。`Java` 采用单线程编程模型，即**如果没有主动创建线程，程序会自动创建一个线程，称为主线程。**我们可以这样验证：

```java
public class ThreadDemo {
  public static void main(String[] args) {
    Thread t = Thread.currentThread();
    System.out.println(t.getName() + " " + t.getId()); // main 1
  }
}
```

`Thread` 类的静态方法 `currentThread()` 用于获取当前运行的线程的引用。

- `getId()` 的作用是取得线程的唯一标识；
- `getName()` 方法可以获取线程名称。

实现多线程编程的方式主要有四种：

- 继承 `Thread` 类；
- 实现 `Runnable` 接口；
- `Callable` 接口和 `Future` 接口。

其中前两种方式线程执行完后都没有返回值，后面一种是带返回值的。下面我们通过例子来详细介绍这几种方式。

#### 1、继承 `Thread` 类

`Thread` 类本质上是实现了 `Runnable` 接口的一个实例，代表一个线程的实例。

**启动线程**的唯一方法就是通过 `Thread` 类的 `start()` 方法。**`start()` 方法将启动一个新线程，并自动执行 `run()` 方法。**也就是说 `run()` 方法是不需要用户来调用的

这种方式实现多线程很简单，通过自己的类直接继承 `Thread` 类，并重写 `run()` 方法，就可以启动新线程并执行自己定义的 `run()` 方法。看个例子：

```java
import java.io.IOException;

public class Main {
  private final Object object = new Object();
  private int i = 10;

  public static void main(String[] args) throws IOException {
    System.out.println(Thread.currentThread().getName() + " 主线程运行开始!");
    Main main = new Main();
    MyThread thread1 = main.getMyThreadInstance();
    MyThread thread2 = main.getMyThreadInstance();
    thread1.start();
    thread2.start();
    System.out.println(Thread.currentThread().getName() + " 主线程运行结束!");
  }

  private MyThread getMyThreadInstance() {
    return new MyThread();
  }


  class MyThread extends Thread {
    @Override
    public void run() {
      synchronized (object) { // synchronized 修饰代码块，其他试图访问该对象的线程将被阻塞
        i++;
        System.out.println("i:" + i);
        try {
          System.out.println("线程" + Thread.currentThread().getName() + "已启动，下面将进入休眠状态");
          sleep(10000);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        System.out.println("线程" + Thread.currentThread().getName() + "休眠结束");
        i++;
        System.out.println("i:" + i);
      }
    }
  }
}
```

输出结果为：

```
main 主线程运行开始!
main 主线程运行结束!
i:11
线程Thread-0已启动，下面将进入休眠状态
线程Thread-0休眠结束
i:12
i:13
线程Thread-1已启动，下面将进入休眠状态
线程Thread-1休眠结束
i:14
```

解释下代码：

- 为了便于演示，这里使用了内部类 `MyThread`，`MyThread` 中重写了 `run` 方法；
- `sleep(long millis)`：**在指定的毫秒数内让当前正在执行的线程休眠（暂停执行）**，相当于让线程睡眠，交出 `CPU`，让 `CPU` 去执行其他的任务；
- `synchronized` 修饰符用来修饰代码块，其他试图访问该对象的线程将被阻塞，保证一个时间段最多只有一个线程访问被修饰的代码（**加锁**）；
- 有一点要非常注意，**如果当前线程是拥有锁的，`sleep()` 方法不会释放锁**，也就是说如果当前线程持有对某个对象的锁，即使调用了 `sleep()` 方法，其他线程也无法访问这个对象，从上面的打印结果也可以验证出来这一点；
- 所以，当 `Thread-0` 进入休眠状态之后，`Thread-1` 并没有去执行具体的任务；只有当 `Thread-0` 执行完之后，此时 `Thread-0` 释放了对象锁，`Thread-1` 才开始执行。
- `sleep()` 方法也支持一个两个形参的构造函数：`sleep(long millis,int nanoseconds)`，第一参数为毫秒，第二个参数为纳秒。

**注意**，如果调用了 `sleep()` 方法，必须捕获 `InterruptedException` 异常或者将该异常向上层抛出。当线程休眠时间到达后，不一定会立即得到执行，因为此时可能 `CPU` 正在执行其他的任务。所以说调用 `sleep()` 方法相当于让线程进入**阻塞**状态。

我们也可以看到，**主线程比子线程早结束**，如果想要主线程一定会等子线程都结束了才结束该怎么办呢？使用 `join()` 方法：

```java
import java.io.IOException;

public class Main {
  private final Object object = new Object();
  private int i = 10;

  public static void main(String[] args) throws IOException {
    System.out.println(Thread.currentThread().getName() + " 主线程运行开始!");
    Main main = new Main();
    MyThread thread1 = main.getMyThreadInstance();
    MyThread thread2 = main.getMyThreadInstance();
    thread1.start();
    thread2.start();

    try {
      thread1.join();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    try {
      thread2.join();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }

    System.out.println(Thread.currentThread().getName() + " 主线程运行结束!");
  }

  private MyThread getMyThreadInstance() {
    return new MyThread();
  }


  class MyThread extends Thread {
    @Override
    public void run() {
      synchronized (object) { // synchronized 修饰代码块，其他试图访问该对象的线程将被阻塞
        i++;
        System.out.println("i:" + i);
        try {
          System.out.println("线程" + Thread.currentThread().getName() + "已启动，下面将进入休眠状态");
          sleep(10000);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        System.out.println("线程" + Thread.currentThread().getName() + "休眠结束");
        i++;
        System.out.println("i:" + i);
      }
    }
  }
}
```

`join()` 方法也是 `Thread` 类的一个方法，启动线程后直接调用。`join()` 还支持一个可以传参的构造函数：

```java
join(long millis);
```

表示等待该线程终止的时间最长时间，单位为毫秒。

在当前线程里调用其它线程的 `join()` 方法时，当前线程进入 `WAITING/TIMED_WAITING` 状态（注意：**当前线程不会释放已经持有的对象锁**），等待其它线程执行完毕或者 `millis` 时间结束，当前线程一般情况下进入 `RUNNABLE` 状态（也有可能进入 `BLOCKED` 状态）；

上面的例子中「当前线程」是主线程，它需要等待子线程的终止之后，再执行后面的代码，所以最后一句打印语句会在最后执行。

**这是一个非常常见的场景。**在很多情况下，主线程生成并起动了子线程，如果子线程里要进行大量的耗时的运算，主线程往往将于子线程之前结束，但是如果主线程处理完其他的事务后，需要用到子线程的处理结果，也就是主线程需要等待子线程执行完成之后再结束，这个时候就要用到 `join()` 方法了。

**`Thread.yield()` 方法**

这里再介绍另外一个方法：`Thread.yield()` 方法，它的作用是：暂停当前正在执行的线程对象，并执行其他线程。它做的其实是让当前运行线程回到可运行状态，以允许具有相同优先级的其他线程获得运行机会。

但是，实际中无法保证 `yield()` 达到让步目的，因为让步的线程还有可能被线程调度程序再次选中。

```java
public class YieldTest extends Thread {
  public YieldTest(String name) {
    super(name);
  }

  public static void main(String[] args) {
    YieldTest yt1 = new YieldTest("线程A");
    YieldTest yt2 = new YieldTest("线程B");

    yt1.start();
    yt2.start();
  }

  @Override
  public void run() {
    for (int i = 1; i <= 5; i++) {
      System.out.println("" + this.getName() + " ----- " + i);
      // 当i为3时，该线程就会把CPU时间让掉，让其他或者自己的线程执行（也就是谁先抢到谁执行）
      if (i == 3) {
        Thread.yield();
      }
    }
  }
}
```

**线程暂停之后，接着轮到谁执行是不确定的。**可以多运行几次上述代码，来验证 `yield()` 的特性（一般在开发中，`yield()` 不常用）。

#### 2、实现 `Runnable` 接口

如果我们自己的类本身已经继承另一个类了，那么就不能再去继承 `Thread` 类了。这个时候我们就可以实现 `Runnable` 接口。

```java
class ThreadDemo implements Runnable {
  @Override
  public void run() {
    try {
      System.out.println("线程" + Thread.currentThread().getName() + "已启动，下面将进入休眠状态");
      Thread.sleep(10000);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    System.out.println("线程" + Thread.currentThread().getName() + "休眠结束");
  }
}
```

要想启动线程，需要讲 `ThreadDemo` 实例传入 `Thread` 类的构造函数中：

```java
public class Main {
  public static void main(String[] args) {
    System.out.println(Thread.currentThread().getName() + " 主线程运行开始!");
    ThreadDemo thread0 = new ThreadDemo();
    ThreadDemo thread1 = new ThreadDemo();

    new Thread(thread0).start();
    new Thread(thread1).start();
    System.out.println(Thread.currentThread().getName() + " 主线程运行结束!");
  }
}
```

输出结果为：

```java
main 主线程运行开始!
main 主线程运行结束!
线程Thread-0已启动，下面将进入休眠状态
线程Thread-1已启动，下面将进入休眠状态
线程Thread-1休眠结束
线程Thread-0休眠结束
```

事实上，当传入一个 `Runnable` 的 `target` 给 `Thread` 后，`Thread` 的 `run()` 方法就会调用 `target.run()` 了，参考 `JDK` 源代码：

```java
@Override
public void run() {
  if (target != null) {
    target.run();
  }
}
```

#### 3、缺陷

前面介绍的两种方式都有一个缺陷：在执行完任务之后无法获取执行结果。 如果需要获取执行结果，就必须通过共享变量或者使用线程通信的方式来达到效果，这样使用起来就比较麻烦。 所以从 `Java 1.5` 开始，`Java` 就提供了 `Callable` 和 `Future`，通过它们可以在任务执行完毕之后得到任务执行结果。

#### 4、使用 `Callable` 接口

`Callable` 接口中，只有一个方法，接口的定义如下：

```java
public interface Callable<V> {
  V call() throws Exception;
}
```

可以看到，它是有返回值的。并且，`Callable` 接口是一个泛型接口，所以我们必须指出 `call()` 方法将返回的数据类型。

通过实现 `Callable` 接口的方式来实现多线程，有两种方式：

- 通过 `FutureTask`；
- 通过线程池获取

##### 4.1、通过 `FutureTask`

前面我们知道，`Runnable` 对象可以传入到 `Thread` 类的构造函数中，通过 `Thread` 来运行；而 `Callable` 接口不能直接传入到 `Thread` 中来运行，需要结合 `FutureTask` 类来使用。

```java
import java.util.concurrent.Callable;

class ThreadDemo implements Callable<Integer> {
  //想当于run方法
  @Override
  public Integer call() throws Exception {
    int sum = 0;
    for (int i = 0; i <= 1000000; i++) {
      sum += i;
    }
    return sum;
  }
}

import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;

public class TestCallable {
  public static void main(String[] args) {
    ThreadDemo td = new ThreadDemo();

    // 1.执行 Callable 方式，需要 FutureTask 实现类的支持，用于接收运算结果。
    FutureTask<Integer> result = new FutureTask<>(td);
    new Thread(result).start();

    // 2.接收线程运算后的结果
    try {
      if (!result.isDone()) {
        System.out.println("任务还没执行完");
      }
      Integer sum = result.get();  // FutureTask 可用于闭锁，会一直等待  直到子线程完成
      System.out.println(sum);
      System.out.println("----------");
    } catch (InterruptedException | ExecutionException e) {
      e.printStackTrace();
    }
  }
}
```

输出结果为：

```
任务还没执行完
1784293664
----------
```

`isDone()` 可以用于判断 `Callable` 的 `call()` 方法是否执行完成。

`get()` 方法用来阻塞当前调用它的线程，直到 `Callable` 的 `call()` 方法执行完毕为止，并且取到返回值；`get()` 方法还支持一个带有参数的重载方法：

```java
get(long timeout, TimeUnit unit)
```

这个重载方法加入了一个超时机制，超时的话抛出 `TimeoutException` 异常：

```java
import java.util.concurrent.Callable;

class ThreadDemo implements Callable<Integer> {
  @Override
  public Integer call() throws Exception {
    int sum = 0;
    for (int i = 0; i <= 1000000; i++) {
      sum += i;
    }
    return sum;
  }
}

import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class TestCallable {
  public static void main(String[] args) {
    ThreadDemo td = new ThreadDemo();

    // 1.执行 Callable 方式，需要 FutureTask 实现类的支持，用于接收运算结果。
    FutureTask<Integer> result = new FutureTask<>(td);
    new Thread(result).start();

    // 2.接收线程运算后的结果
    try {
      if (!result.isDone()) {
        System.out.println("任务还没执行完");
      }
      Integer sum = result.get(1, TimeUnit.MICROSECONDS );  // FutureTask 可用于闭锁，会一直等待  直到子线程完成
      System.out.println(sum);
      System.out.println("----------");
    } catch (InterruptedException | ExecutionException | TimeoutException e) {
      e.printStackTrace();
    }
  }
}
```

##### 4.2、通过线程池实现多线程

在开发中，我们经常会遇到这样的场景：服务器需要接受并处理请求，所以会为一个请求来分配一个线程来进行处理。如果为每次请求都新创建一个线程的话实现起来非常简便，但是存在一个问题：

**如果并发的请求数量非常多，但每个线程执行的时间很短，这样就会频繁的创建和销毁线程，如此一来会大大降低系统的效率。可能出现服务器在为每个请求创建新线程和销毁线程上花费的时间和消耗的系统资源要比处理实际的用户请求的时间和资源更多。**

那么有没有一种办法可以使线程在执行完一个任务之后，并不被销毁，而是可以继续执行其他的任务呢？

这就是线程池的作用了：**解决线程生命周期的开销和资源不足问题**。使用线程池的好处有：

- 降低资源消耗：通过重复利用已创建的线程降低线程创建和销毁造成的消耗；
- 提高响应速度：当任务到达时，任务可以不需要等到线程创建就能立即执行；
- 提高线程的可管理性：线程是稀缺资源，如果无限制的创建，不仅会消耗系统资源，还会降低系统的稳定性，使用线程池可以进行统一的分配，调优和监控。

`Java` 中的线程池是用 `ThreadPoolExecutor` 类来实现的，我们来看一下它的构造函数：

```java
public ThreadPoolExecutor(int corePoolSize,
                            int maximumPoolSize,
                            long keepAliveTime,
                            TimeUnit unit,
                            BlockingQueue<Runnable> workQueue) {
    this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
            Executors.defaultThreadFactory(), defaultHandler);
  }
```

几个核心参数的作用：

- `corePoolSize`： 线程池核心线程数最大值；
- `maximumPoolSize`： 线程池最大线程数（非核心）大小；
- `keepAliveTime`： 线程池中非核心线程空闲的存活时间大小；
- `unit`： 线程空闲存活时间单位；
- `workQueue`： 存放任务的阻塞队列；
- `threadFactory`： 用于设置创建线程的工厂，可以给创建的线程设置有意义的名字，方便排查问题；
- `handler`： 线城池的饱和策略事件（拒绝策略）；用于处理当任务来不及处理的情况。主要有四种类型。

**线程池的执行流程**可以用下图来表示：

<img src="https://gitee.com/IDeepspace/image-hosting/raw/master/Java/java-thread-pool-flow.png" alt="Java 线程池的执行流程" style="zoom:87%;" />

**创建线程池**

通过 `ExecutorService` 可以创建四种类型的线程池：

- `newFixedThreadPool`：固定数目线程的线程池

- `newCachedThreadPool`：可缓存线程的线程池

- `newSingleThreadExecutor`：单线程的线程池

- `newScheduledThreadPool`：定时及周期执行的线程池

创建的语法都是类似的，下面使用「可缓存线程池」写一个例子：

```java
import java.util.concurrent.Callable;

class ThreadDemo implements Callable<Integer> {
  @Override
  public Integer call() throws Exception {
    int sum = 0;
    for (int i = 0; i <= 1000000; i++) {
      sum += i;
    }
    return sum;
  }
}

import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class ThreadPoolDemo {
  public static void main(String[] args) {
    // 创建可缓存线程池
    ExecutorService executorService = Executors.newCachedThreadPool();
    // 往线程池提交任务
    Future<Integer> future = executorService.submit(new ThreadDemo());
    if (!future.isDone()) {
      System.out.println("任务还没执行完");
    }
    try {
      System.out.println(future.get());
      System.out.println("----------");
    } catch (InterruptedException | ExecutionException e) {
      e.printStackTrace();
    } finally {
      // 关闭线程池
      executorService.shutdown();
    }
  }
}
```

通过 `java.util.concurrent.ExecutorService` 接口对象来执行任务，该对象有两个方法可以执行任务：

- `execute()` 方法：这种方式提交没有返回值，也就是说不能判断是否执行成功；
- `submit()` 方法：这种方式它会返回一个 `Future` 对象，通过返回对象的 `get` 方法可以获取返回值；

`future.get` 方法是一个阻塞方法，当 `submit()` 提交多个任务时，只有所有任务都完成后，才能使用 `get` 按照任务的提交顺序得到返回结果，所以一般需要使用 `future.isDone` 先判断任务是否全部执行完成，完成后再使用`future.get` 得到结果。

所以，上面的代码输出结果为：

```
任务还没执行完
1784293664
----------
```

### 四、总结

`Java` 多线程编程的内容是非常多的，足够写一本书；并且在不同的应用场景有不同的最佳解决方案，本文的主要目的是为了帮助初学者初步理解及简单使用多线程，关于更多内容还需要不断学习、总结。
