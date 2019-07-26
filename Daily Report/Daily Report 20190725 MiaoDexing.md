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

- 当客户端调用LocationManager的requestLocationUpdates方法时，会把参数拼成LocationRequest这个类，传给LocationManagerService。服务端会调用requestLocationUpdatesLocked方法，这些加Locked的方法是系统封装的带锁的方法。
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


```
```
在这里每个发起定位请求的客户端都会插入一条记录UpdateRecord，请求定位和取消定位就是插入删除一条记录，如果之前有这条记录，那么就把它移除，相当于App调用了2次定位，那么后面的请求会把前面的覆盖，这种情况一般是发生在持续定位的过程。
```
- 下面分析applyRequirementsLocked方法
```
1719     private void applyRequirementsLocked(String provider) {
1720         LocationProviderInterface p = mProvidersByName.get(provider);
1721         if (p == null) return;
1722                                                                                                                                                                                                        
1723         ArrayList<UpdateRecord> records = mRecordsByProvider.get(provider);
1724         WorkSource worksource = new WorkSource();
1725         ProviderRequest providerRequest = new ProviderRequest();
1726 
1727         ContentResolver resolver = mContext.getContentResolver();
1728         long backgroundThrottleInterval = Settings.Global.getLong(
1729                 resolver,
1730                 Settings.Global.LOCATION_BACKGROUND_THROTTLE_INTERVAL_MS,
1731                 DEFAULT_BACKGROUND_THROTTLE_INTERVAL_MS);
1732 
1733         if (records != null) {
1734             for (UpdateRecord record : records) {
1735                 if (isCurrentProfile(UserHandle.getUserId(record.mReceiver.mIdentity.mUid))) {
1736                     if (checkLocationAccess(
1737                             record.mReceiver.mIdentity.mPid,
1738                             record.mReceiver.mIdentity.mUid,
1739                             record.mReceiver.mIdentity.mPackageName,
1740                             record.mReceiver.mAllowedResolutionLevel)) {
1741                         LocationRequest locationRequest = record.mRealRequest;
1742                         long interval = locationRequest.getInterval();
1743 
1744                         if (!isThrottlingExemptLocked(record.mReceiver.mIdentity)) {
1745                             if (!record.mIsForegroundUid) {
1746                                 interval = Math.max(interval, backgroundThrottleInterval);
1747                             }
1748                             if (interval != locationRequest.getInterval()) {
1749                                 locationRequest = new LocationRequest(locationRequest);
1750                                 locationRequest.setInterval(interval);
1751                             }
1752                         }
1753 
1754                         record.mRequest = locationRequest;
1755                         providerRequest.locationRequests.add(locationRequest);
1756                         if (interval < providerRequest.interval) {
1757                             providerRequest.reportLocation = true;
1758                             providerRequest.interval = interval;
1759                         }
1760                     }
1761                 }
1762             }

```
这里注意下ProviderRequest是一个局部变量，每次都会new出来的，它的时间频率默认值是一个大数，所以每次遍历只要有定位请求，频率就会改变，直到找出最小的频率，并且标记为需要上报位置。
- 遍历完之后判断如果需要上报位置，就把worksource记录下，以便于追查耗电的元凶，worksource包含2个参数，一个是uid，一个是包名。最后会回调setRequest方法，把ProviderRequest和WorkSource参数传递过去。
```
1764             if (providerRequest.reportLocation) {
1765                 // calculate who to blame for power
1766                 // This is somewhat arbitrary. We pick a threshold interval
1767                 // that is slightly higher that the minimum interval, and
1768                 // spread the blame across all applications with a request
1769                 // under that threshold.
1770                 long thresholdInterval = (providerRequest.interval + 1000) * 3 / 2;
1771                 for (UpdateRecord record : records) {
1772                     if (isCurrentProfile(UserHandle.getUserId(record.mReceiver.mIdentity.mUid))) {
1773                         LocationRequest locationRequest = record.mRequest;
1774 
1775                         // Don't assign battery blame for update records whose
1776                         // client has no permission to receive location data.
1777                         if (!providerRequest.locationRequests.contains(locationRequest)) {
1778                             continue;
1779                         }
1780 
1781                         if (locationRequest.getInterval() <= thresholdInterval) {
1782                             if (record.mReceiver.mWorkSource != null
1783                                     && record.mReceiver.mWorkSource.size() > 0
1784                                     && record.mReceiver.mWorkSource.getName(0) != null) {
1785                                 // Assign blame to another work source.
1786                                 // Can only assign blame if the WorkSource contains names.
1787                                 worksource.add(record.mReceiver.mWorkSource);
1788                             } else {
1789                                 // Assign blame to caller.
1790                                 worksource.add(
1791                                         record.mReceiver.mIdentity.mUid,
1792                                         record.mReceiver.mIdentity.mPackageName);
1793                             }
1794                         }
1795                     }
1796                 }
1797             }
1798         }
1799 
1800         if (D) Log.d(TAG, "provider request: " + provider + " " + providerRequest);
1801         p.setRequest(providerRequest, worksource);
1802     }


