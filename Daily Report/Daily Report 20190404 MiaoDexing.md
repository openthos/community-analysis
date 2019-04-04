# 进一步分析camera框架，总结部分内容如下：
- Camera2 API中主要涉及以下几个关键类：
  - CameraManager：摄像头管理器，用于打开和关闭系统摄像头
  - CameraCharacteristics：描述摄像头的各种特性，我们可以通过CameraManager的getCameraCharacteristics(@NonNull String cameraId)方法来获取。
  - CameraDevice：描述系统摄像头，类似于早期的Camera。
  - CameraCaptureSession：Session类，当需要拍照、预览等功能时，需要先创建该类的实例，然后通过该实例里的方法进行控制（例如：拍照 capture()）。
  - CaptureRequest：描述了一次操作请求，拍照、预览等操作都需要先传入CaptureRequest参数，具体的参数控制也是通过CameraRequest的成员变量来设置。
  - CaptureResult：描述拍照完成后的结果。
  - mCameraManager.getCameraIdList()来获取cameraId列表，mCameraManager.getCameraCharacteristics(id) 获取每个id对应摄像头的参数，进而获取各个摄像头（主要是前置摄像头和后置摄像头）的参数。
  - 关于CameraCharacteristics里面的参数，其中LENS_FACING：前置摄像头（LENS_FACING_FRONT）后置摄像头（LENS_FACING_BACK），如果添加虚拟摄像头，需要处理前置摄像头、后置摄像头与虚拟摄像头的关系。
- 上层应用调用 mCameraManager.openCamera(currentCameraId, stateCallback, backgroundHandler)时，在HAL层会最终调用V4L2Camera::Open (const char *device)打开摄像头，摄像头灯亮
- 上层应用调用 Camera.open(cameraId)时，传递的cameraId

# 思考：
- 系统启动完成cameraservice的注册，完成HAL的加载
- 每个应用每次打开摄像头时，都会调用HAL层的open函数，在HAL层调用"V4L2Camera.cpp"文件中的V4L2Camera::Open()函数，最终是使用
 if ((fd = open(device, O_RDWR)) == -1) {
        ALOGE("ERROR opening V4L interface %s: %s", device, strerror(errno));
        return -1;
    }
        
 ret = ioctl (fd, VIDIOC_QUERYCAP, &videoIn->cap);
 打开设备
