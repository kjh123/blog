# go基本语法整理

## go的数据类型

| 类型| 名称 | 长度 | 零值  | 说明  |
| -------- | -------- | -------- | -------- | -------- |
| bool     | 布尔类型     | 1     |  false| 其值部位真则为假，不可以用数字代表ture 或 false |
| byte     | 字节型     | 1   |  1| uint8别名 |
| rune     | 字符类型     | 4     |  0| 专用于存储unicode 编码，等价于uint32 |
| int,uint     | 整型     | 4 或 8   |  0| 32位或者64位 |
| int8,uint8     | 整型     | 1   |  0| -128 ~ 127, 0 ~ 225 |
| int16,uint16     | 整型     | 2   |  0| -32768 ~ 32767, 0 ~ 65535 |
| int32,uint32     | 整型     | 4   |  0| -21亿 ~ 21亿, 0 ~  42亿|
| int64,uint64     | 整型     | 8  |  0| |
| float32     | 浮点型     | 4  |  0.0| 小数位精确到7位 |
| float64     | 浮点型     | 8  |  0.0| 小数位精确到15位 |
| complex64     | 复数类型     | 8   |  |  |
| complex128     | 复数类型     | 16   |  |  |
| uintptr    | 整型     | 4 or 8   |  0| 足以存储指针的uint32 或 uint64 整数 |
| string    | 字符串     |    |  --| utf-8字符串 |

## Go Printf 中的输出类型
| 格式  | 含义 | 
| -------- | -------- |
|%%|    一个%字面量|
|%b|    一个二进制整数值(基数为2)，或者是一个(高级的)用科学计数法表示的指数为2的浮点数|
|%c|    字符型。可以把输入的数字按照ASCII码相应转换为对应的字符|
|%d|    一个十进制数值(基数为10)|
|%e|    以科学记数法e表示的浮点数或者复数值|
|%E|    以科学记数法E表示的浮点数或者复数值|
|%f|    以标准记数法表示的浮点数或者复数值|
|%g|    以%e或者%f表示的浮点数或者复数，任何一个都以最为紧凑的方式输出|
|%G|    以%E或者%f表示的浮点数或者复数，任何一个都以最为紧凑的方式输出|
|%o|    一个以八进制表示的数字(基数为8)|
|%p|    以十六进制(基数为16)表示的一个值的地址，前缀为0x,字母使用小写的a-f表示|
|%q|    使用Go语法以及必须时使用转义，以双引号括起来的字符串或者字节切片[]byte，或者是以单引号括起来的数字|
|%s|    字符串。输出字符串中的字符直至字符串中的空字符（字符串以'\0‘结尾，这个'\0'即空字符）|
|%t|    以true或者false输出的布尔值|
|%T|    使用Go语法输出的值的类型|
|%U|    一个用Unicode表示法表示的整型码点，默认值为4个数字字符|
|%v|    使用默认格式输出的内置或者自定义类型的值，或者是使用其类型的String()方式输出的自定义值，如果该方法存在的话|
|%x|    以十六进制表示的整型值(基数为十六)，数字a-f使用小写表示|
|%X|    以十六进制表示的整型值(基数为十六)，数字A-F使用小写表示|

## array 数组
> var <varName> [n]<type> ， n >= 0

### 知识点
1. 数组在 Go 中为值类型
2. 数组可以使用 == 或 != 来比较，但不可以使用 < 或 > 
3. 可以使用 new 来创建数组，此方法返回一个指向数组的指针
4. Go 支持多维数组
5. 数组的容量永远等于其长度，都是不可变的

## slice 切片
> make([]T, len, cap)  |  var s []int
>> 1. cap 可以省略， 如果 cap 省略，则和 len 的值相同
>> 2. len 表示保存的元素个数，cap 表示容量

