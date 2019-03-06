---
title: shell代码自动部署脚本
tags:
  - Linux
  - 命令
  - 服务器
categories: Linux
translate_title: shell-code-automatic-deployment-script
date: 2018-07-10 12:44:47
---
> 服务器环境：Ubuntu 16.04
此脚本仅适用于在多个服务器中有相同环境配置，以及相同的项目路径

<!--more-->

- 待优化的功能
    - 操作日志记录
    - 脚本执行文件锁
    - 代码回滚操作
    
- 使用到的工具
```bash
# Git 代码版本管理
sudo apt-get install git
# expect 可以实现交互式通信
sudo  apt-get install expect
```
- 相关代码
```bash :deploy.sh
#!/bin/bash
# User: Hui
# Date: 07/10

#########################  ENV  ###############################
TIME=$(date "+%H-%M-%S")
CODE_DIR="/vagrant/jishu"
NETWORK='enp0s8'

NAME=('测试1' '测试2')
HOST=('192.168.33.10' '192.168.0.186')
ACCOUNT=('vagrant' 'vagrant')
PASSWORD=('vagrant' 'vagrant')

#########################  BASH  ##############################
usage(){
    echo 
    echo -e $"\e[1;32mUsage:\e[0m" 
    echo "     $0 pull      拉取代码"
    echo "     $0 rollback  回滚代码"
    echo 
}

# 检测当前运行的主机
check_host(){
    IP=$(ifconfig $NETWORK| grep 'inet' | grep -oE "[0-9\.]+" | head -n1)
    for((i=0; i < ${#HOST[*]}; i++))
    do
        if [ ${HOST[$i]} == $IP ]; then
            check_git_status ${HOST[$i]} ${i};
        else
            origin_pull ${HOST[$i]} ${i};	
        fi
    done
}

# 检测当前的分支状态
check_git_status(){
    echo -e $"\e[1;32m正在同步 ${NAME[$2]}：$1 ------------\e[0m"
    
    cd $CODE_DIR
    local git_status=$(git status 2> /dev/null | tail -n1) || $(git status 2> /dev/null | head -n 2 | tail -n1);
    if [[ "$git_status" =~ nothing\ to\ commit || "$git_status" =~  Your\ branch\ is\ up\-to\-date\ with ]]; then
        code_pull;
    else	
        echo ${NAME[$2]}：$1 存在未提交的修改，请手动处理
    fi
}

# 同步本地代码
code_pull(){
    cd $CODE_DIR
    git pull origin master
}

# 同步远程主机代码
origin_pull(){
    local _host=$1
    local _account=${ACCOUNT[$2]}
    local _password=${PASSWORD[$2]}
    local _dir=${CODE_DIR}
    /usr/bin/expect <<-EOF
    set timeout 2
    spawn ssh ${_account}@${_host} "cd ${_dir} && git pull origin master"
    expect {
        "*yes/no" { send "yes\r"; exp_continue }
        "*password:" { send "${_password}\r"; exp_continue } 
        "*https://gitee.com": { send "GitName"; exp_continue } 
        "Password*": { send "GitPassWord"; exp_continue }
    }
EOF
}

# 代码回滚操作
roll_back(){
    echo rollback;
}

main(){
    case $1 in
    pull)
        check_host;
        ;;
    rollback)
        roll_back;
        ;;
    *)
        usage;
    esac
}
main $1

```