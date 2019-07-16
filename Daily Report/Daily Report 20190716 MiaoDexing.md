#  Android权限管理原理（6.0及以上）
## 前言
- Android系统在MarshMallow之前，权限都是在安装的时候授予的。在6.0之后，Google为了简化安装流程且方便用户控制权限，正式引入了runtime-permission，允许用户在运行的时候动态控制权限。
## AppOpsManager动态权限管理
- AppOpsManager实现的动态管理的本质是：将鉴权放在每个服务内部，比如，如果App要申请定位权限，定位服务LocationManagerService会向AppOpsService查询是否授予了App定位权限，如果需要授权，就弹出一个系统对话框让用户操作，并根据用户的操作将结果持久化在文件中，如果在Setting里设置了响应的权限，也会去更新相应的权限操作持久化文件data/system/user/0/runtime-permissions.xml，下次再次申请服务的时候，服务会再次鉴定权限。
## 举个例子-定位服务LocationManagerService
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/location.png)
## 具体分析PackageManagerService
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
                  ...............................................................
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
              .....................................................
 5407 
 5408         return PackageManager.PERMISSION_DENIED;                                                                                                                                                      
 5409     }


```

其中关键在于mSettings里面保存的SettingBase对象，它记录了PermissionsState也就是权限的授予情况。此处要提前明确一件事，Settings.getPackageLPw方法，是在安装应用扫描的时候scanPackageDirtyLI方法调用的，里面可以看到Settings类中的mUserIds、mPackages里面存的value还有PackageManagerService中的mPackages.pkg. mExtras都是同一个PackageSetting，差异仅在于可以动态修改：也就是修改PermissionState的mGranted值。

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
从上面的代码可以很清晰看出，除了声明了权限之外，还必须是授权了的。
### 权限授予分析
授权有两个地方，一个是设置里面的入口，还有一个是申请权限弹框界面的入口，代码都在PackageInstaller里面，分别是ManagePermissionsActivity和GrantPermissionsActivity。重点分析GrantPermissionsActivity，在这个Activity里面，如果一开始没有获得权限，就会弹出权限申请对话框，根据用户的操作去更新PKMS中的权限信息，同时将更新的结构持久化到runtime-permissions.xml中去。

- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
305     public void onPermissionGrantResult(String name, boolean granted, boolean doNotAskAgain) {
306         KeyguardManager kgm = getSystemService(KeyguardManager.class);
307                                                                                                                                                                                                         
            .......................................................
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
               ...........................................
358     }


```
GrantPermissionsActivity其实是利用GroupState对象与PMS通信，远程更新权限的，当然，如果权限都已经授予了，那么就不需要再次弹出权限申请对话框。

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
 5716             .................................................
 5728 
 5729             if (name.contains(Manifest.permission.CAMERA)) {
 5730                 handlerPermissionOfPhyOrVir(packageName+CAMERA,PHY_CAMERA,0);
 5731             }
 5732             
 5733             if (name.contains(Manifest.permission.RECORD_AUDIO)) {
 5734                 handlerPermissionOfPhyOrVir(packageName+REC_AUDIO,PHY_AUDIO,1);
 5735             }
                  .......................................................
 5747 
 5748             uid = UserHandle.getUid(userId, pkg.applicationInfo.uid);
 5749 
 5750             final PermissionsState permissionsState = ps.getPermissionsState();
 5751 
                  .............................................................
 5781 
 5782             final int result = permissionsState.grantRuntimePermission(bp, userId);
                  ......................................................
 5805 
 5806             // Not critical if that is lost - app has to request again.
 5807             mSettings.writeRuntimePermissionsForUserLPr(userId, false);
 5808         }

