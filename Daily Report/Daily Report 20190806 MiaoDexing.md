# 注册过程
- frameworks//av/services/camera/libcameraservice/api1/CameraClient.cpp
camera的callback是在cameraclient中的initialize接口中注册的，而这个接口是由上层初始化调用的。
```
  65 status_t CameraClient::initialize(sp<CameraProviderManager> manager) {
  66     int callingPid = getCallingPid();
  67     status_t res;
  68 
  69     LOG1("CameraClient::initialize E (pid %d, id %d)", callingPid, mCameraId);
  70 
  71     // Verify ops permissions
  72     res = startCameraOps();
  73     if (res != OK) {
  74         return res;
  75     }
  76 
  77     char camera_device_name[10];
  78     snprintf(camera_device_name, sizeof(camera_device_name), "%d", mCameraId);
  79 
  80     mHardware = new CameraHardwareInterface(camera_device_name);
  81     res = mHardware->initialize(manager);
  82     if (res != OK) {
  83         ALOGE("%s: Camera %d: unable to initialize device: %s (%d)",
  84                 __FUNCTION__, mCameraId, strerror(-res), res);
  85         mHardware.clear();
  86         return res;
  87     }
  88 
  89     mHardware->setCallbacks(notifyCallback,                                                                                                                                                            
  90             dataCallback,
  91             dataCallbackTimestamp,
  92             handleCallbackTimestampBatch,
  93             (void *)(uintptr_t)mCameraId);
  94 
  95     // Enable zoom, error, focus, and metadata messages by default
  96     enableMsgType(CAMERA_MSG_ERROR | CAMERA_MSG_ZOOM | CAMERA_MSG_FOCUS |
  97                   CAMERA_MSG_PREVIEW_METADATA | CAMERA_MSG_FOCUS_MOVE);
  98 
  99     LOG1("CameraClient::initialize X (pid %d, id %d)", callingPid, mCameraId);
 100     return OK;
 101 }

```
-  frameworks/av/services/camera/libcameraservice/device1/CameraHardwareInterface.cpp
res = mHardware->initialize(manager);这里是调用头文件作为和HAL通信的桥梁，其实就是一层接口封装：
```
  39 status_t CameraHardwareInterface::initialize(sp<CameraProviderManager> manager) {
 40     ALOGI("Opening camera %s", mName.string());
 41 
 42     status_t ret = manager->openSession(mName.string(), this, &mHidlDevice);
 43     if (ret != OK) {
 44         ALOGE("%s: openSession failed! %s (%d)", __FUNCTION__, strerror(-ret), ret);
 45     }                                                                                                                                                                                                   
 46     return ret;
 47 }

 
```
- av/services/camera/libcameraservice/common/CameraProviderManager.cpp
```
 272 status_t CameraProviderManager::openSession(const std::string &id,
 273         const sp<hardware::camera::device::V3_2::ICameraDeviceCallback>& callback,
 274         /*out*/
 275         sp<hardware::camera::device::V3_2::ICameraDeviceSession> *session) {
 276 
 277     std::lock_guard<std::mutex> lock(mInterfaceMutex);
 278 
 279     auto deviceInfo = findDeviceInfoLocked(id,
 280             /*minVersion*/ {3,0}, /*maxVersion*/ {4,0});
 281     if (deviceInfo == nullptr) return NAME_NOT_FOUND;
 282 
 283     auto *deviceInfo3 = static_cast<ProviderInfo::DeviceInfo3*>(deviceInfo);
 284 
 285     Status status;
 286     hardware::Return<void> ret;
 287     ret = deviceInfo3->mInterface->open(callback, [&status, &session]
 288             (Status s, const sp<device::V3_2::ICameraDeviceSession>& cameraSession) {
 289                 status = s;
 290                 if (status == Status::OK) {
 291                     *session = cameraSession;
 292                 }
 293             });
 294     if (!ret.isOk()) {
 295         ALOGE("%s: Transaction error opening a session for camera device %s: %s",
 296                 __FUNCTION__, id.c_str(), ret.description().c_str());
 297         return DEAD_OBJECT;
 298     }
 299     return mapToStatusT(status);
 300 }

```
该方法中根据传入的最小和最大版本号调用findDeviceInfoLocked方法获取到一个DeviceInfo对象
- av/services/camera/libcameraservice/common/CameraProviderManager.cpp
```
 355 CameraProviderManager::ProviderInfo::DeviceInfo* CameraProviderManager::findDeviceInfoLocked(                                                                                                          
 356         const std::string& id,
 357         hardware::hidl_version minVersion, hardware::hidl_version maxVersion) const {
 358     for (auto& provider : mProviders) {
 359         for (auto& deviceInfo : provider->mDevices) {
 360             if (deviceInfo->mId == id &&
 361                     minVersion <= deviceInfo->mVersion && maxVersion >= deviceInfo->mVersion) {
 362                 return deviceInfo.get();
 363             }
 364         }
 365     }
 366     return nullptr;
 367 }

```
可以看到，该方法的逻辑就是对成员变量mProviders进行遍历，判断每个DeviceInfo的id值、最小版本、最大版本号是否符合传入的最小和最大版本，
符合的话，就返回该对象，那我们就要问一下了，mProviders中的值是什么时候添加的呢？我们大概追究一下，它是在CameraService进行启动时，
初始化CameraProviderManager对象的逻辑中，通过addProviderLocked方法生成具体的DeviceInfo对象，添加到mProviders成员变量中的。
找到deviceInfo对象之后，然后调用deviceInfo3->mInterface->open，而它的成员变量mInterface就是在前面我们说构造ProviderInfo时
获取到的binder对象了，它实际上是hardware\interfaces\camera\device\3.2\default\CameraDevice.cpp对象了，
来到这里，我们就进入了CameraDaemon进程当中，两个进程的通信是通过HIDL，其实还是binder进程间通信机制，只是它是用来提供给HAL层服务的，
所以和AIDL类似，取了个HIDL的名字。
- hardware\interfaces\camera\device\3.2\default\CameraDevice.cpp
```
173 Return<void> CameraDevice::open(const sp<ICameraDeviceCallback>& callback, open_cb _hidl_cb)  {
174     Status status = initStatus();
175     sp<CameraDeviceSession> session = nullptr;
176 
177     if (callback == nullptr) {
178         ALOGE("%s: cannot open camera %s. callback is null!",
179                 __FUNCTION__, mCameraId.c_str());
180         _hidl_cb(Status::ILLEGAL_ARGUMENT, nullptr);
181         return Void();
182     }
183 
184     if (status != Status::OK) {
185         // Provider will never pass initFailed device to client, so
186         // this must be a disconnected camera
187         ALOGE("%s: cannot open camera %s. camera is disconnected!",
188                 __FUNCTION__, mCameraId.c_str());
189         _hidl_cb(Status::CAMERA_DISCONNECTED, nullptr);
190         return Void();
191     } else {
192         mLock.lock();
193 
194         ALOGV("%s: Initializing device for camera %d", __FUNCTION__, mCameraIdInt);
195         session = mSession.promote();                                                                                                                                                                   
196         if (session != nullptr && !session->isClosed()) {
197             ALOGE("%s: cannot open an already opened camera!", __FUNCTION__);
198             mLock.unlock();
199             _hidl_cb(Status::CAMERA_IN_USE, nullptr);
200             return Void();
201         }
202 
203         /** Open HAL device */
204         status_t res;
205         camera3_device_t *device;
206 
207         ATRACE_BEGIN("camera3->open");
208         res = mModule->open(mCameraId.c_str(),
209                 reinterpret_cast<hw_device_t**>(&device));
210         ATRACE_END();
211 
212         if (res != OK) {
213             ALOGE("%s: cannot open camera %s!", __FUNCTION__, mCameraId.c_str());
214             mLock.unlock();
215             _hidl_cb(getHidlStatus(res), nullptr);
216             return Void();
217         }
218 
219         /** Cross-check device version */
220         if (device->common.version < CAMERA_DEVICE_API_VERSION_3_2) {
221             ALOGE("%s: Could not open camera: "
222                     "Camera device should be at least %x, reports %x instead",
223                     __FUNCTION__,
224                     CAMERA_DEVICE_API_VERSION_3_2,
225                     device->common.version);
226             device->common.close(&device->common);
227             mLock.unlock();
228             _hidl_cb(Status::ILLEGAL_ARGUMENT, nullptr);
229             return Void();
230         }
231 
232         struct camera_info info;
233         res = mModule->getCameraInfo(mCameraIdInt, &info);
234         if (res != OK) {
235             ALOGE("%s: Could not open camera: getCameraInfo failed", __FUNCTION__);
236             device->common.close(&device->common);
237             mLock.unlock();
238             _hidl_cb(Status::ILLEGAL_ARGUMENT, nullptr);
239             return Void();
240         }
241 
242         session = createSession(
243                 device, info.static_camera_characteristics, callback);
244         if (session == nullptr) {
245             ALOGE("%s: camera device session allocation failed", __FUNCTION__);
246             mLock.unlock();
247             _hidl_cb(Status::INTERNAL_ERROR, nullptr);
248             return Void();
249         }
250         if (session->isInitFailed()) {
251             ALOGE("%s: camera device session init failed", __FUNCTION__);
252             session = nullptr;
253             mLock.unlock();
254             _hidl_cb(Status::INTERNAL_ERROR, nullptr);
255             return Void();
256         }
257         mSession = session;
258 
259         IF_ALOGV() {
260             session->getInterface()->interfaceChain([](
261                 ::android::hardware::hidl_vec<::android::hardware::hidl_string> interfaceChain) {
262                     ALOGV("Session interface chain:");
263                     for (auto iface : interfaceChain) {
264                         ALOGV("  %s", iface.c_str());
265                     }
266                 });
267         }
268         mLock.unlock();
269     }
270     _hidl_cb(status, session->getInterface());
271     return Void();
272 }


```
我们先来看一下该方法的参数，第一个是callback对象，它的使用方法和我们之前讲的应用层调用openCamera时
在CameraManager中传入的binder类型的callback是一样的，Server端拿到这个callback之后，就可以针对
需要的节点事件回调应用层，而这里是在CameraDaemon回调CameraServer，道理是一样的。这个callback
参数最终赋值给HAL层中的CameraDeviceSession类的mResultBatcher成员变量了；第二个参数是open_cb类型，
从它的命名中可以看出来，它也是一个回调函数，非常方便，就像一个函数指针一样，它在CameraProviderManager
一侧中像一个结构体一样传了过来，当CameraDevice类中的open执行完成后，就会将session对象作为参数回传到
CameraProviderManager这一侧，我们就拿到了session，后续对camera的操作都是通过这个sesson对象来进行中转完成的。

open方法中先判断status，正常的话，接着调用res = mModule->open(mCameraId.c_str(), reinterpret_cast<hw_device_t**>(&device))
来执行相机的打开操作，mModule对象是CameraDevice类的成员变量，它是在CameraDevice的构造函数中传入的，
而CameraDevice类的对象是在hardware\interfaces\camera\provider\2.4\default\CameraProvider.cpp
文件中的getCameraDeviceInterface_V3_x方法中构造的，该方法也是CameraDaemon进程为CameraServer进程提供的，
当添加相机设备时，CameraServer就需要查询和获取camera设备，也就会使用到这个接口，

- hardware\interfaces\camera\common\1.0\default\CameraModule.cpp
mModule是一个CameraModule对象，调用的是hardware\interfaces\camera\common\1.0\default\CameraModule.cpp类的open方法。
```
339 int CameraModule::open(const char* id, struct hw_device_t** device) {
340     int res;                                                                                                                                                                                            
341     ATRACE_BEGIN("camera_module->open");
342     res = filterOpenErrorCode(mModule->common.methods->open(&mModule->common, id, device));
343     ATRACE_END();
344     return res;
345 }

```
这里就是对应的厂商的HAL代码了！
