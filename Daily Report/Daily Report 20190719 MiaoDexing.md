# 权限管理（PMS）分析
## 前言
重要函数和数据结构说明
1. checkUidPermission
```
此方法皆是由上层应用在请求相应service，其service来向AppOpsService查询是否授权，最后由PMS来完成鉴权
```
2. hasPermission <br>
```
258     /**
259      * Gets whether the state has a given permission for the specified
260      * user, regardless if this is an install or a runtime permission.
261      *
262      * @param name The permission name.
263      * @param userId The device user id.
264      * @return Whether the user has the permission.
265      */
```

数据结构 | 说明
PermissionsState 
```
784     public static final class PermissionState {
785         private final String mName;   //
786         private boolean mGranted;
787         private int mFlags;

```

