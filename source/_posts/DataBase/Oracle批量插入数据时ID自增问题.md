---
title: Oracle批量插入数据时ID自增问题
author: Deepspace
categories: DataBase
date: 2019-07-29
urlname: oracle-id-increase
tags:
  - Oracle
---

<!-- ## Oracle批量插入数据时ID自增问题 -->

**三步走：**

1、创建序列 sequence

```sql
create sequence seq_stu
      increment by 1    -- 每次递增1
      start with 1       -- 从1开始
      nomaxvalue      -- 没有最大值
      minvalue 1       -- 最小值=1
      NOCYCLE;      -- 不循环
```

2、为序列创建触发事件

```sql
create or replace trigger student_id_automation
  before insert
  on student
  for each row
begin
  IF :new.id IS NULL THEN :new.id := seq_stu.nextval;
  end if;
end;
```
<!-- more -->
3、批量插入

```sql
insert into student(...)...
```

