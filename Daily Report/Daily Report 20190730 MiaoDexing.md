- src/com/android/packageinstaller/permission/ui/handheld/GrantPermissionsViewHandlerImpl.java
```
346     @Override 
347     public void onClick(View view) {
348         switch (view.getId()) {
349             case R.id.permission_allow_button:
350                 if (mResultListener != null) {
351                     view.performAccessibilityAction(
352                             AccessibilityNodeInfo.ACTION_CLEAR_ACCESSIBILITY_FOCUS, null);
353                     mResultListener.onPermissionGrantResult(mGroupName, true, false);
354                 }
355                 break;
356             case R.id.permission_deny_button:
357                 mAllowButton.setEnabled(true);
358                 if (mResultListener != null) {
359                     view.performAccessibilityAction(
360                             AccessibilityNodeInfo.ACTION_CLEAR_ACCESSIBILITY_FOCUS, null);
361                     mResultListener.onPermissionGrantResult(mGroupName, false,                                                                                                                          
362                             mShowDonNotAsk && mDoNotAskCheckbox.isChecked());
363                     Log.i("mdx","mShowDonNotAsk " + mShowDonNotAsk + " mDoNotAskCheckbox.isChecked() " + mDoNotAskCheckbox.isChecked());
364          
365                 }
366                 break;
367             case R.id.permission_more_info_button:                                                   
368                 Intent intent = new Intent(Intent.ACTION_MANAGE_APP_PERMISSIONS);                    
369                 intent.putExtra(Intent.EXTRA_PACKAGE_NAME, mAppPackageName);                         
370                 intent.putExtra(ManagePermissionsActivity.EXTRA_ALL_PERMISSIONS, true);              
371                 mActivity.startActivity(intent);
372                 break;
373             case R.id.do_not_ask_checkbox: 
374                 mAllowButton.setEnabled(!mDoNotAskCheckbox.isChecked());                             
375                 break;
376         }               
377     }           
378             

```

- src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
305     @Override
306     public void onPermissionGrantResult(String name, boolean granted, boolean doNotAskAgain) {
307         KeyguardManager kgm = getSystemService(KeyguardManager.class);
308 
309         if (kgm.isDeviceLocked()) {
310             kgm.requestDismissKeyguard(this, new KeyguardManager.KeyguardDismissCallback() {
311                         @Override                                                                                                                                                                       
312                         public void onDismissError() {
313                             Log.e(LOG_TAG, "Cannot dismiss keyguard perm=" + name + " granted="
314                                    + granted + " doNotAskAgain=" + doNotAskAgain);
315                         }
316 
317                         @Override
318                         public void onDismissCancelled() {
319                             // do nothing (i.e. stay at the current permission group)
320                         }
321 
322                         @Override
323                         public void onDismissSucceeded() {
324                             // Now the keyguard is dismissed, hence the device is not locked
325                             // anymore
326                             onPermissionGrantResult(name, granted, doNotAskAgain);
327                         }
328                     });
329 
330             return;
331         }
332 
333         GroupState groupState = mRequestGrantPermissionGroups.get(name);
334         if (groupState.mGroup != null) {
335             if (granted) {
336                 groupState.mGroup.grantRuntimePermissions(doNotAskAgain,
337                         groupState.affectedPermissions);
338                 groupState.mState = GroupState.STATE_ALLOWED;
339                 Log.i("mdx",groupState.mGroup.getName() + " granted " + granted +  " groupState.mState " + groupState.mState);
340             } else {
341                 groupState.mGroup.revokeRuntimePermissions(doNotAskAgain,
342                         groupState.affectedPermissions);
343                 //groupState.mState = GroupState.STATE_DENIED;
344                 groupState.mState = GroupState.STATE_ALLOWED;
345                 Log.i("mdx",groupState.mGroup.getName() + " granted " + granted + " groupState.mState " + groupState.mState);
346 
347                 int numRequestedPermissions = mRequestedPermissions.length;
348                 for (int i = 0; i < numRequestedPermissions; i++) {
349                     String permission = mRequestedPermissions[i];
350 
351                     if (groupState.mGroup.hasPermission(permission)) {
352                         EventLogger.logPermissionDenied(this, permission,
353                                 mAppPermissions.getPackageInfo().packageName);
354                     }
355                 }
356             }
357             updateGrantResults(groupState.mGroup);
358         }
359         if (!showNextPermissionGroupGrantRequest()) {
360             setResultAndFinish();
361         }
362     }


