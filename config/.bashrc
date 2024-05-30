alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias l="ls"
alias la="ls -ahs"
PS1='host-name-127.0.0.1@jiahui\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '

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
alias gotrace='go run -ldflags="-H windowsgui" honnef.co/go/gotraceui/cmd/gotraceui@latest'

# Git
alias gitlog="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
alias pl="git pull --rebase"
alias stash=stash

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
            open $1$2;
            ;;
        hui)  # sublime 打开文件
            hui $1$2;
            ;;
        doc) # doc
            docsify serve $1$2;
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

# mkcd is equivalent to takedir
function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -1)"
  rm "$data"
  cd "$thedir"
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}

# URL-encode a string
#
# Encodes a string using RFC 2396 URL-encoding (%-escaped).
# See: https://www.ietf.org/rfc/rfc2396.txt
#
# By default, reserved characters and unreserved "mark" characters are
# not escaped by this function. This allows the common usage of passing
# an entire URL in, and encoding just special characters in it, with
# the expectation that reserved and mark characters are used appropriately.
# The -r and -m options turn on escaping of the reserved and mark characters,
# respectively, which allows arbitrary strings to be fully escaped for
# embedding inside URLs, where reserved characters might be misinterpreted.
#
# Prints the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#  omz_urlencode [-r] [-m] [-P] <string>
#
#    -r causes reserved characters (;/?:@&=+$,) to be escaped
#
#    -m causes "mark" characters (_.!~*''()-) to be escaped
#
#    -P causes spaces to be encoded as '%20' instead of '+'
function omz_urlencode() {
  emulate -L zsh
  local -a opts
  zparseopts -D -E -a opts r m P

  local in_str=$1
  local url_str=""
  local spaces_as_plus
  if [[ -z $opts[(r)-P] ]]; then spaces_as_plus=1; fi
  local str="$in_str"

  # URLs must use UTF-8 encoding; convert str to UTF-8 if required
  local encoding=$langinfo[CODESET]
  local safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$encoding]} ]]; then
    str=$(echo -E "$str" | iconv -f $encoding -t UTF-8)
    if [[ $? != 0 ]]; then
      echo "Error converting string from $encoding to UTF-8" >&2
      return 1
    fi
  fi

  # Use LC_CTYPE=C to process text byte-by-byte
  local i byte ord LC_ALL=C
  export LC_ALL
  local reserved=';/?:@&=+$,'
  local mark='_.!~*''()-'
  local dont_escape="[A-Za-z0-9"
  if [[ -z $opts[(r)-r] ]]; then
    dont_escape+=$reserved
  fi
  # $mark must be last because of the "-"
  if [[ -z $opts[(r)-m] ]]; then
    dont_escape+=$mark
  fi
  dont_escape+="]"

  # Implemented to use a single printf call and avoid subshells in the loop,
  # for performance (primarily on Windows).
  local url_str=""
  for (( i = 1; i <= ${#str}; ++i )); do
    byte="$str[i]"
    if [[ "$byte" =~ "$dont_escape" ]]; then
      url_str+="$byte"
    else
      if [[ "$byte" == " " && -n $spaces_as_plus ]]; then
        url_str+="+"
      else
        ord=$(( [##16] #byte ))
        url_str+="%$ord"
      fi
    fi
  done
  echo -E "$url_str"
}

# URL-decode a string
#
# Decodes a RFC 2396 URL-encoded (%-escaped) string.
# This decodes the '+' and '%' escapes in the input string, and leaves
# other characters unchanged. Does not enforce that the input is a
# valid URL-encoded string. This is a convenience to allow callers to
# pass in a full URL or similar strings and decode them for human
# presentation.
#
# Outputs the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#   omz_urldecode <urlstring>  - prints decoded string followed by a newline
function omz_urldecode {
  emulate -L zsh
  local encoded_url=$1

  # Work bytewise, since URLs escape UTF-8 octets
  local caller_encoding=$langinfo[CODESET]
  local LC_ALL=C
  export LC_ALL

  # Change + back to ' '
  local tmp=${encoded_url:gs/+/ /}
  # Protect other escapes to pass through the printf unchanged
  tmp=${tmp:gs/\\/\\\\/}
  # Handle %-escapes by turning them into `\xXX` printf escapes
  tmp=${tmp:gs/%/\\x/}
  local decoded
  eval "decoded=\$'$tmp'"

  # Now we have a UTF-8 encoded string in the variable. We need to re-encode
  # it if caller is in a non-UTF-8 locale.
  local safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$caller_encoding]} ]]; then
    decoded=$(echo -E "$decoded" | iconv -f UTF-8 -t $caller_encoding)
    if [[ $? != 0 ]]; then
      echo "Error converting string from UTF-8 to $caller_encoding" >&2
      return 1
    fi
  fi

  echo -E "$decoded"
}

function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
  | fzf --ansi --preview "echo {} \
    | grep -o '[a-f0-9]\{7\}' \
    | head -1 \
    | xargs -I % sh -c 'git show --color=always %'" \
        --bind "enter:execute:
            (grep -o '[a-f0-9]\{7\}' \
                | head -1 \
                | xargs -I % sh -c 'git show --color=always % \
                | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}

function  mans(){
    man -k . \
    | fzf -n1,2 --preview "echo {} \
    | cut -d' ' -f1 \
    | sed 's# (#.#' \
    | sed 's#)##' \
    | xargs -I% man %" --bind "enter:execute: \
      (echo {} \
      | cut -d' ' -f1 \
      | sed 's# (#.#' \
      | sed 's#)##' \
      | xargs -I% man % \
      | less -R)"
}

function h() {
    # check if we passed any parameters
    if [ -z "$*" ]; then
        # if no parameters were passed print entire history
        history 1
    else
        # if words were passed use it as a search
        history 1 | egrep --color=auto "$@"
    fi
}

function fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
