# CentOS7

## 磁盘

### 加载 NTFS 格式的硬盘

```bash
# 安装 ntfs 扩展
yum install ntfs-3g 

# 查看磁盘分区
fdisk -l

# 挂载硬盘
mount -t ntfs-3g /dev/<sdb1> /media
```

### 开机加载硬盘

```bash
# 格式化需要挂载的硬盘 （如有必要）
mkfs -t ext3 -c /dev/<sdb6>

# 创建硬盘的挂载目录
mkdir /data

# 挂载硬盘
mount /dev/<sdb6> /data

# 设置开机自动挂载
vim /etc/fstab

#添加一条挂载记录
# /dev/sdb6 选择一个分区；ext3 是当前分区的格式
# defaults = rw, suid, dev, exec, auto, nouser, and async
# 1 需要 dump；0 不需要 dump
# 2 开机时检查顺序，非 boot 文件系统为 1，其它文件系统都为 2，如要检查就为 0
/dev/<sdb6>    /data     ext3    defaults   1 2
```

## 网络配置

### WiFi配置

```bash
yum -y install NetworkManager-wifi

# 开启无线网
nmcli r wifi on

# 系统内置网络配置界面
nmtui

# 扫描可用于连接wifi
nmcli dev wifi 
 
# 添加一个wifi的连接
nmcli dev wifi con "无线网络名称" password "无线网络密码" name "任意连接名称（删除，修改时用）"

#添加成功后查看已创建的wifi连接
nmcli conn

# 如果wifi没有连接上
nmcli con up <wifi连接名（刚才nmtui创建的连接）>

# 修改该连接为开机自动连接
nmcli con mod wifi连接名 connection.autoconnect yes

# 如果无线网卡安装不正常，可以lspci命令查看网卡型号，使用lspci命令需要先安装
yum -y install pciutils*

# 查询内核日志，查看是否需要安装无线网卡的固件
dmesg | grep firmware
```

## CentOS7配置LNMP

> 先查看当前服务器的版本： `cat /proc/version`

### Nginx 安装

> 安装 yum repo, 在 **http://nginx.org/packages/centos/** 找到对应的版本

```bash
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
```
- 安装**Nginx**: `yum install nginx`
- 设置**Nginx**开机启动: `systemctl enable nginx`
- 查看**Nginx**当前状态: `systemctl status nginx`

### MySQL V5.7 安装
> 安装 yum repo

```bash
rpm -Uvh http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
```

安装**MySQL** V5.7: `yum install mysql-community-server mysql-community-devel`
> 安装完成后 MySQL 会默认加到自动启动服务中, 并且会分配一个随机的 Root 密码 
> 可以使用 `grep 'temporary password' /var/log/mysqld.log` 这个命令来查看密码

- 启动**MySQL**: `systemctl start mysqld`
- 修改**MySQL**密码: `ALTER USER 'root'@'localhost' IDENTIFIED BY '022.Admin';` *不写到这我还真记不住*

### PHP V7 安装
下载**PHP 7.1.5** 的源码包: `wget -c http://cn2.php.net/distributions/php-7.1.5.tar.gz`
解压并进入文件夹 
>    
- `tar zxvf php-7.1.5.tar.gz`
- `cd php-7.1.5`


```bash
    # 安装扩展依赖包
    yum -y install gcc libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel curl curl-devel openssl openssl-devel
    
    # 配置 PHP
    ./configure --prefix=/usr/local/php-7.1.5 --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx --with-mysqli --with-pdo-mysql --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-openssl --enable-mbstring --enable-ftp --enable-zip
    
    # 安装
    make && make install
    
    # copy php.ini
    cp php.ini-development /usr/local/php-7.1.5/lib/php.ini
    
    # 修改 php.ini 文件
    mysqli.default_socket = /var/lib/mysql/mysql.sock
    date.timezone = PRC
    
    # 将 /usr/local/php-7.1.5 软链到 /usr/local/php
    ln -s /usr/local/php-7.1.5 /usr/local/php
    # 将一些常用的可执行文件（例如 php, pecl, pear 和 phpize）软链到 PATH 环境变量中。
    ln -s /usr/local/php/bin/php /usr/sbin/php
    ln -s /usr/local/php/bin/pecl /usr/sbin/pecl
    ln -s /usr/local/php/bin/pear /usr/sbin/pear
    ln -s /usr/local/php/bin/phpize /usr/sbin/phpize
    
    # 配置 php-fpm
    cp /usr/local/php-7.1.5/etc/php-fpm.conf.default /usr/local/php-7.1.5/etc/php-fpm.conf
    cp /usr/local/php-7.1.5/etc/php-fpm.d/www.conf.default /usr/local/php-7.1.5/etc/php-fpm.d/www.conf
    
    # 查找 /usr/local/php-7.1.5/etc/php-fpm.d/www.conf user 和 group 看看是不是安装时指定的 nginx 
    user = nginx
    group = nginx
    
    # 配置 php-fpm 启动服务脚本
    cp /usr/local/src/php-7.1.5/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php71-fpm.service
    # php-fpm 随机启动
    systemctl enable php71-fpm
    
    # 重新载入 systemd
    systemctl daemon-reload
    
    # 启动 php71-fpm
    systemctl start php71-fpm
    
    # 查看php71-fpm当前状态
    systemctl status php71-fpm
```
### 配置 Nginx
添加 nginx 配置文件
```nginx
server {
    listen       80;
    server_name  localhost;
    root         /www/web;
    location / {
        index  index.php index.html index.htm;
    }
    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```
 重新加载**Nginx**配置 `systemctl reload nginx`
 测试验证~
 ![phpinfo](../images/32360315.jpg)

### Redis V4.0 安装
在 PHP 官网扩展包里下载 **Reids** 包 `wget -c http://pecl.php.net/get/redis-4.0.0RC2.tgz`
1. 解压 `tar zxf redis-4.0.0RC2.tgz && cd redis-4.0.0RC2`
2. 执行 `phpize` 生成配置文件
> 若提示没有安装 **autoconf**  则先执行 `yum install -y autoconf`

3. 配置 `./configure --with-php-config=/usr/local/php/bin/php-config`
4. 编译安装 `make && make install`
5. 修改 php.ini 文件，添加 Redis 扩展
```bash
 . . .
 # 添加 Redis 扩展
 extension=redis.so
 . . .
```

### CentOS7 安装 Nodejs
`curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -` 10.x 可切换为对应版本号安装其他版本 执行完后再执行 `sudo yum install -y nodejs` 安装


## 其他

### CentOS7设置笔记本合盖不休眠

```bash
vim /etc/systemd/logind.conf

# 配置文件中找到我们要修改的配置项：
#HandlePowerKey=poweroff        按下电源键后的行为，默认power off
#HandleSuspendKey=suspend       按下挂起键后的行为，默认suspend
#HandleHibernateKey=hibernate   按下休眠键后的行为，默认hibernate
#HandleLidSwitch=suspend        合上笔记本盖后的行为，默认suspend

# 把HandleLidSwitch后面的suspend修改为lock，即：
HandleLidSwitch=lock

systemctl restart systemd-logind
```






