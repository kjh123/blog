
# 我的 Bash 脚本记录 (备份)

## tmux 配置

```bash
# 设置前缀为Ctrl + x
set -g prefix C-x

#解除Ctrl+b 与前缀的对应关系
unbind C-b

## 切换面板
#up
bind-key k select-pane -U
#down
bind-key j select-pane -D
#left
bind-key h select-pane -L
#right
bind-key l select-pane -R
```

## bashrc 配置

```bash
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias l="ls"
alias la="ls -ahs"
PS1='host-name-127.0.0.1@jiahui\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
```

## zshrc 配置

```bash
# 历史命令显示日期
HIST_STAMPS="yyyy-mm-dd"

############### 项目路径定义 ####################
Homestead=${HOME}/Homestead/
alias ops='shortcut "${HOME}/ops/"'
alias code='shortcut "${HOME}/Code/"'
alias blog='shortcut "${HOME}/Code/myblog"'
alias down='shortcut "${HOME}/Downloads"'
alias homestead='shortcut "${HOME}/Homestead"'
alias pic='shortcut "${HOME}/Pictures/"'

############### Aliases ######################
alias v="vi"
alias c="bat"
alias zshrc="vi ~/.zshrc"
alias dir=switchdir
alias msql="mycli"
alias la="ls -ahs"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Git
alias gitlog="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
alias pl="git pull"
alias stash=stash
alias checkout=checkout

# 在单个列中显示每个项目的大小，然后按大小对其进行排序，并使用符号表示文件类型
# GUN 系统中该命令为： alias lt='ls --human-readable --size -1 -S --classify'
alias lt='du -sh * | sort -h'
# 只查看挂载的驱动器
# Linux: alias mnt='mount | awk -F' ' '{ printf "%s\t%s\n",$1,$3; }' | column -t | egrep ^/dev/ | sort'
alias mnt='mount | grep -E ^/dev | column -t'
# 在 grep 历史中查找命令
alias gh='history|grep'
# 文件计数
alias count='find . -type f | wc -l'
# 复制进度条
alias cpv='rsync -ah --info=progress2'

# Laravel
alias artisan=artisan
alias search="/bin/bash ~/.search.sh"
alias phpunit="vendor/bin/phpunit"

# vm
alias vmup="cd ${Homestead} && vagrant up && cd -"
alias vmhalt="cd ${Homestead} && vagrant halt && cd -"
alias vmreload="cd ${Homestead} && vagrant reload --provision && cd -"
alias vmconfig="hui ${Homestead}Homestead.yaml"
alias vmssh="cd ${Homestead} && vagrant ssh"
alias vmstatus="cd ${Homestead} && vagrant global-status --prune && cd -"

# hosts
alias hosts="sudo vim /etc/hosts"

########################### functions ########################

function artisan() {
    php artisan "$@"
}

function checkout() {
    git checkout "$@"
}

function stash() {
    if [ $1 ]
    then
        git stash "$@"
    else
        git stash -u
    fi
}

# 捷径
function shortcut() {
    case ${@: -1} in
        open) # Finder 打开文件
            if [ $2 = 'blog' ]; then
                open $1'myblog';
            else
                open $1$2;
            fi
            ;;
        hui)  # sublime 打开文件
            if [ $2 = 'blog' ]; then
                hui $1'myblog';
            else
                hui $1$2;
            fi
            ;;
        *)
            switchdir -p $1 -d $2;
            ;;
    esac
}

# 切换目录
function switchdir() {
    while getopts ":p:d:" opt; do
        case $opt in
            p)
                DEFAULT=$OPTARG;
                ;;
            d)
                DIR=$OPTARG;
                ;;
        esac
    done
    if [ ${DIR} ]
    then
        if [ -d ${DEFAULT}${DIR} ]
        then
            echo -e "已经进入\033[1;34m ${DIR} \033[0m项目目录✔️"
            cd ${DEFAULT}${DIR}
        else
            echo "\033[1;32m ${DEFAULT} \033[0m下，不存在\033[1;34m ${DIR} \033[0m这个目录😯"
        fi
    else
        # echo "已经进入目录 ${DEFAULT} 👌"
        cd ${DEFAULT}
    fi
    unset DEFAULT;
    unset DIR;
}

# yaf框架生成
function newyaf() {
  YAFPATH=${HOME}/framework/yaf/
  TARGET=${HOME}/Code/
    if [ $1 ]
    then
        php ${YAFPATH}tools/cg/yaf_cg $1
        mv -i ${YAFPATH}tools/cg/output/$1 ${TARGET}
        if [ -d ${CODE}$1 ]
        then
            switchdir -d $1
        fi
    else
        echo -e "Usage: \033[1;34mnewyaf <xxx>\033[0m";
        echo "  then. you can find in ${TARGET}";
    fi
  unset YAFPATH;
  unset TARGET;
}

# refresh 刷新配置文件
function refresh(){
  FILE=${HOME}/.zshrc
    case $1 in
        zsh|*)
            source ${FILE}
            echo 'zsh 已更新';
            ;;
    esac
  unset FILE;
}

# md5decode
function md5decode() {
 curl -s -X POST https://www.md5online.org/md5-decrypt.html -d hash=$1 | grep -o -E 'b>[a-zA-Z0-9]+' | sed 's/b>/decode: /'
}

# 切换文件夹，并列出当前目录文件列表
function cc() {
  TARGET_DIR="$*";
    # if no DIR given, go home
    if [ $# -lt 1 ]; then
        TARGET_DIR=$HOME;
    fi;
    builtin cd "${TARGET_DIR}" && \
    # use your preferred ls command
    ls -F
    unset TARGET_DIR;
}

```