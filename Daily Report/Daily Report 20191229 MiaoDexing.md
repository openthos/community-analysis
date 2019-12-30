# Linux 文本 列数统计
- awk默认的字段分隔符是空格或制表符(tab)，如果你的是其它符号的话，就使用-F参数指定，
例如：cat 文件名 | awk -F ":" ‘{print NF}’,就是表示以分号(:)为空格符。
# 获得函数非整数返回值
- 函数中使用echo返回函数值时，通过 $(func_name arg1 arg2 …) 来捕获函数返回值
```
#!/bin/bash

# 也可在函数中使用echo作返回值
function func2(){
  first_name=$1
  middle_name=$2
  family_name=$3
  echo $first_name
  echo $middle_name
  echo $family_name
}

# 使用$(func_name arg1 arg2 ...)来获取函数中所有的echo值
res3=$(func2 "tony" "kid"   "leung")
echo "func2 'tony' 'kid'  'leung' RESULT IS____"$res3

res4=$(func2 'who' 'is' 'the' 'most' 'handsome' 'guy?')
echo "func2 'who' 'is' 'the' 'most' 'handsome' 'guy?' RESULT IS____"$res4

if [[ $res4 =~ "tony" ]]; then
  echo "it includes tony ^_^ "
else
  echo "Input name doesn't include 'tony'!"
fi
```
# 函数传参为数组
```
    #!/bin/bash
    function showArr(){
     
        arr=$1
     
        for i in ${arr[*]}; do
            echo $i
        done
     
    }
     
    regions=("GZ" "SH" "BJ")
     
    showArr "${regions[*]}"
     
    exit 0
```
- 但此处注意：
使用${#arr[@]} 获得数组元素个数永远为1

# 字符串截取
- '##' 号截取，删除左边字符，保留右边字符。
var=http://www.aaa.com/123.htm<br>
echo ${var##*/}

##*/ 表示从左边开始删除最后（最右边）一个 / 号及左边的所有字符
即删除http://www.aaa.com/
<br>
结果是 123.htm
