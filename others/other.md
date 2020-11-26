
## ps 命令查看线程
`ps -T -p <pid>`

## 负载均衡
> 负载均衡是指基于反向代理能将现在所有的请求根据指定的策略算法，分发到不同的服务器上。常用实现负载均衡的可以用 nginx, lvs。

### 常见的负载均衡方案
1. 轮询
2. 用户IP哈希
3. 指定权重

<details><summary>指定权重详情</summary>

```
# Nginx (Weighted Round)

http{
  # Weighted
  upstream cluster {
    server a weight=5
    server b weight=1;
    server c weight=1;
  }
  
  server {
    listen 80;
 
    location / {
      proxy_pass http://cluster;
    }
  }
 
```
</details>

4.使用第三方 (fair, url_hash)

### 校验IP是否正确
```php
if (filter_var($ip, FILTER_VALIDATE_IP)) {
    return true;
} else {
    return false;
}
```

### 设计一个秒杀系统
其他：[JAVA 秒杀系统设计与架构](https://github.com/qiurunze123/miaosha)

补充: [秒杀架构和优化思路](https://github.com/kjh123/blog/blob/master/others/秒杀架构和优化思路.md)

## 搭建私有 composer 库
参考：[使用 satis 搭建 Composer 私有库](https://joelhy.github.io/2016/08/10/composer-private-packages-with-satis/)

### Nginx 配置

#### 安装 http_realip_module 模块
使用 `nginx -V | grep http_realip_module` 命令检查该模块是否安装

安装:
```bash
wget http://nginx.org/download/nginx-1.12.2.tar.gz
tar zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --user=www --group=www --prefix=/alidata/server/nginx --with-http_stub_status_module --without-http-cache --with-http_ssl_module --with-http_realip_module
make
make install
kill -USR2 `cat /alidata/server/nginx/logs/nginx.pid`
kill -QUIT `cat /alidata/server/nginx/logs/ nginx.pid.oldbin`
```

#### 修改 Nginx 配置文件
打开default.conf配置文件，在location / {}中添加以下内容：
```conf
set_real_ip_from ip_range1;
set_real_ip_from ip_range2;
...
set_real_ip_from ip_rangex;
real_ip_header    X-Forwarded-For;
```

#### 修改 Nginx 日志记录格式
log_format一般在nginx.conf配置文件中的http配置部分。在log_format中，添加x-forwarded-for字段，替换原来remote-address字段，即将log_format修改为以下内容：
```conf
log_format  main  '$http_x_forwarded_for - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" ';
```

修改完成后重启即可