### 知识点
1. 切片本身不是数组，它指向顶层数组
2. 作为变长数组的替代方案，可以关联底层数组的局部或者全部
3. slice 是引用类型
4. 如果多个 slice 指向相同的底层数组，其中一个的值改变会影响全部
5. slice 的容量为其指向的底层数组的长度减去切片的起始索引

### array 与 slice 区别
- array 类型的值长度是固定的，slice 类型的值是可变长的
- array 在函数中传参时，array 传递的是副本，slice 传递的是引用 (map 也是引用传递)

### slice 的扩容
> 参见runtime包中 slice.go 文件里的growslice及相关函数的具体实现: https://github.com/golang/go/blob/master/src/runtime/slice.go#L76

1. 一旦一个切片无法容纳更多的元素，Go 语言就会想办法扩容。但它并不会改变原来的切片，而是会生成一个容量更大的切片，然后将把原有的元素和新元素一并拷贝到新切片中。
2. 在一般的情况下，新切片的容量将会是原切片容量的 2 倍。 
3. 当原切片的长度大于或等于 1024 时，Go 语言将会以原容量的1.25 倍作为新容量的基准。
4. 新容量基准会被调整（不断地与1.25相乘），直到结果不小于原长度与要追加的元素数量之和 （以下简称新长度）。最终，新容量往往会比新长度大一些，当然，相等也是可能的
5. 另外，如果一次追加的元素过多，以至于使新长度比原容量的 2 倍还要大，那么新容量就 会以新长度为基准

## map 数据结构
> make([KeyType]ValueType, cap) 
>>cap 标识容量， 可省略。超出容量时会自动扩容

### 知识点
> Go 语言的字典类型其实是一个哈希表（hash table）的特定实现，比如我们要在哈希表中查找与某个键值对应的那个元素值，那么我们需要先把键值作为参数传给 这个哈希表。哈希表会先用哈希函数（hash function）把键值转换为哈希值。哈希值通常是一个无符号的整数。一个哈希表会持有一定数量的桶（bucket），也可称之为哈希桶，这些哈希桶会均匀地储存其所属哈希表收纳的那些键，哈希表会先用这个键的哈希值的低几位去定位到一个哈希桶，然后再去这个哈希桶中，查找这个键。由于键-元素对总是被捆绑在一起存储的，所以一旦找到了键，就一定能找到对应的 键值

1. Golang 的 map 底层使用哈希表作为底层实现，一个哈希表里可以有多个哈希表节点(bucket)， 每个 bucket 中保存了 map 中的一个或者一组键值对
2. key 必须是支持 == 或 != 比较运算的类型， 不可以是函数， map 或者 slace
2. Map 使用 `make` 创建， 支持 := 简写方式
3. 使用 len() 获取元素个数
4. 键值对不存在时自动添加， 使用 delete() 删除某键值对

### map 数据结构由 runtime/map.go/hmap 定义
```go
type hmap struct {
    count     int                    // 当前保存的元素个数
    ...
    B         int8                   // 当前 bucket 数组大小
    ...
    buckets   unsafe.Pointer         // bucket数组指针，数组的大小为 2^B
}
```
下图展示一个拥有4个bucket的map：

