---
title: Linux命令学习
date: 2018-06-27 14:54:32
tags: [Linux, 记录, 命令]
categories: Linux
---

本文主要记录在学习或者工作中用到的一些 **Linux** 命令

<!--more-->

# 常用命令

## ls 命令详细
- 按文件大小列出： `ls -s`
- 按时间和日期排序： `ls -t`
- 按扩展名排序： `ls -X`
- 按文件大小排序：`ls -S`

## find 文件查找 

```bash :Find 命令 line_number:false url:https://linux.cn/article-9648-1.html 相关链接
    # 查找最后修改的时间为7天前的，jpg 或 jpeg 格式的图片 【注意括号后面需要添加一个空格】
    find ./ \( -iname '*.jpeg' -o -iname '*.jpg' \) -type f -mtime + 7 
```

----

# 文本处理命令 awk & sed
## awk
> awk 是一个行文本处理工具，逐行处理文件中的数据

### 使用方式
`awk 'pattern + {action}'`
> `{action}` 是一个命令分组，`action` 是处理命令 
> `pattern` 是一个过滤器，表示经过过滤后的内容经过 `action` 处理，两者必须存在其一，可以同时存在
> `pattern` 参数可以是正则表达式
> 示例： `cat 11-08.log | awk '/hello/'`  # 输出 11-08.log 文件中包含 hello 的行
>       `cat 11-08.log | awk '/hello/ {print NR}'  # 输出 11-08.log 文件中包含 hello 的行号

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
1. `BEGIN {} END {}`
2. `if(coondotion){}else{}`
3. `while(condition){}`
4. `do()while(condition)`
5. `for(init;condition;step){}`
6. `break/continue`


## sed
> sed是一种行文本处理工具，它一次处理一行内容

### 使用方式

`sed [options] 'command' file(s) `
>   示例： 输出某个文本里面全部的内容： 
    `sed -n p 11-07.log` # 输出 11-07.log 文件的日志
        -n：sed会在处理一行文本前，将待处理的文本打印出来，-n参数关闭了这个功能
        p：命令表示打印当前行
    若要输出某几行显示 则可以在 P 前面加上行数 并以 , 分割 格式为 sed -n '第几行,截止到第几行'p file(s)
    sed -n '1,2'p 11-07.log  # 输出 11-07.log 文件中第一行到第二行的内容
    如果要输出第几行到最后的内容可以使用 $ 
    sed -n '5,$'p 11-07.log  # 输出 11-07.log 文件中第五行开始一直到最后的所有内容 

### 相关命令
#### 将匹配行删除
`sed '/hello/'d 11-07.log` 该命令会输出 11-07.log 文件中的内容，同时把匹配到 hello 的行会删除 （该命令只会影响输出后的显示内容，对源文件不做修改）

#### 将匹配行替换
命令格式： `s/pattern-to-find/replacement-pattern/g`
        **pattern-to-find**：被替换的串
        **replacement-pattern**：替换成这个串
        **g**：全部替换，如果不加 **g** 默认只替换匹配到的第一个
`sed 's/php/python/g' 11-07.log` 该命令会输出 11-07.log 文件中的内容，同时把文件中出现的 `php` 全部替换为 `python`

## 实例： 查找某个时间段内服务器的访问IP
*在此感谢某位大佬* [@大佬](https://gitee.com/alwaysthanksFel)

```bash line_number:false
    sed -n '/2018:06:25:59/,/2018:09:50/p' access.log | awk '{print $1}' | sort -nrk1 | uniq -c | tee
```
> uniq -c       统计去重的行数
  sort -nrk1    k : 第几列 n：以数字模式排序 r：倒序排序
  sed '/^$/d'   删除空行
  
----

# Git 技巧
 由于在项目中经常要用到 `git log` 来查看提交历史，分享一个不错的 `git log` 的配置
```bash line_number:false
git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'
```

效果如图：
![git-log效果图](http://learner-hui.oss-cn-beijing.aliyuncs.com/18-11-27/47269758.jpg)

添加到 bash alias :
```bash line_number:false
alias gitlog="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
```

> 分享来自 [分享一个自定义的 git log 配置](https://www.codecasts.com/blog/post/a-beautiful-git-log-format)

----

# OpenSSL 生成秘钥文件
>输入`openssl`进入openssl交互界面 

1. 生成私钥：       
```bash line_number:false
    genrsa -out rsa_private_key.pem 1024
```
2. 转换成pckcs8格式：
```bash line_number:false
    pkcs8 -topk8 -nocrypt -inform PEM -in rsa_private_key.pem -outform PEM outform
```
3. 根据私钥生成公钥： 
```bash line_number:false
    rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
```

----
  
# 其他命令
- `grep -C 5 foo file` 显示file文件里匹配foo字串那行以及上下5行
- `cut -d ',' -f 1`   d：以逗号切割  f：每行切割的第几份
- `ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6` 查看使用内存最多的五个进程
- `cat /proc/cpuinfo | grep processor | wc -l` 查看 CPU 核数

## 文件批量重命名
```bash line_number:false
    # 使用 for 循环
    for fn in *.jpg; do convert "$fn" `echo $fn | sed 's/jpg$/png/'`; done
    
    # 使用 xargs 
    ls *.jpg | xargs -I{} convert "{}" `echo {} | sed 's/jpg$/png/'`
```



