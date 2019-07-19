# 权限管理（PMS）分析
## 前言
重要函数和数据结构说明

### 数据结构说明
PermissionsState 
```
784     public static final class PermissionState {
785         private final String mName;   //权限名称
786         private boolean mGranted;     //是否授予
787         private int mFlags;

```
### 函数说明
1. checkUidPermission
```
此方法皆是由上层应用在请求相应service，其service来向AppOpsService查询是否授权，最后由PMS来完成鉴权
```
2. hasPermission <br>
```
258     /**
259      * Gets whether the state has a given permission for the specified
260      * user, regardless if this is an install or a runtime permission.
261      *
262      * @param name The permission name.
263      * @param userId The device user id.
264      * @return Whether the user has the permission.
265      */
```
3、grantRuntimePermission
```
授权最终调用方法，修改PermissionState 的 mGranted属性值为true，最终持久化到runtime-permissions.xml
```
4、revokeRuntimePermission
```
权限未授权调用方法，修改PermissionState 的 mGranted属性值为false，并持久化到runtime-permissions.xml
```
5、grantInstallPermission
```
这些安装权限是apk在安装时自动grant的，都是normal的等级，不是dangeous权限。
该函数的主要作用是
生成permission对应的PermissionData，并加入到PermissionsState mPermissions里
```
### 结论
6、7、8权限管理未出现大的变化

## Android 9 权限管理
1、 授权有两个地方，一个是设置里面的入口，还有一个是申请权限弹框界面的入口，代码都在PackageInstaller里面，分别是ManagePermissionsActivity和GrantPermissionsActivity。
2、 GrantPermissionsActivity
```
packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java

477         GroupState groupState = mRequestGrantPermissionGroups.get(name);
478         if (groupState != null && groupState.mGroup != null) {
479             if (granted) {
480                 groupState.mGroup.grantRuntimePermissions(doNotAskAgain,
481                         groupState.affectedPermissions);
482                 groupState.mState = GroupState.STATE_ALLOWED;
483             } else {
484                 groupState.mGroup.revokeRuntimePermissions(doNotAskAgain,                                                                                                                               
485                         groupState.affectedPermissions);
486                 groupState.mState = GroupState.STATE_DENIED;
487 
488                 int numRequestedPermissions = mRequestedPermissions.length;
489                 for (int i = 0; i < numRequestedPermissions; i++) {
490                     String permission = mRequestedPermissions[i];
491 
492                     if (groupState.mGroup.hasPermission(permission)) {
493                         EventLogger.logPermission(
494                                 MetricsProto.MetricsEvent.ACTION_PERMISSION_DENIED, permission,
495                                 mAppPermissions.getPackageInfo().packageName);
496                     }
497                 }
498             }
499             updateGrantResults(groupState.mGroup);
500         }

```
授权依然是调用的groupState.mGroup.grantRuntimePermissions，未授权还是groupState.mGroup.revokeRuntimePermissions

