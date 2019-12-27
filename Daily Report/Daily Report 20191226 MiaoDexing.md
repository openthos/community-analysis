# 静态库
文件有：main.c、hello.c、hello.h

- 1、编译静态库hello.o: 
```
    gcc hello.c -o hello.o  #这里没有使用-shared  
```
- 2、把目标文档归档
```
    ar -r libhello.a hello.o  #这里的ar相当于tar的作用，将多个目标打包。  
```
程序ar配合参数-r创建一个新库libhello.a，并将命令行中列出的文件打包入其中。这种方法，如果libhello.a已经存在，将会覆盖现在文件，否则将新创建。
- 3、链接静态库
```
gcc main.c -lhello -L. -static -o main  
```
这里的-static选项是告诉编译器,hello是静态库。
或者：
```
gcc main.c libhello.a -L . -o main  
```
这样就可以不用加-static

# makefile规则
$@  表示目标文件 <br>
$^  表示所有的依赖文件 <br>
$<  表示第一个依赖文件 <br>
$?  表示比目标还要新的依赖文件列表

```
main: main.o hello.o
        gcc -o $@ $^
%.o : %.c
        gcc -c $< -o $@
clean:
        rm *.o
        rm main
```
- 一般我们可以使用“$(wildcard *.c)”来获取工作目录下的所有的.c文件列表。
```
#sample Makefile

objects := $(patsubst %.c,%.o,$(wildcard *.c))

 

foo : $(objects)

cc -o foo $(objects)


```