services/core/java/com/android/server/location/LocationProviderInterface.java
29 /**   
30  * Location Manager's interface for location providers.
31  * @hide  
32  */           
33 public interface LocationProviderInterface {
34     。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
39     public void setRequest(ProviderRequest request, WorkSource source);                                                          。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
48 }

location/lib/java/com/android/location/provider/LocationProviderBase.java
78     private final class Service extends ILocationProvider.Stub {
 79         @Override
 80         public void enable() {
 81             onEnable();
 82         }
 83         @Override
 84         public void disable() {
 85             onDisable();
 86         }
 87         @Override
 88         public void setRequest(ProviderRequest request, WorkSource ws) {                                                                                                                                
 89             onSetRequest(new ProviderRequestUnbundled(request), ws);
 90         }

```
- 接着我们向服务器请求定位，得到结果后调用LocationProviderBase的reportLocation方法来把位置上报。这里又需要注意了，reportLocation并不是ILocationProvider里的接口方法，而是LocationProviderBase里的一个自定义的final方法，它调用的是ILocationManager里定义的reportLocation方法，而前面已经说过LocationManagerService才是ILocationManager真正实现类，所以要去LocationManagerService去找reportLocation究竟做了什么，定位结果是怎么返给APP的。
```
134     public final void reportLocation(Location location) {
135         try {
136             mLocationManager.reportLocation(location, false);
137         } catch (RemoteException e) {
138             Log.e(TAG, "RemoteException", e);
139         } catch (Exception e) {
140             // never crash provider, might be running in a system process                                                                                                                               
141             Log.e(TAG, "Exception", e);
142         }
143     }
144 


```
- LocationManagerService的reportLocation就是用handler发送了一个MSG_LOCATION_CHANGED的消息
```
2526     @Override
2527     public void reportLocation(Location location, boolean passive) {                                                                                                                                   
2528         checkCallerIsProvider();
2529 
2530         if (!location.isComplete()) {
2531             Log.w(TAG, "Dropping incomplete location: " + location);
2532             return;
2533         }
2534            
2535         mLocationHandler.removeMessages(MSG_LOCATION_CHANGED, location);
2536         Message m = Message.obtain(mLocationHandler, MSG_LOCATION_CHANGED, location);
2537         m.arg1 = (passive ? 1 : 0);
2538         mLocationHandler.sendMessageAtFrontOfQueue(m);
2539     }


2736     private class LocationWorkerHandler extends Handler {                                                                                                                                              
2737         public LocationWorkerHandler(Looper looper) {
2738             super(looper, null, true);
2739         }
2740     
2741         @Override
2742         public void handleMessage(Message msg) {
2743             switch (msg.what) {
2744                 case MSG_LOCATION_CHANGED:
2745                     handleLocationChanged((Location) msg.obj, msg.arg1 == 1);
2746                     break;
2747             }
2748         }
2749     }


```

- 在handleLocationChangedLocked方法里先对mLastLocation做了更新，然后遍历所有UpdateRecord，根据LocationRequest请求的精度来确定返回粗略位置还是精确位置。
```
2757     private void handleLocationChanged(Location location, boolean passive) {
2758         // create a working copy of the incoming Location so that the service can modify it without
2759         // disturbing the caller's copy
2760         Location myLocation = new Location(location);
2761         String provider = myLocation.getProvider();
2762 
2763         // set "isFromMockProvider" bit if location came from a mock provider. we do not clear this
2764         // bit if location did not come from a mock provider because passive/fused providers can
2765         // forward locations from mock providers, and should not grant them legitimacy in doing so.
2766         if (!myLocation.isFromMockProvider() && isMockProvider(provider)) {
2767             myLocation.setIsFromMockProvider(true);
2768         }
2769 
2770         synchronized (mLock) {
2771             if (isAllowedByCurrentUserSettingsLocked(provider)) {
2772                 if (!passive) {
2773                     // notify passive provider of the new location
2774                     mPassiveProvider.updateLocation(myLocation);
2775                 }
2776                 handleLocationChangedLocked(myLocation, passive);
2777             }
2778         }
2779     }


2574     private void handleLocationChangedLocked(Location location, boolean passive) {
2575         if (D) Log.d(TAG, "incoming location: " + location);
2576 
2577         long now = SystemClock.elapsedRealtime();
2578         String provider = (passive ? LocationManager.PASSIVE_PROVIDER : location.getProvider());
2579 
2580         // Skip if the provider is unknown.
2581         LocationProviderInterface p = mProvidersByName.get(provider);
2582         if (p == null) return;
2583 
2584         // Update last known locations
2585         Location noGPSLocation = location.getExtraLocation(Location.EXTRA_NO_GPS_LOCATION);
2586         Location lastNoGPSLocation;
2587         Location lastLocation = mLastLocation.get(provider);
2588         if (lastLocation == null) {
2589             lastLocation = new Location(provider);
2590             mLastLocation.put(provider, lastLocation);
2591         } else {
2592             lastNoGPSLocation = lastLocation.getExtraLocation(Location.EXTRA_NO_GPS_LOCATION);
2593             if (noGPSLocation == null && lastNoGPSLocation != null) {
2594                 // New location has no no-GPS location: adopt last no-GPS location. This is set
2595                 // directly into location because we do not want to notify COARSE clients.
2596                 location.setExtraLocation(Location.EXTRA_NO_GPS_LOCATION, lastNoGPSLocation);
2597             }
2598         }                                                                                                                                                                                              
2599         lastLocation.set(location);

2638         // Broadcast location or status to all listeners
2639         for (UpdateRecord r : records) {
2640             Receiver receiver = r.mReceiver;
2641             boolean receiverDead = false;
2642 
2643             int receiverUserId = UserHandle.getUserId(receiver.mIdentity.mUid);
2644             if (!isCurrentProfile(receiverUserId)
2645                     && !isUidALocationProvider(receiver.mIdentity.mUid)) {                                                                                                                             
2646                 if (D) {
2647                     Log.d(TAG, "skipping loc update for background user " + receiverUserId +
2648                             " (current user: " + mCurrentUserId + ", app: " +
2649                             receiver.mIdentity.mPackageName + ")");
2650                 }
2651                 continue;
2652             }
2653 
2654             if (mBlacklist.isBlacklisted(receiver.mIdentity.mPackageName)) {
2655                 if (D) Log.d(TAG, "skipping loc update for blacklisted app: " +
2656                         receiver.mIdentity.mPackageName);
2657                 continue;
2658             }
2659 
2660             if (!reportLocationAccessNoThrow(
2661                     receiver.mIdentity.mPid,
2662                     receiver.mIdentity.mUid,
2663                     receiver.mIdentity.mPackageName,
2664                     receiver.mAllowedResolutionLevel)) {
2665                 if (D) Log.d(TAG, "skipping loc update for no op app: " +
2666                         receiver.mIdentity.mPackageName);
2667                 continue;
2668             }
2669 
2670             Location notifyLocation;
2671             if (receiver.mAllowedResolutionLevel < RESOLUTION_LEVEL_FINE) {
2672                 notifyLocation = coarseLocation;  // use coarse location
2673             } else {
2674                 notifyLocation = lastLocation;  // use fine location
2675             }
if (notifyLocation != null) {
2677                 Location lastLoc = r.mLastFixBroadcast;
2678                 if ((lastLoc == null) || shouldBroadcastSafe(notifyLocation, lastLoc, r, now)) {
2679                     if (lastLoc == null) {
2680                         lastLoc = new Location(notifyLocation);
2681                         r.mLastFixBroadcast = lastLoc;
2682                     } else {
2683                         lastLoc.set(notifyLocation);
2684                     }
2685                     if (!receiver.callLocationChangedLocked(notifyLocation)) {
2686                         Slog.w(TAG, "RemoteException calling onLocationChanged on " + receiver);
2687                         receiverDead = true;
2688                     }
2689                     r.mRealRequest.decrementNumUpdates();
2690                 }
2691             }

```
- 在callLocationChangedLocaked方法里就会回调客户端Listener的onLocationChanged方法，并把Location回传回去，如果客户端不是用的Listener而是用广播的形式来接受数据，那么就会发送广播。
```
 991         public boolean callLocationChangedLocked(Location location) {
 992             if (mListener != null) {
 993                 try {
 994                     synchronized (this) {
 995                         // synchronize to ensure incrementPendingBroadcastsLocked()
 996                         // is called before decrementPendingBroadcasts()
 997                         mListener.onLocationChanged(new Location(location));
 998                         // call this after broadcasting so we do not increment
 999                         // if we throw an exeption.
1000                         incrementPendingBroadcastsLocked();
1001                     }
1002                 } catch (RemoteException e) {
1003                     return false;
1004                 }
1005             } else {
1006                 Intent locationChanged = new Intent();
1007                 locationChanged.putExtra(LocationManager.KEY_LOCATION_CHANGED, new Location(location));
1008                 try {
1009                     synchronized (this) {
1010                         // synchronize to ensure incrementPendingBroadcastsLocked()
1011                         // is called before decrementPendingBroadcasts()
1012                         mPendingIntent.send(mContext, 0, locationChanged, this, mLocationHandler,
1013                                 getResolutionPermission(mAllowedResolutionLevel));
1014                         // call this after broadcasting so we do not increment
1015                         // if we throw an exeption.
1016                         incrementPendingBroadcastsLocked();
1017                     }
1018                 } catch (PendingIntent.CanceledException e) {
1019                     return false;
1020                 }
1021             }
1022             return true;
1023         }


```
- 然后看是否需要回调callStatusChangedLocked方法，它内部也是回调Listener或者发送广播。
```
956         public boolean callStatusChangedLocked(String provider, int status, Bundle extras) {
 957             if (mListener != null) {
 958                 try {
 959                     synchronized (this) {
 960                         // synchronize to ensure incrementPendingBroadcastsLocked()
 961                         // is called before decrementPendingBroadcasts()
 962                         mListener.onStatusChanged(provider, status, extras);
 963                         // call this after broadcasting so we do not increment
 964                         // if we throw an exeption.
 965                         incrementPendingBroadcastsLocked();
 966                     }
 967                 } catch (RemoteException e) {
 968                     return false;
 969                 }
 970             } else {
 971                 Intent statusChanged = new Intent();
 972                 statusChanged.putExtras(new Bundle(extras));
 973                 statusChanged.putExtra(LocationManager.KEY_STATUS_CHANGED, status);
 974                 try {
 975                     synchronized (this) {
 976                         // synchronize to ensure incrementPendingBroadcastsLocked()
 977                         // is called before decrementPendingBroadcasts()
 978                         mPendingIntent.send(mContext, 0, statusChanged, this, mLocationHandler,
 979                                 getResolutionPermission(mAllowedResolutionLevel));
 980                         // call this after broadcasting so we do not increment
 981                         // if we throw an exeption.
 982                         incrementPendingBroadcastsLocked();
 983                     }
 984                 } catch (PendingIntent.CanceledException e) {
 985                     return false;
 986                 }
 987             }
 988             return true;
 989         }

```
