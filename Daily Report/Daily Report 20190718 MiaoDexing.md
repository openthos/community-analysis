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
439     private void setPreferencesCheckedState(PreferenceScreen screen) {
440         int preferenceCount = screen.getPreferenceCount();
441         for (int i = 0; i < preferenceCount; i++) {
442             Preference preference = screen.getPreference(i);
443             if (preference instanceof SwitchPreference) {
444                 SwitchPreference switchPref = (SwitchPreference) preference;
445                 AppPermissionGroup group = mAppPermissions.getPermissionGroup(switchPref.getKey());
446                 if (group != null) {
447                     String packageName = group.getApp().packageName;
448                     ContentResolver resolver = getContext().getContentResolver();
449                     Log.i("MDX","setPreferencesCheckedState " + packageName + " " + group.getName());
450                     if ((group.getName().equals("android.permission-group.CAMERA")
451                                 && (Settings.Global.getString(resolver, packageName + CAMERA) != null)
452                                 && Settings.Global.getString(resolver, packageName + CAMERA).equals(VIR_CAMERA))
453                         || (group.getName().equals("android.permission-group.MICROPHONE")
454                             && (Settings.Global.getString(resolver, packageName + AUDIO) != null)
455                             && Settings.Global.getString(resolver, packageName + AUDIO).equals(VIR_AUDIO))
456                         || (group.getName().equals("android.permission-group.LOCATION")
457                             && (Settings.Global.getString(resolver, packageName + LOCATION) != null)
458                             && Settings.Global.getString(resolver, packageName + LOCATION).equals(VIR_LOCATION))                                                                                        
459                        )
460                     {
461                         switchPref.setChecked(false);
462                         continue;
463                     }
464 
465                     switchPref.setChecked(group.areRuntimePermissionsGranted());
466                 }
467             }
468         }
469     }



```
# 权限控制组

Permission Group|Permissions
---|---|
CALENDAR| · READ_CALENDAR <br>  · WRITE_CALENDAR
CAMERA| · CAMERA
CONTACTS|· READ_CONTACTS <br>· WRITE_CONTACTS <br>· GET_ACCOUNTS
LOCATION | 	· ACCESS_FINE_LOCATION <br>· ACCESS_COARSE_LOCATION
MICROPHONE | 	· RECORD_AUDIO
PHONE |· READ_PHONE_STATE <br> · CALL_PHONE <br> · READ_CALL_LOG <br> · WRITE_CALL_LOG <br> · ADD_VOICEMAIL <br> · USE_SIP <br> · PROCESS_OUTGOING_CALLS
SENSORS |    BODY_SENSORS
SMS | · SEND_SMS <br> · RECEIVE_SMS <br> · READ_SMS <br> · RECEIVE_WAP_PUSH <br> · RECEIVE_MMS
STORAGE | · READ_EXTERNAL_STORAGE <br> · WRITE_EXTERNAL_STORAGE

# 获取权限控制组信息
- 获取所有用户权限列表： adb shell pm list permissions -g -u -f
- 获取危险权限列表，每个分组申请其中一个权限即可：  adb shell pm list permissions -d -f  -g

# 同步AOSP 9.0
- repo init -u  git://192.168.0.185/android-x86/platform/manifest.git -b android-9.0.0_r45
- repo sync
