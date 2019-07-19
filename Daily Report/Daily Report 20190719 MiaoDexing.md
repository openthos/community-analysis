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
## 结论
6、7、8权限管理未出现大的变化

# Android 9 权限管理
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
2 、groupState.mGroup.grantRuntimePermissions
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
