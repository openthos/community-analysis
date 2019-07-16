#  Android权限管理原理（6.0及以上）
## 前言
- Android系统在MarshMallow之前，权限都是在安装的时候授予的。在6.0之后，Google为了简化安装流程且方便用户控制权限，正式引入了runtime-permission，允许用户在运行的时候动态控制权限。
## AppOpsManager动态权限管理
- AppOpsManager实现的动态管理的本质是：将鉴权放在每个服务内部，比如，如果App要申请定位权限，定位服务LocationManagerService会向AppOpsService查询是否授予了App定位权限，如果需要授权，就弹出一个系统对话框让用户操作，并根据用户的操作将结果持久化在文件中，如果在Setting里设置了响应的权限，也会去更新相应的权限操作持久化文件/data/system/appops.xml，下次再次申请服务的时候，服务会再次鉴定权限。
## 举个例子-定位服务LocationManagerService
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/location.png)
- frameworks/base/location/java/android/location/LocationManager.java
```
 879     private void requestLocationUpdates(LocationRequest request, LocationListener listener,                                                                                                            
 880             Looper looper, PendingIntent intent) {
 881 
 882         String packageName = mContext.getPackageName();
 883 
 884         // wrap the listener class
 885         ListenerTransport transport = wrapListener(listener, looper);
 886 
 887         try {
 888             mService.requestLocationUpdates(request, transport, intent, packageName);
 889        } catch (RemoteException e) {
 890            throw e.rethrowFromSystemServer();
 891        }
 892     }

```
- frameworks/base/services/core/java/com/android/server/LocationManagerService.java
```
2012     public void requestLocationUpdates(LocationRequest request, ILocationListener listener,
2013             PendingIntent intent, String packageName) {
2014         if (request == null) request = DEFAULT_LOCATION_REQUEST;
2015         checkPackageName(packageName);
2016         int allowedResolutionLevel = getCallerAllowedResolutionLevel();
2017         checkResolutionLevelIsSufficientForProviderUse(allowedResolutionLevel,
2018                 request.getProvider());
2019         WorkSource workSource = request.getWorkSource();
2020         if (workSource != null && workSource.size() > 0) {
2021             checkDeviceStatsAllowed();
2022         }
2023         boolean hideFromAppOps = request.getHideFromAppOps();
2024         if (hideFromAppOps) {
2025             checkUpdateAppOpsAllowed();
2026         }
2027         LocationRequest sanitizedRequest = createSanitizedRequest(request, allowedResolutionLevel);
2028 
2029         final int pid = Binder.getCallingPid();
2030         final int uid = Binder.getCallingUid();
2031         // providers may use public location API's, need to clear identity
2032         long identity = Binder.clearCallingIdentity();
2033         try {
2034             // We don't check for MODE_IGNORED here; we will do that when we go to deliver
2035             // a location.
2036             checkLocationAccess(pid, uid, packageName, allowedResolutionLevel);
2037 
2038             synchronized (mLock) {
2039                 Receiver recevier = checkListenerOrIntentLocked(listener, intent, pid, uid,
2040                         packageName, workSource, hideFromAppOps);
2041                 requestLocationUpdatesLocked(sanitizedRequest, recevier, pid, uid, packageName);
2042             }                                                                                                                                                                                          
2043         } finally {
2044             Binder.restoreCallingIdentity(identity);
2045         }
2046     }

```
   - getCallerAllowedResolutionLevel主要通过调用getAllowedResolutionLevel查询APP是否在Manifest中进行了声明
   ```
   1411     /**                                                                                                                                                                                                
   1412      * Returns the resolution level allowed to the caller
   1413      *
   1414      * @return resolution level allowed to caller
   1415      */
   1416     private int getCallerAllowedResolutionLevel() {
   1417         return getAllowedResolutionLevel(Binder.getCallingPid(), Binder.getCallingUid());
   1418     }
   
   1392     /**
   1393      * Returns the resolution level allowed to the given PID/UID pair.
   1394      *
   1395      * @param pid the PID
   1396      * @param uid the UID
   1397      * @return resolution level allowed to the pid/uid pair
   1398      */
   1399     private int getAllowedResolutionLevel(int pid, int uid) {
   1400         if (mContext.checkPermission(android.Manifest.permission.ACCESS_FINE_LOCATION,
   1401                 pid, uid) == PackageManager.PERMISSION_GRANTED) {
   1402             return RESOLUTION_LEVEL_FINE;
   1403         } else if (mContext.checkPermission(android.Manifest.permission.ACCESS_COARSE_LOCATION,
   1404                 pid, uid) == PackageManager.PERMISSION_GRANTED) {
   1405             return RESOLUTION_LEVEL_COARSE;
   1406         } else {
   1407             return RESOLUTION_LEVEL_NONE;
   1408         }
   1409     }


   ```
   - checkLocationAccess这里才是动态鉴权的入口，在checkLocationAccess函数中，会调用mAppOps.checkOp去鉴权，mAppOps就是AppOpsManager实例，
