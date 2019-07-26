# Location（定位）在HAL层完成鉴权从而实现真假数据的切换遇到的几个问题：
## 前言
- 想要完成在HAL层完成鉴权首先需要明确在Android中完成定位请求的过程
### LocationManager
- LocationManager系统服务是位置服务的核心组件，它提供了一系列方法来处理与位置相关的问题，比如查询上一个已知位置，定期更新设备的地理位置，或者当设备进入给定地理位置附近时，触发应用指定意图等；
  
   1、 使用LocationManager需要以下过程：
   -     获取LocationManager
     ```
      LocationManager lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
     ```
   2、 了解LocationProvider：它是位置信息提供者，系统一般提供三种方式获取地理位置信息：
   - GPS_PROVIDER：通过 GPS 来获取地理位置的经纬度信息；<br>
    优点：获取地理位置信息精确度高；<br>
    缺点：只能在户外使用，获取经纬度信息耗时，耗电；<br>
   - NETWORK_PROVIDER：通过移动网络的基站或者 Wi-Fi 来获取地理位置；<br>
    优点：只要有网络，就可以快速定位，室内室外都可；<br>
    缺点：精确度不高；
   - PASSIVE_PROVIDER：被动接收更新地理位置信息，而不用自己请求地理位置信息。 
     PASSIVE_PROVIDER 返回的位置是通过其他 providers 产生的，可以查询 getProvider() 方法决定位置更新的由来，需要 ACCESS_FINE_LOCATION 权限，但是如果未启用 GPS，则此 provider 可能只返回粗略位置匹配；
   
   3、 获取provider的方法有getProviders，getAllProviders，getBestProvider（根据一组条件来返回合适的provider）
   ```
   List<String> list = locationManager.getProviders(true);
        if (list != null) {
            for (String x : list) {
                Log.e("mdx", "name:" + x);
            }
        }

        LocationProvider lpGps = locationManager.getProvider(LocationManager.GPS_PROVIDER);
        LocationProvider lpNet = locationManager.getProvider(LocationManager.NETWORK_PROVIDER);
        LocationProvider lpPsv = locationManager.getProvider(LocationManager.PASSIVE_PROVIDER);


        Criteria criteria = new Criteria();
        // Criteria是一组筛选条件
        criteria.setAccuracy(Criteria.ACCURACY_FINE);
        //设置定位精准度
        criteria.setAltitudeRequired(false);
        //是否要求海拔
        criteria.setBearingRequired(true);
        //是否要求方向
        criteria.setCostAllowed(true);
        //是否要求收费
        criteria.setSpeedRequired(true);
        //是否要求速度
        criteria.setPowerRequirement(Criteria.NO_REQUIREMENT);
        //设置电池耗电要求
        criteria.setBearingAccuracy(Criteria.ACCURACY_HIGH);
        //设置方向精确度
        criteria.setSpeedAccuracy(Criteria.ACCURACY_HIGH);
        //设置速度精确度
        criteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
        //设置水平方向精确度
        criteria.setVerticalAccuracy(Criteria.ACCURACY_HIGH);
        //设置垂直方向精确度
       
        //返回满足条件的当前设备可用的provider，第二个参数为false时返回当前设备所有provider中最符合条件的那个provider，但是不一定可用
        String mProvider = locationManager.getBestProvider(criteria, true);
        if (mProvider != null) {
            Log.e("mdx", "mProvider:" + mProvider);
        }
    }
   ```

4、 注册一个位置监听器来接受结果
    
```
     private final class MyLocationListener implements LocationListener{

      public void onLocationChanged(Location location) {
          Log.e("mdx", "onLocationChanged" + location.toString());
      }

      public void onStatusChanged(String provider, int status, Bundle extras) {
          Log.e("mdx", "onStatusChanged" + status);
      }

      public void onProviderEnabled(String provider) {
          Log.e("mdx", "onProviderEnabled");
      }

      public void onProviderDisabled(String provider) {
          Log.e("mdx", "onProviderDisabled");
      }

      }
```
- 这个回调里面有4个方法；
  -  onLocationChanged：当位置发生改变后就会回调该方法，经纬度相关信息存在Location里面；
  -  onStatusChanged：我们所采用的provider状态改变时会回调，该状态有3种；<br>
    1、   LocationProvider.OUT_OF_SERVICE = 0：无服务 <br>
    2、   LocationProvider.AVAILABLE = 2：provider可用 <br>
    3、   LocationProvider.TEMPORARILY_UNAVAILABLE = 1：provider不可用 <br>
  -  onProviderEnabled：当provider可用时被触发，比如定位模式切换到了使用精确位置时GPSProvider就会回调该方法；
  -  onProviderDisabled：当provider不可用时被触发，比如定位模式切换到了使用网络定位时就会回调该方法；

 5、 获取位置信息，调用监听方法，不过在获取位置前先判断一下要调用的provider是否可用；
  ```
    if (mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
     locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 5,10, locationListener);
    }
  ```
