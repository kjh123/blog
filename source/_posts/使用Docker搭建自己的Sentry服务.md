---
title: 使用Docker搭建自己的Sentry服务
tags:
  - 记录
  - Linux
  - Docker
  - Ubuntu
categories: Docker
translate_title: build-your-own-sentry-service-with-docker
date: 2018-12-10 10:10:02
---

[Sentry](https://sentry.io/welcome/)（哨兵）， 是一款可以部署在生产环境的错误追踪工具， 可以实时通知开发者生产环境中的 `Exception` 等不可预知的系统异常， 开发者可以根据异常， 对代码进行快速修复

<!-- more -->

# Sentry 的两种使用方式
- 官网提供了为期14天的免费试用服务
- 根据源码自己搭建， 包括 『 Docker 』 安装和 『 Python 』 安装两种方式 

# 安装 Sentry
> 基于 『 Docker 』 安装的 `Sentry` 需要依赖于 Docker 环境
>  CentOS 系统详细安装步骤在此： [Docker学习笔记](https://kjh123.github.io/2018/06/30/Docker%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/)

## Ubuntu 安装Docker
```bash line_number:false
# 获取最新版本的Docker安装包
wget -qO- https://get.docker.com/ | sh
# 使用 Docker 加速镜像
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://4031ebb7.m.daocloud.io
# 安装 docker-compose
sudo pip install -U docker-compose
```
### 安装步骤
1. 在 Github 上获取最新的 Sentry
```bash line_number:false
git clone https://github.com/getsentry/onpremise.git sentry
```

2. 创建对应目录
```bash line_number:false
mkdir -p data/{sentry,postgres}
```

3. 创建 Docker 数据卷
```bash line_number:false
docker volume create --name=sentry-data 
docker volume create --name=sentry-postgres
```

4. 创建 .env 配置文件
```bash line_number:false
cp .env.example .env
```

5. 生成秘钥并添加到 **.env** 文件里面
```bash line_number:false
docker-compose run --rm web config generate-secret-key
```
![getKey](/images/posts/37763440.jpg)

6. 构建数据库， 并创建用户 
```bash line_number:false
docker-compose run --rm web upgrade
```

7. 开启 Sentry 服务
```bash line_number:false
docker-compose up -d 
```

8. 访问并配置： http://127.0.0.1:9000

## CentOS 用 Python 安装 Sentry
CentOS 安装： https://learnku.com/articles/4295/centos6-install-python-based-on-sentry 

# Sentry 在 Laravel 框架中的使用

## 安装 Sentry 扩展包
```bash line_number:false
composer require sentry/sentry-laravel
```

## 注册扩展包 （laravel5.5 及以上的忽略此步骤）
```php :config/app.php 
'providers' => array(
    ...
    Sentry\SentryLaravel\SentryLaravelServiceProvider::class,
)

'aliases' => array(
    ...
    'Sentry' => Sentry\SentryLaravel\SentryFacade::class,
)
```

## 捕获异常
在 『 App/Exceptions/Handler.php 』 文件的 『 report 』 里面添加
```php :App/Exceptions/Handler.php first_line:29 mark:39-41
/**
 * Report or log an exception.
 *
 * This is a great spot to send exceptions to Sentry, Bugsnag, etc.
 *
 * @param  \Exception  $exception
 * @return void
 */
public function report(Exception $exception)
{
    if ($this->shouldReport($exception)) {
        app('sentry')->captureException($exception);
    }
    parent::report($exception);
}
```

## 生成配置文件
在 『 config 』 目录下生成 『 Sentry 』 的配置文件
```bash line_number:false
php artisan vendor:publish --provider="Sentry\SentryLaravel\SentryLaravelServiceProvider"
```

在配置文件中 会有一个 **dsn** 的 `env` 配置项, 该配置项是在 Sentry 
里面添加项目的时候生成的一个秘钥， 把该秘钥填写在 `env` 配置文件里面即可

# 接收 Sentry 的通知
## 邮件通知
在 『 Sentry 』 目录下 编辑 **requirements.txt** 文件
```bash :vim: Sentry/requirements.txt
# Add plugins here

# 兼容钉钉插件
redis-py-cluster==1.3.4

# 钉钉通知插件
sentry-dingding~=0.0.2

# 邮件支持 ssl 协议
django-smtp-ssl~=1.0
```

然后编辑 config.yml 文件中的 email 配置项
```bash first_line:10 
mail.backend: 'smtp'  # Use dummy if you want to disable email entirely
mail.host: 'smtp.qq.com'
mail.port: 587
mail.username: '*******@qq.com'
mail.password: '*******'
mail.use-tls: true
# The email address to send on behalf of
mail.from: '*******@qq.com'
```

配置完成后 重启 Sentry 并重新构建 :
```bash 
# 关闭 Sentry
docker-compose down

# 重新构建
docker-compose build

# 启动 Sentry
docker-compose up -d
```

在 Sentry 控制台上可以看到已经出现了 配置的邮箱信息
![email配置](/images/posts/41424988.jpg)
然后在下面点击发送测试邮件即可

## 钉钉即时提醒
邮件通知虽然可以提醒到我们， 但还是达不到实时通知，所以可以使用 『 钉钉 』机器人消息实时提醒

添加方法：
1.  在 『 钉钉 』 群聊中添加自定义机器人， 然后获取机器人的 webhook 中的 **access_token** 

2. 在 Sentry 管理面板中选定项目并点击设置， 在左边菜单栏中选择最后一项 『 所有集成 』，
然后在右边的插件列表中选择 **DingDing** 并开启，然后配置 DingDing， 输入在 钉钉 中获取到的机器人的 **access_token** 保存即可
