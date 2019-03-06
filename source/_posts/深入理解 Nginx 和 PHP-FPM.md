---
title: 深入理解 Nginx 和 PHP-FPM
tags:
  - Linux
  - Nginx
  - FastCGI
  - PHP-FPM
categories: PHP
translate_title: deep-understanding-of-nginx-and-php-fpm
date: 2018-09-22 11:32:03
---

> B/S 运行原理剖析 `Nignx` `FastCGI` `PHP-FPM`

<!-- more -->

# Nginx
> 官网： [Nginx](https://nginx.org/)
> `Nginx` 是一个高性能、轻量级的 Web 服务器 和 反向代理服务器，支持灵活简单的配置以及高达 50,000 个并发连接数的响应
> [点击此处查看具体介绍](https://baike.baidu.com/item/nginx/3817705?fr=aladdin)

## Nginx 的工作原理
  `Nginx` 在启动后，会生成一个 **Master** 进程和fork多个 **Worker** 进程
- **Master** 进程主要是用来管理 **Worker** 进程 『 向各 **Worker** 进程发送信号，监控 **Worker** 进程的运行状态，重启 **Worker** 进程 等 』 

- **Worker** 进程来处理 `Nginx` 的事件，多个 **Worker** 同时获取网络请求，每个 **Worker** 之间是相互独立的，一个网络请求只能被一个 **Worker** 进程处理，一个 **Worker** 进程不能处理其他进程的请求，**Worker** 进程的个数是可以设置的，一般与机器的 CPU 核数一致
   > 为了保证只有一个进程处理一个网络请求，所有的 **Worker** 进程在注册 **listenfd读事件** 之前抢占 **accept_mutex** 抢到互斥锁的那个进程注册 **listenfd读事件** ，在读事件里调用 **accept** 接收该连接，当一个 **Workder** 进程拿到 **accept** 这个连接之后就开始读取请求，并且解析处理，产生数据后再返回给客户端，最后才断开连接。

# FastCGI
## CGI
  **CGI** 是 Web Server 与后台语言交互的协议，有了这个协议，开发者可以使用任何语言处理 Web Server 发来的请求，动态的生成内容
## FastCGI
  传统的 **CGI** 在每次处理请求时 都需要fork一个全新的进程去处理，而且安全性差，不适合在高并发的场景中使用，所以产生了 `FastCGI` 它允许在一个进程内处理多个请求，而不是一个请求处理完毕就直接结束进程，性能上有了很大的提高

## Nginx + FastCGI
  为了使 `Nginx` 能够理解 `FastCGI` 协议，`Nginx` 提供了 `FastCGI` 模块来将 HTTP 请求 映射为对应的 `FastCGI` 请求 [参见fastcgi_params](https://github.com/nginx/nginx/blob/master/conf/fastcgi_params)
  `Nginx` 不支持对外部程序的直接调用或者解析， 外部程序必须通过 `FastCGI` 接口来调用。
  > `FastCGI` 接口在 Linux 下是 Socket

# PHP-FPM
## FPM 『 FastCGI Process Manager 』
  `FPM` 是 **FastCGI** 的实现， 任何实现了 **FastCGI** 协议的 Web Server 都能够与之通信

## PHP-FPM 
  `PHP-FPM` 是一个 PHP 的进程管理器，包含 **Master** 和 **Worker** 进程 
  - **Master** 进程负责监听端口，接收来自 Web Server 的请求
  - **Worker** 进程会有多个(可配置)，每个进程内部都嵌入了一个 PHP 解释器，是 PHP 代码真正执行的地方
    > 从 `PHP-FPM` 接收到请求，到处理完毕 其流程如下
    >   1. `PHP-FPM` 的 **Master** 进程接收到请求
    >   2. **Master** 进程根据配置指派特定的 **Worker** 。进程进行请求处理，如果没有可用进程，返回错误，这也是我们配合 **Nginx** 遇到 502 错误比较多的原因
    >   3. **Worker** 进程处理请求，如果超时，返回 504 错误
    >   4. 请求处理结束，返回结果

## Nginx + PHP-FPM
  在 **Nginx** 的配置文件中，通过 **location** 指令，将所有以 .php 结尾的文件都交给 php7.1-fpm.sock 来处理
  ```bash :Nginx.conf mark:6
    ····· 
    location ~ \.php$ {
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_pass   unix:/run/php/php7.1-fpm.sock;
    }
    ·····
  ```
 
# 配置优化

## Nginx.Conf 配置优化

if (!-e $request_filename) {
    rewrite . /index.php last;
}

- 使用 『 try_files 』： try_files $uri $uri/ /index.php;
- 开启 gzip
- 设置 limit_rate 限制客户端的相应速度

### Nginx 常见错误

1. 502 Bad Gateway
  php-cgi进程数不够用、php执行时间长（mysql慢）、或者是php-cgi进程死掉，都会出现502错误, 一般来说 Nginx 502 Bad Gateway 和 php-fpm.conf 的设置有关，而 Nginx 504 Gateway Time-out 则是与 nginx.conf 的设置有关
2. 413 Request Entity Too Large
  Nignx.conf 中配置 `client_max_body_size`
  php.ini    中配置 `post_max_size` 和 `upload_max_filesize`

## PHP-FPM 配置优化

1. 适当调高 PHP FastCGI 的子进程数
2. 适当增加 max_requests

更多配置： 
 [PHP-FPM 调优：使用 `pm static`来最大化你的服务器负载能力](https://laravel-china.org/topics/14952/php-fpm-tuning-use-pm-static-to-maximize-your-server-load-capability)
 [php配置php-fpm启动参数及配置详解](http://www.php.cn/php-weizijiaocheng-391985.html)


> 参考文章
> https://zhuanlan.zhihu.com/p/20694204
> https://blog.csdn.net/hguisu/article/details/8930668