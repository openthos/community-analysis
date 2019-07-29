# 权限弹窗分析
- AppOpsManager实现的动态管理的本质是：将鉴权放在每个服务内部，比如，如果App要申请定位权限，
定位服务LocationManagerService会向AppOpsService查询是否授予了App定位权限，如果需要授权，
就弹出一个系统对话框让用户操作，并根据用户的操作将结果持久化在文件中，如果在Setting里设置了响应的权限，
也会去更新相应的权限操作持久化文件data/system/user/0/runtime-permissions.xml，下次再次申请服务的时候，服务会再次鉴定权限。

## 分析源码
- 详细的源码可以看：packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
主要偏向于UI 逻辑的控制，在这里主要总计几个重要部分：
  -  mRequestedPermissions <br>
这个是通过intent 的extra 传过来的，extra 的name 是PackageManager.EXTRA_REQUEST_PERMISSIONS_NAMES
```
100         mRequestedPermissions = getIntent().getStringArrayExtra(                                                                                                                                        
101                 PackageManager.EXTRA_REQUEST_PERMISSIONS_NAMES);

```
  -  GrantPermissionsViewHandlerImpl <br>
  这个是用来更新activity UI的重要类
  ```
   95             mViewHandler = new com.android.packageinstaller.permission.ui.handheld
   96                     .GrantPermissionsViewHandlerImpl(this, getCallingPackage())
   97                     .setResultListener(this);

  ```
  -  setContentView(mViewHandler.createView()); <br>
  acitivity 将GrantPermissionsViewHandlerImpl 中的createView 出来的View 显示出来。
  -  mAppPermissions
  ```
  138         mAppPermissions = new AppPermissions(this, callingPackageInfo, null, false,                                                                                                                     
  139                 new Runnable() {
  140                     @Override
  141                     public void run() {
  142                         setResultAndFinish();
  143                     }
  144                 });

  ```
  这个AppPermissions 其实就是单个应用所拥有的所有的group permission 的统计，详细看 <br>
private final ArrayList<AppPermissionGroup> mGroups = new ArrayList<>();
 
 -  showNextPermissionGroupGrantRequest <br>
 
 读取request 的group 相关信息，通过mViewHandler.updateUi 来更新UI。
 ```
292                 mViewHandler.updateUi(groupState.mGroup.getName(), groupCount, currentIndex,                                                                                                            
293                         Icon.createWithResource(resources, icon), message,
294                         groupState.mGroup.isUserSet());
295                 return true;

 ```
- onClick
```
src/com/android/packageinstaller/permission/ui/handheld/GrantPermissionsViewHandlerImpl.java

338     @Override
339     public void onClick(View view) {
340         switch (view.getId()) {
341             case R.id.permission_allow_button:
342                 if (mResultListener != null) {
343                     view.performAccessibilityAction(
344                             AccessibilityNodeInfo.ACTION_CLEAR_ACCESSIBILITY_FOCUS, null);
345                     mResultListener.onPermissionGrantResult(mGroupName, true, false);
346                 }
347                 break;
348             case R.id.permission_deny_button:
349                 mAllowButton.setEnabled(true);
350                 if (mResultListener != null) {
351                     view.performAccessibilityAction(                                                                                                                                                    
352                             AccessibilityNodeInfo.ACTION_CLEAR_ACCESSIBILITY_FOCUS, null);
353                     mResultListener.onPermissionGrantResult(mGroupName, false,
354                             mShowDonNotAsk && mDoNotAskCheckbox.isChecked());
355                 }
356                 break;
357             case R.id.permission_more_info_button:
358                 Intent intent = new Intent(Intent.ACTION_MANAGE_APP_PERMISSIONS);
359                 intent.putExtra(Intent.EXTRA_PACKAGE_NAME, mAppPackageName);
360                 intent.putExtra(ManagePermissionsActivity.EXTRA_ALL_PERMISSIONS, true);
361                 mActivity.startActivity(intent);
362                 break;
363             case R.id.do_not_ask_checkbox:
364                 mAllowButton.setEnabled(!mDoNotAskCheckbox.isChecked());
365                 break;
366         }

```
提示框的click 事件是在GrantPermissionsViewHandlerImpl 这里处理的，最后会通过callback 调回到GrantPermissionsActivity 中。

- onPermissionGrantResult
```
304     @Override                                                                                                                                                                                           
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
这里的callback 是从GrantPermissionsViewHandlerImpl 回来，确定执行grant 还是revoke。
