- 1、packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java
```
  @Override
    public boolean onPreferenceChange(final Preference preference, Object newValue) {
        String groupName = preference.getKey();
        final AppPermissionGroup group = mAppPermissions.getPermissionGroup(groupName);

        if (group == null) {
            return false;
        }

        addToggledGroup(group);

        if (LocationUtils.isLocationGroupAndProvider(group.getName(), group.getApp().packageName)) {
            LocationUtils.showLocationDialog(getContext(), mAppPermissions.getAppLabel());
            return false;
        }

         ContentResolver resolver = getContext().getContentResolver();
         String packageName = group.getApp().packageName;



        if (newValue == Boolean.TRUE) {
            group.grantRuntimePermissions(true);
            //Settings.Global.putInt(resolver, packageName + AppOpsManager.OP_CAMERA, 1);
            SystemProperties.set(packageName+".permission.camera", "phy_camera");
        } else {

    final boolean grantedByDefault = group.hasGrantedByDefaultPermission();
            if (grantedByDefault || (!group.doesSupportRuntimePermissions()
                    && !mHasConfirmedRevoke)) {
                new AlertDialog.Builder(getContext())
                        .setMessage(grantedByDefault ? R.string.system_warning
                                : R.string.old_sdk_deny_warning)
                        .setNegativeButton(R.string.cancel, (DialogInterface dialog, int which) -> {
                            if (preference instanceof MultiTargetSwitchPreference) {
                                ((MultiTargetSwitchPreference) preference).setCheckedOverride(true);
                            }
                        })
                        .setPositiveButton(R.string.grant_dialog_button_deny_anyway,
                                (DialogInterface dialog, int which) -> {
                            ((SwitchPreference) preference).setChecked(false);
                            //Settings.Global.putInt(resolver, packageName, 0);
                            SystemProperties.set(packageName+".permission.camera", "vir_camera");
                            /*group.revokeRuntimePermissions(false);
                            if (Utils.areGroupPermissionsIndividuallyControlled(getContext(),
                                    group.getName())) {
                                updateSummaryForIndividuallyControlledPermissionGroup(
                                        group, preference);
                            }
                            
                            if (!grantedByDefault) {
                                mHasConfirmedRevoke = true;
                            }
                            */
                        })
                        .show();
                return false;
            } else {
                group.revokeRuntimePermissions(false);
            }
        }

```
- 2、frameworks/av/services/camera/libcameraservice/CameraService.cpp +1298
```
 String8 key = clientName8+".permission.camera";
    char value[PROPERTY_VALUE_MAX];
    property_get(key, value, "phy_camera");
    if(strcmp(value,"phy_camera") == 0){
            ALOGI("mdx--------CameraService    if !!!!");
            property_set("persist.camera.use_fake", "phy_camera");
    }else if(strcmp(value,"vir_camera") == 0){
            ALOGI("mdx--------CameraService    else !!!!");
            property_set("persist.camera.use_fake", "vir_camera");
    }

```
- 3、hardware/libcamera/V4L2Camera.cpp
```
 char value[PROPERTY_VALUE_MAX];
    property_get(CAMERA_USE_FAKE, value, NULL);
    if(strcmp(value,"vir_camera") == 0){
            if ((fd = open("/dev/video2", O_RDWR)) == -1) {
                    ALOGE("ERROR opening V4L interface %s: %s", "/dev/video2", strerror(errno));
                    return -1;
            }
    }
    else  if ((fd = open(device, O_RDWR)) == -1) {
            ALOGE("ERROR opening V4L interface %s: %s", device, strerror(errno));
            return -1;
    }


```
