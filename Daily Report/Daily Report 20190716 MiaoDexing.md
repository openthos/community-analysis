#  Android权限管理原理（6.0及以上）
## 前言
- Android系统在MarshMallow之前，权限都是在安装的时候授予的。在6.0之后，Google为了简化安装流程且方便用户控制权限，正式引入了runtime-permission，允许用户在运行的时候动态控制权限。
## AppOpsManager动态权限管理
- AppOpsManager实现的动态管理的本质是：将鉴权放在每个服务内部，比如，如果App要申请定位权限，定位服务LocationManagerService会向AppOpsService查询是否授予了App定位权限，如果需要授权，就弹出一个系统对话框让用户操作，并根据用户的操作将结果持久化在文件中，如果在Setting里设置了响应的权限，也会去更新相应的权限操作持久化文件data/system/user/0/runtime-permissions.xml，下次再次申请服务的时候，服务会再次鉴定权限。
## 举个例子-定位服务LocationManagerService
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/location.png)

- frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
```
5353     @Override
 5354     public int checkUidPermission(String permName, int uid) {
 5355         final int callingUid = Binder.getCallingUid();
 5356         final int callingUserId = UserHandle.getUserId(callingUid);
 5357         final boolean isCallerInstantApp = getInstantAppPackageName(callingUid) != null;
 5358         final boolean isUidInstantApp = getInstantAppPackageName(uid) != null;
 5359         final int userId = UserHandle.getUserId(uid);
 5360         if (!sUserManager.exists(userId)) {
 5361             return PackageManager.PERMISSION_DENIED;
 5362         }
 5363 
 5364         synchronized (mPackages) {
 5365             Object obj = mSettings.getUserIdLPr(UserHandle.getAppId(uid));
 5366             if (obj != null) {
 5367                 if (obj instanceof SharedUserSetting) {
 5368                     if (isCallerInstantApp) {
 5369                         return PackageManager.PERMISSION_DENIED;
 5370                     }
 5371                 } else if (obj instanceof PackageSetting) {
 5372                     final PackageSetting ps = (PackageSetting) obj;
 5373                     if (filterAppAccessLPr(ps, callingUid, callingUserId)) {
 5374                         return PackageManager.PERMISSION_DENIED;
 5375                     }
 5376                 }
 5377                 final SettingBase settingBase = (SettingBase) obj;
 5378                 final PermissionsState permissionsState = settingBase.getPermissionsState();
 5379                 if (permissionsState.hasPermission(permName, userId)) {
 5380                     if (isUidInstantApp) {
 5381                         BasePermission bp = mSettings.mPermissions.get(permName);
 5382                         if (bp != null && bp.isInstant()) {
 5383                             return PackageManager.PERMISSION_GRANTED;
 5384                         }
 5385                     } else {
 5386                         return PackageManager.PERMISSION_GRANTED;
 5387                     }
 5388                 }
 5389                 // Special case: ACCESS_FINE_LOCATION permission includes ACCESS_COARSE_LOCATION
 5390                 if (Manifest.permission.ACCESS_COARSE_LOCATION.equals(permName) && permissionsState
 5391                         .hasPermission(Manifest.permission.ACCESS_FINE_LOCATION, userId)) {
 5392                     return PackageManager.PERMISSION_GRANTED;
 5393                 }
 5394             } else {
 5395                 ArraySet<String> perms = mSystemPermissions.get(uid);
 5396                 if (perms != null) {
 5397                     if (perms.contains(permName)) {
 5398                         return PackageManager.PERMISSION_GRANTED;
 5399                     }
 5400                     if (Manifest.permission.ACCESS_COARSE_LOCATION.equals(permName) && perms
 5401                             .contains(Manifest.permission.ACCESS_FINE_LOCATION)) {
 5402                         return PackageManager.PERMISSION_GRANTED;
 5403                     }
 5404                 }
 5405             }
 5406         }
 5407 
 5408         return PackageManager.PERMISSION_DENIED;                                                                                                                                                      
 5409     }


```

其中关键在于mSettings里面保存的SettingBase对象，它记录了PermissionsState也就是权限的授予情况。

-  frameworks/base/services/core/java/com/android/server/pm/PermissionsState.java
```
266     public boolean hasPermission(String name, int userId) {                                                                                                                                             
267         enforceValidUserId(userId);
268 
269         if (mPermissions == null) {
270             return false;
271         }
272 
273         PermissionData permissionData = mPermissions.get(name);
274         return permissionData != null && permissionData.isGranted(userId);
275     }

```
从上面的代码可以很清晰看出，除了声明了权限之外，还必须是授权了的。授权有两个地方，一个是设置里面的入口，还有一个是申请权限弹框界面的入口，代码都在PackageInstaller里面，分别是ManagePermissionsActivity和GrantPermissionsActivity。重点分析GrantPermissionsActivity，在这个Activity里面，如果一开始没有获得权限，就会弹出权限申请对话框，根据用户的操作去更新PKMS中的权限信息，同时将更新的结构持久化到runtime-permissions.xml中去。

- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
305     public void onPermissionGrantResult(String name, boolean granted, boolean doNotAskAgain) {
306         KeyguardManager kgm = getSystemService(KeyguardManager.class);
307                                                                                                                                                                                                         
308         if (kgm.isDeviceLocked()) {
309             kgm.requestDismissKeyguard(this, new KeyguardManager.KeyguardDismissCallback() {
310                         @Override
311                         public void onDismissError() {
312                             Log.e(LOG_TAG, "Cannot dismiss keyguard perm=" + name + " granted="
313                                    + granted + " doNotAskAgain=" + doNotAskAgain);
314                         }
315 
316                         @Override
317                         public void onDismissCancelled() {
318                             // do nothing (i.e. stay at the current permission group)
319                         }
320 
321                         @Override
322                         public void onDismissSucceeded() {
323                             // Now the keyguard is dismissed, hence the device is not locked
324                             // anymore
325                             onPermissionGrantResult(name, granted, doNotAskAgain);
326                         }
327                     });
328 
329             return;
330         }
331 
332         GroupState groupState = mRequestGrantPermissionGroups.get(name);
333         if (groupState.mGroup != null) {
334             if (granted) {
335                 groupState.mGroup.grantRuntimePermissions(doNotAskAgain,
336                         groupState.affectedPermissions);
337                 groupState.mState = GroupState.STATE_ALLOWED;
338             } else {
339                 groupState.mGroup.revokeRuntimePermissions(doNotAskAgain,
340                         groupState.affectedPermissions);
341                 groupState.mState = GroupState.STATE_DENIED;
342 
343                 int numRequestedPermissions = mRequestedPermissions.length;
344                 for (int i = 0; i < numRequestedPermissions; i++) {
345                     String permission = mRequestedPermissions[i];
346 
347                     if (groupState.mGroup.hasPermission(permission)) {
348                         EventLogger.logPermissionDenied(this, permission,
349                                 mAppPermissions.getPackageInfo().packageName);
350                     }
351                 }
352             }
353             updateGrantResults(groupState.mGroup);
354         }
355         if (!showNextPermissionGroupGrantRequest()) {
356             setResultAndFinish();
357         }
358     }


