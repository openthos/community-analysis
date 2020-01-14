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
