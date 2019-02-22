---
title: MySQL要点
date: 2018-11-01 11:45:27
categories: MySQL
tags: ['MySQL']
---

在一个中大型项目中，随着时间的积累和业务的不断升级，数据的优化处理愈发关键，一个好的数据库设计和优化是项目业务稳定运行的根本

<!-- more -->

> 整理参见 [关于MySQL，你未必知道的](https://mp.weixin.qq.com/s/pWHCieOwAdCrz8cauduWlQ)

# MySQL 的基础架构
`MySQL` 是一种关系数据库产品，是建立在关系模型基础上的数据库。架构一般可分为 **应用层** ，**逻辑层**，**物理层**
- 应用层 ： 负责和客户端以及用户进行交互
- 逻辑层 ： 负责具体的查询处理，事物管理，存储管理，恢复管理等
- 物理层 ： 磁盘上的数据库文件（存储文件，日志文件等）

# MySQL 常用存储引擎比较
> 查看MySQL的默认存储引擎 `show variables like '%storage_engine%'`

- InnoDB： MySQL版本大于5.5时的默认引擎 适用于读少，写多以及高并发场景
    + 灾难恢复性好
    + 支持全部的事物[隔离级别](#事物的隔离级别)
    + 使用行级锁
    + 支持外键
    + 不支持全文索引 （全文索引可以使用**Sphinx**）
    + 按行删除
    
- MyISAM： 适用于读多，写少对原子性要求低的场景
    + 支持全文索引
    + 单独维护索引文件(MYI)
    + 不支持事物
    + 不支持外键
    + 只支持表级锁
    + 可以被压缩，存储空间小
    + 删除时会先删除表，然后重新建立表结构

# 索引比较 
>（[1分钟了解MyISAM与InnoDB的索引差异](https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651961494&idx=1&sn=34f1874c1e36c2bc8ab9f74af6546ec5&chksm=bd2d0d4a8a5a845c566006efce0831e610604a43279aab03e0a6dde9422b63944e908fcc6c05&scene=21#wechat_redirect)）

总结:
* MyISAM的索引与数据分开存储
* MyISAM的索引叶子存储指针，主键索引与普通索引无太大区别
* InnoDB的聚集索引和数据行统一存储
* InnoDB的聚集索引存储数据行本身，普通索引存储主键
* InnoDB一定有且只有一个聚集索引
* InnoDB建议使用趋势递增整数作为PK，而不宜使用较长的列作为PK

## 关于索引
> [MySQL索引背后的数据结构及算法原理](http://blog.codinglabs.org/articles/theory-of-mysql-index.html)

- 数据库索引用于加速查询
- 虽然哈希索引是O(1)，树索引是O(log(n))，但SQL有很多“有序”需求，故数据库使用树型索引，InnoDB不支持哈希索引
- 数据预读的思路是：磁盘读写并不是按需读取，而是按页预读，一次会读一页的数据，每次加载更多的数据，以便未来减少磁盘IO
- 局部性原理：软件设计要尽量遵循“数据读取集中”与“使用到一个数据，大概率会使用其附近的数据”，这样磁盘预读能充分提高磁盘 IO

### B+ 树索引
- 很适合磁盘存储，能够充分利用局部性原理，磁盘预读
- 很低的树高度，能够存储大量数据
- 索引本身占用的内存很小
- 能够很好的支持单点查询，范围查询，有序性查询

# 事物
## 事物的基本特性(ACID)
1. 原子性`Atomicity`： 事物开始后的所有操作要么回退，要么提交，不会停留在中间的某个部分，类似于化学中的原子，构成物质的最基本单位
2. 一致性`Consistency`： 事务开始前和结束后，数据库的完整性约束没有被破坏
3. 隔离性`Isolation`： 同一时间，只允许一个事务请求同一数据，不同的事务之间彼此没有任何干扰
4. 持久性`Durability`： 事务完成后，事务对数据库的所有更新将被保存到数据库，不能回滚

## 事物的隔离级别
|事物的隔离级别|脏读|不可重复度|幻读|
|--|--|--|--|
|读未提交`Read Uncommitted`| 是 | 是 | 是 |
|读提交`Read Committed` | 否 | 是 | 是 |
|可重复读`Repeated Read` (默认) | 否 | 否 | 是 |
|串行化`Serializable` | 否 | 否 | 否 |
> 设置当前事务模式为读提交: `set session transaction isolation level read committed`;

总结：
- 并发事务之间相互干扰，可能导致事务出现读脏，不可重复度，幻读等问题
- **InnoDB** 实现了 [SQL92](https://baike.baidu.com/item/SQL92) 标准中的四种隔离级别
    (1). 读未提交: select 不加锁，可能出现 **脏读**
    (2). 读提交(RC): 普通 select 快照读，锁 select / update / delete 会使用记录锁，可能出现 **不可重复读**
    (3). 可重复读(RR): 普通 select 快照读，锁 select / update / delete 根据查询条件情况，会选择记录锁，或者 间隙锁 / 临键锁，以防止读取到幻影记录 (**幻读**)
    (4). 串行化: select 隐式转化为 select ... in share mode，会被 update 与 delete 互斥
- InnoDB默认的隔离级别是RR，用得最多的隔离级别是RC

# Other
## **InnoDB** 的七种锁
(1). 共享/排它锁 `Shared and Exclusive Locks`
(2). 意向锁     `Intention Locks`
(3). 记录锁     `Record Locks`
(4). 间隙锁     `Gap Locks`
(5). 临键锁     `Next-key Locks`
(6). 插入意向锁 `Insert Intention Locks`
(7). 自增锁     `Auto-inc Locks`

## MySQL 的常见优化
### 常见优化
- 构建SQL时应避免全表扫描
- 建立索引 (先应考虑在 **where** 及 **order by** 涉及的列上建立索引)
- 尽量避免向客户端返回大数据量，若数据量过大，应该考虑相应需求是否合理
- 尽量避免大事务操作，提高系统并发能力
- 应尽量避免在 where 子句中使用 **!=** 或 `<>` 操作符，否则将引擎放弃使用索引而进行全表扫描
- 使用 **in** 来代替 **between**
- 使用 **union all** 来代替 **or**
- 避免类型转换（查询的类型要与字段的类型一致）
- 尽量不使用 **NOT IN** 和 `<>`
- 除非必要的条件下 **事物** 可以使用锁表来代替

### 索引命中
**在以下场景中MySQL不会使用索引**
- 使用 **NOT IN** 、 **!=** 以及 `<>` 不等于的时候
- 在 **join** 时条件字段类型不一致的时候
- 以 **%** 开头 的 **like** 查询
- 使用 **or** 的时候， **or** 的前后字段中存在没有索引的情况时
- 在组合索引里使用非第一个索引字段时也不使用索引

## MySQL B+Tree 演示
点击直达： https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html
