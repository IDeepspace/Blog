---
title: MySQL 笔记
author: Deepspace
categories: DataBase
date: 2016-03-29
urlname: mysql-note
tags:
  - Mysql
  - Docker
---

### 一、安装

网络上已经有很多讲述如何在 `Windows`、`Mac`、和 `Ubuntu` 等环境上安装 `MySQL` 的教程了，这里就不再赘述。

为了不在本地机器上设置太多的环境，这里我们使用 `Docker` 来安装 `MySQL` 并学习如何使用。

#### 1、安装 Docker

`Mac` 客户端下：

```bash
$ brew cask install docker
```

也可以手动下载 `.dmg` 格式安装包进行安装。

其它环境安装 `Docker` 的方式可以参考官方文档：https://docs.docker.com/get-docker/

验证安装：

```bash
$ docker --version
```

输出所安装的 `Docker` 版本。

#### 2、拉取 MySQL 镜像

这里我们拉取最新版本的镜像：

```bash
$ docker pull mysql
```

#### 3、启动 MySQL 容器

```bash
$ docker run -d -p 127.0.0.1:3306:3306 --name test_mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:latest
```

这里没有将容器中的数据映射出来；如果需要，可以在本机创建一个用作数据持久化的目录，将容器中的数据映射到本机该目录中：

```bash
$ docker run -d -p 127.0.0.1:3306:3306 --name mysql -v /Users/cxin/Development/persistent-local-data-for-mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD="123456" mysql:latest
```

验证启动：

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                 NAMES
f0da3247bdd4        mysql:latest        "docker-entrypoint.s…"   56 seconds ago      Up 54 seconds       127.0.0.1:3306->3306/tcp, 33060/tcp   test_mysql
```

我们可以进入 `test_mysql` 容器：

```bash
$ docker exec -it test_mysql bash
$ root@f0da3247bdd4:/#
```

在容器内登陆 `Mysql`：

```bash
$ root@f0da3247bdd4:/# mysql -uroot -p123456
mysql>
```

登录后会显示 `mysql` 命令。

显示所有数据库：

```bash
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
```

退出登录：

```bash
mysql> exit;
```

#### 4、通过客户端来连接

由于前面我们已经把数据库容器的端口映射出来了，所以我们也可以通过一些「数据库可视化客户端」或者「程序代码」进行数据库连接：

```
Host: 127.0.0.1
Port: 3306
User: root
Password: 123456
```

这里推荐一些可视化数据库工具：

- `DataGrip`：`Jetbrain` 家的产品，收费；
- `DBeaver`：功能强大，免费；
- `Navicat`：收费。

### 二、导入演示数据

为了便于演示，这里需要先导入一份数据库数据：

> 链接:https://pan.baidu.com/s/1brD2UJKWgpO0GKicFkyyiA 密码:4nqz

如何导入？

假设下载解压后的文件在本机的存储地址为：`/Users/cxin/Downloads/mysqlsampledatabase.sql`。

首先需要将宿主机（本机）上的文件拷贝至容器中，执行命令：

```bash
$ docker cp /Users/cxin/Downloads/mysqlsampledatabase.sql f0da3247bdd4:/opt/
```

进入容器，在容器内登陆 `Mysql` 并执行数据库脚本文件：

```bash
$ docker exec -it test_mysql bash
$ root@f0da3247bdd4:/opt# mysql -uroot -p123456
mysql> source /opt/mysqlsampledatabase.sql
```

该脚本会创建一个名为 `classicmodels` 的数据库，并写入一些数据。

```bash
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| classicmodels      |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```

数据库的表之间的关系为：

<img src="https://deepspace.coding.net/p/personal-blog/d/ImageHosting/git/raw/master/DB/MySQL-Sample-Database-Schema.png" alt="MySQL-Sample-Database-Schema" />

接下来的 `SQL` 语句讲解都是基于上面所导入的数据。

### 二、查询

#### 1、SELECT

语法：

```mysql
SELECT select_list
FROM table_name;
```

例子：

查询一张表中的所有数据：

```mysql
SELECT * FROM employees;
```

查询一条数据：

```mysql
SELECT lastName
FROM employees;
```

查询多条数据

```mysql
SELECT
    lastname,
    firstname,
    jobtitle
FROM
    employees;
```

### 三、排序

#### 1、ORDER BY

语法：

```mysql
SELECT
   select_list
FROM
   table_name
ORDER BY
   column1 [ASC|DESC],
   column2 [ASC|DESC],
   ...;
```

例子：

```mysql
SELECT
    contactLastname,
    contactFirstname