```

   -  permissionsState.grantRuntimePermission(bp, userId); 更新内存中的权限授予情况
       -   services/core/java/com/android/server/pm/PermissionsState.java 
   ```
   210     public int grantRuntimePermission(BasePermission permission, int userId) {                                                                                                                          
   211         enforceValidUserId(userId);
   212         if (userId == UserHandle.USER_ALL) {
   213             return PERMISSION_OPERATION_FAILURE;
   214         }
   215         return grantPermission(permission, userId);
   216     }

   ```
      -   services/core/java/com/android/server/pm/PermissionsState.java
      ```
      559     private int grantPermission(BasePermission permission, int userId) {

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
      582 
      
      684         public boolean grant(int userId) {                                                                                                                                                              
      685             if (!isCompatibleUserId(userId)) {
      686                 return false;
      687             }
      688 
      689             if (isGranted(userId)) {
      690                 return false;
      691             }
      692                 
      693             PermissionState userState = mUserStates.get(userId);
      694             if (userState == null) {
      695                 userState = new PermissionState(mPerm.name);
      696                 mUserStates.put(userId, userState);
      697             }
      698 
      699             userState.mGranted = true;
      700         
      701             return true;
      702         }   
      ```
   修改PermissionData 中PermissionState 的 mGranted属性值为true
   -  mSettings.writeRuntimePermissionsForUserLPr(userId, false); 将更新的权限持久化到文件data/system/user/0/runtime-permissions.xml中

这些持久化的数据会在手机启动的时候由PMS读取,开机启动，PKMS扫描Apk，并更新package信息，检查/data/system/packages.xml是否存在，这个文件是在解析apk时由writeLP()创建的，里面记录了系统的permissions，以及每个apk的name,codePath,flags,ts,version,uesrid等信息，这些信息主要通过apk的AndroidManifest.xml解析获取，解析完apk后将更新信息写入这个文件并保存到flash，下次开机直接从里面读取相关信息添加到内存相关列表中，当有apk升级，安装或删除时会更新这个文件，packages.xml放的只包括installpermission，只要granted="true"，就是永远是取得授权的；runtimepermissiono由runtime-permissions.xml存放。


这里开始分析ManagePermissionsActivity
- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/ManagePermissionsActivity.java
```
55             case Intent.ACTION_MANAGE_APP_PERMISSIONS: {
 56                 String packageName = getIntent().getStringExtra(Intent.EXTRA_PACKAGE_NAME);
 57                 if (packageName == null) {
 58                     Log.i(LOG_TAG, "Missing mandatory argument EXTRA_PACKAGE_NAME");
 59                     finish();
 60                     return;
 61                 }
 62                 if (DeviceUtils.isWear(this)) {
 63                     fragment = AppPermissionsFragmentWear.newInstance(packageName);
 64                 } else if (DeviceUtils.isTelevision(this)) {
 65                     fragment = com.android.packageinstaller.permission.ui.television
 66                             .AppPermissionsFragment.newInstance(packageName);
 67                 } else {
 68                     final boolean allPermissions = getIntent().getBooleanExtra(
 69                             EXTRA_ALL_PERMISSIONS, false);
 70                     if (allPermissions) {
 71                         fragment = com.android.packageinstaller.permission.ui.handheld
 72                                 .AllAppPermissionsFragment.newInstance(packageName);
 73                     } else {
 74                         fragment = com.android.packageinstaller.permission.ui.handheld
 75                                 .AppPermissionsFragment.newInstance(packageName);
 76                     }
 77                 }
 78             } break;
 79 
 80             case Intent.ACTION_MANAGE_PERMISSION_APPS: {
 81                 String permissionName = getIntent().getStringExtra(Intent.EXTRA_PERMISSION_NAME);
 82                 if (permissionName == null) {
 83                     Log.i(LOG_TAG, "Missing mandatory argument EXTRA_PERMISSION_NAME");
 84                     finish();
 85                     return;
 86                 }
 87                 if (DeviceUtils.isTelevision(this)) {
 88                     fragment = com.android.packageinstaller.permission.ui.television
 89                             .PermissionAppsFragment.newInstance(permissionName);
 90                 } else {
 91                     fragment = com.android.packageinstaller.permission.ui.handheld
 92                             .PermissionAppsFragment.newInstance(permissionName);
 93                 }
 94             } break;

```
Setting中可以针对某个应用的权限或者全部应用的权限进行管理，这里分析单个应用，也就是AppPermissionsFragment

- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java

```
293     public boolean onPreferenceChange(final Preference preference, Object newValue) {
294         String groupName = preference.getKey();
295         final AppPermissionGroup group = mAppPermissions.getPermissionGroup(groupName);
296 
297         if (group == null) {
298             return false;
299         }
300                                                                                                                                                                                                         
301         addToggledGroup(group);
302 
303         if (LocationUtils.isLocationGroupAndProvider(group.getName(), group.getApp().packageName)) {
304             LocationUtils.showLocationDialog(getContext(), mAppPermissions.getAppLabel());
305             return false;
306         }
307         ContentResolver resolver = getContext().getContentResolver();
308         String packageName = group.getApp().packageName;
309         if (newValue == Boolean.TRUE) {
310             group.grantRuntimePermissions(false);
311             Settings.Global.putString(resolver,packageName+".permission.camera","phy_camera");
312         } else {
313             final boolean grantedByDefault = group.hasGrantedByDefaultPermission();
314             if (grantedByDefault || (!group.doesSupportRuntimePermissions()
315                     && !mHasConfirmedRevoke)) {
316                 new AlertDialog.Builder(getContext())
317                         .setMessage(grantedByDefault ? R.string.system_warning
318                                 : R.string.old_sdk_deny_warning)
319                         .setNegativeButton(R.string.cancel, (DialogInterface dialog, int which) -> {
320                             if (preference instanceof MultiTargetSwitchPreference) {
321                                 ((MultiTargetSwitchPreference) preference).setCheckedOverride(true);
322                             }
323                         })
324                         .setPositiveButton(R.string.grant_dialog_button_deny_anyway,
325                                 (DialogInterface dialog, int which) -> {
326                             ((SwitchPreference) preference).setChecked(false);
327 
328                             Settings.Global.putString(resolver,packageName+".permission.camera","vir_camera");
329                             /*group.revokeRuntimePermissions(false);
330                             if (Utils.areGroupPermissionsIndividuallyControlled(getContext(),
331                                     group.getName())) {
332                                 updateSummaryForIndividuallyControlledPermissionGroup(
333                                         group, preference);
334                             }
335                             if (!grantedByDefault) {
336                                 mHasConfirmedRevoke = true;                                                                                                                                             
337                             }*/
338                         })
339                         .show();
340                 return false;
341             } else {
342                 group.revokeRuntimePermissions(false);
343             }
344         }
345 
346         return true;
347     }

```
此处授予权限依然是调用的PackageManagerService的方法grantRuntimePermission来完成

### 权限未授予分析
- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
305     public void onPermissionGrantResult(String name, boolean granted, boolean doNotAskAgain) {
306         KeyguardManager kgm = getSystemService(KeyguardManager.class);
307                                                                                                                                     ..............................................................
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
- packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/model/AppPermissionGroup.java


```
433     public boolean revokeRuntimePermissions(boolean fixedByTheUser) {
434         return revokeRuntimePermissions(fixedByTheUser, null);                                                                                                                                          
435     }
436         
437     public boolean revokeRuntimePermissions(boolean fixedByTheUser, String[] filterPermissions) {
438         final int uid = mPackageInfo.applicationInfo.uid;
439 
440         // We toggle permissions only to apps that support runtime
441         // permissions, otherwise we toggle the app op corresponding
442         // to the permission if the permission is granted to the app.
443         for (Permission permission : mPermissions.values()) {
444             if (filterPermissions != null
445                     && !ArrayUtils.contains(filterPermissions, permission.getName())) {
446                 continue;
447             }
448 
449             if (mAppSupportsRuntimePermissions) {
450                 // Do not touch permissions fixed by the system.
451                 if (permission.isSystemFixed()) {
452                     return false;
453                 }
454 
455                 // Revoke the permission if needed.
456                 if (permission.isGranted()) {
457                     permission.setGranted(false);
458                     mPackageManager.revokeRuntimePermission(mPackageInfo.packageName,
459                             permission.getName(), mUserHandle);
460                 }


````
此处mPackageManager.revokeRuntimePermission最终还是调用的是PackageManagerService的revokeRuntimePermission方法

- frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
```
5833     private void revokeRuntimePermission(String packageName, String name, int userId,
 5834             boolean overridePolicy) {
 5835         if (!sUserManager.exists(userId)) {
 5836             Log.e(TAG, "No such user:" + userId);
 5837             return;
 5838         }
 5839 
 5840         mContext.enforceCallingOrSelfPermission(
 5841                 android.Manifest.permission.REVOKE_RUNTIME_PERMISSIONS,
 5842                 "revokeRuntimePermission");
 5843 
 5844         enforceCrossUserPermission(Binder.getCallingUid(), userId,
 5845                 true /* requireFullPermission */, true /* checkShell */,
 5846                 "revokeRuntimePermission");
 5847                                                                                                                                                                                                       
 5848         final int appId;
 5849 
 5850         synchronized (mPackages) {
 5851             final PackageParser.Package pkg = mPackages.get(packageName);
 5852             if (pkg == null) {
 5853                 throw new IllegalArgumentException("Unknown package: " + packageName);
 5854             }
 5855             final PackageSetting ps = (PackageSetting) pkg.mExtras;
 5856             if (ps == null
 5857                     || filterAppAccessLPr(ps, Binder.getCallingUid(), userId)) {
 5858                 throw new IllegalArgumentException("Unknown package: " + packageName);
 5859             }
 5860             final BasePermission bp = mSettings.mPermissions.get(name);
 5861             if (bp == null) {
 5862                 throw new IllegalArgumentException("Unknown permission: " + name);
 5863             }
 5864 
 5865             if (name.contains(Manifest.permission.CAMERA)) {
 5866                 handlerPermissionOfPhyOrVir(packageName+CAMERA,VIR_CAMERA,0);
 5867                 return;
 5868             }
 5869             if (name.contains(Manifest.permission.RECORD_AUDIO)) {
 5870                 handlerPermissionOfPhyOrVir(packageName+REC_AUDIO,VIR_AUDIO,1);
 5871                 return;
 5872             }

 5920             mSettings.writeRuntimePermissionsForUserLPr(userId, true);
```

- runtime-permissions.xml 示例

```
<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<runtime-permissions fingerprint="OPENTHOS/openthos_x86_64/openthos:8.1.0/OPM8.190605.003/root07040705:userdebug/test-keys">
  <pkg name="org.android_x86.analytics">^M
    <item name="android.permission.GET_ACCOUNTS" granted="true" flags="30" />
  </pkg>
  <pkg name="com.android.companiondevicemanager">^M
    <item name="android.permission.ACCESS_COARSE_LOCATION" granted="true" flags="30" />
  </pkg>
  <pkg name="com.campmobile.snowcamera">
    <item name="android.permission.READ_EXTERNAL_STORAGE" granted="false" flags="1" />
    <item name="android.permission.READ_PHONE_STATE" granted="true" flags="0" />
    <item name="android.permission.CAMERA" granted="true" flags="1" />
    <item name="android.permission.WRITE_EXTERNAL_STORAGE" granted="false" flags="1" />
    <item name="android.permission.RECORD_AUDIO" granted="true" flags="0" />
  </pkg>


```
