# Question
- 1、应用层在打开摄像头时，根据cameraId来判断使用前置摄像头还是后置摄像头，其中LENS_FACING：前置摄像头（LENS_FACING_FRONT）后置摄像头（LENS_FACING_BACK），这些在系统中已经做好映射，如果添加虚拟摄像头，应该如何做好映射？
- 2、在vivid 驱动添加成功之后，HAL层调用"V4L2Camera.cpp"文件中的V4L2Camera::Open()函数时最终是使用open(device, O_RDWR)打开设备，在这里无论上层使用的是前置摄像头还是后置摄像头，此处直接写死使用“/dev/video3”,但是应用层打开设备之后需要获取需要调用getParameters()函数获得摄像头参数信息，但vivid 摄像头貌似没有相关信息，此处需要自己填入？Camera中的函数还有很多，难道每个都需要手动填入？后续的拍照、聚焦、录像这些复杂的函数信息可不好手动填入！
- 3、相机拍照的一般流程是首先获取CameraManager，然后获取相机列表，进而获取各个摄像头（前置摄像头和后置摄像头）的参数；CameraCharacteristics 是描述相机设备的属性类，包括：曝光补偿（Exposure compensation）、自动曝光/自动对焦/自动白平衡模式（AE / AF / AWB mode）、自动曝光/自动白平衡锁（AE / AWB lock）、自动对焦触发器（AF trigger）、拍摄前自动曝光触发器（Precapture AE trigger）、测量区域（Metering regions）、闪光灯触发器（Flash trigger）、曝光时间（Exposure time）、感光度（ISO Sensitivity）、帧间隔（Frame duration）、镜头对焦距离（Lens focus distance）、色彩校正矩阵（Color correction matrix）、JPEG 元数据（JPEG metadata）、色调映射曲线（Tonemap curve）、裁剪区域（Crop region）、目标 FPS 范围（Target FPS range）、拍摄意图（Capture intent）、硬件视频防抖（Video stabilization）等。

官方文档链接：https://developer.android.google.cn/reference/android/hardware/camera2/CameraCharacteristics


# Next
- 1、根据与黄志伟的沟通，驱动起vivid