```

- src/com/android/packageinstaller/permission/model/AppPermissionGroup.java
```
440     public boolean revokeRuntimePermissions(boolean fixedByTheUser, String[] filterPermissions) {
441         final int uid = mPackageInfo.applicationInfo.uid;
442 
443         // We toggle permissions only to apps that support runtime
444         // permissions, otherwise we toggle the app op corresponding
445         // to the permission if the permission is granted to the app.
446         for (Permission permission : mPermissions.values()) {                                                                                                                                           
447             if (filterPermissions != null
448                     && !ArrayUtils.contains(filterPermissions, permission.getName())) {
449                 continue;
450             }
451 
452             Log.i("mdx--permission","revokeRuntimePermissions " + permission.getName());
453             if (mAppSupportsRuntimePermissions) {
454                 // Do not touch permissions fixed by the system.
455                 if (permission.isSystemFixed()) {
456                     return false;
457                 }
458 
459                 // Revoke the permission if needed.
460                 if (!permission.isGranted()) {
461                     permission.setGranted(false);
462                     mPackageManager.revokeRuntimePermission(mPackageInfo.packageName,
463                             permission.getName(), mUserHandle);
464                     
465                     Log.i("mdx--permission","revokeRuntimePermissions " + mPackageInfo.packageName + " " + permission.getName());
466                 }
467             
468                 // Update the permission flags.
469                 if (fixedByTheUser) {
470                     // Take a note that the user fixed the permission.
471                     if (permission.isUserSet() || !permission.isUserFixed()) {
472                         permission.setUserSet(false);
473                         permission.setUserFixed(true);
474                         mPackageManager.updatePermissionFlags(permission.getName(),
475                                 mPackageInfo.packageName,
476                                 PackageManager.FLAG_PERMISSION_USER_SET
477                                         | PackageManager.FLAG_PERMISSION_USER_FIXED,
478                                 PackageManager.FLAG_PERMISSION_USER_FIXED,
479                                 mUserHandle);
480                     }   
481                 } else {
482                     if (!permission.isUserSet() || permission.isUserFixed()) {
483                         permission.setUserSet(true);
484                         permission.setUserFixed(false);
485                         // Take a note that the user already chose once.
486                         mPackageManager.updatePermissionFlags(permission.getName(),
487                                 mPackageInfo.packageName,
488                                 PackageManager.FLAG_PERMISSION_USER_SET
489                                         | PackageManager.FLAG_PERMISSION_USER_FIXED,
490                                 PackageManager.FLAG_PERMISSION_USER_SET,
491                                 mUserHandle);
492                     }
493                 }
494             } else {
495                 // Legacy apps cannot have a non-granted permission but just in case.
496                 if (!permission.isGranted()) {
497                     continue;
498                 }
499 
500                 int mask = 0;
501                 int flags = 0;
502                 int killUid = -1;
503 
504                 // If the permission has no corresponding app op, then it is a
505                 // third-party one and we do not offer toggling of such permissions.
506                 if (permission.hasAppOp()) {
507                     if (permission.isAppOpAllowed()) {
508                         permission.setAppOpAllowed(false);
509                         // Disable the app op.
510                         mAppOps.setUidMode(permission.getAppOp(), uid, AppOpsManager.MODE_IGNORED);
511 
512                         // Disabling an app op may put the app in a situation in which it                                                                                                               
513                         // has a handle to state it shouldn't have, so we have to kill the
514                         // app. This matches the revoke runtime permission behavior.
515                         killUid = uid;
516                     }
517 
518                     // Mark that the permission should not be granted on upgrade
519                     // when the app begins supporting runtime permissions.
520                     if (!permission.shouldRevokeOnUpgrade()) {
521                         permission.setRevokeOnUpgrade(true);
522                         mask |= PackageManager.FLAG_PERMISSION_REVOKE_ON_UPGRADE;
523                         flags |= PackageManager.FLAG_PERMISSION_REVOKE_ON_UPGRADE;
524                     }
525                 }
526 
527                 if (mask != 0) {
528                     mPackageManager.updatePermissionFlags(permission.getName(),
529                             mPackageInfo.packageName, mask, flags, mUserHandle);
530                 }
531 
532                 if (killUid != -1) {
533                     mActivityManager.killUid(uid, KILL_REASON_APP_OP_CHANGE);
534                 }
535             }
536         }
537 
538         return true;
539     }

