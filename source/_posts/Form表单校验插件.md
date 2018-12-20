---
title: Form表单校验插件
date: 2018-09-02 00:14:47
tags: [记录, 前端]
categories: JavaScript
---

> FormCheck 为了解决开发中经常用到的前端表单验证，避免重复开发，
> 一方面又为了加强前端知识理解，所以写一个小插件
 
项目地址： [GitHub](https://github.com/kjh123/FormCheck) 

<!--more-->

# 示例
功能示例：
[代码示例](http://learner-hui.oss-cn-beijing.aliyuncs.com/18-12-14/49406133.jpg)
[校验结果（失败：不能为空）](http://learner-hui.oss-cn-beijing.aliyuncs.com/18-12-14/18923734.jpg)
[校验结果（失败：长度不符）](http://learner-hui.oss-cn-beijing.aliyuncs.com/18-12-14/18079569.jpg)
[校验结果（成功）](http://learner-hui.oss-cn-beijing.aliyuncs.com/18-12-14/15306891.jpg)
示例说明：
```html
<!-- 为更好的说明 已省略非必要部分 -->

 <!-- 在表单的 Form 元素上添加 `id="FormCheck"`  用于指定监听需要校验的表单 -->
<form id="FormCheck">
    ···
     <!-- 在需要校验的表单元素上添加 `data-rules` 属性 
     该属性为一个含有 attribute 属性 和 rules 属性的对象，
     该 attribute 为提示信息的字段名称 rules 为校验规则 -->
    <input type="text" 
    data-rules='{"attribute":"姓名","rules":["required", "length:2,8"]}' 
    name="name" value="" placeholder="请输入姓名" />

    ----------------------------

    该示例如果校验不通过则会提示：
        - 若为空（required）：姓名不能为空
        - 若长度不符（length:2,8）：姓名长度应该在2-8个字符之间
            
    ···
</form>
```
# 使用

1. 引入 `JQuery` （必须）
2. 引入 `layer` （非必须，主要用来美化错误提示，可更换）
3. 引入 `formCheck.js`
4. 在页面需要校验的表单上添加 `id="FormCheck"`
5. 在需要校验的表单元素上添加 `data-rules` 属性 （具体规则可看规则列表）
> `data-rules`  是一个包含 `attribute` 和 `rules` 属性的对象 
> `attribute` 为提示信息的字段名称 
> `rules` 规则必须使用数组形式来定义
> 例如： 
> ```
> data-rules='{"attribute":"示例","rules"：["sometimes","in:1,3,5"]}'
> ```

# 规则列表
`rules` 已实现的校验规则如下

- `required` 可选规则，默认，表示该字段不能为空

- `length:n,[m]` 长度校验 ： m 参数可选 
    + 只有 **n** 参数表示 字段长度不小于 **n** 位  | 例如："length:4" 验证长度必须不小于4位
    + 加上 **m** 参数表示 字段长度在 **n** 到 **m** 个字符之间 | 例如："length:2,6" 验证字段长度必须是2到6位
    + 若想规定字段长度只能为具体值时，则 **n** 参数 应该为 eq | 例如："length:eq,2" 规定长度只能是两位
- `int:n,[m]` 数值校验 ： m 参数可选  同 length 规则
    + 只有 **n** 参数表示 字段大小不小于 **n**  | 例如："int:4" 验证值必须不小于4
    + 加上 **m** 参数表示 字段大小在 **n** 到 **m** 个之间 | 例如："int:2,6" 验证字段必须大于2并且小于6
    + 若想规定字段大小只能为具体值时，则 **n** 参数 应该为 eq | 例如："int:eq,2" 规定值只能是2
- `in:n,m,···` 范围校验 ： 参数数量不限
    + 当使用 **in** 范围校验时必须至少指定一个参数 例如："in:k,j,h" 规定值的范围只能是在 k,j,h 中的某一个
- `eq:n` 值校验 ： 校验值必须与参数 **n** 相等 例如："eq:hello" 规定值必须为 hello

- `max:n` 同 `lt:n`  值校验 ： 校验值必须大于参数 **n**

- `min:n` 同 `gt:n`  值校验 ： 校验值必须小于参数 **n**

- `phone` 同 `mobile` 手机号校验 

- `idcard`  身份证号校验

- `url` url地址校验

- `email` 邮箱校验 

# 其他规则

- `sometime` 同 `sometimes` 表示可选校验，如果值为空，则不校验，反之，则校验

# 最后
个人能力有限，希望可以有志同道合的伙伴一起优化