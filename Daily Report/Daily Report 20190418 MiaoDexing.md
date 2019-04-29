- 1、设置页面针对某一个应用的权限设置对应的Fragment
  - PackageInstaller//src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java

```
  292     @Override
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
307         if (newValue == Boolean.TRUE) {
308             group.grantRuntimePermissions(false);
309         } else {
310             final boolean grantedByDefault = group.hasGrantedByDefaultPermission();
311             if (grantedByDefault || (!group.doesSupportRuntimePermissions()
312                     && !mHasConfirmedRevoke)) {
313                 new AlertDialog.Builder(getContext())
314                         .setMessage(grantedByDefault ? R.string.system_warning
315                                 : R.string.old_sdk_deny_warning)
316                         .setNegativeButton(R.string.cancel, (DialogInterface dialog, int which) -> {
317                             if (preference instanceof MultiTargetSwitchPreference) {
318                                 ((MultiTargetSwitchPreference) preference).setCheckedOverride(true);
319                             }
320                         })
321                         .setPositiveButton(R.string.grant_dialog_button_deny_anyway,
322                                 (DialogInterface dialog, int which) -> {
323                             ((SwitchPreference) preference).setChecked(true);
324                             group.revokeRuntimePermissions(true);
325                             if (Utils.areGroupPermissionsIndividuallyControlled(getContext(),
326                                     group.getName())) {
327                                 updateSummaryForIndividuallyControlledPermissionGroup(
328                                         group, preference);
329                             }
330                             if (!grantedByDefault) {
331                                 mHasConfirmedRevoke = true;
332                             }
333                         })
334                         .show();
335                 return false;
336             } else {
337                 group.revokeRuntimePermissions(false);
338             }
339         }
340 
341         return true;
342     }

```

```
350     private void updateSummaryForIndividuallyControlledPermissionGroup(
351             AppPermissionGroup group, Preference preference) {
352         int revokedCount = 0;
353         List<Permission> permissions = group.getPermissions();
354         final int permissionCount = permissions.size();
355         for (int i = 0; i < permissionCount; i++) {
356             Permission permission = permissions.get(i);
357             if (group.doesSupportRuntimePermissions()
358                     ? !permission.isGranted() : (!permission.isAppOpAllowed()
359                             || permission.isReviewRequired())) {
360                 revokedCount++;
361             }
362         }
363 
364         final int resId;
365         if (revokedCount == 0) {
366             resId = R.string.permission_revoked_none;
367         } else if (revokedCount == permissionCount) {
368             resId = R.string.permission_revoked_all;
369         } else {
370             resId = R.string.permission_revoked_count;
371         }
372 
373         String summary = getString(resId, revokedCount);
374         preference.setSummary(summary);
375     }


```
