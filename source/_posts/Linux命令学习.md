---
title: Linux命令学习
tags:
  - Linux
  - 记录
  - 命令
top: 98
categories: Linux
translate_title: linux-command-learning
date: 2018-06-27 14:54:32
---

本文主要记录在学习或者工作中用到的一些 **Linux** 命令

<!--more-->
  
# 常用命令
## 查看 & 搜索
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

## vim 常用快捷键
```
常用指令 (commands)
a -> 在光表后插入 (append after cursor)
A -> 在一行的结尾插入 (append at end of the line)
i -> 在光标前插入 (insert before cursor)
I -> 在第一个非空白字符前插入 (insert before first non-blank)
o -> 光标下面插入一个新行 (open line below)
O -> 光标上面插入一个新行 (open line above)
x -> 删除光标下（或者之后）的东西 (delete under and after cursor)
例如x就是删除当前光标下，3x就是删除光标下+光标后2位字符
X -> 删除光标前的字符 (delete before cursor)
d -> 删除 (delete)
J -> 将下一行提到这行来 (join line)
r -> 替换个字符 (replace characters)
R -> 替换多个字符 (replace mode – continue replace)
gr -> 不影响格局布置的替换 (replace without affecting layout)
c -> 跟d键一样，但是删除后进入输入模式 (same as “d" but after delete, in insert mode)
S -> 删除一行(好像dd一样）但是删除后进入输入模式 (same as “dd" but after delete, in insert mode)
s -> 删除字符，跟(d)一样，但是删除后进入输入模式 (same as “d" but after delete, in insert mode)
s4s 会删除4个字符，进入输入模式 (delete 4 char and put in insert mode)
~ -> 更改大小写，大变小，小变大 (change case upper-> lower or lower->upper)
gu -> 变成小写 (change to lower case)
例如 guG 会把光标当前到文件结尾全部变成小写 (change lower case all the way to the end)
gU -> 变成大写 (change to upper case)
例如 gUG 会把光标当前到文件结尾全部变成大写 (change upper case all the way to the end)

查找替换（find）
/pattern        向后搜索字符串pattern
?pattern        向前搜索字符串pattern
"\c"            忽略大小写
"\C"            大小写敏感
n               下一个匹配(如果是/搜索，则是向下的下一个，?搜索则是向上的下一个)
N               上一个匹配(同上)
:%s/old/new/g   搜索整个文件，将所有的old替换为new
:%s/old/new/gc  搜索整个文件，将所有的old替换为new，每次都要你确认是否替换

编辑指令 (edit)
u -> undo
CTRL-r -> redo
v -> 进入视觉模式
CTRL-v -> visual block

将文件写成网页格式 (html)
:source $VIMRUNTIME/syntax/2html.vim -> change current open file to html

加密 (encryption)
vim可以给文件加密码
vim -x 文件名 (filename) -> 输入2次密码，保存后文件每次都会要密码才能进入 (encrypt the file with password)
vim 处理加密文件的时候，并不会作密码验证，也就是说，当你打开文件的时候，vim不管你输入的密码是否正确，直接用密码对本文进行解密。如果密码错误，你看 到的就会是乱码，而不会提醒你密码错误（这样增加了安全性，没有地方可以得知密码是否正确）当然了，如果用一个够快的机器作穷举破解，vim还是可以揭开的

语法显示 (syntax)
:syntax enable -> 打开语法的颜色显示 (turn on syntax color)
:syntax clear -> 关闭语法颜色 (remove syntax color)
:syntax off -> 完全关闭全部语法功能 (turn off syntax)
:syntax manual -> 手动设定语法 (set the syntax manual, when need syntax use :set syntax=ON)

自动备份 (backup)
vim可以帮你自动备份文件（储存的时候，之前的文件备份出来）
:set backup -> 开启备份，内建设定备份文件的名字是 源文件名加一个 '~' (enable backup default filename+~)
:set backupext=.bak -> 设定备份文件名为源文件名.bak (change backup as filename.bak)
自动备份有个问题就是，如果你多次储存一个文件，那么这个你的备份文件会被不断覆盖，你只能有最后一次存文件之前的那个备份。没关系，vim还提 供了patchmode，这个会把你第一次的原始文件备份下来，不会改动
:set patchmode=.orig -> 保存原始文件为 文件名.orig (keep orignal file as filename.orig)
开启，保存与退出 （save & exit)

复制与粘贴 (copy & paste)
y -> 复制 (yank line)
yy -> 复制当前行 (yank current line)
{a-zA-Z}y -> 把信息复制到某个寄存中 (yank the link into register {a-zA-Z})
例如我用 ayy 那么在寄存a，就复制了一行，然后我再用byw复制一个词在寄存b
粘贴的时候，我可以就可以选择贴a里面的东西还是b里面的，这个就好像是多个复制版一样
*y -> 这个是把信息复制进系统的复制版（可以在其他程序中贴出来）(yank to OS buffer)
p -> 当前光标下粘贴 (paste below)
P -> 当前光标上粘贴 (paste above)
{a-zA-Z}p -> 将某个寄存的内容贴出来 (paste from register)
例如ap那么就在当前光标下贴出我之前在寄存a中 的内容。bP就在当前光标上贴出我之前寄存b的内容
*p -> 从系统的剪贴板中读取信息贴入vim (paste from OS buffer to vim)
reg -> 显示所有寄存中的内容 (list all registers)

书签 (Mark)
书签是vim中非常强大的一个功能，书签分为文件书签跟全局书签。文件书签是你标记文件中的不同位置，然后可以在文件内快速跳转到你想要的位置。 而全局书签是标记不同文件中的位置。也就是说你可以在不同的文件中快速跳转
m{a-zA-Z} -> 保存书签，小写的是文件书签，可以用(a-z）中的任何字母标记。大写的是全局 书签，用大写的(A-Z)中任意字母标记。(mark position as bookmark. when lower, only stay in file. when upper, stay in global)
'{a-zA-Z} -> 跳转到某个书签。如果是全局书签，则会开启被书签标记的文件跳转至标记的行 (go to mark. in file {a-z} or global {A-Z}. in global, it will open the file)
'0 -> 跳转入现在编辑的文件中上次退出的位置 (go to last exit in file)
" -> 跳转如最后一次跳转的位置 (go to last jump -> go back to last jump)
'" -> 跳转至最后一次编辑的位置 (go to last edit)
g'{mark} -> 跳转到书签 (jump to {mark})
:delm{marks} -> 删除一个书签 (delete a mark) 例如:delma那么就删除了书签a
:delm! -> 删除全部书签 (delete all marks)
:marks -> 显示系统全部书签 (show all bookmarks)

标志 (tag)
:ta -> 跳转入标志 (jump to tag)
:ts -> 显示匹配标志，并且跳转入某个标志 (list matching tags and select one to jump)
:tags -> 显示所有标志 (print tag list)

运行外部命令 (using an external program)
:! -> 直接运行shell中的一个外部命令 (call any external program)
:!make -> 就直接在当前目录下运行make指令了 (run make on current path)
:r !ls -> 读取外部运行的命令的输入，写入当然vim中。这里读取ls的输出 (read the output of ls and append the result to file)
:3r !date -u -> 将外部命令date -u的结果输入在vim的第三行中 (read the date -u, and append result to 3rd line of file)
:w !wc -> 将vim的内容交给外部指令来处理。这里让wc来处理vim的内容 (send vim's file to external command. this will send the current file to wc command)
vim对于常用指令有一些内建，例如wc (算字数）(vim has some buildin functions, such like wc)
g CTRL-G -> 计算当前编译的文件的字数等信息 (word count on current buffer)
!!date -> 插入当前时间 (insert current date)

多个文件的编辑 (edit multifiles)
vim a.txt b.txt c.txt 就打开了3个文件
:next -> 编辑下一个文件 (next file in buffer)
:next! -> 强制编辑下个文件，这里指如果更改了第一个文件 (force to next file in buffer if current buffer changed)
:wnext -> 保存文件，编辑下一个 (save the file and goto next)
:args -> 查找目前正在编辑的文件名 (find out which buffer is editing now)
:previous -> 编辑上个文件 (previous buffer)
:previous! -> 强制编辑上个文件，同 :next! (force to previous buffer, same as :next!)
:last -> 编辑最后一个文件 (last buffer)
:first -> 编辑最前面的文件 (first buffer)
:set autowrite -> 设定自动保存，当你编辑下一个文件的时候，目前正在编辑的文件如果改动，将会自动保存 (automatic write the buffer when you switch to next buffer)
:set noautowrite -> 关闭自动保存 (turn autowrite off)
:hide e abc.txt -> 隐藏当前文件，打开一个新文件 abc.txt进行编辑 (hide the current buffer and edit abc.txt)
:buffers -> 显示所有vim中的文件 (display all buffers)
:buffer2 -> 编辑文件中的第二个 (edit buffer 2)

分屏 (split)
vim提供了分屏功能（跟screen里面的split一样）
:split -> 将屏幕分成2个 (split screen)
:split abc.txt -> 将屏幕分成两个，第二个新的屏幕中显示abc.txt的内容 (split the windows, on new window, display abc.txt)
:vsplit -> 竖着分屏 (split vertically)
:{d}split -> 设定分屏的行数，例如我要一个屏幕只有20行，就可以下:20split (split the windows with {d} line. 20split: open new windows with 3 lines)
:new -> 分屏并且在新屏中建立一个空白文件 (split windows with a new blank file)
CTRL-w+j/k/h/l -> 利用CTRL加w加上j/k/h/l在不同的屏内切换 (switch, move between split screens)
CTRL-w+ -/+ -> 增减分屏的大小 (change split size)
CTRL-w+t -> 移动到最顶端的那个屏 (move to the top windows)
CTRL-w+b -> 移动到最下面的屏 (move to bottom window)
:close -> 关闭一个分出来的屏 (close splited screen)
:only -> 只显示光标当前屏 ，其他将会关闭(only display current active screen, close all others )
:qall -> 退出所有屏 (quite all windows)
:wall -> 保存所有屏 （write to all windows）
:wqall -> 保存并退出所有屏 (write and quite all windows)
:qall! -> 退出所有屏，不保存任何变动 (quite all windows without save)
开启文件的时候，利用 -o选项，就可以直接开启多个文件在分屏中 (with -o option from command line, it will open files and display in split mode)
vim -o a.txt b.txt

除了split之外， vim还可以用 tab
:tab split filename -> 这个就用tab的方式来显示多个文件 (use tab to display buffers)
gt -> 到下一个tab (go to next tab)
gT -> 到上一个tab (go to previous tab)
vim大多数东西都是可一给数字来执行的，tab也是一样
0gt ->跳到第一个tab (switch to 1st tab)
5gt -> 跳到第五个tab (switch to 5th tab)
关闭所有的tab可以使用qall的指令。另外让vim在启动的时候就自动用tabnew的方式来开启多个文件，可以用alias
linux: 添加 alias vim='vim -p' 到 ~/.bashrc
windows: 自己写个vim.bat的文件，然后放在path中，文件内容：
@echo off
vim -p %*
当需要更改多个tab中的文件的时候，可以用 :tabdo 这个指令 这个就相当于 loop 到你的所有的 tab 中然后运行指令。
例如有5个文件都在tab里面，需要更改一个变量名称：abc 到 def， 就可以用 :tabdo %s/abc/def/g 这样所有的5个tab里面的abc就都变成def了
 
折叠 (folding)
zfap -> 按照段落折叠 (fold by paragraph)
zo -> 打开一个折叠 (open fold)
zc -> 关闭一个折叠 (close fold)
zf -> 创建折叠 (create fold) 这个可以用v视觉模式，可以直接给行数等等
zr -> 打开一定数量的折叠，例如3rz (reduce the folding by number like 3zr)
zm -> 折叠一定数量（之前你定义好的折叠） (fold by number)
zR -> 打开所有的折叠 (open all fold)
zM -> 关闭所有的摺叠 (close all fold)
zn -> 关闭折叠功能 (disable fold)
zN -> 开启折叠功能 (enable fold)
zO -> 将光标下所有折叠打开 (open all folds at the cursor line)
zC -> 将光标下所有折叠关闭 (close all fold at cursor line)
zd -> 将光标下的折叠删除，这里不是删除内容，只是删除折叠标记 (delete fold at cursor line)
zD -> 将光标下所有折叠删除 (delete all folds at the cursor line)
按照tab来折叠，python最好用的 (ford by indent, very useful for python)
:set foldmethod=indent -> 设定后用zm 跟 zr 就可以的开关关闭了 (use zm zr)

保存 (save view)
对于vim来说，如果你设定了折叠，但是退出文件，不管是否保持文件，折叠部分会自动消失的。这样来说非常不方便。所以vim给你方法去保存折 叠，标签，书签等等记录。最厉害的是，vim对于每个文件可以保存最多10个view，也就是说你可以对同一个文件有10种不同的标记方法，根据你的需 要，这些东西都会保存下来。
:mkview -> 保存记录 (save setting)
:loadview -> 读取记录 (load setting)
:mkview 2 -> 保存记录在寄存2 （save view to register 2)
:loadview 3 -> 从寄存3中读取记录 (load view from register 3)


:set ic ->设定为搜索时不区分大小 写 (search case insensitive)
:set noic ->搜索时区分大小写。 vim内定是这个(case sensitive )
& -> 重复上次的":s" (repeat previous “:s")
. -> 重复上次的指令 (repeat last command)
K -> 在man中搜索当前光标下的词 (search man page under cursor)
{0-9}K -> 查找当前光标下man中的章节，例如5K就是同等于man 5 (search section of man. 5K search for man 5)
:history -> 查看命令历史记录 (see command line history)
q: -> 打开vim指令窗口 (open vim command windows)
:e -> 打开一个文件，vim可以开启http/ftp/scp的文件 (open file. also works with http/ftp/scp)
:e http://www.google.com/index.html -> 这里就在vim中打开google的index.html (open google's index.html)
:cd -> 更换vim中的目录 (change current directory in vim)
:pwd -> 显示vim当前目录 (display pwd in vim)
gf -> 打开文件。例如你在vim中有一行写了#include 那么在abc.h上面按gf，vim就会把abc.h这个文件打开 (look for file. if you have a file with #include , then the cursor is on abc.h press gf, it will open the file abc.h in vim )
记录指令 (record)

q{a-z} -> 在某个寄存中记录指令 (record typed char into register)
q{A-Z} -> 将指令插入之前的寄存器 (append typed char into register{a-z})
q -> 结束记录 (stop recording)
@{a-z} -> 执行寄存中的指令 (execute recording)
@@ -> 重复上次的指令 (repeat previours :@{a-z})
还是给个例子来说明比较容易明白
我现在在一个文件中下qa指令,然后输入itest然后ESC然后q
这里qa就是说把我的指令记录进a寄存，itest实际是分2步，i 是插入 (insert) 写入的文字是 text 然后用ESC退回指令模式q结束记录。这样我就把itest记录再一个寄存了。
下面我执行@a那么就会自动插入test这个词。@@就重复前一个动作，所以还是等于@a

搜索 (search)
vim超级强大的一个功能就是搜索跟替换了。要是熟悉正表达(regular expressions)这个搜索跟后面的替换将会是无敌利器（支持RE的编辑器不多吧）
从简单的说起
# -> 光标下反向搜索关键词 (search the word under cursor backward)
* -> 光标下正向搜索关键词 (search the word under cursor forward)
/ -> 向下搜索 (search forward)
? -> 向上搜索 (search back)
这里可以用 /abc 或 ?abc的方式向上，向下搜索abc
% -> 查找下一个结束，例如在"(“下查找下一个")"，可以找"()", “[]" 还有shell中常用的 if, else这些 (find next brace, bracket, comment or #if/#else/#endif)

下面直接用几个例子说话
/a* -> 这个会搜到 a aa aaa
/\(ab\)* -> 这个会搜到 ab abab ababab
/ab\+ -> 这个会搜到 ab abb abbb
/folers\= -> 这个会搜到 folder folders
/ab\{3,5} -> 这个会搜到 abbb abbbb abbbbb
/ab\{-1,3} -> 这个会在abbb中搜到ab (will match ab in abbb)
/a.\{-}b -> 这个会在axbxb中搜到axb (match 'axb' in 'axbxb')
/a.*b -> 会搜索到任何a开头后面有b的 (match a*b any)
/foo\|bar -> 搜索foo或者bar，就是同时搜索2个词 (match 'foo' or 'bar')
/one\|two\|three -> 搜索3个词 (match 'one', 'two' or 'three')
/\(foo\|bar\)\+ -> 搜索foo, foobar, foofoo, barfoobar等等 (match 'foo', 'foobar', 'foofoo', 'barfoobar' … )
/end\(if\|while\|for\) -> 搜索endif, endwhile endfor (match 'endif', 'endwhile', 'endfor')
/forever\&… -> 这个会在forever中搜索到"for"但是不会在fortuin中搜索到"for" 因为我们这里给了&…的限制 (match 'for' in 'forever' will not match 'fortuin')

特殊字符前面加^就可以 (for special character, user “^" at the start of range)
/"[^"]*"
这里解释一下
" 双引号先引起来 (double quote)
[^"] 任何不是双引号的东西(any character that is not a double quote)
* 所有的其他 (as many as possible)
" 结束最前面的引号 (double quote close)
上面那个会搜到“foo" “3!x"这样的包括引号 (match “foo" -> and “3!x" include double quote)

更多例子，例如搜索车牌规则，假设车牌是 “1MGU103" 也就是说，第一个是数字，3个大写字幕，3个数字的格式。那么我们可以直接搜索所有符合这个规则的字符
(A sample license plate number is “1MGU103″. It has one digit, three upper case
letters and three digits. Directly putting this into a search pattern)
这个应该很好懂，我们搜索
\数字\大写字母\大写字母\大写字母\数字\数字\数字
/\d\u\u\u\d\d\d
另外一个方法，是直接定义几位数字（不然要是30位，难道打30个\u去？）
/\d\u\{3}\d\{3}
也可以用范围来搜索 (Using [] ranges)
/[0-9][A-Z]\{3}[0-9]\{3}

用到范围搜索，列出一些范围(range)
/[a-z]
/[0123456789abcdef] = /[0-9a-f]
\e
\t
\r
\b

简写 (item matches equivalent)
\d digit [0-9]
\D non-digit [^0-9]
\x hex digit [0-9a-fA-F]
\X non-hex digit [^0-9a-fA-F]
\s white space [ ] ( and )
\S non-white characters [^ ] (not and )
\l lowercase alpha [a-z]
\L non-lowercase alpha [^a-z]
\u uppercase alpha [A-Z]
\U non-uppercase alpha [^A-Z]

:help /[] –> 特殊的定义的，可以在vim中用用help来看 (everything about special)
:help /\s –> 普通的也可以直接看一下 (everything about normal)

替换 (string substitute) – RX
%s/abc/def/ -> 替换abc到def (substitute abc to def)
%s/abc/def/c -> 替换abc到def，会每次都问你确定(substitute on all text with confirmation (y,n,a,q,l))
1,5s/abc/def/g -> 只替换第一行到第15行之间的abc到def (substitute abc to def only between line 1 to 5)
54s/abc/def/ -> 只替换第54行的abc到def (only substitute abc to def on line 54)

全局 (global)
global具体自行方法是 g/pattern/command
:g/abc/p -> 查找并显示出只有abc的行 (only print line with “abc" )
:g/abc/d -> 删除所有有abc的行 (delete all line with “abc")
:v/abc/d -> 这个会把凡是不是行里没有abc的都删掉 (delete all line without “abc")

退出编辑器（quit）
:w -> 保存文件 (write file)
:w! -> 强制保存 (force write)
:q -> 退出文件 (exit file without save)
:q! -> 强制退出 (force quite without save)
:e filename -> 打开一个文件名为filename的文件 (open file to edit)
:e! filename -> 强制打开一个文件，所有未保存的东西会丢失 (force open, drop dirty buffer)
:saveas filename -> 另存为 filename (save file as filename)
```

# Git 技巧
## 常用命令
> 全部命令参考 [Git](/images/posts/git.png)

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