FROM
    customers
ORDER BY
    contactLastname DESC,
    contactFirstname ASC;
```

也可以写表达式：

```mysql
SELECT
    orderNumber,
    orderlinenumber,
    quantityOrdered,
    priceEach,
    quantityOrdered * priceEach as subtotal
FROM
    orderdetails
ORDER BY
   quantityOrdered * priceEach DESC;
```

#### 2、FIELD

分类排序：

```mysql
SELECT
    orderNumber,
    status
FROM
    orders
ORDER BY
    FIELD(status,
        'In Process',
        'On Hold',
        'Cancelled',
        'Resolved',
        'Disputed',
        'Shipped');
```

### 四、过滤

#### 1、WHERE

语法：

```mysql
SELECT
    select_list
FROM
    table_name
WHERE
    search_condition;
```

例子：

```mysql
SELECT
    lastname,
    firstname,
    jobtitle
FROM
    employees
WHERE
    jobtitle = 'Sales Rep';
```

使用 `AND`：

```mysql
SELECT
    lastname,
    firstname,
    jobtitle,
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' AND
    officeCode = 1;
```

使用 `OR`：

```mysql
SELECT
    lastName,
    firstName,
    jobTitle,
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' OR
    officeCode = 1
ORDER BY
    officeCode ,
    jobTitle;
```

使用 `BETWEEN` ：

```mysql
SELECT
    firstName,
    lastName,
    officeCode
FROM
    employees
WHERE
    officeCode BETWEEN 1 AND 3
ORDER BY officeCode;
```

使用 `LIKE` ：

```mysql
SELECT
    firstName,
    lastName
FROM
    employees
WHERE
    lastName LIKE '%son'
ORDER BY firstName;
```

使用 `IN` ：

```mysql
SELECT
    firstName,
    lastName,
    officeCode
FROM
    employees
WHERE
    officeCode IN (1 , 2, 3)
ORDER BY
    officeCode;
```

使用 `IS NULL` ：

```mysql
SELECT
    lastName,
    firstName,
    reportsTo
FROM
    employees
WHERE
    reportsTo IS NULL;
```

过滤时也可以使用数学比较符：

| Operator | Description                                                            |
| :------- | :--------------------------------------------------------------------- |
| =        | Equal to. You can use it with almost any data types.                   |
| <> or != | Not equal to                                                           |
| <        | Less than. You typically use it with numeric and date/time data types. |
| >        | Greater than.                                                          |
| <=       | Less than or equal to                                                  |
| >=       | Greater than or equal to                                               |

如：

```mysql
SELECT
    lastname,
    firstname,
    officeCode
FROM
    employees
WHERE
    officecode > 5;
```

不等于我们也可以这样写：

```sql
SELECT
    lastname,
    firstname,
    jobtitle
FROM
    employees
WHERE
    jobtitle <> 'Sales Rep';
```

#### 2、DISTINCT

`DISTINCT` 可以用来去除重复元素。

语法：

```mysql
SELECT DISTINCT
    select_list
FROM
    table_name;
```

例子：

```mysql
SELECT
    DISTINCT lastname
FROM
    employees
ORDER BY
    lastname;
```

> 注意：如果有多条数据的值为 `NULL` 值，MySQL 也只会查出来一条。

在多个 `COLUMN` 中去重：

```mysql
SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY
    state,
    city;
```

这个时候，`Mysql` 会使用这些列中的值的组合来确定唯一性。

在 `DISTINCT` 中使用表达式：

```mysql
SELECT
    COUNT(DISTINCT state)
FROM
    customers
WHERE
    country = 'USA';
```

`DISTINCT` 和 `LIMIT` 结合使用：

```mysql
SELECT DISTINCT
    state
FROM
    customers
WHERE
    state IS NOT NULL
LIMIT 5;
```

`LIMIT` 可用于限制查询的数量。

#### 3、GROUP BY

`GROUP BY` 的效果和 `DISTINCT` 类似，也可以去重。当然 `GROUP BY` 还可以支持更多的表达式。

```mysql
SELECT
    state
FROM
    customers
GROUP BY state;
```

`GROUP BY` 的作用是按照指定的规则对数据进行分组，下面会讲到。

### 五、联表查询

#### 1、设置别名

我们可以为 `Table` 或者 `Column` 以及一些表达式的结果设置别名（`alias`）。

语法：

```mysql
SELECT
   [column_1 | expression] AS descriptive_name
FROM table_name;
```

如果别名中包含空格，就需要这样写：

```mysql
SELECT
   [column_1 | expression] AS `descriptive name`
