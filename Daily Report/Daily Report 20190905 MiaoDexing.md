-  src/com/android/packageinstaller/permission/ui/ManagePermissionsActivity.java
```
 case Intent.ACTION_MANAGE_APP_PERMISSIONS: {                                                                                                                                                
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

```

-  src/com/android/packageinstaller/permission/ui/handheld/AppPermissionsFragment.java

这里会出现AlertDialog 

![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/Screenshot_20190904-202216.png)


-  packages/providers/ContactsProvider/src/com/android/providers/contacts/ContactsProvider2.java

经测试，联系人添加，更改，删除皆是通过ContactsProvider2类中的相应方法实现

-  frameworks/base/core/java/android/content/ContentResolver.java

联系人的查询最终调用的是ContentResolver的query方法