```
GrantPermissionsActivity其实是利用GroupState对象与PKMS通信，远程更新权限的，当然，如果权限都已经授予了，那么就不需要再次弹出权限申请对话框。

- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/model/AppPermissionGroup.java
```
330     public boolean grantRuntimePermissions(boolean fixedByTheUser, String[] filterPermissions) {
331         final int uid = mPackageInfo.applicationInfo.uid;


358 
359                 // Grant the permission if needed.
360                 if (!permission.isGranted()) {
361                     permission.setGranted(true);
362                     mPackageManager.grantRuntimePermission(mPackageInfo.packageName,
363                             permission.getName(), mUserHandle);
364                 }
365 
366                 // Update the permission flags.
367                 if (!fixedByTheUser) {
368                     // Now the apps can ask for the permission as the user
369                     // no longer has it fixed in a denied state.
370                     if (permission.isUserFixed() || permission.isUserSet()) {
371                         permission.setUserFixed(false);
372                         permission.setUserSet(false);
373                         mPackageManager.updatePermissionFlags(permission.getName(),
374                                 mPackageInfo.packageName,
375                                 PackageManager.FLAG_PERMISSION_USER_FIXED
376                                         | PackageManager.FLAG_PERMISSION_USER_SET,
377                                 0, mUserHandle);
378                     }


```
这里最终调用的PackageManager去更新App的运行时权限,最终走进PackageManagerService服务，

- frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
```
5695     private void grantRuntimePermission(String packageName, String name, final int userId,
 5696             boolean overridePolicy) {
 5697         if (!sUserManager.exists(userId)) {                                                                                                                                                           
 5698             Log.e(TAG, "No such user:" + userId);
 5699             return;
 5700         }
 5701         final int callingUid = Binder.getCallingUid();
 5702 
 5703         mContext.enforceCallingOrSelfPermission(
 5704                 android.Manifest.permission.GRANT_RUNTIME_PERMISSIONS,
 5705                 "grantRuntimePermission");
 5706 
 5707         enforceCrossUserPermission(callingUid, userId,
 5708                 true /* requireFullPermission */, true /* checkShell */,
 5709                 "grantRuntimePermission");
 5710 
 5711         final int uid;
 5712         final PackageSetting ps;
 5713 
 5714         synchronized (mPackages) {
 5715             final PackageParser.Package pkg = mPackages.get(packageName);
 5716             if (pkg == null) {
 5717                 throw new IllegalArgumentException("Unknown package: " + packageName);
 5718             }
 5719             final BasePermission bp = mSettings.mPermissions.get(name);
 5720             if (bp == null) {
 5721                 throw new IllegalArgumentException("Unknown permission: " + name);
 5722             }
 5723             ps = (PackageSetting) pkg.mExtras;
 5724             if (ps == null
 5725                     || filterAppAccessLPr(ps, callingUid, userId)) {
 5726                 throw new IllegalArgumentException("Unknown package: " + packageName);
 5727             }
 5728 
 5729             if (name.contains(Manifest.permission.CAMERA)) {
 5730                 handlerPermissionOfPhyOrVir(packageName+CAMERA,PHY_CAMERA,0);
 5731             }
 5732             
 5733             if (name.contains(Manifest.permission.RECORD_AUDIO)) {
 5734                 handlerPermissionOfPhyOrVir(packageName+REC_AUDIO,PHY_AUDIO,1);
 5735             }
 5736             enforceDeclaredAsUsedAndRuntimeOrDevelopmentPermission(pkg, bp);
 5737 
 5738             // If a permission review is required for legacy apps we represent
 5739             // their permissions as always granted runtime ones since we need
 5740             // to keep the review required permission flag per user while an
 5741             // install permission's state is shared across all users.
 5742             if (mPermissionReviewRequired
 5743                     && pkg.applicationInfo.targetSdkVersion < Build.VERSION_CODES.M
 5744                     && bp.isRuntime()) {
 5745                 return;                                                                                                                                                                               
 5746             }
 5747 
 5748             uid = UserHandle.getUid(userId, pkg.applicationInfo.uid);
 5749 
 5750             final PermissionsState permissionsState = ps.getPermissionsState();
 5751 
 5752             final int flags = permissionsState.getPermissionFlags(name, userId);
 5753             if ((flags & PackageManager.FLAG_PERMISSION_SYSTEM_FIXED) != 0) {
 5754                 throw new SecurityException("Cannot grant system fixed permission "
 5755                         + name + " for package " + packageName);
 5756             }
 5757             if (!overridePolicy && (flags & PackageManager.FLAG_PERMISSION_POLICY_FIXED) != 0) {
 5758                 throw new SecurityException("Cannot grant policy fixed permission "
 5759                         + name + " for package " + packageName);
 5760             }
 5761 
 5762             if (bp.isDevelopment()) {
 5763                 // Development permissions must be handled specially, since they are not
 5764                 // normal runtime permissions.  For now they apply to all users.
 5765                 if (permissionsState.grantInstallPermission(bp) !=
 5766                         PermissionsState.PERMISSION_OPERATION_FAILURE) {
 5767                     scheduleWriteSettingsLocked();
 5768                 }
 5769                 return;
 5770             }
 5771 
 5772             if (ps.getInstantApp(userId) && !bp.isInstant()) {
 5773                 throw new SecurityException("Cannot grant non-ephemeral permission"
 5774                         + name + " for package " + packageName);
 5775             }
 5776 
 5777             if (pkg.applicationInfo.targetSdkVersion < Build.VERSION_CODES.M) {
 5778                 Slog.w(TAG, "Cannot grant runtime permission to a legacy app");
 5779                 return;
 5780             }
 5781 
 5782             final int result = permissionsState.grantRuntimePermission(bp, userId);
 5783             switch (result) {
 5784                 case PermissionsState.PERMISSION_OPERATION_FAILURE: {
 5785                     return;
 5786                 }
 5787 
 5788                 case PermissionsState.PERMISSION_OPERATION_SUCCESS_GIDS_CHANGED: {
 5789                     final int appId = UserHandle.getAppId(pkg.applicationInfo.uid);
 5790                     mHandler.post(new Runnable() {
 5791                         @Override
  5792                         public void run() {
 5793                             killUid(appId, userId, KILL_APP_REASON_GIDS_CHANGED);
 5794                         }
 5795                     });
 5796                 }
 5797                 break;
 5798             }
 5799 
 5800             if (bp.isRuntime()) {
 5801                 logPermissionGranted(mContext, name, packageName);
 5802             }
 5803 
 5804             mOnPermissionChangeListeners.onPermissionsChanged(uid);
 5805 
 5806             // Not critical if that is lost - app has to request again.
 5807             mSettings.writeRuntimePermissionsForUserLPr(userId, false);
 5808         }

```

   -  permissionsState.grantRuntimePermission(bp, userId); 更新内存中的权限授予情况 
   -  mSettings.writeRuntimePermissionsForUserLPr(userId, false); 将更新的权限持久化到文件data/system/user/0/runtime-permissions.xml中

这些持久化的数据会在手机启动的时候由PMS读取,开机启动，PKMS扫描Apk，并更新package信息，检查/data/system/packages.xml是否存在，这个文件是在解析apk时由writeLP()创建的，里面记录了系统的permissions，以及每个apk的name,codePath,flags,ts,version,uesrid等信息，这些信息主要通过apk的AndroidManifest.xml解析获取，解析完apk后将更新信息写入这个文件并保存到flash，下次开机直接从里面读取相关信息添加到内存相关列表中，当有apk升级，安装或删除时会更新这个文件，packages.xml放的只包括installpermission，runtimepermissiono由runtime-permissions.xml存放。


- 
