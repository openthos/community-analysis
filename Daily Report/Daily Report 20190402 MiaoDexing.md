# 打开 /dev/qemu_pipe 设备文件出错，无法找到此文件
- Android QEMU 高速管道是Android 模拟器实现了的一个特殊的虚拟设备，用于提供客户 Android 系统和模拟器本身 非常 快速的通信通道。
在客户 Android 系统端，用法非常简单，如下：
   -    打开 /dev/qemu_pipe 设备文件来读和写
        注意：自 Linux 3.10 开始，设备被重命名为了 /dev/goldfish_pipe，但行为完全一样。
   - 写入描述你想要连接的服务，且以 0 结束的字符串。
   - 简单地使用 read() 和 write() 来与服务通信。
- 最后论证是Android x86上goldfish无法使用，改用kernel vivi driver

# 虚拟驱动VIVI测试
- https://blog.csdn.net/ljmiaw/article/details/72801456
- https://blog.csdn.net/charliewangg12/article/details/42292609
