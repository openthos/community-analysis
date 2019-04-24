- 1、build/tools/buildinfo.sh   此脚本生成default.prop文件
  echo "persist.camera.use_fake=1"
  
- 2、packages/apps/PackageInstaller/src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java
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
            //设置属性值，以当前应用报名+camera权限为key，值为0，1；0代表虚拟，1代表物理。
            //在camera打开之前，根据key，判断值。如果是1，设置系统属性为false；0，true。
            //在HAL的open中，使用property_get_bool判断
            Settings.Global.putInt(resolver, packageName + AppOpsManager.OP_CAMERA, 1);
            //SystemProperties.set("persist.camera.use_fake", "false");
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
                            Settings.Global.putInt(resolver, packageName + AppOpsManager.OP_CAMERA, 0);
                              //SystemProperties.set("persist.camera.use_fake", "true");
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

        return true;
    }



```
- 3、frameworks/base/core/java/android/hardware/camera2/CameraManager.java

```
  private CameraDevice openCameraDeviceUserAsync(String cameraId,
            CameraDevice.StateCallback callback, Handler handler, final int uid)
            throws CameraAccessException {


  if(Settings.Global.getInt(mContext.getContentResolver(), mContext.getPackageName() + AppOpsManager.OP_CAMERA, 1) == 1){
               
                SystemProperties.set("persist.camera.use_fake", 1);
        }else{
                
                SystemProperties.set("persist.camera.use_fake", 0);
        }



```

- 4、hardware/libcamera/V4L2Camera.cpp
```
 if(property_get_bool(CAMERA_USE_FAKE,1) == 0){
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
