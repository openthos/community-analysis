# PackageManager、ApplicationPackageManager和PackageManagerService的关系总结
- IPackageManager负责通信。IPackageManager接口类中定义了很多业务方法，但是由于安全等方面的考虑，Android对外(即SDK)提供的仅仅是一个子集，该子集被封装在抽象类PackageManager中。客户端一般通过Context的getPackageManager函数返回一个类型为PackageManager的对象，该对象的实际类型是PackageManager的子类ApplicationPackageManager。ApplicationPackageManager并没有直接参与Binder通信，而是通过mPM成员变量指向了一个IPackageManager.Stub.Proxy类型的对象
- AIDL中的Binder服务端是PackageManagerService，因为PackageManagerService继承自IPackageManager.Stub。由于IPackageManager.Stub类从Binder派生，所以PackageManagerService将作为服务端参与Binder通信。
- AIDL中的Binder客户端是ApplicationPackageManager中成员变量mPM，因为mPM内部指向的是IPackageManager.Stub.Proxy
- 整体流程的Binder结构大致如下：![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/%E6%95%B4%E4%BD%93%E6%B5%81%E7%A8%8B%E7%9A%84Binder%E7%BB%93%E6%9E%84.png)

# 获取Client的过程
- 从上面的图中我们知道通过AIDL结束，Client通过PackageManagerService去快进程调用Server端的Stub，底层依然是依靠Binder机制进行机制，Client获取PackageManangerService的代理对象过程：
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/%E8%8E%B7%E5%8F%96client.png)
