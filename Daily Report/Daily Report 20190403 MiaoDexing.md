# Android Camera从App层到framework层到HAL层的初始化过程
- https://blog.csdn.net/hutongling/article/details/77053920

# [Android O] Camera 服务启动流程简析
- https://blog.csdn.net/qq_16775897/article/details/81240600
- 此处分析到hw_get_module函数根据id找到camera对应的HAL

# 总结
- 在 Android O 之前，Service 与 HAL 的耦合比较严重，而现在 Google 通过 HIDL 这个进程通信机制将他们分隔成两个进程，这使得 Service 与 HAL 之间的通路建立过程变得复杂了一些。 这两个进程的启动与初始化流程进程的总体逻辑顺序如下：
-  android.hardware.camera.provider@2.4-service 进程启动，仅注册 Provider；
-  cameraserver 进程启动，实例化 CameraService，并注册到 ServiceManager 中；
-  由于强指针首次引用，CameraService::onFirstRef() 被调用，相当于进行初始化；
-  在 CameraService 初始化过程中，通过 CameraProviderManager 来获取已注册的 Provider，并实例化、初始化 CameraProvider；
-  CameraProvider 初始化过程中，从动态库中加载了 HAL 层的关键结构，并将其封装到 CameraModule 中；
-  将获取到的 CameraProvider 保存在 ProviderInfo 中，以便后续的使用。
