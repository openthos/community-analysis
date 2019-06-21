# Android ContentProvider调用报错"Bad call: specified package xxx under uid 10032 but it is really 10001"
-
```
 5715             final long token = Binder.clearCallingIdentity();
 5716             try {
 5717                 if (name.contains(Manifest.permission.RECORD_AUDIO)) {
 5718                     //SystemProperties.set(packageName + REC_AUDIO, PHY_AUDIO);
 5719                     android.provider.Settings.Global.putInt(mContext.getContentResolver(), packageName + REC_AUDIO,  PHY_AUDIO);                                                                      
 5720                 }
 5721                 if (name.contains(Manifest.permission.CAMERA)) {
 5722                     //SystemProperties.set(packageName + CAMERA, PHY_CAMERA);
 5723                     android.provider.Settings.Global.putInt(mContext.getContentResolver(), packageName + CAMERA,  PHY_CAMERA);
 5724                 }
 5725             }finally{
 5726                 Binder.restoreCallingIdentity(token);
 5727             }

```
作用是清空远程调用端的uid和pid，用当前本地进程的uid和pid替代，这样在之后的调用方去进行权限校验时会以当前进程的信息为主，不会出现包名和UID不一致的情况。

## 总结：（原文：https://blog.csdn.net/weixin_33681778/article/details/87370431 ）

- 1.ContentProvider是用Binder实现的，查询的过程其实就是一次Binder调用，所以想深入了解ContentProvider一定要会一些Binder相关的知识。
- 2.ContentProvider在接受一次查询前会调用AppOpsManager(其会通过Binder再由AppOpsService完成)进行权限校验，其中会校验调用方的UID和包名是否一致，其相关功能可见文章： Android 权限管理 —— AppOps。
- 2.Binder调用时候可以通过Binder.getCallingPid()和Binder.getCallingUid()来获取调用方的PID和UID，而如果A通过Binder调用B，B又Binder调用了C，那么在C中Binder.getCallingPid()和Binder.getCallingUid()得到的是A的PID和UID，这种情况下需要在B调用C的前后用Binder.clearCallingIdentity()和Binder.restoreCallingIdentity()使其带上B的PID和UID，从而在C中进行权限校验时候用B的信息进行校验，当然这也符合逻辑，B调用的C，应该B需要有相应权限。
- 3.Binder.clearCallingIdentity()和Binder.restoreCallingIdentity()的实现原理 Binder IPC的权限控制也有介绍，是通过移位实现的。