FROM
   table_name;
```

用指定的字符连接字符串 `CONCAT_WS`，看个综合的例子：

```mysql
SELECT
    CONCAT_WS(', ', lastName, firstname) `Full name`
FROM
    employees
ORDER BY
    `Full name`;
```

配合 `HAVING` 使用：

```mysql
SELECT
    orderNumber `Order no.`,
    SUM(priceEach * quantityOrdered) total
FROM
    orderdetails
GROUP BY
    `Order no.`
HAVING
    total > 60000;
```

#### 2、JOIN

下面我们来看一下如何在两张或者两张以上的表中查询数据。

一个关系数据库由多个相关的表组成，表之间使用公共的列连接在一起，这些列被称为外键。

以我们导入的数据库为例， `orders` 和 `orderdetails` 这两张表就使用 `orderNumber` 这个外键进行连接。如果要获得完整的订单信息就需要联表查询，这就是 `JOIN` 的作用。

语法：

```mysql
SELECT column_list
FROM table_1
INNER JOIN table_2 ON join_condition;
```

例子：

```mysql
SELECT
    o.orderNumber,
    o.orderDate,
    o.orderNumber,
    o.status,
    od.priceEach,
    od.quantityOrdered,
    od.productCode
FROM orders o
INNER JOIN orderdetails od on o.orderNumber = od.orderNumber;
```

上面的语句等同于：

```mysql
SELECT
    o.orderNumber,
    o.orderDate,
    o.orderNumber,
    o.status,
    od.priceEach,
    od.quantityOrdered,
    od.productCode
FROM orders o, orderdetails od
WHERE o.orderNumber = od.orderNumber;
```

当然，这里也可以省略 `INNER` 使用 `JOIN`，效果是一样的。

#### 3、LEFT JOIN

`LEFT JOIN` 与 `JOIN` 有所不同。`LEFT JOIN` 以左表为基准，会读取左表的全部数据，如果右表无对应数据则显示 `Null`。

```mysql
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o
    ON c.customerNumber = o.customerNumber;
```

#### 4、RIGHT JOIN

和左连接刚好相反，以右表为基准，会读取右表的全部数据，如果左表无对应数据则显示 `Null`。

```mysql
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o
    ON c.customerNumber = o.customerNumber;
```

#### 5、CROSS JOIN

`CROSS JOIN` （交叉连接）：交叉联接返回左表中的所有行，左表中的每一行与右表中的所有行组合。

```mysql
SELECT
    employeeNumber,
    customerNumber
FROM
    customers
CROSS JOIN employees
    ON salesRepEmployeeNumber = employeeNumber
LIMIT 20;
```

### 六、分组

#### 1、GROUP BY

语法：

```mysql
SELECT
    c1, c2,..., cn, aggregate_function(ci)
FROM
    table
WHERE
    where_conditions
GROUP BY c1 , c2,...,cn;
```

例子：

```mysql
SELECT
    status,
    COUNT(*)
FROM
    orders
GROUP BY
    status
ORDER BY
    status DESC;
```

#### 2、HAVING

`HAVING` 的作用是筛选满足条件的组，即在分组之后过滤数据，条件中经常包含聚组函数。

> 在 `SQL` 中增加 `HAVING` 原因是，`WHERE` 关键字无法与合计函数一起使用。

语法：

```mysql
SELECT
    select_list
FROM
    table_name
WHERE
    search_condition
GROUP BY
    group_by_expression
HAVING
    group_condition;
```

例子：

```mysql
SELECT
    a.ordernumber,
    status,
    SUM(priceeach*quantityOrdered) total
FROM
    orderdetails a
INNER JOIN orders b
    ON b.ordernumber = a.ordernumber
GROUP BY
    ordernumber,
    status
HAVING
    status = 'Shipped' AND
    total > 1500
ORDER BY
    total
LIMIT 10;
```

### 七、修改数据

#### 1、INSERT

用作插入数据。

语法：

```mysql
INSERT INTO table(c1,c2,...)
VALUES
   (v11,v12,...),
   (v21,v22,...),
    ...
   (vnn,vn2,...);
```

例子：

```mysql
CREATE TABLE projects(
    project_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY(project_id)
);

INSERT INTO
    projects(name, start_date, end_date)
VALUES
    ('AI for Marketing','2019-08-01','2019-12-31'),
    ('ML for Sales','2019-05-15','2019-11-20');
```

使用 `SELECT` 语句的结果作为 `INSERT` 语句的数据源：

```mysql
CREATE TABLE suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);

