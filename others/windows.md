
## Windows 配置

### Chocolatey 包管理工具


> 官网: https://docs.chocolatey.org

#### 安装

```bash

# 方式1
winget install --id chocolatey.chocolatey --source winget

# 方式2
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

#### 通过环境变量设置 choco 包安装目录

```bash
export ChocolateyInstall="xxx"
```

### 安装 Docker 

> 安装最新的 docker 版本有可能会出现 **//./pipe/docker_engine: access is denied** 因此需要安装 **4.14** 之前的版本


```bash
choco install docker-desktop --version=4.13.0
```

### 软件安装管理包

https://www.cygwin.com/install.html


### .zshrc 的配置


```bash

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# tldr
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'

export ChocolateyInstall="/d/app"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#


CODE="/d/code/"
HOME="/c/Users/appcpi-pc/"

alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias l="ls"
alias la="ls -ahs"
alias sub="/d/app/sublime/sublime_text.exe"

# 历史命令显示日期
HIST_STAMPS="yyyy-mm-dd"

############### 项目路径定义 ####################
alias code='shortcut "${CODE}"'
alias zshrc="vi ~/.zshrc"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

alias gitlog="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"

alias gh='history|grep'

# 文件计数
alias count='find . -type f | wc -l'
# 复制进度条
alias cpv='rsync -ah --info=progress2'

########################### functions ########################

function artisan() {
    php artisan "$@"
}

function checkout() {
    git checkout "$@"
}

function open() {
    explorer "$@"
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
        sub)  # sublime 打开文件
            if [ $2 = 'blog' ]; then
                sub $1'myblog';
            else
                sub $1$2;
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

function refresh() {
  FILE=${HOME}/.zshrc
    case $1 in
        zsh|*)
            source ${FILE}
            echo 'zsh 已更新';
            ;;
    esac
  unset FILE;
}

# 文件共享
function transfer() {
  if [ $# -eq 0 ]; then
    echo "Usage:\n transfer <file|directory> \n" >&2
    return 1
  fi
  if tty -s; then
    file="$1"
    file_name=$(basename "$file")
    if [ ! -e "$file" ]; then
      echo "$file: No such file or directory" >&2
      return 1
    fi
    if [ -d "$file" ]; then
      file_name="$file_name.zip" ,
      (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
    else
      cat "$file" | curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
    fi
  else
    file_name=$1
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
  fi
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

function mans(){
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
```
