# NDK开发camera流程
- 调用的相关文件有 CameraActivity.java(上层应用)  --->  Camera.java  --->  android_android_Camera.java (JNI) --->     Camera.java   --->  CameraBase.cpp   --->  ServiceManaager.java  --->   CameraService.cpp  --->  CameraClient.cpp  --->  CameraHardwareInterface.cpp(HWI调用接口)

- 基于NDK开发，使用自己封装PMS方法完成鉴权
```
core/java/android/hardware/Camera.java

 public static Camera open(int cameraId) {
129 +        if (ActivityThread.CameraPermissionInfo)
130 +        {
131 +            SystemProperties.set(CAMERA_USE_FAKE, VIR_CAMERA);
132 +        } else {
133 +            SystemProperties.set(CAMERA_USE_FAKE, PHY_CAMERA);                                                                                                                                         
134 +        }
135 +
136          return new Camera(cameraId);
137      }

```

# 错误信息 
CameraHardwareInterface: dataCallback: memory pool ID 16 not found

# 定位文件 位置
- frameworks/av/services/camera/libcameraservice/device1/CameraHardwareInterface.cpp
- 
```
120 hardware::Return<void> CameraHardwareInterface::dataCallback(
121         DataCallbackMsg msgType, uint32_t data, uint32_t bufferIndex,
122         const hardware::camera::device::V1_0::CameraFrameMetadata& metadata) {
123     camera_memory_t* mem = nullptr;
124     {
125         std::lock_guard<std::mutex> lock(mHidlMemPoolMapLock);
126         if (mHidlMemPoolMap.count(data) == 0) {
127             ALOGE("mdx------%s: memory pool ID %d not found", __FUNCTION__, data);                                                                                                                      
128             return hardware::Void();
129         }
130         mem = mHidlMemPoolMap.at(data);
131     }
132     camera_frame_metadata_t md;
133     md.number_of_faces = metadata.faces.size();
134     md.faces = (camera_face_t*) metadata.faces.data();
135     sDataCb((int32_t) msgType, mem, bufferIndex, &md, this);
136     return hardware::Void();
137 }

```
