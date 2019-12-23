# 本机编译coreutils
- ./configure CC="gcc -m32" CXX="g++ -m32" CFLAGS="-pie -fPIC" CPPFLAGS="-m64" LDFLAGS="-m64"   FORCE_UNSAFE_CONFIGURE=1
- 运行完./configure之后生成了Makefile文件；
- 运行make，这一步需要通过，因为很多源码需要的.h文件(如config.h)都是经过这一步之后生成的； 
- 步骤到此，其实所有命令的可执行程序已经被编译出来了，在src目录下，只是还没移动到我们指定的安装路径去，文件的属性也还没修改。只要再执行
make install 这个命令才算完全安装完成。
