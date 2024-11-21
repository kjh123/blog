# Linux常用命令

## 查看 & 搜索
- `cat /proc/version` 先查看当前服务器的版本
- `du -sh` 查看当前目录所占空间大小
- `grep -C 5 foo file` 显示file文件里匹配foo字串那行以及上下5行
- `grep "<string>" . -R -n` 在多级目录中对文本递归搜索
- `cat LOG.* | tr a-z A-Z | grep "FROM " | grep "WHERE" > b ` 将日志中的所有带 where 条件的SQL查找查找出来
- `ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6` 查看使用内存最多的五个进程
- `cat /proc/cpuinfo | grep processor | wc -l` 查看 CPU 核数
- `find ./ \( -iname '*.jpeg' -o -iname '*.jpg' \) -type f -mtime + 7 ` 查找最后修改的时间为7天前的，jpg 或 jpeg 格式的图片

> 更多 find 内容参考： [如何在 Linux 中使用 find](https://linux.cn/article-9648-1.html)

## 文件操作
- `cut -d ',' -f 1`   d：以逗号切割  f：每行切割的第几份
- `tar -cvf etc.tar /etc` 仅打包文件，不压缩
- `gzip demo.txt` 压缩文件
- `zip -q -r html.zip /home/Blinux/html` #打包压缩成zip文件

### ln 创建文件链接
- 语法： `ln [参数] [源文件或目录] [目标文件或目录]`
- 参数：
    + -b ： 删除或覆盖之前的链接
    + -d ： 建立硬链接
    + -f ： 强制执行， 不论文件或目录是否存在
    + -i ： 文件存在则提示用户是否覆盖
    + -n ： 把符号链接视为一般目录
    + -s ： 建立软链接（符号链接）
    + -v ： 显示指令执行过程

## 进程管理 & 网络服务
- `ps -ef` 查询正在运行的进程信息
- `ps -A | grep nginx` 查看进程中的nginx
- `lsof -p 23295` 查询指定的进程ID(23295)打开的文件
- `top` 显示进程信息，并实时更新
- `netstat -at` 列出所有tcp端口

## 文件批量重命名
```bash 
# 使用 find 查找 login_data_*.csv 的文件, 并重命名为 *.csv, (移除 login_data_ 前缀)
find . -name 'login_data_*.csv' -exec rename 's/login_data_//' {} \;
```

## 禁止 root 用户 SSH 登录服务器
```bash
sed -i -E 's/#?\s*(PermitRootLogin)(.*)$/\1 no/' /etc/ssh/sshd_config
```

----

# OpenSSL 生成秘钥文件
>输入`openssl`进入openssl交互界面 

1. 生成私钥：       
```bash 
genrsa -out rsa_private_key.pem 1024
```
2. 转换成pckcs8格式：
```bash 
pkcs8 -topk8 -nocrypt -inform PEM -in rsa_private_key.pem -outform PEM outform
```
3. 根据私钥生成公钥： 
```bash 
rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
```

----


# 文本处理命令 awk & sed
## awk
> awk 是一个行文本处理工具，逐行处理文件中的数据

### 使用方式

`awk 'pattern + {action}'`
> - `{action}` 是一个命令分组，`action` 是处理命令 
> - `pattern` 是一个过滤器，表示经过过滤后的内容经过 `action` 处理，两者必须存在其一，可以同时存在
> - `pattern` 参数可以是正则表达式
>> 示例： `cat 11-08.log | awk '/hello/'`  # 输出 11-08.log 文件中包含 hello 的行
>>       `cat 11-08.log | awk '/hello/ {print NR}'  # 输出 11-08.log 文件中包含 hello 的行号

### awk 内置变量 和 函数
#### 变量
- NR 当前行号
- FS 分隔符，默认是空格
- NF 当前记录的字段个数
- $0 当前记录
- $1~$n 当前记录的第 n 个字段 


> 例如： `cat 11-08.log | awk 'NR==2,NR==4 {print $NF}' `  # 显示 11-08.log 文件中的第2行到第4行的最后一列


#### 函数
- gsub(r,s)：在 **$0** 中用 **s** 代替 **r**
- index(s,t)：返回 **s** 中 **t** 的第一个位置
- length(s)： **s** 的长度
- match(s,r)： **s** 是否匹配 **r**
- split(s,a,fs)：在 **fs** 上将 **s** 切割成序列 **a**
- substr(s,p)：返回 **s** 从 **p** 开始的子串

### 流程控制语句
1. **BEGIN {} END {}**
2. **if(coondotion){}else{}**
3. **while(condition){}**
4. **do()while(condition)**
5. **for(init;condition;step){}**
6. **break/continue**

### 示例

```log
日志格式： 
$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"

日志记录：
27.189.231.39 - [09/Apr/2018:16:22:23 +0800] "GET /Public/index/images/icon_pre.png HTTP/1.1" 200 44668 "http://www.test.com/Public/index/css/global.css" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36" "-"
```

1. 统计日志最多的10个IP
```bash 
awk '{arr[$1]++} END {for(i in arr) {print arr[i]}}' access.log | sort -k1 -nr | uniq -c | head -n10
```
2. 统计日志访问次数大于100次的IP
```bash 
awk '{arr[$1]++} END{for (i in arr) {if(arr[i] > 100){print $i}}}' access.log
```
3. 统计2018年4月9日内访问最多的10个ip
```bash 
awk '$4>="[09/Apr/2018:00:00:00" && $4<="[09/Apr/2018:23:59:59" {arr[i]++} END{print arr[i]}' | sort -k1 -nr | head -n10
```
4. 统计访问最多的十个页面
```bash 
 awk '{a[$7]++}END{for(i in a)print a[i],i | "sort -k1 -nr | head -n10"}' access.log
```
5. 统计访问状态为404的ip出现的次数
```bash 
awk '{if($9~/404/)a[$1" "$9]++}END{for(i in a)print i,a[i]}' access.log
```

> 相关命令
uniq -c 统计去重的行数
sort -nrk1 k : 第几列 n：以数字模式排序 r：倒序排序

## sed
> Stream Editor文本流编辑，sed是一个“非交互式的"面向字符流的编辑器。能同时处理多个文件多行的内容，可以不对原文件改动，把整个文件输入到屏幕,可以把只匹配到模式的内容输入到屏幕上。还可以对原文件改动，但是不会再屏幕上返回结果

### 使用方式

语法格式：
* sed的命令格式： `sed [option] 'sed command' filename`
* sed的脚本格式： `sed [option] -f 'sed script' filename`

sed命令的选项(option)：
* -n ：只打印模式匹配的行
* -e ：直接在命令行模式上进行sed动作编辑，此为默认选项
* -f ：将sed的动作写在一个文件内，用 **–f filename** 执行 filename 内的 sed 动作
* -r ：支持扩展表达式
* -i ：直接修改文件内容
* -p ：命令表示打印当前行

```bash
# 示例： 输出某个文本里面全部的内容： 
sed -n p file # 输出 file 文件的日志

# 若要输出某几行显示 则可以在 P 前面加上行数 并以 , 分割 格式为 sed -n '第几行,截止到第几行'p file(s)
sed -n '1,2'p file  # 输出 file 文件中第一行到第二行的内容

# 如果要输出第几行到最后的内容可以使用 $ 
sed -n '5,$'p file  # 输出 file 文件中第五行开始一直到最后的所有内容 
```

### 相关命令
#### 将匹配行删除 d
`sed '/^$/d' file` 删除file文件的空白行
`sed '1,10d' file` 删除file文件的1-10行
`sed '/hello/'d file` 该命令会输出file文件中的内容，同时把匹配到 hello 的行会删除 

#### 追加 a\
`sed '/^test/a\this is a test line' file` 将 this is a test line 追加到 以test 开头的行后面

对源文件追加 使用 **-i**
`sed '/^test/i\this is begin/' file` 将this is end 追加到匹配的行头

#### 将匹配行替换 s
命令格式： `s/pattern-to-find/replacement-pattern/g`
> - **pattern-to-find**：被替换的串
> - **replacement-pattern**：替换成这个串
> - **g**：全部替换，如果不加 **g** 默认只替换匹配到的第一个

`sed 's/php/python/g' file` 该命令会输出 file 文件中的内容，同时把文件中出现的 `php` 全部替换为 `python`
  
----