```

- services/core/java/com/android/server/pm/PackageManagerService.java
```
5860     private void revokeRuntimePermission(String packageName, String name, int userId,                                                                                                                 
 5861             boolean overridePolicy) {
 5862         if (!sUserManager.exists(userId)) {
 5863             Log.e(TAG, "No such user:" + userId);
 5864             return;
 5865         }
 5866 
 5867         mContext.enforceCallingOrSelfPermission(
 5868                 android.Manifest.permission.REVOKE_RUNTIME_PERMISSIONS,
 5869                 "revokeRuntimePermission");
 5870 
 5871         enforceCrossUserPermission(Binder.getCallingUid(), userId,
 5872                 true /* requireFullPermission */, true /* checkShell */,
 5873                 "revokeRuntimePermission");
 5874 
 5875         final int appId;
 5876 
 5877         synchronized (mPackages) {
 5878             final PackageParser.Package pkg = mPackages.get(packageName);
 5879             if (pkg == null) {
 5880                 throw new IllegalArgumentException("Unknown package: " + packageName);
 5881             }
 5882             final PackageSetting ps = (PackageSetting) pkg.mExtras;
 5883             if (ps == null
 5884                     || filterAppAccessLPr(ps, Binder.getCallingUid(), userId)) {
 5885                 throw new IllegalArgumentException("Unknown package: " + packageName);
 5886             }
 5887             final BasePermission bp = mSettings.mPermissions.get(name);
 5888             if (bp == null) {
 5889                 throw new IllegalArgumentException("Unknown permission: " + name);
 5890             }
 5891 
 5892             if (name.contains(Manifest.permission.CAMERA)) {
 5893                 handlerPermissionOfPhyOrVir(packageName + CAMERA, VIR_CAMERA, 0);
 5894                 //return;
 5895             }
 5896             if (name.contains(Manifest.permission.RECORD_AUDIO)) {
 5897                 handlerPermissionOfPhyOrVir(packageName + REC_AUDIO, VIR_AUDIO, 1);
 5898                 //return;
 5899             }
 5900             if (name.contains(Manifest.permission.ACCESS_FINE_LOCATION)) {
 5901                 handlerPermissionOfPhyOrVir(packageName + LOCATION, VIR_LOCATION, 2);
 5902                 //return;
 5903             }
 5904             enforceDeclaredAsUsedAndRuntimeOrDevelopmentPermission(pkg, bp);
 5905 
 5906             // If a permission review is required for legacy apps we represent
 5907             // their permissions as always granted runtime ones since we need
 5908             // to keep the review required permission flag per user while an
 5909             // install permission's state is shared across all users.

 5910             if (mPermissionReviewRequired
 5911                     && pkg.applicationInfo.targetSdkVersion < Build.VERSION_CODES.M
 5912                     && bp.isRuntime()) {
 5913                 return;
 5914             }
 5915 
 5916             final PermissionsState permissionsState = ps.getPermissionsState();
 5917 
 5918             final int flags = permissionsState.getPermissionFlags(name, userId);
 5919             if ((flags & PackageManager.FLAG_PERMISSION_SYSTEM_FIXED) != 0) {
 5920                 throw new SecurityException("Cannot revoke system fixed permission "
 5921                         + name + " for package " + packageName);
 5922             }
 5923             if (!overridePolicy && (flags & PackageManager.FLAG_PERMISSION_POLICY_FIXED) != 0) {
 5924                 throw new SecurityException("Cannot revoke policy fixed permission "
 5925                         + name + " for package " + packageName);
 5926             }
 5927 
 5928             if (bp.isDevelopment()) {
 5929                 // Development permissions must be handled specially, since they are not
 5930                 // normal runtime permissions.  For now they apply to all users.
 5931                 if (permissionsState.revokeInstallPermission(bp) !=
 5932                         PermissionsState.PERMISSION_OPERATION_FAILURE) {
 5933                     scheduleWriteSettingsLocked();
 5934                 }
 5935                 return;
 5936             }
 5937 
 5938             if (permissionsState.revokeRuntimePermission(bp, userId) ==
 5939                     PermissionsState.PERMISSION_OPERATION_FAILURE) {
 5940                 return;
 5941             }
 5942 
 5943             if (bp.isRuntime()) {
 5944                 logPermissionRevoked(mContext, name, packageName);
 5945             }
 5946 
 5947             mOnPermissionChangeListeners.onPermissionsChanged(pkg.applicationInfo.uid);
 5948 
 5949             // Critical, after this call app should never have the permission.
 5950             mSettings.writeRuntimePermissionsForUserLPr(userId, true);
 5951 
 5952             appId = UserHandle.getAppId(pkg.applicationInfo.uid);
 5953         }
 5954 
 5955         killUid(appId, userId, KILL_APP_REASON_PERMISSIONS_REVOKED);
 5956     }                                                                                                                                                                                                 
 5957 

