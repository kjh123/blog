
## HTTP 协议部分
> * 一个 HTTP 请求报文由请求行（request line）、请求头部（header）、空行和请求数据 4 个部分组成
> * HTTP 响应也由三个部分组成，分别是：状态行、消息响应头、响应正文。

### TCP/UDP/HTTP 的区别和联系

> 参考: [TCP/UDP/HTTP的区别和联系](https://blog.csdn.net/qq_31332467/article/details/79217262)

- TPC/IP协议是传输层协议，主要解决数据如何在网络中传输，而HTTP是应用层协议，主要解决如何包装数据
- UDP是一种不可靠的传输层协议，TCP为了实现网络通信的可靠性，使用了复杂的拥塞控制算法，建立了繁琐的握手过程以及重传策略
- UDP在传送数据之前不需要先建立连接；TCP则提供面向连接的服务

### 一次 HTTP 请求，谁会先断开 TCP 连接？什么情况下客户端先断，什么情况下服务端先断

http1.0和http1.1之间保持连接的差异以及http头中connection、content-length、Transfer-encoding等参数有关

### HTTP/1.0
1. 带 content-length，body 长度可知，客户端在接收 body 时，就可以依据这个长度来接受数据。接受完毕后，就表示这个请求完毕了。客户端主动调用 close 进入四次挥手。
2. 不带 content-length ，body 长度不可知，客户端一直接受数据，直到服务端主动断开

### HTTP/1.1
1. 带 content-length body 长度可知，客户端主动断开
2. 带 Transfer-encoding：chunked，body 会被分成多个块，每块的开始会标识出当前块的长度，body 就不需要通过 content-length 来指定了。但依然可以知道 body 的长度 客户端主动断开
3. 不带 Transfer-encoding：chunked 且不带 content-length ，客户端接收数据，直到服务端主动断开连接

>即：如果能够有办法知道服务器传来的长度，都是客户端首先断开。如果不知道就一直接收数据。直到服务端断开

### HTTP/1.1 该如何优化
1. 尽量避免发送 HTTP 请求；
2. 在需要发送 HTTP 请求时，考虑如何减少请求次数；
3. 减少服务器的 HTTP 响应的数据大小；

![](../images/20210225160248.png)

### 请求行
请求行 由请求方法字段、URL 字段和 HTTP 协议版本字段 3 个字段组成，它们用空格分隔。

### 请求头部
- 请求头部由关键字 / 值对组成，每行一对，关键字和值用英文冒号 “:” 分隔。
- 请求头部通知服务器有关于客户端请求的信息，典型的 请求头有：
    - UserAgent：产生请求的浏览器类型。
    - Accept：客户端可识别的内容类型列表。
    - Host：请求的主机名，允许多个域名同处一个 IP 地址，即虚拟主机。

### 空行
后一个请求头之后是一个空行，发送回车符和换行符，通知服务器以下不再有请求头。

### 请求数据
请求数据不在 GET 方法中使用，而是在 POST 方法中使用。POST 方法适用于需要客户填写表单的场合。与请求数据相关的常使 用的请求头是 **ContentType** 和 **ContentLength**。

### 响应-状态行
- 1xx：指示信息表示请求已接收，继续处理。
- 2xx：成功表示请求已被成功接收、理解、接受。
- 3xx：重定向要完成请求必须进行更进一步的操作。
- 4xx：客户端错误请求有语法错误或请求无法实现。
- 5xx：服务器端错误服务器未能实现合法的请求。

### 响应-消息头

#### 响应内容类型
```
1. 网页编码              header('Content-Type: text/html;charset=utf-8')
2. 纯文本格式            header('Content-Type:text/plain');
3. 图片响应 JPG、JPEG    header('Content-Type:image/jpeg');
4. ZIP 文件             header('Content-Type:application/zip');
5. PDF 文件             header('Content-Type:application/pdf');
6. css 文件             header('Content-type:text/css');
```

#### 响应一个下载文件

##### 下载 PDF
```sh
header('Content-Description: File Transfer');
header('Content-Type: application/pdf');
header('Content-Disposition: attachment; filename=download_name.pdf');
header('Content-Transfer-Encoding: binary');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');
```

##### 下载图片
```sh
header('Content-type: image/jpeg');
header('Content-Disposition: attachment; filename=download_name.jpg');
readfile($yourFilePath);
```

#### 显示一个需要验证的登录对话框
```sh
header('HTTP/1.1 401Unauthorized');
header('WWW-Authenticate:Basic realm="TopSecret"');
```
