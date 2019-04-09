# 进展
- 1、修改device/generic/common/init.sh，在init_hal_camera函数中添加 modprobe vivid，系统启动成功后，可以在dev目录下看到设备节点
- 2、hardware/libcamera/V4L2Camera.cpp中的open函数，可以通过传参来决定打开哪个设备

# NEXT
- Audio
  - https://www.alsa-project.org/main/index.php/Matrix:Module-dummy