```
# 分割线

- src/com/android/packageinstaller/permission/ui/GrantPermissionsActivity.java
```
181                     default: {                                                                                                                                                                          
182                         if (!group.areRuntimePermissionsGranted()) {
183                             GroupState state = mRequestGrantPermissionGroups.get(group.getName());
184                             if (state == null) {
185                                 state = new GroupState(group);
186                                 mRequestGrantPermissionGroups.put(group.getName(), state);
187                                 Log.i("mdx--mRequestGrantPermissionGroups","group.getName() " + group.getName() + " state " + state);
188                             }
189                             String[] affectedPermissions = computeAffectedPermissions(
190                                     callingPackageInfo, requestedPermission);
191                             if (affectedPermissions != null) {
192                                 for (String affectedPermission : affectedPermissions) {
193                                     state.affectedPermissions = ArrayUtils.appendString(
194                                             state.affectedPermissions, affectedPermission);
195                                 }
196                             }
197                         } else {
198                             group.grantRuntimePermissions(false, computeAffectedPermissions(
199                                     callingPackageInfo, requestedPermission));
200                             updateGrantResults(group); 
201                         }
202                     } break;
```
首先判断group.areRuntimePermissionsGranted()
- src/com/android/packageinstaller/permission/model/AppPermissionGroup.java
```
                          
305     public boolean areRuntimePermissionsGranted(String[] filterPermissions) {                                                                                                                           
306         if (LocationUtils.isLocationGroupAndProvider(mName, mPackageInfo.packageName)) {
307             return LocationUtils.isLocationEnabled(mContext);
308         }                   
309         final int permissionCount = mPermissions.size(); 
310         for (int i = 0; i < permissionCount; i++) {
311             Permission permission = mPermissions.valueAt(i); 
312             if (filterPermissions != null
313                     && !ArrayUtils.contains(filterPermissions, permission.getName())) {
314                 continue;
315             }                   
316             if (mAppSupportsRuntimePermissions) {
317                 if (permission.isGranted()) {
318                     return true;
319                 }                   
320             } else if (permission.isGranted() && (permission.getAppOp() == null
321                     || permission.isAppOpAllowed()) && !permission.isReviewRequired()) {
322                 return true;
323             }
324         }   
325         return false;
326     }

```
