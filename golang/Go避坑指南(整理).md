<center>收集网络上关于 Golang 的一些坑和需要注意的地方</center>

## 收集来源： 知乎: https://www.zhihu.com/question/60952598/answer/414690873

1. uint 不能直接相减，结果是负数会变成一个很大的 uint，这点对动态语言出身的会可能坑。
2. channel 一定记得 close。 
3. goroutine 记得 return 或者中断，不然容易造成 goroutine 占用大量 CPU。
4. 从 slice 创建 slice 的时候，注意原 slice 的操作可能导致底层数组变化。
5. 如果你要创建一个很长的 slice，尽量创建成一个 slice 里存引用，这样可以分批释放，避免 gc 在低配机器上 "stop the world"

### 需要注意的地方
1. 面试的时候尽量了解协程，线程，进程的区别。
2. 明白 channel 是通过注册相关 goroutine id 实现消息通知的。
3. slice 底层是数组，保存了 len，capacity 和对数组的引用。
4. 如果了解协程的模型，就知道所谓抢占式 goroutine 调用是什么意思。
5. 尽量了解互斥锁，读写锁，死锁等一些数据竞争的概念，debug 的时候可能会有用。
6. 尽量了解 golang 的内存模型，知道多小才是小对象，为什么小对象多了会造成gc压力。


