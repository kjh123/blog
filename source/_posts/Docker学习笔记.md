---
title: Docker学习笔记
date: 2018-06-30 15:30:34
tags: [Linux, Docker, CenterOS]
categories: Linux
---
>前段时间有学过一些 `Docker` 的相关知识，但最近忙于工作，对这方面还是有些疏忽了，就再次学习下，然后做个笔记

<!--more-->

-----

*系统环境 `CenterOS 7`*

# 安装 Docker 
> 版本：社区版（Docker Community Edition）
> 介绍：[Docker在PHP项目开发中的应用](https://avnpc.com/pages/build-php-develop-env-by-docker)
> 相关资料：[Docker-从入门到实践](https://yeasy.gitbooks.io/docker_practice/content/)
> 如果之前有安装过的旧版本 先卸载 `yum remove docker  docker-common docker-selinux docker-engine`
**因为我服务器中已安装了一套运行环境为避免冲突，相关应用会修改相应的端口**

- 添加软件源:
```bash line_number:false
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 如果没有 yum-config-manager 命令则执行下面
yum install -y yum-utils device-mapper-persistent-data lvm2
```
- 查看软件仓库中所有的 `Docker` 版本
```bash line_number:false
yum list docker-ce --showduplicates | sort -r
```
- 安装最新版本 [ 指定版本 ]
```bash line_number:false
# [docker-ce] 替换指定版本
sudo yum install [docker-ce]
```
- 加入 `Docker` 到开机启动
```bash line_number:false
systemctl enable docker
```
- 启动 `Docker` 
```bash line_number:false
systemctl start docker
```
- 查看 `Docker` 状态
```bash line_number:false
systemctl status docker
```
- 安装 `docker-compose` [docker-compose介绍](http://dockone.io/article/34)
```bash line_number:false
pip install docker-compose
```
- 加速 `Docker` 
```bash line_number:false
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://9d4cd35f.m.daocloud.io

# 修改完成后会提示重启
systemctl restart docker
```

# 在 `Docker` 上构建 `LNMP` 环境
## 分别拉取需要的镜像文件
### MySQL
```bash line_number:false
# 获取 mysql5.6 版本的docker镜像
docker pull mysql:5.6
# 创建mysql容器
docker run -d -p 3307:3306 -e MYSQL_ROOT_PASSWORD=admin --name mysql5.6 mysql:5.6
# -d：让容器在后台运行
# -p：添加主机到容器的端口映射
# -e：设置环境变量，这里是设置MySQL的root账户的初始密码 （必选）
# -name：容器的名字，必须唯一
```
### PHP-FPM
```bash line_number:false
# 拉取php-fpm 
docker pull php:7.1-fpm
# 创建 php-fpm 容器
docker run -d -v /www:/var/www/html -p 9001:9000 --link mysql5.6:mysql --name phpfpm7.1 php:7.1-fpm 
# -v 目录映射，把主机的 /www 目录映射到容器中的 /var/www/html 目录
# –link 与另外一个容器建立起联系，这样我们就可以在当前容器中去使用另一个容器里的服务。
#      或者使用 ip 去访问其它容器的服务
```
> **在PHP-FPM容器中**  安装PHP扩展使用命令 `docker-php-ext-install pdo_mysql`

### Nginx
```bash
# 拉取 Nginx 镜像
docker pull nginx:1.14.0
# 创建 Nginx 容器
docker run -d -p 81:80 -v /www:/var/www/html --link phpfpm7.1:phpfpm --name nginx nginx:1.14.0
```
> **在Nginx容器中** 修改nginx配置文件
```bash :/etc/nginx/conf.d/default.conf line_number:false 
location ~ \.php$ {
    root           /var/www/html;
    fastcgi_index  index.php;
    fastcgi_pass   phpfpm:9001;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcdi_script_name;
    include        fastcgi_params;
}
```
### 测试
![info](http://oyvpp7gqd.bkt.clouddn.com/18-7-2/11032690.jpg)

## 使用 `DockerFile` 构建环境
> 推荐阅读：[如何编写最佳的Dockerfile](http://www.phpchina.com/portal.php?mod=view&aid=41111)

### 介绍
`DockerFile` 是 `Docker` 用来构建镜像的一个文件，包含自定义的指令，类似于shell脚本，把一系列的指令集和放在一个 .sh 文件中去执行
**DockerFile**分为四部分组成：**基础镜像信**、**维护者信息**、**镜像操作指令** 和 **容器启动时执行指令**。例如：
```bash :dockerfile line_number:false url:https://blog.csdn.net/mozf881/article/details/55798811 相关链接
# 第一行必须指令基于的基础镜像
From ubutu

# 维护者信息
MAINTAINER docker_user  docker_user@mail.com

# 镜像的操作指令
apt/sourcelist.list

RUN apt-get update && apt-get install -y ngnix 
RUN echo "\ndaemon off;">>/etc/ngnix/nignix.conf

# 容器启动时执行指令
CMD /usr/sbin/ngnix
```
![dockerfile](http://oyvpp7gqd.bkt.clouddn.com/18-7-2/8082419.jpg)

# Docker 相关命令
1. `docker images`  查看本地**docker**镜像文件
2. `docker ps -a`   查看所有容器的进程情况
3. `docker exec -ti docker_names /bin/bash` 进入docker容器中
> -t 在容器里生产一个伪终端
> -i 对容器内的标准输入 (STDIN) 进行交互
4.  `docker stop name`  停止一个运行中的容器
    `docker rm name`    删除本地一个容器 （需要该容器处于未运行状态）
    `docker rmi image`  删除本地一个镜像文件
