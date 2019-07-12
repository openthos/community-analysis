# 关于权限管理目前的可行性方案总结
- 针对于虚拟设备权限管理，目前切实可行的方案如下：
   -   在Settings中，用户可以对某一应用的权限是否授予进行操作，其最终是交由PMS来处理，授予就是”PERMISSION_GRANTED“，代表有权限能访问设备；未授予就是”PERMISSION_DENIED“，代表没有权限也就是无法访问设备。
而我们这里为了完成物理设备与虚拟设备的切换，其实都是”PERMISSION_DENIED“，只不过访问的是物理设备还是虚拟设备而已。

   -   基于上述论断，在PMS中使用Setting Global来完成状态存储，本地是XML文件。滑动开关的状态为”ON“，Settings.Global.putString中存储的就是物理设备；滑动开关的状态为”OFF“，Settings.Global.putString
中存储的就是虚拟设备，putString中根据每一个应用的包名为key来存储的信息。
   -   frameworks中，camera或者audio的service中都是可以得到请求应用的包名，根据包名，得到当前应用的具体权限，从而设置property
   -   因为在同一时刻只能有一个应用占用camera或者audio，所以在HAL中，可以根据property的属性值，完成虚拟设备或者物理设备的切换
