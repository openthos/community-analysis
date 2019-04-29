- 1、av/services/audioflinger/Threads.cpp
  - 录入音频输入源为空
```
6063         state->mInputSource = NULL;

```

- 2、packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
303     @Override
304     public void onPermissionGrantResult(String name, boolean granted, boolean doNotAskAgain) {
305         GroupState groupState = mRequestGrantPermissionGroups.get(name);
306         if (groupState.mGroup != null) {
307             if (granted) {
308                 groupState.mGroup.grantRuntimePermissions(doNotAskAgain,
309                         groupState.affectedPermissions);
310                 groupState.mState = GroupState.STATE_ALLOWED;
311             } else {
312                 groupState.mGroup.revokeRuntimePermissions(doNotAskAgain,
313                         groupState.affectedPermissions);
314                 groupState.mState = GroupState.STATE_DENIED;
315          
316 
317                 int numRequestedPermissions = mRequestedPermissions.length;
318                 for (int i = 0; i < numRequestedPermissions; i++) {
319                     String permission = mRequestedPermissions[i];
320 
321                     if (groupState.mGroup.hasPermission(permission)) {
322                         EventLogger.logPermissionDenied(this, permission,
323                                 mAppPermissions.getPackageInfo().packageName);
324                     }
325                 }
326             }
327             updateGrantResults(groupState.mGroup);
328         }
329         if (!showNextPermissionGroupGrantRequest()) {
330             setResultAndFinish();
331         }
332     }


```

- 3、packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/handheld/GrantPermissionsViewHandlerImpl.java
```
338     @Override
339     public void onClick(View view) {
340         switch (view.getId()) {
341             case R.id.permission_allow_button:
342                 if (mResultListener != null) {
343                     view.performAccessibilityAction(
344                             AccessibilityNodeInfo.ACTION_CLEAR_ACCESSIBILITY_FOCUS, null);
345                     mResultListener.onPermissionGrantResult(mGroupName, true, false);
346                     //Log.v("mdx","mResultListener.onPermissionGrantResult");
347                 }
348                 break;
349             case R.id.permission_deny_button:
350                 mAllowButton.setEnabled(true);
351                 if (mResultListener != null) {
352                     view.performAccessibilityAction(
353                             AccessibilityNodeInfo.ACTION_CLEAR_ACCESSIBILITY_FOCUS, null);
354                     mResultListener.onPermissionGrantResult(mGroupName, false,
355                             mShowDonNotAsk && mDoNotAskCheckbox.isChecked());
356                 }
357                 break;
358             case R.id.permission_more_info_button:
359                 Intent intent = new Intent(Intent.ACTION_MANAGE_APP_PERMISSIONS);
360                 intent.putExtra(Intent.EXTRA_PACKAGE_NAME, mAppPackageName);
361                 intent.putExtra(ManagePermissionsActivity.EXTRA_ALL_PERMISSIONS, true);
362                 mActivity.startActivity(intent);
363                 break;
364             case R.id.do_not_ask_checkbox:
365                 mAllowButton.setEnabled(!mDoNotAskCheckbox.isChecked());
366                 break;
367         }
368     }

```