### 小结：
- 上层APP通过获得LocationManager从而获得最合适的Provider，应用的位置信息都是来自provider；应用是通过设置listener的方式来获得到Location，是被动的获取，而不是主动的获取。
### 问题：
1、 上层应用想要获得GpsProvider，必须有对应的设备，目前的PC没有GPS，因此，需要我们虚拟一个GPS设备，但此设备只能产生虚拟数据，没有真实数据，也就谈不上虚拟设备和物理设备切换了！
2、 假如上层应用使用getBestProvider获得provider，优先使用的GPS，这时我们已经返回的是GpsProvider（因为我们有虚拟GPS），所以根本就不可能在所谓的“虚拟设备与物理设备”切换了！
## 定位服务源码分析
- 下图是定位服务架构图，先从宏观上有个了解。如图一共分为四层，每层都依赖下面一层完成其所需提供的服务
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/GpsLocation.png)

  -   应用层：是android.location包中包含的内容，主要通过LocationManager来进行方法调用
  -   框架层：这一层包含了系统服务的实现，LocationManager通过Binder机制来和LocationManagerService进行通讯，LocationManagerService会选择合适的provider来提供位置，其中LocationProviderProxy的一个实现就是NLP，可以理解为LocationProviderProxy和GeocoderProxy都是一个空壳，如果没有第三方实现他们，那么将不提供服务，如果使用了GpsLocationProvider则会去调用硬件来获取位置；
  -   共享库层：GpsLocationProvider通过JNI来调用本层libgps.so中的C++代码；
  -   Linux内核层：C++代码最终去调用GPS硬件来获取位置；
### 具体分析代码
#### LocationManager分析
- App调用定位接口是通过LocationManager的API，其中很多方法都是代理了service的一些方法，这个service的声明类型是ILocationManager，这个对象就是代理对象，很显然是AIDL的调用，具体实现类则是LocationManagerService，LocationManager和LocationManagerService就是通过Binder机制来进行通讯的。
- LocationManager提供的主要方法有：
1、 getLastKnownLocation：获取上一次缓存的位置，这个方法不会发起定位请求，返回的是上一次的位置信息，但此前如果没有位置更新的话，返回的位置信息可能是错误的；<br>
2、 equestSingleUpdate：只请求一次定位，会发起位置监听，该方法要在主线程上执行，可以传入Listener或广播来接收位置；<br>
3、 equestLocationUpdates：持续请求定位，根据传入的时间间隔和位置差进行回调，该方法要在主线程上执行，可以传入Listener或广播来接收位置；<br>
4、 emoveUpdates：移除定位请求，传入Listener；<br>
5、 ddProximityAlert：添加一个地理围栏，这是一个圆形的围栏；<br>
6、 etProvider：获取Provider，可以指定条件，也可以根据名字来获取；<br>
7、 endExtraCommand：给系统发送辅助指令；<br>
- 这些方法的最终都是由service来实现的，发起定位时传入的Listener经过包装成AIDL接口传给了服务端，因为它们是需要跨进程来进行通讯的。
- 这里分析一下requestSingleUpdate方法，这个方法主要是传一个Listener，然后内部创建了一个LocationRequest，最小时间和最小距离都是0，还给singleShot设置为了true，并最终调用requestLocationUpdates方法，所以requestLocationUpdates才是核心，而所有定制的参数都封装成了LocationRequest。
```
687     @RequiresPermission(anyOf = {ACCESS_COARSE_LOCATION, ACCESS_FINE_LOCATION})
 688     public void requestSingleUpdate(String provider, LocationListener listener, Looper looper) {                                                                                                       
 689         checkProvider(provider);
 690         checkListener(listener);
 691 
 692         LocationRequest request = LocationRequest.createFromDeprecatedProvider(
 693                 provider, 0, 0, true);
 694         requestLocationUpdates(request, listener, looper, null);
 695     }

 879     private void requestLocationUpdates(LocationRequest request, LocationListener listener,                                                                                                            
 880             Looper looper, PendingIntent intent) {
 881         
 882         String packageName = mContext.getPackageName();
 883         
 884         // wrap the listener class
 885         ListenerTransport transport = wrapListener(listener, looper);
 886     
 887         try {
 888             mService.requestLocationUpdates(request, transport, intent, packageName);
 889        } catch (RemoteException e) {
 890            throw e.rethrowFromSystemServer();
 891        }
 892     }

```
- createFromDeprecatedProvider
```
170     /** @hide */
171     @SystemApi   
172     public static LocationRequest createFromDeprecatedProvider(String provider, long minTime,
173             float minDistance, boolean singleShot) {
174         if (minTime < 0) minTime = 0;
175         if (minDistance < 0) minDistance = 0;
176 
177         int quality;
178         if (LocationManager.PASSIVE_PROVIDER.equals(provider)) {
179             quality = POWER_NONE;
180         } else if (LocationManager.GPS_PROVIDER.equals(provider)) {
181             quality = ACCURACY_FINE;
182         } else {
183             quality = POWER_LOW;
184         }                                                                                                                                                                                               
185 
186         LocationRequest request = new LocationRequest()
187             .setProvider(provider)
188             .setQuality(quality)
189             .setInterval(minTime)
190             .setFastestInterval(minTime)
191             .setSmallestDisplacement(minDistance);
192         if (singleShot) request.setNumUpdates(1);
193         return request;
194     }

```
这里把传来的最小时间频率，最小距离差值存下，设置了定位的精度类型，如果singleShot为true，会设置locationRequest.setNumUpdates(1)，numUpdate这个变量的默认值是一个很大的数，Integer.MAX_VALUE = 0x7fffffff，而单次定位g该值就设为了1，这里最终获得了一个LocationRequest，这在LocationManagerService时会用到。

