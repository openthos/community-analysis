# 分析应用程序启动时申请权限弹窗

-  ./src/com/android/packageinstaller/permission/ui/handheld/GrantPermissionsViewHandlerImpl.java
弹窗里面主要有checkbox “Don't ask again”  两个button  “DENY”，“ALLOW”
```
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
367     }

```

-  src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java

```
60 public class GrantPermissionsActivity extends OverlayTouchActivity                                                                                                                                      
 61         implements GrantPermissionsViewHandler.ResultListener {
```
类GrantPermissionsActivity实现了GrantPermissionsViewHandler.ResultListener，所以当弹窗被点击时，调用的是GrantPermissionsActivity的onPermissionGrantResult方法

- src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
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

```
  -   当用户点击“ALLOW”时，执行的是mResultListener.onPermissionGrantResult(mGroupName, true, false);  
因为granted = true，所以执行的是
```
335                 groupState.mGroup.grantRuntimePermissions(doNotAskAgain,
336                         groupState.affectedPermissions);
337                 groupState.mState = GroupState.STATE_ALLOWED;
```
   -   当用户点击“DENY”时，执行的是 mResultListener.onPermissionGrantResult(mGroupName, false,mShowDonNotAsk && mDoNotAskCheckbox.isChecked());
因为granted = true，所以执行的是
```
340                 groupState.mGroup.revokeRuntimePermissions(doNotAskAgain,
341                         groupState.affectedPermissions);
342                 groupState.mState = GroupState.STATE_DENIED;
```



08-23 04:03:26.262  3670  3670 I mdx----- revokeRuntimePermissions: mAppSupportsRuntimePermissions true false
08-23 04:03:26.265  3670  3670 I mdx------revokeRuntimePermissions: android.permission-group.CAMERA
08-23 04:03:26.266  3670  3670 I mdx------ updateGrantResults: permission android.permission.CAMERA 0 true


08-23 04:05:06.092  3670  3670 I mdx------grantRuntimePermissions: android.permission-group.MICROPHONE
08-23 04:05:06.092  3670  3670 I mdx------ updateGrantResults: permission android.permission.RECORD_AUDIO 0 true
