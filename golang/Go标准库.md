# 标准库

## 常用标准库索引
> 参考 [标准库概述](https://learnku.com/docs/the-way-to-go/overview-of-the-91-standard-library/3626)

- [`unsafe`](https://studygolang.com/static/pkgdoc/pkg/unsafe.htm): 包含了一些打破 Go 语言“类型安全”的命令，一般的程序中不会被使用，可用在 C/C++ 程序的调用中。
- `syscall`-`os`-`os/exec`:  
    - [`os`](https://studygolang.com/static/pkgdoc/pkg/os.htm): 提供给我们一个平台无关性的操作系统功能接口，采用类Unix设计，隐藏了不同操作系统间差异，让不同的文件系统和操作系统对象表现一致。  
    - [`os/exec`](https://studygolang.com/static/pkgdoc/pkg/os_exec.htm): 提供我们运行外部操作系统命令和程序的方式。  
    - [`syscall`](https://studygolang.com/static/pkgdoc/pkg/syscall.htm): 底层的外部包，提供了操作系统底层调用的基本接口。
- [`archive/tar`](https://studygolang.com/static/pkgdoc/pkg/archive_tar.htm) 和 `/zip-compress`：压缩(解压缩)文件功能。
- `fmt`-`io`-`bufio`-`path/filepath`-`flag`:  
    - [`fmt`](https://studygolang.com/static/pkgdoc/pkg/fmt.htm): 提供了格式化输入输出功能。  
    - [`io`](https://studygolang.com/static/pkgdoc/pkg/io.htm): 提供了基本输入输出功能，大多数是围绕系统功能的封装。  
    - [`bufio`](https://studygolang.com/static/pkgdoc/pkg/bufio.htm): 缓冲输入输出功能的封装。  
    - [`path/filepath`](https://studygolang.com/static/pkgdoc/pkg/path_filepath.htm): 用来操作在当前系统中的目标文件名路径。  
    - [`flag`](https://studygolang.com/static/pkgdoc/pkg/flag.htm): 对命令行参数的操作。　　
- `strings`-`strconv`-`unicode`-`regexp`-`bytes`:  
    - [`strings`](https://studygolang.com/static/pkgdoc/pkg/strings.htm): 提供对字符串的操作。  
    - [`strconv`](https://studygolang.com/static/pkgdoc/pkg/strconv.htm): 提供将字符串转换为基础类型的功能。
    - [`unicode`](https://studygolang.com/static/pkgdoc/pkg/unicode.htm): 为 unicode 型的字符串提供特殊的功能。
    - [`regexp`](https://studygolang.com/static/pkgdoc/pkg/regexp.htm): 正则表达式功能。  
    - [`bytes`](https://studygolang.com/static/pkgdoc/pkg/bytes.htm): 提供对字符型分片的操作。  
    - [`index/suffixarray`](https://studygolang.com/static/pkgdoc/pkg/index_suffixarray.htm): 子字符串快速查询。
- `math`-`math/cmath`-`math/big`-`math/rand`-`sort`:  
    - [`math`](https://studygolang.com/static/pkgdoc/pkg/math.htm): 基本的数学函数。  
    - [`math/cmath`](https://studygolang.com/static/pkgdoc/pkg/math_cmath.htm): 对复数的操作。  
    - [`math/rand`](https://studygolang.com/static/pkgdoc/pkg/math_rand.htm): 伪随机数生成。  
    - [`sort`](https://studygolang.com/static/pkgdoc/pkg/sort.htm): 为数组排序和自定义集合。  
    - [`math/big`](https://studygolang.com/static/pkgdoc/pkg/math_big.htm): 大数的实现和计算。  　　
- `container`-`/list-ring-heap`: 实现对集合的操作。  
    - [`list`](https://studygolang.com/static/pkgdoc/pkg/list.htm): 双链表。
    - [`ring`](https://studygolang.com/static/pkgdoc/pkg/ring.htm): 环形链表。

下面代码演示了如何遍历一个链表(当 l 是 `*List`)：

```go
for e := l.Front(); e != nil; e = e.Next() {
    //do something with e.Value
}
```

- `time`-`log`:  
    - [`time`](https://studygolang.com/static/pkgdoc/pkg/time.htm): 日期和时间的基本操作。  
    - [`log`](https://studygolang.com/static/pkgdoc/pkg/log.htm): 记录程序运行时产生的日志,我们将在后面的章节使用它。
- `encoding/json`-`encoding/xml`-`text/template`:
    - [`encoding/json`](https://studygolang.com/static/pkgdoc/pkg/encoding_json.htm): 读取并解码和写入并编码 JSON 数据。  
    - [`encoding/xml`](https://studygolang.com/static/pkgdoc/pkg/encoding_xml.htm):简单的 XML1.0 解析器
    - [`text/template`](https://studygolang.com/static/pkgdoc/pkg/text_template.htm):生成像 HTML 一样的数据与文本混合的数据驱动模板（相关[点此查看](https://learnku.com/docs/the-way-to-go/157-exploring-the-template-package/3709)）  
- `net`-`net/http`-`html`
    - [`net`](https://studygolang.com/static/pkgdoc/pkg/net.htm): 网络数据的基本操作。  
    - [`http`](https://studygolang.com/static/pkgdoc/pkg/net_http.htm): 提供了一个可扩展的 HTTP 服务器和基础客户端，解析 HTTP 请求和回复。  
    - [`html`](https://studygolang.com/static/pkgdoc/pkg/html.htm): HTML5 解析器。  
- [`runtime`](https://studygolang.com/static/pkgdoc/pkg/runtime.htm): Go 程序运行时的交互操作，例如垃圾回收和协程创建。  
- [`reflect`](https://studygolang.com/static/pkgdoc/pkg/reflect.htm): 实现通过程序运行时反射，让程序操作任意类型的变量。  

`exp` 包中有许多将被编译为新包的实验性的包。它们将成为独立的包在下次稳定版本发布的时候。如果前一个版本已经存在了，它们将被作为过时的包被回收。然而 Go1.0 发布的时候并不包含过时或者实验性的包。

## sync标准库 [文档](https://studygolang.com/static/pkgdoc/pkg/sync.htm)
> 当同时有多个线程连续向同一个缓冲区写入数据块，如果没有一个机制去协调这些线程的写入操作的话，那么被写入的数据块就很可能会出现错乱。比如，在线程 A 还没有写完一个数据块的时候，线程 B 就开始写入另外一个数据块了，两个数据块中的数据会被混在一起，因此需要采取一些措施来协调他们对缓冲区的修改，由此就涉及到 sync 同步

同步的用途有两个
1. 避免多个线程在同一时刻操作同一个数据块
2. 是协调多个线程，以避免它们在同一时刻执行同一个代码块

### 互斥锁
Go 语言中，有不少可选择的同步工具。其中，最重要且最常用的同步工具当属互斥量 （mutual exclusion，简称 mutex ）。 sync 包中的 Mutex 就是与其对应的类型，该类型的值可以被称为互斥量或者互斥锁。

#### 使用互斥锁的注意事项
1. 不要重复锁定互斥锁
2. 不要忘记解锁互斥锁，必要时使用defer语句
3. 不要对尚未锁定或者已解锁的互斥锁解锁
4. 不要在多个函数之间直接传递互斥锁
> [sync.Mutex类型](https://studygolang.com/static/pkgdoc/pkg/sync.htm#Mutex)是一个结构体类型，属于值类型的一种，把它传给一个函数、将它从函数中返回、把它赋给其他变量、让它进入某个通道都会导致它的副本的产生，并且，原值和它的副本，以及多个副本之间都是完全独立的，它们都是不同的互斥锁。 如果把一个互斥锁作为参数值传给了一个函数，那么在这个函数中对传入的锁的所有操作，都不会对存在于该函数之外的那个原锁产生任何的影响。

### 读写锁
> 读写锁（sync.RWMutex） 是 读互斥锁 和 写互斥锁 的简称

[sync.RWMutex类型](https://studygolang.com/static/pkgdoc/pkg/sync.htm#RWMutex)中的 **Lock方法** 和 **Unlock方法** 分别用于对 **写锁进行锁定** 和 **解锁**，而它的 **RLock方法** 和 **RUnlock方法** 则分别用于 **对读锁进行锁定** 和 **解锁**。

#### 读写锁的注意事项
1. 在写锁已被锁定的情况下再试图锁定写锁，会阻塞当前的 goroutine
2. 在写锁已被锁定的情况下试图锁定读锁，也会阻塞当前的 goroutine
3. 在读锁已被锁定的情况下试图锁定写锁，同样会阻塞当前的 goroutine
4. 在读锁已被锁定的情况下再试图锁定读锁，并不会阻塞当前的 goroutine
> 对于某个受到读写锁保护的共享资源，多个写操作不能同时进行，写操作和读操作也不能同时进行，但多个读操作却可以同时进行。

对写锁进行解锁，会唤醒 “所有因试图锁定读锁，而被阻塞的 goroutine”，并且，这通常会使它们都成功完成对读锁的锁定。然而，对读锁进行解锁，只会在没有其他读锁锁定的前提下，唤醒“因试图锁定写锁，而被阻塞 的 goroutine”；并且，最终只会有一个被唤醒的 goroutine 能够成功完成对写锁的锁定，其 他的 goroutine 还要在原处继续等待。

### 条件变量
> [条件变量（sync.Cond）](https://studygolang.com/static/pkgdoc/pkg/sync.htm#Cond)是用于协调想要访问共享资源的那些线程 的。当共享资源的状态发生变化时，它可以被用来通知被互斥锁阻塞的线程。 
>> 条件变量是基于互斥锁的，必须有互斥锁的支撑才能发挥作用

#### 条件变量的使用


#### 条件变量的 wait 方法主要做了那些事
1. 把调用它的 goroutine（也就是当前的 goroutine）加入到当前条件变量的通知队列中。
2. 解锁当前的条件变量基于的那个互斥锁。
3. 让当前的 goroutine 处于等待状态，等到通知到来时再决定是否唤醒它。此时，这个 goroutine 就会阻塞在调用这个Wait方法的那行代码上。
4. 如果通知到来并且决定唤醒这个 goroutine，那么就在唤醒它之后重新锁定当前条件变量基于的互斥锁。自此之后，当前的 goroutine 就会继续执行后面的代码了。

### 原子操作
> 原子操作（atomic operation）是为保证并发的绝对安全性，不被其他因素影响而导致 goroutine 中断执行
> * Go 语言提供的原子操作相关的函数都在标准库 [sync/atomic](https://studygolang.com/static/pkgdoc/pkg/sync_atomic.htm) 中

#### sync/atomic 都有哪些原子操作
sync/atomic包中的函数可以做的原子操作有：加法（add）、比较并交换（compare and swap，简称 CAS）、加载（load）、存储（store）和交换（swap）。

#### 原子操作函数的第一个值为什么都是指针类型的变量
> 以 [atomic.AddInt32(addr *int32, delta int32)](https://github.com/golang/go/blob/master/src/sync/atomic/doc.go?name=release#L93) 为例， 传入原子操作函数的第一个参数是 int32 类型的指针

因为原子操作函数需要的是被操作值的指针，而不是这个值本身，被传入函数的参数值都会被复制，像这种基本类型的值一旦被传入函数，就已经与函数外的那个值毫无关系，所以传值本身没有任何意义。

unsafe.Pointer类型虽然是指针类型，但是那些原子操作函数要操作的是这个指针值，而不是它指向的那个值，所以需要的仍然是指向这个指针值的指针。

#### 原子操作中 uint32 类型的减法操作
如果对 uint32 类型的被操作值 18 做原子减法，比如说差量是 -3，那么我们可以先把 这个差量转换为有符号的 int32 类型的值，然后再把该值的类型转换为 uint32

```go
// 方法一
delta := int32(-3)
uint32(delta)

// 方法二
// 说明： 整数在计算机中是以补码的形式存在的
// N代表由负整数表示的差量。也就是说，先要把差量的绝对值减去1，然后再把得到的这个无类型的整数常量转换为uint32类型的值，最后，在这个值之上做按位异或操作，就可以获得最终的参数值了
^uint32(-N-1))
```




