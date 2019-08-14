---
title: 使用docker快速搭建gitlab
tags:
  - Centos
  - Linux
  - Docker
categories: Docker
translate_title: using-docker-to-build-gitlab-quickly
date: 2019-04-14 12:29:04
---

使用 Dcoker 快速搭建自己的代码库

<!-- more -->

> 参考资料
GitLib官方文档: https://docs.gitlab.com/omnibus/docker/#install-gitlab-using-docker-compose

安装步骤：

1. 安装 [Docker](https://kjh123.github.io/blog/docker-learning-notes.html) 和 [docker-compose](https://kjh123.github.io/blog/docker-learning-notes.html#安装-docker-compose)
2. 创建 GitLab 目录 `mkdir -p ~/Code/gitlab && cd ~/Code/gitlab`
3. 创建 **docker-compose.yml** 文件，并修改默认域名
```yml :~/Code/gitlab/docker-compose.yml mark:4,7
 web:
   image: 'gitlab/gitlab-ce:latest'
   restart: always
   hostname: 'gitlab.example.com'
   environment:
     GITLAB_OMNIBUS_CONFIG: |
       external_url 'https://gitlab.example.com'
       # Add any other gitlab.rb configuration here, each on its own line
   ports:
     - '80:80'
     - '443:443'
     - '22:22'
   volumes:
     - '/srv/gitlab/config:/etc/gitlab'
     - '/srv/gitlab/logs:/var/log/gitlab'
     - '/srv/gitlab/data:/var/opt/gitlab'
```
4. 在当前目录下执行 `docker-compose up -d`


GitLab在VPS上报 502 的解决方案

由于使用的 VPS 的内存很小只有 1024m ， GitLab 在搭建好后访问时报 502 错误
调整虚拟内存
```bash
sudo dd if=/dev/zero of=/swapfile bs=1024 count=2048k
sudo mkswap /swapfile
sudo swapon /swapfile
sudo vim /etc/fstab
/swapfile none swap defaults 0 0
```







