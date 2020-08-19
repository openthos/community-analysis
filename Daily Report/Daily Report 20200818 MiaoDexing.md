# SystemUI（一）基于Android9.0SystemUI的启动与定制化
- 众所周知SystemUI包含基本的StatusBar、VolumeBar、NavigationBar等部分，在手机开机时就已经为我们加载好，
但是有时候会出现对StatusBar，DropList等进行定制化的任务，那么就需要了解SystemUI的启动流程，了解StatusBar，DropList等view是如何加载在系统界面上，
下文是从SystemUI启动入口、SystemUI的加载机制以及以StatusBar为例来分析整个流程。
## SystemUI的启动入口
- 一、SystemUI的加载是在Android系统启动的时候，那么我们可以知道SystemUI的入口可能是在系统启动的流程中。通过调查，发现在SyetemServer进程中开始启动系统服务，如AMS，PMS，蓝牙，窗口管理服务等，其中就包括SystemUI，那么就来看看代码中是如何实现的。
-- frameworks/base/services/java/com/android/server/SystemServer.java
```
public final class SystemServer {
   ...
   
    /**
     * The main entry point from zygote.
     */
    public static void main(String[] args) {
        new SystemServer().run();
    }
        ...
        
    private void run() {
             ...
    
        // Initialize native services.
        System.loadLibrary("android_servers");

        // Check whether we failed to shut down last time we tried.
        // This call may not return.
        performPendingShutdown();

        // Initialize the system context.
        createSystemContext();

        // Create the system service manager.
        mSystemServiceManager = new SystemServiceManager(mSystemContext);
        mSystemServiceManager.setStartInfo(mRuntimeRestart,
                mRuntimeStartElapsedTime, mRuntimeStartUptime);
        LocalServices.addService(SystemServiceManager.class, mSystemServiceManager);
        // Prepare the thread pool for init tasks that can be parallelized
        SystemServerInitThreadPool.get();

        // Start services.
        try {
            traceBeginAndSlog("StartServices");
            startBootstrapServices();
            startCoreServices();
            startOtherServices();
            SystemServerInitThreadPool.shutdown();
        } catch (Throwable ex) {
            Slog.e("System", "******************************************");
            Slog.e("System", "************ Failure starting system services", ex);
            throw ex;
        } finally {
            traceEnd();
        }
        
        ...
    }
```
在SystemServer中可以发现启动SystemServer的是zygote进程，这个不属于本文范畴先不做探讨。在SystemServer的Main函数中，调用了run()，那么跟进到run方法中（上述代码省略了一部分，只保留主线），首先初始化了native services和system context，接着创建一个SystemServiceManager对象用于后续系统服务的启动和管理。初始化完成，接下来就开始系统服务的启动，这里调用了startBootstrapServices()、startCoreServices()、startOtherServices()三个方法，
从名字来看，分别是启动引导service、启动中心service、启动其他的services，这三个方法就是开启不同的系统服务的入口，那就分别进入到三个方法中。
--  startBootstrapServices()
```
private void startBootstrapServices() {
        ...
     
        Installer installer = mSystemServiceManager.startService(Installer.class);

        mSystemServiceManager.startService(DeviceIdentifiersPolicyService.class);
      
        mActivityManagerService = mSystemServiceManager.startService(
                ActivityManagerService.Lifecycle.class).getService();
        mActivityManagerService.setSystemServiceManager(mSystemServiceManager);
        mActivityManagerService.setInstaller(installer);

        mPowerManagerService = mSystemServiceManager.startService(PowerManagerService.class);
        
        mSystemServiceManager.startService(LightsService.class);
        
        mSystemServiceManager.startService(new OverlayManagerService(mSystemContext, installer));
        ...

    }
```
在startBootstrapServices()方法中，可以发现mSystemServiceManager.startServic()为核心所在，方法中传入不同的service作为参数，以实现不同services的开启，包括AMS，PMS，LightsService等系统所需的一些小的关键服务；
  -- startCoreServices()
  ```
  /**
    * Starts some essential services that are not tangled up in the bootstrap process.
    */
   private void startCoreServices() {
       traceBeginAndSlog("StartBatteryService");
       // Tracks the battery level.  Requires LightService.
       mSystemServiceManager.startService(BatteryService.class);
       traceEnd();

       // Tracks application usage stats.
       traceBeginAndSlog("StartUsageService");
       mSystemServiceManager.startService(UsageStatsService.class);
       mActivityManagerService.setUsageStatsManager(
               LocalServices.getService(UsageStatsManagerInternal.class));
       traceEnd();

       // Tracks whether the updatable WebView is in a ready state and watches for update installs.
       if (mPackageManager.hasSystemFeature(PackageManager.FEATURE_WEBVIEW)) {
           traceBeginAndSlog("StartWebViewUpdateService");
           mWebViewUpdateService = mSystemServiceManager.startService(WebViewUpdateService.class);
           traceEnd();
       }

       ...
   }
  ```
  同样的，代码中以mSystemServiceManager.startService()来开启服务，只不过里面的参数不同，就不做详细的探讨，继续看第三个方法；
  -  startOtherServices()
  ```
  private void startOtherServices() {
        ...
        traceBeginAndSlog("StartSystemUI");
            try {
                startSystemUi(context, windowManagerF);
            } catch (Throwable e) {
                reportWtf("starting System UI", e);
            }
    
    }
  ```

在第三个startOtherServices()方法中，除掉开启一些系统所需的服务外，最主要的核心在于startSystemUi()方法，里面传入systemContext和WindowManagerService两个参数，也就是说我们已经找到systemUI启动的入口，那么就继续进入到startSystemUi()方法中。

 -  startSystemUi()
 ```
 static final void startSystemUi(Context context, WindowManagerService windowManager) {
        Intent intent = new Intent();
        intent.setComponent(new ComponentName("com.android.systemui",
                    "com.android.systemui.SystemUIService"));
        intent.addFlags(Intent.FLAG_DEBUG_TRIAGED_MISSING);
        //Slog.d(TAG, "Starting service: " + intent);
        context.startServiceAsUser(intent, UserHandle.SYSTEM);
        windowManager.onSystemUiStarted();
    }
 ```
 在上面代码中可以看见创建了一个Intent，然后通过设置组件名称来开启SystemUIService，至此，SystemUI才只是找到启动的入口，对于系统启动完全完成，需要进入到SystemUIService中查看详细的启动流程。
 ## 二、SystemUI开始加载
 第一部分找到了SystemUIService的启动，那么就先进入到SystemUIService类中。如下所示：
/frameworks/base/packages/SystemUI/src/com/android/systemui/SystemUIService.java
```
public class SystemUIService extends Service {

    @Override
    public void onCreate() {
        super.onCreate();
        ((SystemUIApplication) getApplication()).startServicesIfNeeded();
    ...
    }
}
```

在onCreate()中获取了SystemUIApplication并且调用了它的startServicesIfNeeded()方法，那么接着就进入到SystemUIApplication类中，在SystemUIApplication类中找到startServicesIfNeeded方法，如下。
 
 

