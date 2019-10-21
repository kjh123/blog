---
title: Linux命令学习
tags:
  - Linux
  - 记录
  - 命令
top: 98
sticky: 98
categories: Linux
translate_title: linux-command-learning
date: 2018-06-27 14:54:32
---

本文主要记录在学习或者工作中用到的一些 **Linux** 命令

<!--more-->
  
# 常用命令
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
```bash line_number:false
    # 使用 for 循环
    for fn in *.jpg; do convert "$fn" `echo $fn | sed 's/jpg$/png/'`; done
    
    # 使用 xargs 
    ls *.jpg | xargs -I{} convert "{}" `echo {} | sed 's/jpg$/png/'`
```

## 禁止 root 用户 SSH 登录服务器
```bash
sed -i -E 's/#?\s*(PermitRootLogin)(.*)$/\1 no/' /etc/ssh/sshd_config
```

# Git 技巧
## 常用命令
> 全部命令参考 [Git命令图解](/images/posts/git.png)

```bash
# 查看分支：
git branch -r # 查看所有远程分支
git branch -a # 查看本地及线上所有分支
git branch -vv # 本地分支关联到远程仓库的情况

# 新建分支：
git branch <new branch-name> # 新建分支
git checkout -b <new branch-name> # 新建并切换到该分支
git checkout -b <branch-name> origin/<branch-name> # 从远程分支中创建并切换到本地分支

# 回退分支：
git reset --hard HEAD~1 # 回退本地当前分支
    git push --force # 回退远程分支

# 删除分支：
git branch -d/-D <local-branch-name> # 删除一个本地分支
git push origin --delete <remote-branchname> # 删除远程分支
git push origin :<remote-branchname> # 删除远程分支
git branch --merged master | grep -v '^\*\|  master' | xargs -n 1 git branch -d # 删除已经合并到 master 的分支

# 代码暂存：
git stash # 代码暂存
git stash list # 查看暂存区列表
git stash apply <stash@{0}> # 恢复暂存区的代码（恢复完之后还保留在暂存区）
git stash pop # 恢复最后一个暂存内容，并删除该暂存
git stash clear # 清空暂存区

# 标签：
git tag -ln # 查看所有标签以及详细信息
git tag <version-number> # 新建本地标签
git tag -a <version-number> -m "v1.0 发布(描述)" <commit-id>  # 默认 tag 是打在最近的一次 commit 上，如果需要指定 commit 打 tag
git push origin <local-version-number> # 推送指定本地标签到远程
git push origin --tags  # 一次性推送所有标签，同步到远程仓库
git tag -d <tag-name> # 删除本地标签
git push origin :refs/tags/<tag-name> # 删除远程标签（需要先删除本地标签）
git checkout -b branch_name tag_name # 切换到某个标签

# git cherry-pick 向当前分支合并commit
git cherry-pick <commit-id> 单独合并一个提交
git cherry-pick -x <commit-id> 单独合并一个提交，并保留原来提交者信息
git cherry-pick <start-commit-id>..<end-commit-id> 把 start 到 end 之间的提交合并到当前分支 (不包含 start)
git cherry-pick <start-commit-id>^..<end-commit-id> 把 start 以及 end 之间的提交合并到当前分支 (包含 start)

# 其他操作：
git revert <commit-id> # 以新增一个 commit 的方式还原某一个 commit 的修改
git branch -m <new-branch-name> # 重命名本地分支
git bundle create <file> <branch-name> # 把某一个分支到导出成一个文件
git clean -X -f # 清除Ignore中记录的文件
git show <branch-name>:<file-name> # 展示某一分支下的某个文件修改
git clone -b <branch-name> --single-branch https://github.com/user/repo.git # 仅Clone下来指定的单一分支
git config core.fileMode false # 忽略文件的权限变化
git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ # 以最后提交的顺序列出所有Git分支
git remote set-url origin <URL> # 修改远程仓库的URL
```

## Git 监听大小写设置
Mac 开发默认大小写不敏感所以可能会遇到本地环境没问题，上线报错的问题
解决： `git config core.ignorecase false`

