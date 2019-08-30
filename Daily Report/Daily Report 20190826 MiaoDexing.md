# PMS弹窗分析（二）
## 实现思路：
- 弹窗对权限的管理无非就是 “DEFY”去执行 “revokerRuntimePermission”方法 ,“ALLOW”去执行 “grantRuntimePermission”方法，只不过我们是希望在我们要管理的camera、micphone等权限是不是真正去 “defined”，而是 “granted”，所以其实 revoke 也是 grant。但是为了不破坏原有的系统框架，我们可以自定义一个方法，比如叫做“grantRuntimeVirPermission”方法，在次方法中调用grantRuntimePermission，不过需要重写 grantRuntimePermission，因为要区分我们到底是授予 物理权限 还是 虚拟权限，详情见相关patch
