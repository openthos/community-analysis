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
