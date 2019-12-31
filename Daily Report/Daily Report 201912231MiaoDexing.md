# Shell中小数计算的两种方式
在Shell中，不能用计算整数的方式来计算小数。要借助bc命令，可以说bc是一个计算器，也可以说bc是个微型编程语言，反正当作工具来用，还是很方便，特别是小数计算。必须借助bc命令。
- 1、方法一：
```
    linux:~# var1=5
    linux:~# var2=35.14
    linux:~# var3=$(echo "scale=4; $var2 / $var1" | bc)
    linux:~# echo $var3
    7.0280
```
- 2、方法二：
```
    linux:~# var3=$(bc <<EOF
    >scale = 4
    >var1 = 5
    >var2 = 35.14
    >var2 / var1
    >EOF)
    linux:~# echo $var3
```
