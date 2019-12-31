# shell ：将标准输出及标准错误输出写到指定文件
- 脚本如下：
```
logFile=/usr/local/log/today.txt 

exec >> $logFile 2>&1 

```
 1为标准输出stdout、2为标准错误stderr。 
 
 # Shell中小数计算的两种方式
 在Shell中，不能用计算整数的方式来计算小数。要借助bc命令，可以说bc是一个计算器，也可以说bc是个微型编程语言，反正当作工具来用，还是很方便，特别是小数计算。必须借助bc命令。
 - 方式一：
 ```
linux:~# var1=5
linux:~# var2=35.14
linux:~# var3=$(echo "scale=4; $var2 / $var1" | bc)
linux:~# echo $var3
7.0280
 ```
 - 方式二：
 ```
 linux:~# var3=$(bc <<EOF
>scale = 4
>var1 = 5
>var2 = 35.14
>var2 / var1
>EOF)
linux:~# echo $var3
 ```
 # Shell变量while循环内改变无法传递到循环外
- shell中使用管道会生成一个子shell，在子shell中使用while、for循环的代码也是在子shell中执行的，所以在循环中的修改的变量只在子shell中有效，当循环结束时，会回到主shell，子shell中修改的变量不会影响主shell中的变量<br>
代码如下：
```
A="1"
B="2"
C="/home/test/a"

cat $C | grep -v '^#' | while read LINE
do
     if [ "x$A" = "x1" ]; then
         B=$A
         echo $B
     fi
done

echo $B

第一个echo打印的是1
第二个echo打印的是2
```
这里是因为在子shell中的while循环中的B只是主shell中B的一个副本，你在子shell中对B重新赋值是不能影响到父shell的，所以你最后echo $B时值没有改变。

以下是可以的：
```
while read LINE
do
   if
   B=$A
   fi
done<$C

```
这样是可以重新赋值的，因为这里没有管道，也就不存在子shell了