INSERT INTO suppliers (
    supplierName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
)
SELECT
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state ,
    postalCode,
    country,
    customerNumber
FROM
    customers
WHERE
    country = 'USA' AND
    state = 'CA';
```

当使用 `INSERT` 语句向一个表中添加多个行时，如果在处理过程中出现错误，`MySQL` 将终止该语句并返回一个错误，表中不会插入任何行。

使用 `INSERT IGNORE` 语句，则会忽略导致错误的包含无效数据的行，并将包含有效数据的行插入到表中。

```mysql
CREATE TABLE subscribers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL UNIQUE
);

INSERT IGNORE INTO subscribers(email)
VALUES('john.doe@gmail.com'),
      ('john.doe@gmail.com');
```

#### 2、UPDATE

`UPDATE` 语句用于修改表中的现有数据。

语法：

```mysql
UPDATE [LOW_PRIORITY] [IGNORE] table_name
SET
    column_name1 = expr1,
    column_name2 = expr2,
    ...
[WHERE
    condition];
```

例子：

```mysql
UPDATE employees
SET
    email = 'mary.patterson@classicmodelcars.com'
WHERE
    employeeNumber = 1056;

SELECT
    firstname,
    lastname,
    email
FROM
    employees
WHERE
    employeeNumber = 1056;
```

更新多列数据：

```mysql
UPDATE employees
SET
    lastname = 'Hill',
    email = 'mary.hill@classicmodelcars.com'
WHERE
    employeeNumber = 1056;

SELECT
    firstname,
    lastname,
    email
FROM
    employees
WHERE
    employeeNumber = 1056;
```

#### 3、UPDATE JOIN

使用 `UPDATE JOIN` 语句执行跨表更新。

准备数据：

```mysql
CREATE DATABASE IF NOT EXISTS empdb;

USE empdb;

-- create tables
CREATE TABLE merits (
    performance INT(11) NOT NULL,
    percentage FLOAT NOT NULL,
    PRIMARY KEY (performance)
);

CREATE TABLE employees (
    emp_id INT(11) NOT NULL AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    PRIMARY KEY (emp_id),
    CONSTRAINT fk_performance FOREIGN KEY (performance)
        REFERENCES merits (performance)
);
-- insert data for merits table
INSERT INTO merits(performance,percentage)
VALUES(1,0),
      (2,0.01),
      (3,0.03),
      (4,0.05),
      (5,0.08);
-- insert data for employees table
INSERT INTO employees(emp_name,performance,salary)
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000);
```

跨表更新：

```mysql
UPDATE employees
        INNER JOIN
    merits ON employees.performance = merits.performance
SET
    salary = salary + salary * percentage;
```

#### 4、DELETE

删除表中的数据。

```mysql
DELETE FROM customers
WHERE country = 'France'
ORDER BY creditLimit
LIMIT 5;
```

如果有外键约束，则无法删除数据，需要先删除外键约束。

#### 5、DELETE JOIN

联表删除。

```mysql
DELETE customers
FROM customers
        LEFT JOIN
    orders ON customers.customerNumber = orders.customerNumber
WHERE
    orderNumber IS NULL;

SELECT
    c.customerNumber,
    c.customerName,
    orderNumber
FROM
    customers c
        LEFT JOIN
    orders o ON c.customerNumber = o.customerNumber
WHERE
    orderNumber IS NULL;
```

#### 6、REPLACE

使用 `REPLACE` 语句可以在数据库表中插入或更新数据。

`REPLACE`语句的工作原理如下：

- 如果给定行数据不存在，那么 `REPLACE` 语句会插入一个新行；
- 如果给定行数据存在，则 `REPLACE` 语句首先删除旧行，然后插入一个新行。

```mysql
CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    population INT NOT NULL
);

INSERT INTO cities(name,population)
VALUES('New York',8008278),
      ('Los Angeles',3694825),
      ('San Diego',1223405);

SELECT * from cities;

REPLACE INTO cities(id,population)
VALUES(2,3696820);
```

因为 `2` 已经存在，所以先删除这一条数据，因为没有设置 `name` 的值，所以插入后的第二条数据 `name` 为 `null`。

使用 `REPLACE` 更新一条数据：

```mysql
REPLACE INTO cities
SET id = 4,
    name = 'Phoenix',
    population = 1768980;
```

使用 `REPLACE` 拷贝一条数据：

```mysql
REPLACE INTO
    cities(name,population)
SELECT
    name,
    population
FROM
   cities
WHERE id = 1;
```

### 八、最后

参考：https://www.mysqltutorial.org/basic-mysql-tutorial.aspx
