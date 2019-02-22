---
title: Hexo博客Next主题配置
date: 2018-06-05 14:16:25
tags: [记录]
categories: 记录
photos: /images/posts/75322921.jpg
---
本文为`Hexo`博客的`Next`主题的一些常用配置项
<!--more-->

# 设置「阅读全文」
NexT 提供三种方式来控制文章在首页的显示方式。 也就是说，在首页显示文章的摘录并显示 阅读全文 按钮，可以通过以下方法：
1. 在文章中使用`<!-- more -->`手动进行截断，Hexo 提供的方式
2. 在文章的 [front-matter](http://hexo.io/docs/front-matter.html) 中添加 description，并提供文章摘录
3. 自动形成摘要，在主题配置文件中添加：
```
auto_excerpt:
    enable: true
    length: 200
```
------

# 统计访问量
> 注册并登录百度统计获取你的统计代码。

编辑配置文件 `hexo\themes\next\_config.yml`, 增加配置选项：
``` :file:  hexo\themes\next\_config.yml
baidu_tongji: true
```
新建文件 `hexo\themes\next\layout\_partial\baidu_tongji.swig`，内容如下：
```
<% if (theme.baidu_tongji){ %>
<script type="text/javascript">
    #你的百度统计代码
</script>
<% } %>
```
编辑文件 `hexo\themes\next\layout\_partial\head.swig`，在『/head』之前增加：
```
<%- partial('baidu_tongji') %>
```
-----

# 网站图标
在文件 `hexo\themes\next\layout\_partial\head.swig` 中，![图标](/images/posts/22171672.jpg)可以看到，网站图标文件是在 *hexo\themes\next\source\images* 这个路径下，替换即可

-----

# 为文章添加密码
定位到文件 `hexo\themes\next\layout\_partial\head.swig` 中，添加下面的代码到文件最后面
```javascript
    (function(){
        if('{{ page.password }}'){
            if (prompt('请输入文章密码') !== '{{ page.password }}'){
                alert('密码错误！');
                history.back();
            }
        }
    })();
```
然后在编辑文章时添加 password: password即可
![password](/images/posts/67716877.jpg)

-----