2、groupState.mGroup.grantRuntimePermissions
```
src/com/android/packageinstaller/permission/model/AppPermissionGroup.java

357     public boolean grantRuntimePermissions(boolean fixedByTheUser, String[] filterPermissions) {  

386                 // Grant the permission if needed.
387                 if (!permission.isGranted()) {
388                     permission.setGranted(true);
389                     mPackageManager.grantRuntimePermission(mPackageInfo.packageName,
390                             permission.getName(), mUserHandle);
391                 }  

```
此处仍然是调用的PMS中的grantRuntimePermission
```
services/core/java/com/android/server/pm/PackageManagerService.java

 5409     @Override
 5410     public void grantRuntimePermission(String packageName, String permName, final int userId) {                                                                                                       
 5411         mPermissionManager.grantRuntimePermission(permName, packageName, false /*overridePolicy*/,
 5412                 getCallingUid(), userId, mPermissionCallback);
 5413     }


1372     private void grantRuntimePermission(String permName, String packageName, boolean overridePolicy,
1373             int callingUid, final int userId, PermissionCallback callback) {


1453         final int result = permissionsState.grantRuntimePermission(bp, userId);  
```
3、permissionsState.grantRuntimePermission
```
services/core/java/com/android/server/pm/permission/PermissionsState.java

201     /**
202      * Grant a runtime permission for a given device user.
203      *
204      * @param permission The permission to grant.
205      * @param userId The device user id.
206      * @return The operation result which is either {@link #PERMISSION_OPERATION_SUCCESS},
207      *     or {@link #PERMISSION_OPERATION_SUCCESS_GIDS_CHANGED}, or {@link
208      *     #PERMISSION_OPERATION_FAILURE}.
209      */
210     public int grantRuntimePermission(BasePermission permission, int userId) {                                                                                                                          
211         enforceValidUserId(userId);
212         if (userId == UserHandle.USER_ALL) {
213             return PERMISSION_OPERATION_FAILURE;
214         }
215         return grantPermission(permission, userId);
216     }

```
4、grantPermission
```
services/core/java/com/android/server/pm/permission/PermissionsState.java

559     private int grantPermission(BasePermission permission, int userId) {
560         if (hasPermission(permission.getName(), userId)) {
561             return PERMISSION_OPERATION_FAILURE;
562         }
563 
564         final boolean hasGids = !ArrayUtils.isEmpty(permission.computeGids(userId));
565         final int[] oldGids = hasGids ? computeGids(userId) : NO_GIDS;
566 
567         PermissionData permissionData = ensurePermissionData(permission);
568 
569         if (!permissionData.grant(userId)) {
570             return PERMISSION_OPERATION_FAILURE;
571         }
572 
573         if (hasGids) {
574             final int[] newGids = computeGids(userId);
575             if (oldGids.length != newGids.length) {
576                 return PERMISSION_OPERATION_SUCCESS_GIDS_CHANGED;                                                                                                                                       
577             }
578         }
579     
580         return PERMISSION_OPERATION_SUCCESS;
581     }

```

5、permissionData.grant
```
686         public boolean grant(int userId) {
687             if (!isCompatibleUserId(userId)) {
688                 return false;
689             }
690 
691             if (isGranted(userId)) {
692                 return false; 
693             }
694         
695             PermissionState userState = mUserStates.get(userId);
696             if (userState == null) {
697                 userState = new PermissionState(mPerm.getName());
698                 mUserStates.put(userId, userState);
699             }
700         
701             userState.mGranted = true;
702             
703             return true;
704         }

```
### 变化
安卓9.0将禁止空闲后台应用访问智能手机的相机或麦克风。
1、 如果UID闲置（在后台时间超过了一定时间），它应该无法使用相机。如果UID变得空闲，我们会生成一个错误并关闭这个UID的摄像头。如果空闲UID中的应用程序尝试使用相机，我们会立即生成错误。由于应用程序应该已经能够处理这些错误，所以将此策略应用于所有应用程序是安全的，以保护用户隐私。
2、 如果UID处于空闲状态，我们不允许录制以保护用户的隐私。如果UID处于空闲状态，我们允许录制但报告空数据（字节数组中的全零），一旦进程处于活动状态，我们会报告真实的麦克风数据。

## Android 10 权限管理
1、入口  GrantPermissionsActivity
```
src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
477         GroupState groupState = mRequestGrantPermissionGroups.get(name);
478         if (groupState != null && groupState.mGroup != null) {
479             if (granted) {
480                 groupState.mGroup.grantRuntimePermissions(doNotAskAgain,
481                         groupState.affectedPermissions);
482                 groupState.mState = GroupState.STATE_ALLOWED;
483             } else {
484                 groupState.mGroup.revokeRuntimePermissions(doNotAskAgain,
485                         groupState.affectedPermissions);
486                 groupState.mState = GroupState.STATE_DENIED;
487 
488                 int numRequestedPermissions = mRequestedPermissions.length;
489                 for (int i = 0; i < numRequestedPermissions; i++) {
490                     String permission = mRequestedPermissions[i];
491 
492                     if (groupState.mGroup.hasPermission(permission)) {
493                         EventLogger.logPermission(
494                                 MetricsProto.MetricsEvent.ACTION_PERMISSION_DENIED, permission,
495                                 mAppPermissions.getPackageInfo().packageName);
496                     }
497                 }
498             }
499             updateGrantResults(groupState.mGroup);
500         }

```

