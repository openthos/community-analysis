# Settings 中SwitchPreference控件针对camera和microphone权限在每次refresh时永远为"ON"状态的问题分析
1. ./src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java
```
116     @Override
117     public void onResume() {
118         super.onResume();
119         mAppPermissions.refresh();
120         Log.w("mdx------onResume","mAppPermissions.refresh()");
121         loadPreferences();
122         setPreferencesCheckedState();                                                                                                                                                                   
123     }


```

2、 ./src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java
```
403   private void setPreferencesCheckedState() {                                                                                                                                                         
404         setPreferencesCheckedState(getPreferenceScreen());
405         if (mExtraScreen != null) {
406             setPreferencesCheckedState(mExtraScreen);
407         }
408     }

```

3、 ./src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java
```
410     private void setPreferencesCheckedState(PreferenceScreen screen) {                                                                                                                                  
411         int preferenceCount = screen.getPreferenceCount();
412         for (int i = 0; i < preferenceCount; i++) {
413             Preference preference = screen.getPreference(i);
414             if (preference instanceof SwitchPreference) {
415                 SwitchPreference switchPref = (SwitchPreference) preference;
416                 AppPermissionGroup group = mAppPermissions.getPermissionGroup(switchPref.getKey());
417                 if (group != null) {
418                     switchPref.setChecked(group.areRuntimePermissionsGranted());
419                 }
420             }
421         }
422     }

```

4、 src/com/android/packageinstaller/permission/model/AppPermissionGroup.java
```
299     public boolean areRuntimePermissionsGranted() {                                                                                                                                                     
300         return areRuntimePermissionsGranted(null);
301     }
```

5、 src/com/android/packageinstaller/permission/model/AppPermissionGroup.java
```
303     public boolean areRuntimePermissionsGranted(String[] filterPermissions) {
304         if (LocationUtils.isLocationGroupAndProvider(mName, mPackageInfo.packageName)) {
305             return LocationUtils.isLocationEnabled(mContext);
306         }
307         final int permissionCount = mPermissions.size();
308         for (int i = 0; i < permissionCount; i++) {
309             Permission permission = mPermissions.valueAt(i);
310             if (filterPermissions != null
311                     && !ArrayUtils.contains(filterPermissions, permission.getName())) {
312                 continue;
313             }
314             if (mAppSupportsRuntimePermissions) {
315                 if (permission.isGranted()) {                                                                                                                                                           
316                     return true;
317                 }
318             } else if (permission.isGranted() && (permission.getAppOp() == null
319                     || permission.isAppOpAllowed()) && !permission.isReviewRequired()) {
320                 return true;
321             }
322         }
323         return false;
324     }

```
# 解决方案
```
430     private void setPreferencesCheckedState(PreferenceScreen screen) {
431         int preferenceCount = screen.getPreferenceCount();
432         for (int i = 0; i < preferenceCount; i++) {
433             Preference preference = screen.getPreference(i);
434             if (preference instanceof SwitchPreference) {
435                 SwitchPreference switchPref = (SwitchPreference) preference;
436                 AppPermissionGroup group = mAppPermissions.getPermissionGroup(switchPref.getKey());
437                 if (group != null) {
438                     String packageName = group.getApp().packageName;
439                     ContentResolver resolver = getContext().getContentResolver();
440                     if ((group.getName().equals("android.permission-group.CAMERA")  && Settings.Global.getString(resolver,packageName+".permission.camera").equals("vir_camera"))
441                         || (group.getName().equals("android.permission-group.MICROPHONE") && Settings.Global.getString(resolver,packageName+".permission.audio").equals("vir_audio"))                          
442                        )
443                     {
444                         switchPref.setChecked(false);
445                         Log.v("mdx------setPreferencesCheckedState AUDIO",group.getName() +  " " +group.areRuntimePermissionsGranted());
446                         continue;
447                     }
448 
449                     switchPref.setChecked(group.areRuntimePermissionsGranted());
450                 }
451             }
452         }
453     }


```
# 权限控制组

Permission Group|Permissions
---|---|
CALENDAR| ·READ_CALENDAR  ·WRITE_CALENDAR
CAMERA| · CAMERA
CONTACTS|·         READ_CONTACTS·         WRITE_CONTACTS ·         GET_ACCOUNTS
LOCATION | 	·         ACCESS_FINE_LOCATION ·         ACCESS_COARSE_LOCATION
MICROPHONE | 	·         RECORD_AUDIO
PHONE |·   READ_PHONE_STATE·  CALL_PHONE· READ_CALL_LOG· WRITE_CALL_LOG· ADD_VOICEMAIL· USE_SIP· PROCESS_OUTGOING_CALLS
SENSORS |    BODY_SENSORS
SMS | ·         SEND_SMS·         RECEIVE_SMS·         READ_SMS·         RECEIVE_WAP_PUSH·         RECEIVE_MMS
STORAGE | ·         READ_EXTERNAL_STORAGE·         WRITE_EXTERNAL_STORAGE
