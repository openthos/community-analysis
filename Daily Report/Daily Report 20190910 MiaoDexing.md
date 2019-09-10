# 权限检查流程梳理
## 权限申请
- （1）App调用requestPermissions发起动态权限申请；
- （2）requestPermissions方法通过广播的形式启动PackageInstaller的GrantPermissionsActivity界面让用户选择是否授权；
- （3）经由PackageManagerService把相关信息传递给PermissionManagerService处理；
- （4）PermissionManagerService处理结束后回调PackageManagerService中onPermissionGranted方法把处理结果返回；
- （5）PackageManagerService通知观察者权限变化并调用writeRuntimePermissionsForUserLPr方法让PackageManager的settings记录下相关的权限授予状态。

## 权限检查
- （1）App调用checkSelfPermission方法检测是否具有权限；
```
 frameworks/base/core/java/android/app/ContextImpl.java
    @Override
    public int checkPermission(String permission, int pid, int uid) {
        if (permission == null) {
            throw new IllegalArgumentException("permission is null");
        }

       final IActivityManager am = ActivityManager.getService();
       ...
        try {
            return am.checkPermission(permission, pid, uid);
        } catch (RemoteException e) {
            throw e.rethrowFromSystemServer();
        }
    }
```
- （2）通过实现类ContextImpl的checkPermission方法经由ActivityManager和ActivityManagerService处理；
```
    frameworks/base/services/core/java/com/android/server/am/ActivityManagerService.java
    @Override
    public int checkPermission(String permission, int pid, int uid) {
        if (permission == null) {
            return PackageManager.PERMISSION_DENIED;
        }
        return checkComponentPermission(permission, pid, uid, -1, true);
    }

    int checkComponentPermission(String permission, int pid, int uid,
            int owningUid, boolean exported) {
        if (pid == MY_PID) {
            return PackageManager.PERMISSION_GRANTED;
        }
        return ActivityManager.checkComponentPermission(permission, uid,
                owningUid, exported);
    }
```
- （3）经过ActivityManager处理后会调用PackageManagerService的checkUidPermission方法把数据传递给PermissionManagerService处理；
```
上面源码最后又回到了 ActivityManager中的checkComponentPermission方法。checkComponentPermission方法中先是对一些固定case作了判断，如果都不满足，最后会调用PackageManager的checkUidPermission方法来查询授权状态。
  frameworks/base/core/java/android/app/ActivityManager.java
    public static int checkComponentPermission(String permission, int uid,
            int owningUid, boolean exported) {
        // Root, system server get to do everything.
        final int appId = UserHandle.getAppId(uid);
        if (appId == Process.ROOT_UID || appId == Process.SYSTEM_UID) {
            return PackageManager.PERMISSION_GRANTED;
        }
        // Isolated processes don't get any permissions.
        if (UserHandle.isIsolated(uid)) {
            return PackageManager.PERMISSION_DENIED;
        }
        // If there is a uid that owns whatever is being accessed, it has
        // blanket access to it regardless of the permissions it requires.
        if (owningUid >= 0 && UserHandle.isSameApp(uid, owningUid)) {
            return PackageManager.PERMISSION_GRANTED;
        }
        // If the target is not exported, then nobody else can get to it.
        if (!exported) {
            /*
            RuntimeException here = new RuntimeException("here");
            here.fillInStackTrace();
            Slog.w(TAG, "Permission denied: checkComponentPermission() owningUid=" + owningUid,
                    here);
            */
            return PackageManager.PERMISSION_DENIED;
        }
        if (permission == null) {
            return PackageManager.PERMISSION_GRANTED;
        }
        try {
            return AppGlobals.getPackageManager()
                    .checkUidPermission(permission, uid);
        } catch (RemoteException e) {
            throw e.rethrowFromSystemServer();
        }
    }

```
- （4）最终经过一系列查询返回权限授权的状态。