2、 groupState.mGroup.grantRuntimePermissions
```
357     public boolean grantRuntimePermissions(boolean fixedByTheUser, String[] filterPermissions) {


386                 // Grant the permission if needed.
387                 if (!permission.isGranted()) {                                                                                                                                                          
388                     permission.setGranted(true);
389                     mPackageManager.grantRuntimePermission(mPackageInfo.packageName,
390                             permission.getName(), mUserHandle);
391                 }


```
3、 mPackageManager.grantRuntimePermission
```
1372     private void grantRuntimePermission(String permName, String packageName, boolean overridePolicy,
1373             int callingUid, final int userId, PermissionCallback callback) {


1453         final int result = permissionsState.grantRuntimePermission(bp, userId);       
```
4、 permissionsState.grantRuntimePermission
```
services/core/java/com/android/server/pm/permission/PermissionsState.java

220     public int grantRuntimePermission(BasePermission permission, int userId) {                                                                                                                          
221         enforceValidUserId(userId);
222         if (userId == UserHandle.USER_ALL) {
223             return PERMISSION_OPERATION_FAILURE;
224         }
225         return grantPermission(permission, userId);
226     }

```
5、 grantPermission
```
600     private int grantPermission(BasePermission permission, int userId) {                                                                                                                                
601         if (hasPermission(permission.getName(), userId)) {
602             return PERMISSION_OPERATION_FAILURE;
603         }   
604         
605         final boolean hasGids = !ArrayUtils.isEmpty(permission.computeGids(userId));
606         final int[] oldGids = hasGids ? computeGids(userId) : NO_GIDS;
607 
608         PermissionData permissionData = ensurePermissionData(permission);
609 
610         if (!permissionData.grant(userId)) {
611             return PERMISSION_OPERATION_FAILURE;
612         }
613 
614         if (hasGids) {
615             final int[] newGids = computeGids(userId);
616             if (oldGids.length != newGids.length) {
617                 return PERMISSION_OPERATION_SUCCESS_GIDS_CHANGED; 
618             }
619         }
620             
621         return PERMISSION_OPERATION_SUCCESS;
622     }

```
6、 permissionData.grant
```


737         public boolean grant(int userId) {                                                                                                                                                              
738             if (!isCompatibleUserId(userId)) {
739                 return false;
740             }
741 
742             if (isGranted(userId)) {
743                 return false; 
744             }
745         
746             PermissionState userState = mUserStates.get(userId);
747             if (userState == null) {
748                 userState = new PermissionState(mPerm.getName());
749                 mUserStates.put(userId, userState);
750             }
751         
752             userState.mGranted = true;
753             
754             return true;
755         }  


```
### 变化
- Google开始了一项名为 Project Strobe 的工作 —— 对第三方开发者访问 Google 帐户和 Android 设备数据以及我们围绕应用数据访问的理念进行彻底的审核。该项目考察了我们对隐私保护的控制，用户因为担心数据隐私而选择回避使用我们的 API 的平台/服务，开发者可能会获得过多访问权限的领域，以及政策应该收紧的领域。
1、关闭消费者版 Google+
2、当应用提示您访问 Google 帐户数据时，我们始终要求您知晓应用所要求的数据是哪些，而且您必须明确授予其权限。
今后的消费者将对他们选择与每个应用分享的帐户数据进行更精细的控制。应用将不再使用一个对话框向您索取所有的数据访问权限，而必须针对每个权限，在其独立的对话框中逐一向您进行确认。例如，如果开发者请求访问日历条目和 Drive 文档，您将能够选择共享其中一个而拒绝另外一个。
3、当用户授权应用访问其Gmail，是基于特定的使用场景做出的选择，即便用户已经授权，我们也会对使用场景进行限制。
4、限制应用在 Android 设备上接收通话日志和短信权限的能力，并且不再通过 Android Contacts API 提供联系人互动数据。
某些 Android 应用会要求获得访问用户手机  (包括通话记录) 和短信数据的权限。今后，Google Play 将只允许部分应用请求这些权限。只有被您选定为默认应用的电话应用或短信应用才能发出这些请求。有一些例外情况，例如语音邮件和备份应用不受此限制。
