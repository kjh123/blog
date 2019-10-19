---
title: PHP常用知识整理
tags:
  - PHP
top: 98
sticky: 98
categories: PHP
translate_title: common-knowledge-of-php
date: 2019-10-01 11:45:27
---

PHP 常见知识点整理

<!-- more -->

## PHP7底层运行机制
参考链接：
[浅析 PHP7 底层运行机制](https://learnku.com/articles/32343)
[【PHP7源码分析】PHP7语言的执行原理](https://zhuanlan.zhihu.com/p/42215849)
> 运行过程：
> PHP 代码 => Token标识 => 抽象语法树(AST) => Opcodes => 执行

1. 源代码通过词法分析得到 Token
- Token 是 PHP 代码被切割成的有意义的标识。PHP7 一共有 137 种 Token，在 zend_language_parser.h 文件中做了定义。
2. 基于语法分析器将 Token 转换成抽象语法树（AST）
- Token 就是一个个的词块，但是单独的词块不能表达完整的语义，还需要借助一定的规则进行组织串联。所以就需要语法分析器根据语法匹配 Token，将 Token 进行串联。语法分析器串联完 Token 后的产物就是抽象语法树（AST，Abstract Syntax Tree）
- AST 是 PHP7 版本的新特性，之前版本的 PHP 代码的执行过程中是没有生成 AST 这一步的。它的作用主要是实现了 PHP 编译器和解释器的解耦，提升了可维护性
3. 将语法树转换成 Opcode
- 需要将语法树转换成 Opcode，才能被引擎直接执行
4. 执行 Opcodes
- opcodes 是 opcode 的集合形式，是 PHP 执行过程中的中间代码。PHP 工程优化措施中有一个比较常见的 “开启 opcache”，指的技术这里将 opcodes 进行缓存。通过省去从源码到 opcode 的阶段，引擎直接执行缓存好的 opacode，以提升性能

### PHP7 内核架构
![10ec442783c3ece026a3448bfebcf0b2.png](evernotecid://4E686A16-6940-466A-9D0C-A1B9FD748218/appyinxiangcom/19244053/ENResource/p77)

#### Zend 引擎
词法 / 语法分析、AST 编译和 opcodes 的执行均在 Zend 引擎中实现。此外，PHP 的变量设计、内存管理、进程管理等也在引擎层实现。

#### PHP层
zend 引擎为 PHP 提供基础能力，而来自外部的交互则需要通过 PHP 层来处理。

#### SAPI
server API 的缩写，其中包含了场景的 cli SAPI 和 fpm SAPI。只要遵守定义好的 SAPI 协议，外部模块便可与 PHP 完成交互。

#### 扩展部分
依据 zend 引擎提供的核心能力和接口规范，可以进行开发扩展

## Session有效期
1. 设置seesion.cookie_lifetime有30分钟，并设置session.gc_maxlifetime为30分钟
2. 自己为每一个Session值增加timestamp
3. 每次访问之前, 判断时间戳

## PHP 运行的生命周期
- 模块初始化阶段 (Module init)：即调用每个拓展源码中的的 PHP_MINIT_FUNCTION 中的方法初始化模块，进行一些模块所需变量的申请，内存分配等。
- 请求初始化阶段 (Request init)：即接受到客户端的请求后调用每个拓展的 PHP_RINIT_FUNCTION 中的方法，初始化 PHP 脚本的执行环境。
- 执行该 PHP 脚本。
- 请求结束 (Request Shutdown)：这时候调用每个拓展的 PHP_RSHUTDOWN_FUNCTION 方法清理请求现场，并且 ZE 开始回收变量和内存
- 关闭模块 (Module shutdown)：Web 服务器退出或者命令行脚本执行完毕退出会调用拓展源码中的 PHP_MSHUTDOWN_FUNCTION 方法

## Laravel

### Laravel 的生命周期
- 加载项目依赖，注册加载 composer 自动生成的 class loader，也就是加载初始化第三方依赖。
- 创建应用实例，生成容器 Container，并向容器注册核心组件，是从 bootstrap/app.php 脚本获取 Laravel 应用实例，并且绑定内核服务容器，它是 HTTP 请求的运行环境的不同，将请求发送至相应的内核： HTTP 内核 或 Console 内核
    1. 创建服务容器：从 bootstrap/app.php 文件中取得 Laravel 应用实例 $app (服务容器)
    2. 创建 HTTP / Console 内核：传入的请求会被发送给 HTTP 内核或者 console 内核进行处理
    3. 载入服务提供者至容器：
        在内核引导启动的过程中最重要的动作之一就是载入服务提供者到你的应用，服务提供者负责引导启动框架的全部各种组件，例如数据库、队列、验证器以及路由组件。
- 接收请求并响应，请求被发送到 HTTP 内核或 Console 内核，这取决于进入应用的请求类型。HTTP 内核继承自 Illuminate\Foundation\Http\Kernel 类，该类定义了一个 bootstrappers 数组，这个数组中的类在请求被执行前运行，这些 bootstrappers 配置了错误处理、日志、检测应用环境以及其它在请求被处理前需要执行的任务。HTTP 内核还定义了一系列所有请求在处理前需要经过的 HTTP 中间件，这些中间件处理 HTTP 会话的读写、判断应用是否处于维护模式、验证 CSRF 令牌等等。
- 发送请求，在 Laravel 基础的服务启动之后，把请求传递给路由了。路由器将会分发请求到路由或控制器，同时运行所有路由指定的中间件。传递给路由是通过 Pipeline（管道）来传递的，在传递给路由之前所有请求都要经过 app\Http\Kernel.php 中的 $middleware 数组，也就是中间件，默认只有一个全局中间件，用来检测你的网站是否暂时关闭。所有请求都要经过，你也可以添加自己的全局中间件。然后遍历所有注册的路由，找到最先符合的第一个路由，经过它的路由中间件，进入到控制器或者闭包函数，执行你的具体逻辑代码，把那些不符合或者恶意的的请求已被 Laravel 隔离在外。

### 什么是服务提供者
服务提供者是所有 Laravel 应用程序引导启动的中心, Laravel 的核心服务器、注册服务容器绑定、事件监听、中间件、路由注册以及我们的应用程序都是由服务提供者引导启动的

### 什么是 Ioc 容器  (控制反转和依赖注入)
IoC（Inversion of Control）译为 「控制反转」，也被叫做「依赖注入」(DI)。

1. 什么是「控制反转」？
- 对象 A 功能依赖于对象 B，但是控制权由对象 A 来控制，控制权被颠倒，所以叫做「控制反转」，
2. 而「依赖注入」是实现 IoC 的方法，
- 就是由 IoC 容器在运行期间，动态地将某种依赖关系注入到对象之中。

其作用简单来讲就是利用依赖关系注入的方式，把复杂的应用程序分解为互相合作的对象，从而降低解决问题的复杂度，实现应用程序代码的低耦合、高扩展。

Laravel 中的服务容器是用于管理类的依赖和执行依赖注入的工具。


## 接口与抽象类的区别
1. 接口
（1）对接口的使用是通过关键字implements
（2）接口不能定义成员变量（包括类静态变量），能定义常量
（3）子类必须实现接口定义的所有方法
（4）接口只能定义不能实现该方法
（5）接口没有构造函数
（6）接口中的方法和实现它的类默认都是public类型的
2. 抽象类
（1）对抽象类的使用是通过关键字extends
（2）不能被实例化，可以定义子类必须实现的方法
（3）子类必须定义父类中的所有抽象方法，这些方法的访问控制必须和父类中一样（或者更为宽松）
（4）如一个类中有一个抽象方法，则该类必须定义为抽象类
（5）抽象类可以有构造函数
（6）抽象类中的方法可以使用private,protected,public来修饰。
（7）一个类可以同时实现多个接口，但一个类只能继承于一个抽象类。

## OOP 
>oop 是面向对象编程，面向对象编程是一种计算机编程架构，OOP 的一条基本原则是程序是由单个能够起到子程序作用的单元或对象组合而成。

1. 封装性：也称为信息隐藏，就是将一个类的使用和实现分开，只保留部分接口和方法与外部联系，或者说只公开了一些供开发人员使用的方法。于是开发人员只 需要关注这个类如何使用，而不用去关心其具体的实现过程，这样就能实现 MVC 分工合作，也能有效避免程序间相互依赖，实现代码模块间松藕合。
2. 继承性：就是子类自动继承其父级类中的属性和方法，并可以添加新的属性和方法或者对部分属性和方法进行重写。继承增加了代码的可重用性。PHP 只支持单继承，也
就是说一个子类只能有一个父类。
3. 多态性：子类继承了来自父级类中的属性和方法，并对其中部分方法进行重写。于是多个子类中虽然都具有同一个方法，但是这些子类实例化的对象调用这些相同的方法后却可以获得完全不同的结果，这种技术就是多态性。多态性增强了软件的灵活性。

## 魔术方法
```php
__autoload() 类文件自动加载函数
__construct() 构造函数，PHP 将在对象创建时调用这个方法
__destruct()  析构函数，PHP 将在对象被销毁前（即从内存中清除前）调用这个方法
__call() 当所调用的成员方法不存在（或者没有权限）该类时调用，用于对错误后做一些操作或者提示信息
__clone() 该函数在对象克隆时自动调用，其作用是对克隆的副本做一些初始化操作
__get() 当所对象所调用的成员属性未声明或者级别为 private 或者 protected 等时，我们可以在这个函数里进行自己的一些操作
__set() 当所对未声明或者级别为 private 或者 protected 等进行赋值时调用此函数，我们可以在这个函数里进行自己的一些操作
__isset() 当对一个未声明或者访问级别受限的成员属性调用 isset 函数时调用此函数，共用户做一些操作
__unset() 当对一个未声明或者访问级别受限的成员属性调用 unset 函数时调用此函数，共用户做一些操作
__toString() 函数 该函数在将对象引用作为字符串操作时自动调用，返回一个字符串
__sleep() 函数 该函数是在序列化时自动调用的，序列化这里可以理解成将信息写如文件中更长久保存
__wakeup() 函数 该魔术方法在反序列化的时候自动调用，为反序列化生成的对象做一些初始化操作
__invoke() 函数，当尝试以调用函数的方式调用一个对象时，invoke 方法会被自动调用。
_callStatic() 函数，它的工作方式类似于 call () 魔术方法，callStatic() 是为了处理静态方法调用，
```

## 超全局变量
```php
$GLOBALS 是 PHP 的一个超级全局变量组，在一个 PHP 脚本的全部作用域中都可以访问。是一个包含了全部变量的全局组合数组。变量的名字就是数组的键。
$_SERVER 是一个包含了诸如头信息 (header)、路径 (path)、以及脚本位置 (script locations) 等等信息的数组。这个数组中的项目由 Web 服务器创建。不能保证每个服务器都提供全部项目；服务器可能会忽略一些，或者提供一些没有在这里列举出来的项目。
$_REQUEST 用于收集 HTML 表单提交的数据。
$_POST 被广泛应用于收集表单数据，在 HTML form 标签的指定该属性："method="post"。
$_GET 同样被广泛应用于收集表单数据，在 HTML form 标签的指定该属性："method="get"。
$_COOKIE 经由 HTTP Cookies 方法提交至脚本的变量
$_SESSION 当前注册给脚本会话的变量。类似于旧数组 $HTTP_SESSION_VARS 数组。
$_FILES 经由 HTTP POST 文件上传而提交至脚本的变量。类似于旧数组 $HTTP_POST_FILES 数组。
$_ENV 执行环境提交至脚本的变量。类似于旧数组 $HTTP_ENV_VARS 数组。
```

# Linux

## 知识
- Linux系统是由 **系统内核**，**shell**，**文件系统** 和 **应用程序** 四部分组成
- 查看系统当前进程连接数
```bash
netstat -an | grep ESTABLISHED | wc -l
```

## awk 命令
### 统计 Nginx 日志里面访问最多的 ip 前十位
```bash
awk '{print $1}' /var/log/nginx/access.log | uniq -c | sort -rn | head -n 10
```

### 统计 Nginx 日志里面访问最多的 url 前十位
```bash
awk '{++S[$7]} END {for (a in S) print S[a],a}' /var/log/nginx/access.log | sort -rn | head -n 10
```

## find 命令
1. 查找 /tmp 目录下大于 10MB 的文件
```bash
find /tmp -type f -size +10240k
```
2. 在 /var 目录下找出30天之内未被访问过的文件
```bash
find /var \! -atime -30
```
3. 在 /home 目录下找出120天之前被修改过的文件
```bash
find /home  -mtime +120
```
4. 在 /tmp 目录下查找文件 “log” 如发现则无需提示直接删除它们
```bash
find /tmp -name core -exec rm {} \;
```

## 进程和线程有什么区别
- 进程是一个资源的容器，为进程里的所有线程提供共享资源，是对程序的一种静态描述
- 线程是进程中的一个执行单元， 线程有自己的堆和栈
- 一个进程可以由多个线程的执行单元组成，每个线程都可以运行在进程的上下文

## 硬链接和软链接有什么区别
1. 硬链接不可以跨分区，软链接可以跨分区
2. 硬链接指向一个i节点，而软链接则是创建一个新的i节点
3. 删除硬链接文件，不会删除原文件，删除软链接文件，会把原文件删除

## Linux进程属性
- 进程：是用pid表示，它的数值是唯一的
- 父进程：用ppid表示
- 启动进程的用户：用UID表示
- 启动进程的用户所属的组：用GID表示
- 进程的状态：运行R，就绪W，休眠S，僵尸Z

## 统计某一天网站的访问量
```bash
awk '{print $1}' /var/log/access_.log | sort | uniq | wc -l
```

# MySQL
## 规范
参考：[58到家MySQL军规升级版](https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651961030&idx=1&sn=73a04dabca409c1557e752382d777181&chksm=bd2d031a8a5a8a0c6f7b58b79ae8933dfefbd840dfb5d34a5c708ab63e6decbbc1b13533ebc8&scene=21#wechat_redirect)

1. 基础规范
    1. 表存储引擎必须使用InnoDB，表字符集默认使用utf8，必要时候使用utf8mb4
    （1）通用，无乱码风险，汉字3字节，英文1字节
    （2）utf8mb4是utf8的超集，有存储4字节例如表情符号时，使用它
    2. 禁止使用存储过程，视图，触发器，Event
    3. 禁止在数据库中存储大文件，例如照片，可以将大文件存储在对象存储系统，数据库中存储路径
    4. 禁止在线上环境做数据库压力测试
    5. 测试，开发，线上数据库环境必须隔离
    
2. 命名规范
    1. 库名，表名，列名必须用小写，采用下划线分隔
    2. 库名，表名，列名必须见名知义，长度不要超过32字符
    3. 库备份必须以bak为前缀，以日期为后缀
    4. 从库必须以-s为后缀
    5. 备库必须以-ss为后缀
    
3. 表设计规范
    1. 单实例表个数必须控制在2000个以内
    2. 单表分表个数必须控制在1024个以内
    3. 表必须有主键，推荐使用UNSIGNED整数为主键
    4. 禁止使用外键，如果要保证完整性，应由应用程式实现
    5. 建议将大字段，访问频度低的字段拆分到单独的表中存储，分离冷热数据
    
4. 列设计规范
    1. 根据业务区分使用tinyint/int/bigint，分别会占用1/4/8字节
    2. 根据业务区分使用char/varchar
        （1）字段长度固定，或者长度近似的业务场景，适合使用char，能够减少碎片，查询性能高
        （2）字段长度相差较大，或者更新较少的业务场景，适合使用varchar，能够减少空间
    3. 根据业务区分使用datetime/timestamp
        前者占用5个字节，后者占用4个字节，存储年使用YEAR，存储日期使用DATE，存储时间使用datetime
    4. 必须把字段定义为NOT NULL并设默认值
        （1）NULL的列使用索引，索引统计，值都更加复杂，MySQL更难优化
        （2）NULL需要更多的存储空间
        （3）NULL只能采用IS NULL或者IS NOT NULL，而在=/!=/in/not in时有大坑
    5. 使用INT UNSIGNED存储IPv4，不要用char(15)
    6. 使用varchar(20)存储手机号，不要使用整数
        （1）牵扯到国家代号，可能出现+/-/()等字符，例如+86
        （2）手机号不会用来做数学运算
        （3）varchar可以模糊查询，例如like ‘138%’
    7. 使用TINYINT来代替ENUM
   
5. 索引规范
    1. 唯一索引使用uniq_[字段名]来命名
    2. 非唯一索引使用idx_[字段名]来命名
    3. 单张表索引数量建议控制在5个以内
        （1）互联网高并发业务，太多索引会影响写性能
        （2）生成执行计划时，如果索引太多，会降低性能，并可能导致MySQL选择不到最优索引
        （3）异常复杂的查询需求，可以选择ES等更为适合的方式存储
    4. 组合索引字段数不建议超过5个
    5. 不建议在频繁更新的字段上建立索引
    6. 非必要不要进行JOIN查询，如果要进行JOIN查询，被JOIN的字段必须类型相同，并建立索引
        因为JOIN字段类型不一致，而导致全表扫描
    7. 理解组合索引最左前缀原则，避免重复建设索引，如果建立了(a,b,c)，相当于建立了(a), (a,b), (a,b,c)
    
6. SQL规范
    1. 禁止使用select *，只获取必要字段
        （1）select *会增加cpu/io/内存/带宽的消耗
        （2）指定字段能有效利用索引覆盖
        （3）指定字段查询，在表结构变更时，能保证对应用程序无影响
    2. insert必须指定字段，禁止使用insert into T values()
    3. 隐式类型转换会使索引失效，导致全表扫描
    4. 禁止在where条件列使用函数或者表达式
    5. 禁止负向查询以及%开头的模糊查询
    6. 禁止大表JOIN和子查询
    7. 同一个字段上的OR必须改写问IN，IN的值必须少于50个
    8. 应用程序必须捕获SQL异常

## 优化
1. 应尽量避免在 where 子句中使用 函数 或 `!=`, `<>`操作符，否则将引擎放弃使用索引而进行全表扫描
2. 避免隐式类型转换
3. 少用子查询,最好是把连接拆开成较小的几个部分逐个顺序执行
4. or 的查询尽量用 union或者union all 代替 (在确认没有重复数据或者不用剔除重复数据时，union all会更好)
5. 合理的增加冗余的字段（减少表的联接查询）
6. 适当建立索引

## 索引
> 索引 (Index) 是帮助 MySQL 高效获取数据的数据结构。我们可以简单理解为：快速查找排好序的一种数据结构。
> 
> Mysql 索引主要有两种结构：B+Tree 索引和 Hash 索引。

以 B-Tree 为结构的索引是最常见的索引类型，比如 InnoDB 和 MyISAM 都是以 B-Tree 为索引结构的索引，事实上是以 B+ Tree 为索引结构，B-Tree 和 B+Tree 区别在于，B+ Tree 在叶子节点上增加了顺序访问指针，方便叶子节点的范围遍历.

### 聚簇索引和非聚簇索引的区别
参考：[一分钟了解索引技巧](https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651960258&idx=1&sn=caf8295fa5c0ee47d6b9e6bf5cffcb49&chksm=bd2d061e8a5a8f08374ddc84a3c59355368b840ab38ba97782947e02c0d9d6d3c289032b3d39&scene=25#wechat_redirect)
聚簇索引的叶节点就是数据节点，而非聚簇索引的页节点仍然是索引检点，并保留一个链接指向对应数据块。

## 数据库设计范式
1. 第一范式：无重复的列
字段值具有原子性,不能再分(所有关系型数据库系统都满足第一范式)
>     在任何一个关系数据库中，第一范式（1NF）是对关系模式的基本要求，不满足第一范式（1NF）的数据库就不是关系数据库。 所谓第一范式（1NF）是指数据库表的每一列都是不可分割的基本数据项，同一列中不能有多个值，即实体中的某个属性不能有多个值或者不能有重复的属性。如果出现重复的属性，就可能需要定义一个新的实体，新的实体由重复的属性构成，新实体与原实体之间为一对多关系。在第一范式（1NF）中表的每一行只包含一个实例的信息。
2. 第二范式：非主属性非部分依赖于主关键字
一个表必须有主键,即每行数据都能被唯一的区分
>     第二范式（2NF）是在第一范式（1NF）的基础上建立起来的，即满足第二范式（2NF）必须先满足第一范式（1NF）。第二范式（2NF）要求数据库表中的每个实例或行必须可以被惟一地区分。为实现区分通常需要为表加上一个列，以存储各个实例的惟一标识。这个惟一属性列被称为主关键字或主键、主码。 第二范式（2NF）要求实体的属性完全依赖于主关键字。所谓完全依赖是指不能存在仅依赖主关键字一部分的属性，如果存在，那么这个属性和主关键字的这一部分应该分离出来形成一个新的实体，新实体与原实体之间是一对多的关系。为实现区分通常需要为表加上一个列，以存储各个实例的惟一标识
3. 第三范式：属性不依赖于其它非主属性 (消除冗余)
一个表中不能包涵其他相关表中非关键字段的信息,即数据表不能有沉余字段
>     满足第三范式（3NF）必须先满足第二范式（2NF）。简而言之，第三范式（3NF）要求一个数据库表中不包含已在其它表中已包含的非主关键字信息。例如，存在一个部门信息表，其中每个部门有部门编号（dept_id）、部门名称、部门简介等信息。那么在员工信息表中列出部门编号后就不能再将部门名称、部门简介等与部门有关的信息再加入员工信息表中。如果不存在部门信息表，则根据第三范式（3NF）也应该构建它，否则就会有大量的数据冗余

## 数据库事务的四个特性 ACID
数据库事务transanction正确执行的四个基本要素。ACID,原子性(Atomicity)、一致性(Correspondence)、隔离性(Isolation)、持久性(Durability)。

* 原子性:整个事务中的所有操作，要么全部完成，要么全部不完成，不可能停滞在中间某个环节。事务在执行过程中发生错误，会被回滚（Rollback）到事务开始前的状态，就像这个事务从来没有执行过一样。

* 一致性:在事务开始之前和事务结束以后，数据库的完整性约束没有被破坏。

* 隔离性:隔离状态执行事务，使它们好像是系统在给定时间内执行的唯一操作。如果有两个事务，运行在相同的时间内，执行 相同的功能，事务的隔离性将确保每一事务在系统中认为只有该事务在使用系统。这种属性有时称为串行化，为了防止事务操作间的混淆，必须串行化或序列化请 求，使得在同一时间仅有一个请求用于同一数据。

* 持久性:在事务完成以后，该事务所对数据库所作的更改便持久的保存在数据库之中，并不会被回滚。

## MySQL 隔离级别
链接：[MySQL事务的隔离级别](https://www.jintix.com/q/b8169ec8ec1)

## 视图的作用，视图可以更改吗
视图是虚拟的表，与包含数据的表不一样，视图只包含使用时动态检索数据的查询；不包含任何列或数据。使用视图可以简化复杂的sql操作，隐藏具体的细节，保护数据；视图创建后，可以使用与表相同的方式利用它们。

视图不能被索引，也不能有关联的触发器或默认值，如果视图本身内有order by 则对视图再次order by将被覆盖。

创建视图：create view XXX as XXXXXXXXXXXXXX;

对于某些视图比如未使用联结子查询分组聚集函数Distinct Union等，是可以对其更新的，对视图的更新将对基表进行更新；但是视图主要用于简化检索，保护数据，并不用于更新，而且大部分视图都不可以更新。

## MySQL 锁
参考： [MySQL 锁机制](https://www.jianshu.com/p/0d5b7cd592f9)
### InnoDB 的行锁模式及加锁方法
InnoDB 的行锁有两种：共享锁（S）和排他锁（X）。为了允许行锁和表锁共存，实现多粒度锁机制，InnoDB 还有两种内部使用的意向锁：意向共享锁和意向排他锁，这两种意向锁都是表锁。一个事务在给数据行加锁之前必须先取得对应表对应的意向锁

**InnoDB 行锁是通过给索引上的索引项加锁来实现的**

> 1. 只有通过索引条件检索数据，InnoDB才使用行级锁，否则会自动锁全表
> 2. 两个事务不能锁同一个索引
> 3. insert ，delete ， update 在事务中都会自动默认加上排它锁

### InnoDB什么时候使用表锁
1. 第一种情况是：事务需要更新大部分或全部数据，表又比较大，如果使用默认的行锁，不仅这个事务执行效率低，而且可能造成其他事务长时间锁等待和锁冲突，这种情况下可以考虑使用表锁来提高该事务的执行速度。
2. 第二种情况是：事务涉及多个表，比较复杂，很可能引起死锁，造成大量事务回滚。这种情况也可以考虑一次性锁定事务涉及的表，从而避免死锁、减少数据库因事务回滚带来的开销。

### InnoDB使用表锁注意事项
1. 使用LOCK TABLES虽然可以给InnoDB加表级锁，但必须说明的是，表锁不是由InnoDB存储引擎层管理的，而是由其上一层──MySQL Server负责的，仅当autocommit=0、innodb_table_locks=1（默认设置）时，InnoDB层才能知道MySQL加的表锁，MySQL Server也才能感知InnoDB加的行锁，这种情况下，InnoDB才能自动识别涉及表级锁的死锁；否则，InnoDB将无法自动检测并处理这种死锁。
2. 在用 LOCK TABLES对InnoDB表加锁时要注意，要将AUTOCOMMIT设为0，否则MySQL不会给表加锁；事务结束前，不要用UNLOCK TABLES释放表锁，因为UNLOCK TABLES会隐含地提交事务；COMMIT或ROLLBACK并不能释放用LOCK TABLES加的表级锁，必须用UNLOCK TABLES释放表锁。

### MyISAM 表锁
1. 共享读锁（S）之间是兼容的，但共享读锁（S）和排他写锁（X）之间，以及排他写锁之间（X）是互斥的，也就是说读和写是串行的。
2. 在一定条件下，ＭyISAM 允许查询和插入并发执行，我们可以利用这一点来解决应用中对同一表和插入的锁争用问题。
3. ＭyISAM 默认的锁调度机制是写优先，这并不一定适合所有应用，用户可以通过设置 LOW_PRIPORITY_UPDATES 参数，或在 INSERT、UPDATE、DELETE 语句中指定 LOW_PRIORITY 选项来调节读写锁的争用。
4. 由于表锁的锁定粒度大，读写之间又是串行的，因此，如果更新操作较多，ＭyISAM 表可能会出现严重的锁等待，可以考虑采用 InnoDB 表来减少锁冲突。

### MySQL 死锁
#### 产生原因
1. 竞争资源
    - 产生死锁中的竞争资源之一指的是竞争不可剥夺资源 [当系统把这类资源分配给某进程后，再不能强行收回，只能在进程用完后自行释放，如磁带机、打印机等]（例如：系统中只有一台打印机，可供进程 P1 使用，假定 P1 已占用了打印机，若 P2 继续要求打印机打印将阻塞）
    - 产生死锁中的竞争资源另外一种资源指的是竞争临时资源 [指某进程在获得这类资源后，该资源可以再被其他进程或系统剥夺，CPU 和主存均属于可剥夺性资源] （临时资源包括硬件中断、信号、消息、缓冲区内的消息等），通常消息通信顺序进行不当，则会产生死锁

2. 进程间推进顺序非法
    - 若 P1 保持了资源 R1,P2 保持了资源 R2，系统处于不安全状态，因为这两个进程再向前推进，便可能发生死锁
    
#### 产生死锁的必要条件
- 互斥条件：进程要求对所分配的资源进行排它性控制，即在一段时间内某资源仅为一进程所占用。
- 请求和保持条件：当进程因请求资源而阻塞时，对已获得的资源保持不放。
- 不剥夺条件：进程已获得的资源在未使用完之前，不能剥夺，只能在使用完时由自己释放。
- 环路等待条件：在发生死锁时，必然存在一个进程--资源的环形链。

#### 预防死锁
- 资源一次性分配：一次性分配所有资源，这样就不会再有请求了：（破坏请求条件）
- 只要有一个资源得不到分配，也不给这个进程分配其他的资源：（破坏请保持条件）
- 可剥夺资源：即当某进程获得了部分资源，但得不到其它资源，则释放已占有的资源（破坏不可剥夺条件）
- 资源有序分配法：系统给每类资源赋予一个编号，每一个进程按编号递增的顺序请求资源，释放则相反（破坏环路等待条件）
    
#### 解除死锁
- 剥夺资源：从其它进程剥夺足够数量的资源给死锁进程，以解除死锁状态；
- 撤消进程：可以直接撤消死锁进程或撤消代价最小的进程，直至有足够的资源可用，死锁状态。消除为止；所谓代价是指优先级、运行代价、进程的重要性和价值等。

## InnoDB && MyISAM
![716609f0be997a7dea5f31850596f315.jpeg](evernotecid://4E686A16-6940-466A-9D0C-A1B9FD748218/appyinxiangcom/19244053/ENResource/p76)


## Explain 详解
参考 ： [MySQL EXPLAIN详解](https://www.jianshu.com/p/ea3fc71fdc45)
|列名|说明|
|--|--|
|id|执行编号，标识select所属的行。如果在语句中没子查询或关联查询，只有唯一的select，每行都将显示1。否则，内层的select语句一般会顺序编号，对应于其在原始语句中的位置|
|select_type|显示本行是简单或复杂select。如果查询有任何复杂的子查询，则最外层标记为PRIMARY（DERIVED、UNION、UNION RESUlT）|
|table|访问引用哪个表|
|type|数据访问/读取操作类型（ALL、index、range、ref、eq_ref、const/system、NULL）|
|possible_keys|揭示哪一些索引可能有利于高效的查找|
|key|显示mysql决定采用哪个索引来优化查询|
|key_len|显示mysql在索引里使用的字节数|
|ref|显示了之前的表在key列记录的索引中查找值所用的列或常量|
|rows|为了找到所需的行而需要读取的行数，估算值，不精确。通过把所有rows列值相乘，可粗略估算整个查询会检查的行数|
|Extra|额外信息，如using index、filesort等|

### Explain:id
id是用来顺序标识整个查询中SELELCT 语句的，在嵌套查询中id越大的语句越先执行。该值可能为NULL

### Explain:select_type
表示查询的类型
|类型|说明|
|--|--|
|simple|简单子查询，不包含子查询和union|
|primary|包含union或者子查询，最外层的部分标记为primary|
|subquery|一般子查询中的子查询被标记为subquery，也就是位于select列表中的查询|
|derived|派生表——该临时表是从子查询派生出来的，位于form中的子查询|
|union|位于union中第二个及其以后的子查询被标记为union，第一个就被标记为primary如果是union位于from中则标记为derived|
|union result|用来从匿名临时表里检索结果的select被标记为union result|
|dependent union|顾名思义，首先需要满足UNION的条件，及UNION中第二个以及后面的SELECT语句，同时该语句依赖外部的查询|
|subquery|子查询中第一个SELECT语句|
|dependent subquery|和DEPENDENT UNION相对UNION一样|

### Explain:table
对应行正在访问哪一个表，表名或者别名
- 关联优化器会为查询选择关联顺序，左侧深度优先
- 当from中有子查询的时候，表名是derivedN的形式，N指向子查询，也就是explain结果中的下一列
- 当有union result的时候，表名是union 1,2等的形式，1,2表示参与union的query id

### Explain:type
type显示的是访问类型，是较为重要的一个指标，结果值从好到坏依次是：system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL ，一般来说，得保证查询至少达到range级别，最好能达到ref
|类型|说明|
|--|--|
|All|最坏的情况,全表扫描|
|index|和全表扫描一样。只是扫描表的时候按照索引次序进行而不是行。主要优点就是避免了排序, 但是开销仍然非常大。如在Extra列看到Using index，说明正在使用覆盖索引，只扫描索引的数据，它比按索引次序全表扫描的开销要小很多|
|range|范围扫描，一个有限制的索引扫描。key 列显示使用了哪个索引。当使用=、 <>、>、>=、<、<=、IS NULL、<=>、BETWEEN 或者 IN 操作符,用常量比较关键字列时,可以使用 range|
|ref|一种索引访问，它返回所有匹配某个单个值的行。此类索引访问只有当使用非唯一性索引或唯一性索引非唯一性前缀时才会发生。这个类型跟eq_ref不同的是，它用在关联操作只使用了索引的最左前缀，或者索引不是UNIQUE和PRIMARY KEY。ref可以用于使用=或<=>操作符的带索引的列。|
|eq_ref|最多只返回一条符合条件的记录。使用唯一性索引或主键查找时会发生 （高效）|
|const|当确定最多只会有一行匹配的时候，MySQL优化器会在查询前读取它而且只读取一次，因此非常快。当主键放入where子句时，mysql把这个查询转为一个常量（高效）|
|system|这是const连接类型的一种特例，表仅有一行满足条件。|
|Null|意味说mysql能在优化阶段分解查询语句，在执行阶段甚至用不到访问表或索引（高效）|

### Explain:possible_keys
显示查询使用了哪些索引，表示该索引可以进行高效地查找，但是列出来的索引对于后续优化过程可能是没有用的

### Explain:key
key列显示MySQL实际决定使用的键（索引）。如果没有选择索引，键是NULL。要想强制MySQL使用或忽视possible_keys列中的索引，在查询中使用FORCE INDEX、USE INDEX或者IGNORE INDEX

### Explain:key_len
key_len列显示MySQL决定使用的键长度。如果键是NULL，则长度为NULL。使用的索引的长度。在不损失精确性的情况下，长度越短越好

### Explain:ref
ref列显示使用哪个列或常数与key一起从表中选择行

### Explain:rows
rows列显示MySQL认为它执行查询时必须检查的行数。注意这是一个预估值

### Explain:Extra
Extra是EXPLAIN输出中另外一个很重要的列，该列显示MySQL在查询过程中的一些详细信息，MySQL查询优化器执行查询的过程中对查询计划的重要补充信息
|类型|说明|
|--|--|
|Using filesort|MySQL有两种方式可以生成有序的结果，通过排序操作或者使用索引，当Extra中出现了Using filesort 说明MySQL使用了后者，但注意虽然叫filesort但并不是说明就是用了文件来进行排序，只要可能排序都是在内存里完成的。大部分情况下利用索引排序更快，所以一般这时也要考虑优化查询了。使用文件完成排序操作，这是可能是ordery by，group by语句的结果，这可能是一个CPU密集型的过程，可以通过选择合适的索引来改进性能，用索引来为查询结果排序。|
|Using temporary|用临时表保存中间结果，常用于GROUP BY 和 ORDER BY操作中，一般看到它说明查询需要优化了，就算避免不了临时表的使用也要尽量避免硬盘临时表的使用。|
|Not exists|MYSQL优化了LEFT JOIN，一旦它找到了匹配LEFT JOIN标准的行， 就不再搜索了。|
|Using index|说明查询是覆盖了索引的，不需要读取数据文件，从索引树（索引文件）中即可获得信息。如果同时出现using where，表明索引被用来执行索引键值的查找，没有using where，表明索引用来读取数据而非执行查找动作。这是MySQL服务层完成的，但无需再回表查询记录。|
|Using index condition|这是MySQL 5.6出来的新特性，叫做“索引条件推送”。简单说一点就是MySQL原来在索引上是不能执行如like这样的操作的，但是现在可以了，这样减少了不必要的IO操作，但是只能用在二级索引上。|
|Using where|使用了WHERE从句来限制哪些行将与下一张表匹配或者是返回给用户。注意：Extra列出现Using where表示MySQL服务器将存储引擎返回服务层以后再应用WHERE条件过滤。|
|Using join buffer|使用了连接缓存：Block Nested Loop，连接算法是块嵌套循环连接;Batched Key Access，连接算法是批量索引连接|
|impossible where|where子句的值总是false，不能用来获取任何元组|
|select tables optimized away|在没有GROUP BY子句的情况下，基于索引优化MIN/MAX操作，或者对于MyISAM存储引擎优化COUNT(*)操作，不必等到执行阶段再进行计算，查询执行计划生成的阶段即完成优化。|
|distinct|优化distinct操作，在找到第一匹配的元组后即停止找同样值的动作|

# Redis
## Redis有哪些好处
1. 速度快，因为数据存储在内存中，类似于 HashMap 读取和操作的时间复杂度都是O(1)
2. 支持丰富的数据类型 **string**, **list**, **set**, **sorted set**, **hash**
3. 支持事物，操作都是原子性(要么全部执行,要么不执行)
    1. `multi`: 开启事物 `exec`: 提交并执行事物 `discard`: 取消事物
    2. `watch` 用于监听在事物过程中 key 是否被另外一个客户端修改，如果修改，则不执行事物（返回nil), 从而保证事物的安全性 
4. 丰富的特性：可用于缓存，消息，按key设置过期时间，过期后将会自动删除

## 讲讲 Redis 的同步机制
无论是初次连接还是重新连接，当建立一个从服务器时，从服务器都将从主服务器发送一个SYNC命令。接到SYNC命令的主服务器将开始执行BGSAVE，并在保存操作执行期间，将所有新执行的命令都保存到一个缓冲区里面，当BGSAVE执行完毕后，主服务器将执行保存操作所得到的.rdb文件发送给从服务器，从服务器接收这个.rdb文件，并将文件中的数据载入到内存中。之后主服务器会以Redis命令协议的格式，将写命令缓冲区中积累的所有内容都发送给从服务器。

## 如何保证 Redis 里面都保存的是热点数据
相关知识：redis 内存数据集大小上升到一定大小的时候，就会施行数据淘汰策略。redis 提供 6种数据淘汰策略：
1. voltile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
2. volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
3. volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰
4. allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
5. allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
6. no-enviction（驱逐）：禁止驱逐数据

# 其他
## 设计模式
链接：[PHP设计模式](http://larabase.com/collection/5/post/143)

## ps 命令查看线程
`ps -T -p <pid>`

## GET, POST 的区别
>链接：
>[HTTP 方法：GET 对比 POST](https://www.w3school.com.cn/tags/html_ref_httpmethods.asp)
>[都 2019 年了，还问 GET 和 POST 的区别](https://segmentfault.com/a/1190000018129846)

GET 是从指定的资源获取数据，POST 是向指定的资源提交要被处理的数据
||GET|POST|
|--|--|--|
|后退按钮/刷新|无害|数据会被重新提交（浏览器应该告知用户数据会被重新提交）。|
|书签|可收藏为书签|不可收藏为书签|
|缓存|能被缓存|不能缓存|
|编码类型|application/x-www-form-urlencoded|application/x-www-form-urlencoded 或 multipart/form-data。为二进制数据使用多重编码。|
|历史|参数保留在浏览器历史中。|参数不会保存在浏览器历史中。|
|对数据长度的限制|是的。当发送数据时，GET 方法向 URL 添加数据；URL 的长度是受限制的（URL 的最大长度是 2048 个字符）。|无限制。
|对数据类型的限制|只允许 ASCII 字符。|没有限制。也允许二进制数据。|
|安全性|与 POST 相比，GET 的安全性较差，因为所发送的数据是 URL 的一部分。|POST 比 GET 更安全，因为参数不会被保存在浏览器历史或 web 服务器日志中。|
|可见性|数据在 URL 中对所有人都是可见的。|数据不会显示在 URL 中。|

## TCP/UDP/HTTP的区别和联系
[TCP/UDP/HTTP的区别和联系](https://blog.csdn.net/qq_31332467/article/details/79217262)

- TPC/IP协议是传输层协议，主要解决数据如何在网络中传输，而HTTP是应用层协议，主要解决如何包装数据
- UDP是一种不可靠的传输层协议，TCP为了实现网络通信的可靠性，使用了复杂的拥塞控制算法，建立了繁琐的握手过程以及重传策略
- UDP在传送数据之前不需要先建立连接；TCP则提供面向连接的服务

## 一次http请求，谁会先断开TCP连接？什么情况下客户端先断，什么情况下服务端先断
http1.0和http1.1之间保持连接的差异以及http头中connection、content-length、Transfer-encoding等参数有关

### http1.0  
1. 带 content-length，body 长度可知，客户端在接收 body 时，就可以依据这个长度来接受数据。接受完毕后，就表示这个请求完毕了。客户端主动调用 close 进入四次挥手。
2. 不带 content-length ，body 长度不可知，客户端一直接受数据，直到服务端主动断开

### http1.1
1. 带 content-length body 长度可知，客户端主动断开
2. 带 Transfer-encoding：chunked，body 会被分成多个块，每块的开始会标识出当前块的长度，body 就不需要通过 content-length 来指定了。但依然可以知道 body 的长度 客户端主动断开
3. 不带 Transfer-encoding：chunked 且不带 content-length ，客户端接收数据，直到服务端主动断开连接

>即：如果能够有办法知道服务器传来的长度，都是客户端首先断开。如果不知道就一直接收数据。直到服务端断开

## HTTP 协议部分
> 一个 HTTP 请求报文由请求行（request line）、请求头部（header）、空行和请求数据 4 个部分组成
> HTTP 响应也由三个部分组成，分别是：状态行、消息响应头、响应正文。

### 请求行
请求行 由请求方法字段、URL 字段和 HTTP 协议版本字段 3 个字段组成，它们用空格分隔。

### 请求头部
- 请求头部由关键字 / 值对组成，每行一对，关键字和值用英文冒号 “:” 分隔。
- 请求头部通知服务器有关于客户端请求的信息，典型的 请求头有：
    - UserAgent：产生请求的浏览器类型。
    - Accept：客户端可识别的内容类型列表。
    - Host：请求的主机名，允许多个域名同处一个 IP 地址，即虚拟主机。

### 空行
后一个请求头之后是一个空行，发送回车符和换行符，通知服务器以下不再有请求头。

### 请求数据
请求数据不在 GET 方法中使用，而是在 POST 方法中使用。POST 方法适用于需要客户填写表单的场合。与请求数据相关的常使 用的请求头是 **ContentType** 和 **ContentLength**。

### 响应-状态行
1xx：指示信息表示请求已接收，继续处理。
2xx：成功表示请求已被成功接收、理解、接受。
3xx：重定向要完成请求必须进行更进一步的操作。
4xx：客户端错误请求有语法错误或请求无法实现。
5xx：服务器端错误服务器未能实现合法的请求。

### 响应-消息头

#### 响应内容类型
1. 网页编码
header('Content-Type: text/html;charset=utf-8');
2. 纯文本格式
header('Content-Type:text/plain');
3. 图片响应 JPG、JPEG
header('Content-Type:image/jpeg');
4. ZIP 文件
header('Content-Type:application/zip');
5. PDF 文件
header('Content-Type:application/pdf');
6. css 文件
header('Content-type:text/css');

#### 响应一个下载文件

##### 下载 PDF
header('Content-Description: File Transfer');
header('Content-Type: application/pdf');
header('Content-Disposition: attachment; filename=download_name.pdf');
header('Content-Transfer-Encoding: binary');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');

##### 下载图片
header('Content-type: image/jpeg');
header('Content-Disposition: attachment; filename=download_name.jpg');
readfile($yourFilePath);

#### 显示一个需要验证的登录对话框
header('HTTP/1.1 401Unauthorized');
header('WWW-Authenticate:Basic realm="TopSecret"');

## 设计模式的六大原则
文章：[PHP设计模式的六大设计原则](https://blog.csdn.net/bushuwei/article/details/85234393)
1. **单一职责原则**(Single)：一个类只负责一个职责
2. **开放封闭原则**(Open)：一个软件实体比如类/模块/函数，应该对扩展开放，对修改关闭
3. **里氏替换原则**(Liskov)：所有引用基类的地方必须透明地使用其子类的对象，子类必须完全实现父类的方法，可以拓展自己的方法和属性，即子类可以扩展父类的功能，但是不能改变父类的原有功能
4. **迪米特法则**(Law)：一个对象应该对其他对象保持最少的了解
5. **接口隔离原则**(Interface)：类间的依赖应该建立在最小的接口上
6. **依赖倒置原则**(Dependence)：高层模块不应该依赖底层模块，二者应该依赖其抽象；抽象不应该依赖细节；细节应该依赖抽象

## 负载均衡
> 负载均衡是指基于反向代理能将现在所有的请求根据指定的策略算法，分发到不同的服务器上。常用实现负载均衡的可以用 nginx, lvs。

### 常见的负载均衡方案
1. 轮询
2. 用户IP哈希
3. 指定权重
```php
## Nginx (Weighted Round)

http{
  # Weighted
  upstream cluster {
    server a weight=5
    server b weight=1;
    server c weight=1;
  }
  
  server {
    listen 80;
 
    location / {
      proxy_pass http://cluster;
    }
  }
 
```
4.使用第三方 (fair,url_hash)

## 列出一些防范SQL注入、XSS攻击、CSRF攻击的方法
SQL注入：
- addslashes函数
- mysql_real_escape_string/mysqli_real_escape_string/PDO::quote()
- PDO预处理 **prepare()**

XSS：
- htmlspecial函数 

CSRF：
- 验证HTTP REFER
- 使用toke进行验证


# 算法

![616f00cc8f4b15975c999272e8abb770.png](evernotecid://4E686A16-6940-466A-9D0C-A1B9FD748218/appyinxiangcom/19244053/ENResource/p75)

## 常见查找算法
链接：[常见查找算法一篇说透](https://segmentfault.com/a/1190000016582674)

## 冒泡排序法
```
function bubbleSort(array $arr)
{
    $count = count($arr);
    if ($count <= 1) {
        return $arr;
    }
    for ($i = $count-1; $i > 0; $i--) {
        for($j = 0; $j < $i; $j++) {
            if ($arr[$i] < $arr[$j]) {
                list($arr[$j], $arr[$i]) = [$arr[$i], $arr[$j]];
            }
        }
    }
    return $arr;
}
```

## 插入排序法
每次将一个待排序的记录，按其关键字大小插入到前面已经排好序的子序列中的适当位置，直到全部记录插入完成为止
```php
function insertSort(array $arr) 
{
    if ($count <= 1) {
        return $arr;
    }
    for ($i = 1; $i < count($arr); $i++) {
        for ($j = 0; $j < $i; $j++) {
            if ($arr[$i] < $arr[$j]) {
                list($arr[$j],$arr[$i]) = [$arr[$i], $arr[$j]];
            }
        }
    }
    return $arr;
}
```

## 选择排序法
每一次从待排序的数据元素中选出最小（或最大）的一个元素，存放在序列的起始位置，直到全部待排序的数据元素排完

## 快速排序法
```
public function quickSort($arr) 
{
     $length = count($arr);
     if(!is_array($arr)||$length <= 1) {
        return $arr;
     }
     $baseValue = $arr[0];

     $leftArr = [];
     $rightArr = [];

     for($i = 1; $i<$length; $i++) {
         if( $arr[$i] < $baseValue) {
             $leftArr[] = $arr[$i];
         } else {
             $rightArr[] = $arr[$i];
         }
     }

     $leftArr = $this->quickSort($leftArr);
     $rightArr = $this->quickSort($rightArr);
     return array_merge($leftArr, array($baseValue), $rightArr);
 }
```

## 二分查找法
```php
function binarySearch(array $array, $val) 
{
    $left = 0;
    $right = count($array) - 1;
    while($left <= $right) {
        $mid = floor(($left + $right)/2);
        if ($array[$mid] > $val) {
            $right = $mid - 1;
        } elseif ($array[$mid] < $val) {
            $left = $mid + 1; 
        } else {
            return $mid;
        }
    }
    return -1;
}
```

# 常见面试题

## 校验IP是否正确
```php
if (filter_var($ip, FILTER_VALIDATE_IP)) {
    return true;
} else {
    return false;
}
```

## 约瑟夫环问题
一群猴子排成一圈，按1,2,…,n依次编号。然后从第1只开始数，数到第m只,把它踢出圈，从它后面再开始数， 再数到第m只，在把它踢出去…，如此不停的进行下去， 直到最后只剩下一只猴子为止，那只猴子就叫做大王。要求编程模拟此过程，输入m、n, 输出最后那个大王的编号
```php
/**
 * 获取大王
 * @param  int $n 
 * @param  int $m 
 * @return int  
 */
function get_king_mokey($n, $m) 
{
    $arr = range(1, $n);

    $i = 1;

    while (count($arr) > 1) {
        $survice = array_shift($arr);
        
        if ($i % $m != 0) {
            array_push($arr, $survice);
        }
        
        $i++;
    }

    return $arr[0];
}
```

## 设计一个秒杀系统
其他：[JAVA 秒杀系统设计与架构](https://github.com/qiurunze123/miaosha)

// TODO 待补充


## 网页/应用访问慢突然变慢，如何定位问题
- top、iostat查看cpu、内存及io占用情况
- 内核、程序参数设置不合理 查看有没有报内核错误，连接数用户打开文件数这些有没有达到上限等等
- 链路本身慢 是否跨运营商、用户上下行带宽不够、dns解析慢、服务器内网广播风暴什么的
- 程序设计不合理 是否程序本身算法设计太差，数据库语句太过复杂或者刚上线了什么功能引起的
- 其它关联的程序引起的 如果要访问数据库，检查一下是否数据库访问慢
- 是否被攻击了 查看服务器是否被DDos了等等
- 硬件故障 这个一般直接服务器就挂了，而不是访问慢

## 搭建私有 composer 库
参考：[使用 satis 搭建 Composer 私有库](https://joelhy.github.io/2016/08/10/composer-private-packages-with-satis/)


## 面试题
1. 谈谈 PHP 和 golang 的优缺点
2. http / https / tcp / udp 这些协议之间的关系
3. 浏览器上输入一个网址从回车到页面显示，这中间都经历了哪些步骤
4. 算法： 一个数组里面 所有和加起来为另外一个数的 任意两个数的下标, 并写出时间复杂度，并提出优化方案
    例如: 
 数组 [1,2,5,3,9,7,6,10] 求 和为 12 的任意两个数的下标 
 [1,7]，[2,5]  
 5. 有一个题库：里面有一百万道题，如有 学生A练习时 随机抽取其中十道题，可以多次练习，每次拿到的题不重复，当学生B也进来练习时，也随机抽取其中的十道题，可以多次练习，第二天同样  求设计思路
 6. 一个 4核8G 的机器上如果要配置 php-fpm 的进程数，应该配置多少合适
 7. 数据库使用到的索引类型以及原理 (B-Tree索引 和 Hashmap 的区别)
     InnoDB 和 MyISAM 的区别
 8. 数据结构 (btree 的实现，Redis 数据结构是什么实现的)
 9. https 的加密原理
 10. mysql，redis，mongodb 的区别
 
 ## 浏览器上输入一个网址从回车到页面显示，这中间都经历了哪些步骤
参考：[浏览器输入 URL 回车之后发生了什么](https://mp.weixin.qq.com/s/dc9fOCNrHkh5a-DAR2VPvg)
1. URL 解析
    1. 解析输入内容是查询关键字还是 URL 地址
    2. 由于安全隐患，会使用 HSTS 强制客户端使用 HTTPS 访问页面
    3. 检查浏览器缓存， 如果有缓存并且缓存没有失效时，则直接访问缓存，如果缓存已过有效期，则访问服务器资源是否有变化，如果没有更新则访问缓存，如果有更新(或者浏览器没有缓存时)则返回资源和缓存标识，并存入缓存中 [图解](https://mmbiz.qpic.cn/mmbiz_png/6b3KbEywh0WqRApGqv5gB5LbKZo7ADPAkhpV02XtQTwibFyic8lCPz4p9m6ejt58MGmspYia1GfqYBiaOnzI2pVPrA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
  
2. DNS 查询
    1. 浏览器缓存
    2. 本地域名解析,如果有 (hosts 文件)
    3. 路由器缓存
    4. 本地电脑的DNS缓存
    5. 根域名服务器查询 详细: [根域名服务器](https://mmbiz.qpic.cn/mmbiz_png/6b3KbEywh0WqRApGqv5gB5LbKZo7ADPARh7CrjZGJjeYphhuv7zibMsSCkfYzhpkuZqwjriaQ550iaibbKjrsSbRQg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
       
>注意：
>1. 递归方式：一路查下去中间不返回，得到最终结果才返回信息（浏览器到本地DNS服务器的过程）
>2. 迭代方式，就是本地DNS服务器到根域名服务器查询的方式。
>3. 什么是 DNS 劫持
>4. 前端 dns-prefetch 优化

3. TCP 连接
    TCP/IP 分为四层，在发送数据时，每层都要对数据进行封装： [图解](https://mmbiz.qpic.cn/mmbiz_png/6b3KbEywh0WqRApGqv5gB5LbKZo7ADPAyX5eibZwj30KfCOb07ZJCNg3oia8kcJ2WgGh4qLNtz1ibFT4Ft8K7peZw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

4. 处理请求
    [图解](https://mmbiz.qpic.cn/mmbiz_png/6b3KbEywh0WqRApGqv5gB5LbKZo7ADPAKGuAY3WBY3QCzgEeUHOk1z7t8hkDaMH2pUQrJPp65mGD5D6atvhibrg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

5. 接受响应
    浏览器接收到来自服务器的响应资源后，会对资源进行分析。
    首先查看 Response header，根据不同状态码做不同的事（比如上面提到的重定向）。
    如果响应资源进行了压缩（比如 gzip），还需要进行解压。
然后，对响应资源做缓存。
    接下来，根据响应资源里的 MIME[3] 类型去解析响应内容（比如 HTML、Image各有不同的解析方式）。

6. 渲染页面
    [图解](https://mmbiz.qpic.cn/mmbiz_png/6b3KbEywh0WqRApGqv5gB5LbKZo7ADPAFLQPmV0NKV8ibkibG1wbFHRp6gY6wOogEHyT67vIF0UrMU6rtqic58xNg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
    
    
## 为什么说 B+Tree 比 BTree 更适合实际应用中操作系统的文件索引和数据库索引？

1. B+Tree 的磁盘读写代价更低
    - B+树的内部结点并没有指向关键字具体信息的指针。因此其内部结点相对于B树更小。如果把所有同一内部结点的关键字存放在同一盘块中，那么盘块所能容纳的关键字数量也越多。一次性读入内存中的需要查找的关键字也就越多。相对来说IO读写次数也就降低了。
    
2. B+Tree 的查询效率更加稳定
    - 由于非终结点并不是最终指向文件内容的结点，而只是叶子结点中关键字的索引。所以任何关键字的查找必须走一条从根结点到叶子结点的路。所有关键字查询的路径长度相同，导致每一个数据的查询效率相当

## 如何获取用户的真实 IP
一般情况下，透明的代理服务器在将用户的访问请求转发到下一环节的服务器时，会在HTTP的请求头中添加一条 **X-Forwarded-For** 记录，用于记录用户的真实IP，其记录格式为**X-Forwarded-For**:**用户IP**。如果期间经历多个代理服务器，则X-Forwarded-For将以该格式记录用户真实IP和所经过的代理服务器IP：
**X-Forwarded-For**:**用户IP**, **代理服务器1-IP**, **代理服务器2-IP**, **代理服务器3-IP**, ……

### Nginx 配置

#### 安装 http_realip_module 模块
使用 `nginx -V | grep http_realip_module` 命令检查该模块是否安装

安装:
```bash
wget http://nginx.org/download/nginx-1.12.2.tar.gz
tar zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --user=www --group=www --prefix=/alidata/server/nginx --with-http_stub_status_module --without-http-cache --with-http_ssl_module --with-http_realip_module
make
make install
kill -USR2 `cat /alidata/server/nginx/logs/nginx.pid`
kill -QUIT `cat /alidata/server/nginx/logs/ nginx.pid.oldbin`
```

#### 修改 Nginx 配置文件
打开default.conf配置文件，在location / {}中添加以下内容：
```conf
set_real_ip_from ip_range1;
set_real_ip_from ip_range2;
...
set_real_ip_from ip_rangex;
real_ip_header    X-Forwarded-For;
```

#### 修改 Nginx 日志记录格式
log_format一般在nginx.conf配置文件中的http配置部分。在log_format中，添加x-forwarded-for字段，替换原来remote-address字段，即将log_format修改为以下内容：
```conf
log_format  main  '$http_x_forwarded_for - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" ';
```

修改完成后重启即可