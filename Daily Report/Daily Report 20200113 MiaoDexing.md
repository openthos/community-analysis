# 结果分析特殊情况
## 第一种：
```
 3002 ±169%     -98.6%      41.00        proc-vmstat.pgactivate
```
## 第二种：
```
404.00           -75.2%     100.25 ±173%  slabinfo.Acpi-Namespace.active_objs
```
上述两种情况的列数都是五列，针对上述两种情况，代码如下：
```
#num 表示列数
#line 表示读取的一行数据

[ $num -eq 5 ]; then
             s=`echo $line | awk '{print $4}'
             if [ $s == *±* ]; then 
                 rs=`echo $line | awk '{print $2}' | awk -F '%' '{print $1}'`
             else
                 rs=`echo $line | awk '{print $3}' | awk -F '%' '{print $1}'`

```
