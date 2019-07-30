- services/core/java/com/android/server/pm/Settings.java
```
5658         private void writePermissions(XmlSerializer serializer,
5659                 List<PermissionState> permissionStates) throws IOException {
5660             for (PermissionState permissionState : permissionStates) {
5661                 serializer.startTag(null, TAG_ITEM);
5662                 serializer.attribute(null, ATTR_NAME,permissionState.getName());
5663                 //serializer.attribute(null, ATTR_GRANTED,
5664                 //        String.valueOf(permissionState.isGranted()));
5665                 serializer.attribute(null, ATTR_GRANTED,
5666                         String.valueOf("true"));                                                                                                                                                       
5667                 serializer.attribute(null, ATTR_FLAGS,
5668                         Integer.toHexString(permissionState.getFlags()));
5669                 serializer.endTag(null, TAG_ITEM);
5670             }                          
5671         }  
```

- src/com/android/packageinstaller/permission/model/AppPermissionGroup.java
```
459                 // Revoke the permission if needed.
460                 if (!permission.isGranted()) {
461                     permission.setGranted(true);
462                     mPackageManager.revokeRuntimePermission(mPackageInfo.packageName,                                                                                                                   
463                             permission.getName(), mUserHandle);
464                     
465                     Log.i("mdx--permission","revokeRuntimePermissions" + mPackageInfo.packageName + " " + permission.getName());
466                 }


```