-当客户端调用LocationManager的requestLocationUpdates方法时，会把参数拼成LocationRequest这个类，传给LocationManagerService。服务端会调用requestLocationUpdatesLocked方法，这些加Locked的方法是系统封装的带锁的方法。
```
2011     @Override
2012     public void requestLocationUpdates(LocationRequest request, ILocationListener listener,
2013             PendingIntent intent, String packageName) {
         。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
2033         try {
2034             // We don't check for MODE_IGNORED here; we will do that when we go to deliver
2035             // a location.
2036             checkLocationAccess(pid, uid, packageName, allowedResolutionLevel);
2037 
2038             synchronized (mLock) {
2039                 Receiver recevier = checkListenerOrIntentLocked(listener, intent, pid, uid,
2040                         packageName, workSource, hideFromAppOps);
2041                 requestLocationUpdatesLocked(sanitizedRequest, recevier, pid, uid, packageName);                                                                                                       
2042             }
2043        。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
2046     }



2048     private void requestLocationUpdatesLocked(LocationRequest request, Receiver receiver,
2049             int pid, int uid, String packageName) {
2050         // Figure out the provider. Either its explicitly request (legacy use cases), or
2051         // use the fused provider
2052         if (request == null) request = DEFAULT_LOCATION_REQUEST;
2053         String name = request.getProvider();
2054         if (name == null) {
2055             throw new IllegalArgumentException("provider name must not be null");
2056         }
2057 
2058         LocationProviderInterface provider = mProvidersByName.get(name);
2059         if (provider == null) {
2060             throw new IllegalArgumentException("provider doesn't exist: " + name);
2061         }
2062 
2063         UpdateRecord record = new UpdateRecord(name, request, receiver);
2064         if (D) Log.d(TAG, "request " + Integer.toHexString(System.identityHashCode(receiver))
2065                 + " " + name + " " + request + " from " + packageName + "(" + uid + " "
2066                 + (record.mIsForegroundUid ? "foreground" : "background")
2067                 + (isThrottlingExemptLocked(receiver.mIdentity)
2068                     ? " [whitelisted]" : "") + ")");
2069 
2070         UpdateRecord oldRecord = receiver.mUpdateRecords.put(name, record);
2071         if (oldRecord != null) {
2072             oldRecord.disposeLocked(false);
2073         }
2074 
2075         boolean isProviderEnabled = isAllowedByUserSettingsLocked(name, uid);
2076         if (isProviderEnabled) {
2077             applyRequirementsLocked(name);
2078         } else {
2079             // Notify the listener that updates are currently disabled
2080             receiver.callProviderEnabledLocked(name, false);
2081         }
2082         // Update the monitoring here just in case multiple location requests were added to the
2083         // same receiver (this request may be high power and the initial might not have been).                                                                                                         
2084         receiver.updateMonitoring(true);
2085     }


```在这里每个发起定位请求的客户端都会插入一条记录UpdateRecord，请求定位和取消定位就是插入删除一条记录，如果之前有这条记录，那么就把它移除，相当于App调用了2次定位，那么后面的请求会把前面的覆盖，这种情况一般是发生在持续定位的过程。
- 
