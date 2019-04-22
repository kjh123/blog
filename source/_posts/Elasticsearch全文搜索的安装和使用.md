---
title: Elasticsearch全文搜索的安装和使用
tags:
  - 记录
  - Linux
category: 记录
translate_title: installation-and-use-of-elastic-search-full-text-search
date: 2018-11-30 10:07:47
---

# Elasticsearch 介绍
`Elasticsearch` 是一个基于 **Apache Lucene(TM)** 的开源搜索引擎。无论在开源还是专有领域， `Lucene` 可以被认为是迄今为止最先进、性能最好的、功能最全的搜索引擎库。

<!-- more -->

# 安装
## Debian 和 Ubuntu 安装
### 安装 JAVA 环境
*Elasticsearch requires Java 8 or later. (**Elasticsearch需要Java 8或更高版本**)*
```bash line_number:false
sudo apt-get install openjdk-8-dbg
```

### 安装 apt-transport-https package
```bash line_number:false
sudo apt-get install apt-transport-https
```

### 安装软件源
```bash line_number:false
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main"  | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
```

### 更新软件源并安装 Elasticsearch
```bash line_number:false
sudo apt-get update && sudo apt-get install elasticsearch
```

### 配置自动启动
#### 查看系统使用 SysV  init 还是 systemd
```bash line_number:false
ps -p 1
```

#### init 方式
使用 `update-rc.d` 命令将 Elasticsearch 配置为在系统启动时自动启动：
```bash line_number:false
sudo update-rc.d elasticsearch defaults 95 10
```

启动 和 停止命令
```bash line_number:false
sudo -i service elasticsearch start
sudo -i service elasticsearch stop
```

>如果 Elasticsearch 因任何原因无法启动，它将打印STDOUT失败的原因。可以查看日志文件 /var/log/elasticsearch/

#### systemd 方式
```bash line_number:false
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
```
启动 和 停止命令
```bash line_number:false
sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service
```

## 其他安装方式
### [Windows 环境安装](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html)
### [Docker 安装方式](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
### [Homestead 虚拟机安装](https://laravel-china.org/docs/laravel/5.7/homestead/2245#installing-elasticsearch)

## 检查 Elasticsearch 是否在运行
出现下面信息说明运行成功
![Elasticsearch运行](/images/posts/88442110.jpg)

默认情况下 Elasticsearch 的 RESTful 服务只有本机才能访问，如果需要在电脑访问的话。可以修改 /etc/elasticsearch/config/elasticsearch.yml 文件(线上项目不建议这么操作)：
```bash line_number:false
network.bind_host: “0.0.0.0"
network.publish_host: \_non_loopback:ipv4_
```

## 安装中文分词插件 [elasticsearch-analysis-ik](https://github.com/medcl/elasticsearch-analysis-ik)

 下载最新包
```bash line_number:false
wget https://github.com/medcl/elasticsearch-analysis-ik/archive/v6.5.1.tar.gz
```
解压: `tar -zxvf v6.5.1.tar.gz`


 安装
> 两种安装方式选择其一即可
### 打包方式安装
使用 maven 打包该 java 项目
```bash line_number:false
cd elasticsearch-analysis-ik-1.9.4
mvn package
```
在plugins目录下创建ik目录，并将打包好的IK插件解压到其中
```bash line_number:false
mkdir /usr/share/elasticsearch/plugins/ik
unzip target/releases/elasticsearch-analysis-ik-1.9.4.zip -d /usr/share/elasticsearch/plugins/ik/
```
### 插件方式安装
在 Elasticsearch 安装目录下: `/usr/share/elasticsearch/` 执行
```bash line_number:false
./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.3.0/elasticsearch-analysis-ik-6.3.0.zip
```

# 在 PHP 项目中使用
新建一个 laravel 项目， 安装 相应的扩展包 （[scout-elasticsearch-driver](https://github.com/babenkoivan/scout-elasticsearch-driver)）
> 这个扩展包会安装 laravel/scout 插件

```php
composer require babenkoivan/scout-elasticsearch-driver
```
## 发布配置文件
```php
// 全文索引配置文件
php artisan vendor:publish --provider="Laravel\Scout\ScoutServiceProvider"
// 扩展包配置文件
php artisan vendor:publish --provider="ScoutElastic\ScoutElasticServiceProvider"
```
## 创建索引文件
> 每个索引都有一个对应的配置文件，所以需要先创建配置文件
默认情况下，索引名称就是配置文件前面的部分：例如下面的 Demo

```php
// 索引配置文件
php artisan make:index-configurator DemoIndexConfigurator
// 索引文件
php artisan elastic:create-index App\\DemoIndexConfigurator
```
创建完成后，查看已经生成的索引文件：
```bash
GET 127.0.0.1:9200/_cat/indices?v

health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   demo  8n45obLpTgSasMUTkmom3Q   5   1          0            0       460b           460b
```

## 导入测试数据
新建模型并建立前面创建的索引: `php artisan make:searchable-model Demo --index-configurator=DemoConfigurator`

```php
<?php

namespace App;

use ScoutElastic\Searchable;
use Illuminate\Database\Eloquent\Model;

class Demo extends Model
{
    use Searchable;

    /**
     * @var string
     */
    protected $indexConfigurator = DemoConfigurator::class;

    /**
     * @var array
     */
    protected $searchRules = [
        //
    ];

    /**
     * @var array
     */
    protected $mapping = [
        'properties' => [
            'title' => [
                'type' => 'text',
                'analyzer' => 'ik_smart'
            ],
            'body' => [
                'type' => 'text',
                'analyzer' => 'ik_smart'
            ],
            'user_name' => [
                'type' => 'keyword',
            ]
        ]
    ];

    public function toSearchableArray()
    {
        return [
            'title'=> $this->title,
            'body' => $this->body,
            'user_name' => $this->user->name,
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

}
```
> 如果是在已有的 Model 中建立索引， 则执行 `php artisan scout:import "App\Demo"` 导入数据

## 查看索引中导入的数据
```bash
GET curl 127.0.0.1:9200/demo/demo/_search?pretty
{
  "took" : 115,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 0,
    "max_score" : null,
    "hits" : [
    	. . .
    ]
  }
}
```

## 使用
```php
Demo::search('keyword')->get();
```