## Git硬回退补救方案
> `git reflog` 查看Git所有分支的所有操作(包含已经删除的记录)
> `git cherry-pick <commit id>` 向当前分支单独合并一个提交

假定当前场景为： 在提交了 1，2，3，4，5 等多个 **feature commit**之后，然后执行了 `git reset --hard xxx1` 代码硬回退到第一次提交， 然后又提交了第 6 个 **feature commit**， 现在想要恢复 1，2，3，4，5，6 等 feature commit 提交
恢复步骤
1. 执行 `git reflog` 查看操作记录
```git mark:2 diff:true 
xxx7 HEAD@{0} commit: feature-6
xxx6 HEAD@{1} commit: reset moving to xxx1
-xxx5 HEAD@{2} commit: feature-5  ▔▔|
-xxx4 HEAD@{3} commit: feature-4    |=> 硬回退部分
-xxx3 HEAD@{4} commit: feature-3    |
-xxx2 HEAD@{5} commit: feature-2  __|
xxx1 HEAD@{6} commit: feature-1
```
记录硬回退之前的一次提交(xxx5) 和 后面需要保存的提交(xxx6)
2. 执行 `git reset --hard xxx5` 恢复代码到硬回退之前的这次提交中
3. 合并需要保存的提交 `git cherry-pick xxx6` 

## 技巧
 由于在项目中经常要用到 `git log` 来查看提交历史，分享一个不错的 `git log` 的配置
```bash line_number:false
git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'
```

效果如图：
![git-log效果图](/images/posts/47269758.jpg)

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

### 示例
日志格式： 
`$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"`
日志记录：
`27.189.231.39 - [09/Apr/2018:16:22:23 +0800] "GET /Public/index/images/icon_pre.png HTTP/1.1" 200 44668 "http://www.test.com/Public/index/css/global.css" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36" "-"`

1. 统计日志最多的10个IP
```bash line_number:false
awk '{arr[$1]++} END {for(i in arr) {print arr[i]}}' access.log | sort -k1 -nr | uniq -c | head -n10
```
2. 统计日志访问次数大于100次的IP
```bash line_number:false
awk '{arr[$1]++} END{for (i in arr) {if(arr[i] > 100){print $i}}}' access.log
```
3. 统计2018年4月9日内访问最多的10个ip
```bash line_number:false
awk '$4>="[09/Apr/2018:00:00:00" && $4<="[09/Apr/2018:23:59:59" {arr[i]++} END{print arr[i]}' | sort -k1 -nr | head -n10
```
4. 统计访问最多的十个页面
```bash line_number:false
 awk '{a[$7]++}END{for(i in a)print a[i],i | "sort -k1 -nr | head -n10"}' access.log
```
5. 统计访问状态为404的ip出现的次数
```bash line_number:false
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

sed命令的选项(**option**)：
* -n ：只打印模式匹配的行
* -e ：直接在命令行模式上进行sed动作编辑，此为默认选项
* -f ：将sed的动作写在一个文件内，用 **–f filename** 执行 filename 内的 sed 动作
* -r ：支持扩展表达式
* -i ：直接修改文件内容
* -p ：命令表示打印当前行

>   示例： 输出某个文本里面全部的内容： 
    `sed -n p file` # 输出 file 文件的日志
    若要输出某几行显示 则可以在 P 前面加上行数 并以 , 分割 格式为 sed -n '第几行,截止到第几行'p file(s)
    sed -n '1,2'p file  # 输出 file 文件中第一行到第二行的内容
    如果要输出第几行到最后的内容可以使用 $ 
    sed -n '5,$'p file  # 输出 file 文件中第五行开始一直到最后的所有内容 

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
        **pattern-to-find**：被替换的串
        **replacement-pattern**：替换成这个串
        **g**：全部替换，如果不加 **g** 默认只替换匹配到的第一个
`sed 's/php/python/g' file` 该命令会输出 file 文件中的内容，同时把文件中出现的 `php` 全部替换为 `python`
  
----