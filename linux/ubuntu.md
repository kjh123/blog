
## Ubuntu设置Swap交换空间

>交换分区并不是必须的，但是有些软件却强制要求系统内含有交换分区
>> 先在分区内创建交换文件，再让系统挂载这个交换文件

### 查看交换分区

`free -m` 查看当前系统的交换分区信息

```bash
              total        used        free      shared  buff/cache   available
Mem:           1993         120        1730           2         142        1726
Swap:          0            0          0
```

Swap的total值是0，说明当前系统没有设置交换空间。Mem指的是计算机内存大小，图中显示为2G

### 创建和挂载

1. 获取 root 权限  `sudo -i`
2. 在根目录下创建交换空间目录（文件夹）：`mkdir /swap && cd /swap`
3. 指定一个大小为 1G 的名为 **swap** 的交换文件(你可以自定义文件名)：`dd if=/dev/zero of=swap bs=1M count=1k`。空间大小由 **bs x count** 计算得出
4. 创建交换文件：`mkswap swap`
5. 挂载交换分区：`swapon swap`
6. 查看交换空间信息：`free -m`

```bash
              total        used        free      shared  buff/cache   available
Mem:           1993         120        1730           2         142        1726
Swap:          1023         0          1023
```

### 卸载交换分区

卸载交换分区的命令：`swapoff swap`




