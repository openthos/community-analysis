# 移植goldfish 中的camera至openthos
- cp Android-8.1/device/generic/goldfish/camera    openthos/hardware/ -a
- cp Android-8.1/device/generic/goldfish/include/qemu_pipe.h   openthos/system/core/qemu_pipe/include/
- device/generic/common/packages.mk

# 分析gps代码结构
- https://blog.csdn.net/feelinghappy/article/details/77084680
