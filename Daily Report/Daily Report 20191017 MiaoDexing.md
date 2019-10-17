-    core/java/android/os/Environment.java

```
455     public static File getExternalStorageDirectory() {
456         throwIfUserRequired();
457         return sCurrentUser.getExternalDirs()[0];                                                                                                                                                       
458     } 

```

```
 86         public File[] getExternalDirs() {                                                                                                                                                               
 87             final StorageVolume[] volumes = StorageManager.getVolumeList(mUserId,
 88                     StorageManager.FLAG_FOR_WRITE);
 89             final File[] files = new File[volumes.length];
 90             for (int i = 0; i < volumes.length; i++) {
 91                 files[i] = volumes[i].getPathFile();
 92             }
 93             return files;
 94         }

```

- core/java/android/os/storage/StorageManager.java

```
1100     public static @NonNull StorageVolume[] getVolumeList(int userId, int flags) {                                                                                                                      
1101         final IStorageManager storageManager = IStorageManager.Stub.asInterface(
1102                 ServiceManager.getService("mount"));
1103         try {
1104             String packageName = ActivityThread.currentOpPackageName();
1105             Log.v("mdx------","packageName ==== " + packageName);
1106             if (packageName == null) {
1107                 // Package name can be null if the activity thread is running but the app
1108                 // hasn't bound yet. In this case we fall back to the first package in the
1109                 // current UID. This works for runtime permissions as permission state is
1110                 // per UID and permission realted app ops are updated for all UID packages.
1111                 String[] packageNames = ActivityThread.getPackageManager().getPackagesForUid(
1112                         android.os.Process.myUid());
1113                 if (packageNames == null || packageNames.length <= 0) {
1114                     return new StorageVolume[0];
1115                 }
1116                 packageName = packageNames[0];
1117             }
1118             final int uid = ActivityThread.getPackageManager().getPackageUid(packageName,
1119                     PackageManager.MATCH_DEBUG_TRIAGED_MISSING, userId);
1120             if (uid <= 0) {
1121                 return new StorageVolume[0];
1122             }
1123             return storageManager.getVolumeList(uid, packageName, flags);
1124         } catch (RemoteException e) {
1125             throw e.rethrowFromSystemServer();
1126         }
1127     }

```