![](https://oscimg.oschina.net/oscnet/a680d221f582e35a1ea8f52616d5c4ca7d2.jpg)

hmap.B=2， 而 hmap.buckets 长度是 2^B 为 4， 元素经过哈希运算后会落到某个 bucket 中进行存储。查找过程类似。 bucket 很多时候被翻译为桶，所谓的哈希桶实际上就是 bucket。

### map 查找过程
查找过程如下：

1. 跟据 key 值算出哈希值
2. 取哈希值低位与 hmpa.B 取模确定 bucket 位置
3. 取哈希值高位在 tophash 数组中查询
4. 如果 tophash[i] 中存储值也哈希值相等，则去找到该 bucket 中的 key 值进行比较
5. 当前 bucket 没有找到，则继续从下个 overflow 的 bucket 中查找。
6. 如果当前处于搬迁过程，则优先从 **oldbuckets** 查找

> - 如果查找不到，也不会返回空值，而是返回相应类型的零值。
> - hmap 数据结构中 **oldbuckets** 成员指身原 bucket， 而 buckets 指向了新申请的 bucket。 新的键值对被插入新的 bucket 中。 后续对 map 的访问操作会触发迁移，将 **oldbuckets** 中的键值对逐步的搬迁过来。当 **oldbuckets** 中的键值对全部搬迁完毕后，删除 **oldbuckets**

### map 插入过程
新元素插入过程如下：

1. 跟据 key 值算出哈希值
2. 取哈希值低位与 hmap.B 取模确定 bucket 位置
3. 查找该 key 是否已经存在，如果存在则直接更新值
4. 如果没找到将 key， 将 key 插入

## channel 通道
>  Don’t communicate by sharing memory; share memory by communicating.  
> 不要通过共享内存来通信，而应该通过通信来共享内存。     (-Rob Pike)

### 通道的创建
> make(chan int [int])

- 在声明一个通道类型变量的时候，我们首先要确定该通道类型的元素类型，这决定了我们可以通过这个通道传递什么类型的数据。
比如，类型字面量 chan int，其中的 chan 是表示通道类型的关键字，而 int 则说明了该通道类型的元素类型。又比如，chan string 代表了一个元素类型为 string 的通道类型。
- 在初始化通道的时候，make 函数除了必须接收这样的类型字面量作为参数，还可以接收一个 int 类型的参数，用于表示该通道的容量。所谓通道的容量，就是指通道最多可以缓存多少个元素值。由此，虽然这个参数是 int 类型的，但是它是不能小于 0 的。
- 当容量为0时，我们可以称通道为非缓冲通道，也就是不带缓冲的通道。而当容量大于0时，我们可以称为缓冲通道，也就是带有缓冲的通道。

### 知识点
> 通道中的各个元素值都是严格地按照发送的顺序排列的，先被发送通道的元素值一定会先被接收。元素值的发送和接收都需要用到操作符 **<-**  我们也可以叫它接送操作符。一个左尖括号紧接着一个减号形象地代表了元素值的传输方向。

1. channel 是 goroutine 沟通的桥梁，大都是阻塞同步的
2. channel 通过 make 创建，通过 close 关闭
3. channel 是引用类型
4. 一个通道相当于一个先进先出的队列
5. 可以设置单向或者双向通道
6. 可以设置缓存大小，在未被填满前不会发生阻塞

### channel 通道的发送和接收操作

```go
ch1 := make(chan int, 3)
ch1 <- 1
ch1 <- 2
ch1 <- 3
elem1 := <-ch1
fmt.Printf("ch1: %v\n" , elem1)  // ch1: 1
```
1. 对于同一个通道，发送操作之间是互斥的，接收操作之间也是互斥的；同样，发送操作和接收操作之间也是互斥的。
> 在同一时刻，Go 语言的运行时系统（以下简称运行时系统）只会执行对同一个通道的任意个发送操作中的某一个，
直到这个元素值被完全复制进该通道之后，其他针对该通道的发送操作才可能被执行。即使这些操作是并发执行（代码在不同的 goroutine ）的也是如此。
>> 注意： 进入通道的并不是 在接收操作符右边的那个元素值，而是它的副本。

2. 发送操作和接收操作中对元素值的处理都是不可分割的。
> 参考 MySQL 事物的「 原子性 」，操作要么还没复制元素值，要么已经复制完毕，不会出现只复制了一部分的情况。
> 保证通道中元素值的完整性，也是为了保证通道操作的唯一性。对于通道中的同一个 元素值来说，它只可能是某一个发送操作放入的，同时也只可能被某一个接收操作取出。

3. 发送操作在完全完成之前会被阻塞。接收操作也是如此。
> - 发送操作包括了 “复制元素值” 和 “放置副本到通道内部” 这两个步骤。在这两个步骤完全完成之前，发起这个发送操作的那句代码会一直阻塞在那里。也就是说，在它 之后的代码不会有执行的机会，直到这句代码的阻塞解除。
> - 接收操作通常包含了 “复制通道内的元素值” “放置副本到接收方” “删掉原值” 三个步骤。

### 单向通道和双向通道
- 一般默认创建的通道都是双向通道，即：既可以发也可以收的通道。
- 所谓单向通道就是，只能发不能收，或者只能收不能发的通道。
- 一个通道是双向的，还是单向的 是由它的类型字面量体现的。

> make(chan<- int, 1)
>> 表示创建看一个容量为 1 的单向通道，并且只能发而不能收，简称为**发送通道**

> make(<-chan int, 1)
>> 表示创建看一个容量为 1 的单向通道，并且只能收而不能发，简称为**接收通道**

#### 单向通道的用途
**单向通道最主要的用途就是约束其他代码的行为。**
```go
// Notifier接口中的SendInt方法只会接受一个发送通道作为参数，所以，在该接口的所有实现类型中的 SendInt 方法都会受到限制。
// 在调用SendInt函数的时候，只需要把一个元素类型匹配的双向通道传给它 就行了，没必要用发送通道，因为 Go 语言在这种情况下会自动地把双向通道转换为函数所需的单向通道。
type Notifier interface { 
    SendInt(ch chan<- int) 
}

// 函数 getIntChan 会返回一个 <-chan int 类型的通道，这就意味着得到该通道的程序，只能从通道中接收元素值。这实际上就是对函数调用方的一种约束了。
func getIntChan() <-chan int {
    num := 5 
    ch := make(chan int, num) 
    for i := 0; i < num; i++ { 
        ch <- i 
        } 
    close(ch) 
    return ch
}

intChan2 := getIntChan() 
for elem := range intChan2 { 
    fmt.Printf(" The element in intChan2: %v\n" , elem) 
}
```
### select 语句与 channel 联用
- select 语句的分支分为两种，一种叫做候选分支，另一种叫做默认分支。
    - 候选分支总是以关键 字 case 开头，后跟一个case表达式和一个冒号，然后从下一行开始写入当分支被选中时需要执行的语句。
    - 默认分支其实就是 default case，因为当且仅当没有候选分支被选中时它才会被执行，所以它以关键字 default 开头并直接后跟一个冒号。同样的在 default: 的下一行写入要执行的语句。

## new 与 make
- new 用于生成一个容器参数 type 的指针 *type ，并且对内部成员做了零值初始化
- make 只用于 **slice** **map** **chan** 初始值为 nil， 并且生成的是 type 而非指针

## 关于 **defer** **return** **匿名函数** 三者的思考
- 问题： defer与return 哪个先执行？

解释：defer会开辟独立的栈空间，遵循先进后出的原则。return关键字会先被执行(return关键字会对值进行拷贝为副本), 然后才进行defer.
但defer的执行结果不影响return(包括地址传递)


```php
代码1:defer
package main

import "fmt"

func main() {
    a := getCount(5)
    fmt.Println(a)
}

func getCount(n int) int {
    defer func () {
        fmt.Println("begin in defer")
        fmt.Println(n)
        n = n + 40
        fmt.Println("end in defer")
    }()
    fmt.Println("out")
    n = n + 10
    return n
}

//output
out
begin in defer
15    //程序非串行执行，所以先执行n=n+10; 然后到defer,获取值15
end in defer
15    //defer中修改值不影响return结果
```


```php
代码2:匿名函数
package main

import "fmt"

func main() {
    a := getCount(5)
    fmt.Println(a)
}

func getCount(n int) int {
    func () {
        fmt.Println("begin in defer")
        fmt.Println(n)
        n = n + 40
        fmt.Println("end in defer")
    }()
    fmt.Println("out")
    n = n + 10
    return n
}

//output
begin in defer
5
end in defer
out
55   //匿名函数顺序执行，结果为55
```

```php
代码3: defer引用传值
package main

import "fmt"

func main() {
    a := getCount(5)
    fmt.Println(a)
}

func getCount(n int) int {
    defer func () {//第二个defer
        fmt.Println("second defer begin")
        fmt.Println(n)
        fmt.Println("second defer end")
    }()
    defer func (m *int) { //第一个defer
        fmt.Println("begin in defer")
        fmt.Println(n)
        *m = *m + 40

        fmt.Println(*m)
        fmt.Println("end in defer")
    }(&n)
    fmt.Println("out")
    n = n + 10
    return n
}

//output
out
begin in defer
15   
55   //地址值修改
end in defer
second defer begin
55   //影响后续defer
second defer end
15   //不影响return关键字的编译
```

```php
代码4:return关键字返回副本值
package main

import "fmt"

func main() {
    s := 5
    a := getCount(&s)
    fmt.Println(a) //15
    fmt.Println(s) //55
}

func getCount(n *int) int {
    defer func (m *int) {
        fmt.Println("begin in defer")
        fmt.Println(*n)
        *m = *m + 40

        fmt.Println(*m)
        fmt.Println("end in defer")
    }(n)
    fmt.Println("out")
    *n = *n + 10
    return *n  //return关键字返回的是副本
}

//output
out
begin in defer
15
55
end in defer
15   //最终return 输出结果a为：15
55   //引用传参，输出结果s为：55
```

## 「 值传递 」 还是 「 引用传递 」

Go 语言里不存在像 Java 等编程语言中那种令人困惑的 “传值或传引用” 问题。在 Go 语言中，我们判断所谓的“传值”或者“传引用”只要看被传递的值的类型就好了。

如果传递的值是引用类型的，那么就是 “传引用”。如果传递的值是值类型的，那么就是 “传值”。从传递成本的角度讲，引用类型的值往往要比值类型的值低很多

## 结构体和结构体的方法
### 结构体

### 结构体的方法
#### 值方法和指针方法之间的不同点
1. 方法内部对所属类型的值修改
    - 值方法的接受者是该方法所属类型值的一个副本，对该副本的修改操作都无法修改所属的类型值，除非这个类型本身是某个引用类型（比如切片或字典）的别名类型。
    - 而指针方法的接收者，是该方法所属的那个基本类型值的**指针值**的一个副本。在这样的方法内对该副本指向的值进行修改，一定会体现在原值上。
2. 一个自定义数据类型的方法集合中仅会包含它的所有值方法，而该类型的指针类型的方法集合却囊括了前者的所有方法，包括所有值方法和所有指针方法。
3. 如果一个值类型和它的指针类型的方法集合是不同的，那么它们具体实现的接口类型的数量就也会有差异，除非这两个数量都是零。
> 比如，一个指针类型实现了某某接口类型，但它的基本类型却不一定能够作为该接口的实现类型。

## 接口数据类型

### 接口的声明
```go
type Code interface {
    Action() return type
}
```
接口通过关键字 type 和 interface 可以声明出接口类型，与结构体类似，不过结构体的声明内部是它的字段声明，而接口内部声明的是方法的定义

### 接口值类型
> 当我们给一个接口变量赋值的时候，该变量的动态类型会与它的动态值一起被存储在一个专用的[数据结构（iface）](https://github.com/golang/go/blob/master/src/runtime/iface.go)中。

iface的实例会包含两个指针，一个是指向类型信息的指针，另一个是指向动态值的指针。这 里的类型信息是由另一个专用数据结构的实例承载的，其中包含了动态值的类型，以及使它实现了接口的方法和调用它们的途径，等等。

当给接口变量赋值时，接口变量会持有被赋予值的副本，而不是它本身，接口变量的值并不等同于这个变量值的副本。它会包含两个指针，一个指 针指向动态值，一个指针指向类型信息。

## 接口 及 结构体 嵌套
接口嵌套的方法调用类似子类继承父类的函数方式，但是不同于子类继承。子类调用，对象就是子类，而接口嵌套调用方法时，其实质是直接调用该方法源（谁的方法，就是调用谁）。

- 使用嵌套函数时，需要注意 **指针入参 struct** 与 **非指针的入参 struct** 的区别 

```c
package main
import "fmt"

//接口
type Parent interface{
    Left
    Right
}
type Left interface {
    getName() string
}
type Right interface{
    getAge() int
}

//结构体嵌套
type User struct {
    N
    A
}

type N string 
type A int

func (n N) getName() string {
    return string(n)
}
func (a A) getAge() int {
    return int(a)
}

func main() {
    var o Parent
    //方式1
    // n := N("zhang123")
    // a := A(181)
    //u := User{n,a}
    
    //方式2
    u := new(User)
    u.N = "123"
    u.A = 40
    
    //嵌套结构体实现
    o = u
    fmt.Println(o.getName(), o.getAge())
    //output: "123" 40
}
```

## init 函数运行： 
先引入当前文件中的包，执行包中的 const, var, 然后执行包中init()函数，返回当前文件脚本，
执行当前脚本中的const, var, init()...

## 错误处理panic, recover
```php
package main

import (
    "fmt"
)

// 定义结构体
type User struct {
    Name string
    Age int
}

func (b User) error(mes string) {
    panic(Err(mes))
}

func main() {
    // defer
    defer func () {
        if err := recover() ; err != nil {//recover函数
            fmt.Println("in recover")
            fmt.Println(err.(Err).Error())
        }
    }()
    u := new(User)
    u.Name = "张飞"
    input := 20
    if input > 18 {
        u.error("超过18岁不可以使用")
    }
    u.Age = input
    fmt.Println(u)
}

//定义错误,实现Error接口
type Err string

func (e Err) Error() string {
    return string(e)
}

```

## 指针

### Go 中可以代表指针的几种情况
1. 指向某个内存地址的值 （&var）
2. [uintptr](#go的数据类型) 类型，该类型实际上是一个数值类型，也是 Go 语言内建的数据类型之一
3. unsafe.Pointer 标准库中的 unsafe 包。unsafe 包中有一个类型叫做 [**Pointer**](https://github.com/golang/go/blob/master/src/unsafe/unsafe.go#L180) ，也代表了“指针”

### Go 中的哪些值是不可寻址的
> 1. 不可变的值不可寻址。常量、基本类型的值字面量、字符串变量的值、函数以及方法的字面量都是如此。其实这样规定也有安全性方面的考虑。
> 2. 绝大多数被视为临时结果的值都是不可寻址的。算术操作的结果值属于临时结果，针对值字面量的表达式结果值也属于临时结果。但有一个例外，对切片字面量的索引结果值虽然也属于临时结果，但却是可寻址的。
> 3. 若拿到某值的指针可能会破坏程序的一致性，那么就是不安全的，该值就不可寻址。由于字典的内部机制，对字典的索引结果值的取址操作都是不安全的。另外，获取由字面量或标识符代表的函数或方法的地址显然也是不安全的。

- 常量的值
- 基本类型值的字面量
- 算术操作的结果值
- 对各种字面量的索引表达式和切片表达式的结果值，不过有一个例外，对切片字面量的索引结果值却是可寻址的
- 对字符串变量的索引表达式和切片表达式的结果值
- 对字典变量的索引表达式的结果值
- 函数字面量和方法字面量，以及对它们的调用表达式的结果值
- 结构体字面量的字段值，也就是对结构体字面量的选择表达式的结果值
- 类型转换表达式的结果值
- 类型断言表达式的结果值
- 接收表达式的结果值





