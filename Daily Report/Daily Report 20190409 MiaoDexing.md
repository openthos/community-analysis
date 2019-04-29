# 进展
- 1、修改device/generic/common/init.sh，在init_hal_camera函数中添加 modprobe vivid，系统启动成功后，可以在dev目录下看到设备节点
- 2、hardware/libcamera/V4L2Camera.cpp中的open函数，可以通过传参来决定打开哪个设备
 -  
 ```
  67     if(property_get_bool(CAMERA_USE_FAKE, 1)) {
  68         if ((fd = open("/dev/video2", O_RDWR)) == -1) {
  69                 ALOGE("ERROR opening V4L interface %s: %s", "/dev/video2", strerror(errno));
  70                 return -1;
  71         }
  72     }
 
 ```

# NEXT
- Audio
  -  dummy driver
     - This driver provides up to 4 devices with up to 16 substreams. It uses a timer to sink and generate data. Useful for initial testing of an ALSA installation.参考 https://www.alsa-project.org/main/index.php/Matrix:Module-dummy
  -  insert the modules into the kernel:
     - modprobe snd-dummy ; modprobe snd-pcm-oss ; modprobe snd-mixer-oss ; modprobe snd-seq-oss
     
     
# 编译chromium
