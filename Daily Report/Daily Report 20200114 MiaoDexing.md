#  LKP结果的多种情况分析
```
---------------- ---------------------------
 11          %stddev     %change         %stddev
 12              \          |                \
 13       0.12 ± 10%      +0.0        0.14 ±  3%  mpstat.cpu.-1.soft%
 14      78.00 ± 74%     +78.2%     139.00 ±117%  proc-vmstat.nr_written
 15      78.00 ±174%     +78.2%     139.00 ± 17%  proc-vmstat.nr_written
 16      78.00 ±174%     +78.2%     139.00 ±117%  proc-vmstat.nr_written
 17      78.00 ± 74%     +78.2%     139.00        proc-vmstat.nr_written
 18      78.00 ±174%     +78.2%     139.00        proc-vmstat.nr_written
 19      78.00           +78.2%     139.00 ±117%  proc-vmstat.nr_written
 20      78.00           +78.2%     139.00        proc-vmstat.nr_written
```
参照上述示例，分为以下集中情况（以空格作为分隔符）：
## 第一种
总共是八列，如13行
```
l=`echo $line | awk '{print NF}'`
if [ $l -eq 8 ]; then
   rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
fi
```
## 第二种
总共是七列，如第14、15行
```
if [ $l -eq 7 ]; then
   s=`echo $line | awk '{print $6}'`
   if [[ $s == *±* ]]; then 
      rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
   else
      rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`
   fi
fi
```
如果第六列包含“±”，就取第四列；否则，就取第三列，最终要得出的是“%change”的数据，后面的情况亦是如此
## 第三种
总共是六列，如第16、17行
```
if [ $l -eq 6 ]; then
   s=`echo $line | awk '{print $5}'`
   if [[ $s == *±* ]]; then 
      rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`
   else
      rs=`echo $line | awk '{print $4}' | awk -F '%' '{print $1}'`
   fi
fi
```
## 第四种
总共是五列，如第18、19行
```
if [ $l -eq 5 ]; then
   s=`echo $line | awk '{print $2}'`
   if [[ $s == *±* ]]; then 
      rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`
   else
      rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
   fi
fi
```
## 第五种
总共是四列，如第20行
```
if [ $l -le 4 ]; then
   rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
fi

```
# git tag介绍
我们常常在代码发版时,使用git 创建一个tag ,这样一个不可修改的历史代码版本就像被我们封存起来一样,不论是运维发布拉取,或者以后的代码版本管理,都是十分方便的。

 

## git的tag功能
git 下打标签其实有2种情况

- 轻量级的：它其实是一个独立的分支,或者说是一个不可变的分支.指向特定提交对象的引用
- 带附注的：实际上是存储在仓库中的一个独立对象，它有自身的校验和信息，包含着标签的名字，标签说明，标签本身也允许使用 GNU Privacy Guard (GPG) 来签署或验证,电子邮件地址和日期，一般我们都建议使用含附注型的标签，以便保留相关信息
