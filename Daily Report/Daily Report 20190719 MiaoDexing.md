# 权限管理（PMS）分析
## 前言
重要函数和数据结构说明

### 数据结构说明
PermissionsState 
```
784     public static final class PermissionState {
785         private final String mName;   //权限名称
786         private boolean mGranted;     //是否授予
787         private int mFlags;

```
### 函数说明
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
3、grantRuntimePermission
```
授权最终调用方法，修改PermissionState 的 mGranted属性值为true，最终持久化到runtime-permissions.xml
```
4、revokeRuntimePermission
```
权限未授权调用方法，修改PermissionState 的 mGranted属性值为false，并持久化到runtime-permissions.xml
```

## 结论，6、7、8权限管理未出现大的变化

