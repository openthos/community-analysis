# 网络定位简介
- 在安卓的设置中，“网络定位”是指利用手机基站信息、wifi信息等（一般有网络制式、MCC、MNC、MAC、WIFI SSID等维度；ip极少参与其中）发送到指定的位置服务器；
位置服务器接收后，直接返回粗略的经纬度和精度信息。整个过程中其实就是“根据IP地址获取地址”的高级版，而且手机端无需定位卫星的信号，
做到低耗电定位（所以说，网络定位的本质，其实和GPS乃至AGPS都没什么关系）。<br>
  从上面可以看到，要实现网络定位，位置服务器是必须的，但这部分一般都在地图资源商的手中，手机/平板制造商不可能有这种资源。
  他们只能通过和地图资源商进行商务合作或者取得授权，才能够合法地放入网络定位的相关底层应用和分发使用权，否则会被视为侵权使用。<br>
  国内常见的网络定位目前有两种：
  -  Google GMS（Google Mobile Service）中的网络定位服务（许多人可能更加熟悉NetworkLocation.apk）。但国内行货由于众多原因，目前没有一家通过GMS认证，所以一定不会有这个服务（换句话讲，也不会有这个文件）。即使有，其实也是在灰色使用状态，不能太声张——之前曾有一次，小米放入这个文件，结果引发同行批评
  -  百度地图的网络定位服务（一般为NetworkLocation_Baidu.apk或者BaiduNetworkLocation.apk）。目前有部分国行和部分rom采用。这满足了国行不能使用GMS、但又希望使用网络定位的需求。
  
# 源码分析
- LocationManagerService这个类，在systemRunning方法里，做了一系列初始化的操作，其中一个重要的方法就是loadProvidersLocked()，
它就是来加载provider的；位置服务的提供者是LocationProvider，它包含3种：GPS_PROVIDER，NETWORK_PROVIDER，PASSIVE_PROVIDER，
BaiduNLP就是NETWORK_PROVIDER的一种。
- 加载NetworkLocationProvider了， LocationProviderProxy是对NetworkLocationProvider的代理，
而第三方NLP才是NetworkLocationProvider的具体实现，这里会根据XML文件中配置的布尔值，
包名和字符串数组去绑定指定action的服务，如果bind成功就把它加入到可用provider中。
那么实现方必然要创建一个Service来实现LocationProviderProxy中使用的AIDL对象的接口，这个类名没有具体要求，
但是Service必须要对指定的action进行绑定并返回binder对象才能被唤醒。所以有的时候会遇到第三方NLP没有被厂商bind上，
后续就无法通过第三方NLP来获取位置。
```
 631         // bind to network provider
 632         LocationProviderProxy networkProvider = LocationProviderProxy.createAndBind(
 633                 mContext,
 634                 LocationManager.NETWORK_PROVIDER,
 635                 NETWORK_LOCATION_SERVICE_ACTION,
 636                 com.android.internal.R.bool.config_enableNetworkLocationOverlay,
 637                 com.android.internal.R.string.config_networkLocationProviderPackageName,                                                                                                               
 638                 com.android.internal.R.array.config_locationProviderPackageNames,
 639                 mLocationHandler);
 640         if (networkProvider != null) {
 641             mRealProviders.put(LocationManager.NETWORK_PROVIDER, networkProvider);
 642             mProxyProviders.add(networkProvider);
 643             addProviderLocked(networkProvider);
 644         } else {
 645             Slog.w(TAG,  "no network location provider found");
 646         }

```
- LocationProviderProxy的createAndBind方法，在这里创建了一个ServiceWatcher对象，然后执行了它的start方法。
ServiceWatcher是用来连接和监视应用程序实现LocationProvider服务的，成功binder到服务后，
会对该服务进行监控，包的卸载，加载、安装都会引起rebinder动作，它实现了ServiceConnection，在构造函数里，
把xml中的配置项都传了过来，包括一个boolean值overlay(覆盖)，一个字符串数组，一个默认的服务字符串，如果开启覆盖即overlay=true，
则使用字符串数组中指定包名的provider，如果不覆盖，则使用包名字符串中的provider来提供服务。
```
 57     public static LocationProviderProxy createAndBind(
 58             Context context, String name, String action,
 59             int overlaySwitchResId, int defaultServicePackageNameResId,
 60             int initialPackageNamesResId, Handler handler) {
 61         LocationProviderProxy proxy = new LocationProviderProxy(context, name, action,                                                                                                                  
 62                 overlaySwitchResId, defaultServicePackageNameResId, initialPackageNamesResId,
 63                 handler);
 64         if (proxy.bind()) {
 65             return proxy;
 66         } else {
 67             return null;
 68         }
 69     }            
 70 
 71     private LocationProviderProxy(Context context, String name, String action,
 72             int overlaySwitchResId, int defaultServicePackageNameResId,
 73             int initialPackageNamesResId, Handler handler) {
 74         mContext = context;
 75         mName = name;
 76         mServiceWatcher = new ServiceWatcher(mContext, TAG + "-" + name, action, overlaySwitchResId,
 77                 defaultServicePackageNameResId, initialPackageNamesResId,
 78                 mNewServiceWork, handler);
 79     }        

```
- 在ServiceWatcher的start方法里，执行了bindBestPackageLocked这个关键的方法，在这个方法里，先去给intent设置之前提到的Action，
然后根据传来的包名去查询service，如果前面使用了字符串数组，那么包名就是空的，接着对遍历出来的service做签名效验。
```
147     public boolean start() {
148         if (isServiceMissing()) return false;
149 
150         synchronized (mLock) {
151             bindBestPackageLocked(mServicePackageName, false);
152         }
153 
154         // listen for user change
155         IntentFilter intentFilter = new IntentFilter();
156         intentFilter.addAction(Intent.ACTION_USER_SWITCHED);
157         intentFilter.addAction(Intent.ACTION_USER_UNLOCKED);
158         mContext.registerReceiverAsUser(new BroadcastReceiver() {
159             @Override
160             public void onReceive(Context context, Intent intent) {
161                 final String action = intent.getAction();
162                 final int userId = intent.getIntExtra(Intent.EXTRA_USER_HANDLE,
163                         UserHandle.USER_NULL);
164                 if (Intent.ACTION_USER_SWITCHED.equals(action)) {
165                     switchUser(userId);
166                 } else if (Intent.ACTION_USER_UNLOCKED.equals(action)) {
167                     unlockUser(userId);
168                 }
169             }
170         }, UserHandle.ALL, intentFilter, null, mHandler);
171                                                                                                                                                                                                         
172         // listen for relevant package changes if service overlay is enabled.
173         if (mServicePackageName == null) {
174             mPackageMonitor.register(mContext, null, UserHandle.ALL, true);
175         }
176 
177         return true;
178     }

```
- 找到bestComponent后，就会调用bindToPackageLocked方法
```
201     private boolean bindBestPackageLocked(String justCheckThisPackage, boolean forceRebind) {                                                                                                           
202         Intent intent = new Intent(mAction);
203         if (justCheckThisPackage != null) {
204             intent.setPackage(justCheckThisPackage);
205         }
206         final List<ResolveInfo> rInfos = mPm.queryIntentServicesAsUser(intent,
207                 PackageManager.GET_META_DATA | PackageManager.MATCH_DEBUG_TRIAGED_MISSING,
208                 mCurrentUserId);
209         int bestVersion = Integer.MIN_VALUE;
210         ComponentName bestComponent = null;
211         boolean bestIsMultiuser = false;
212         if (rInfos != null) {
213             for (ResolveInfo rInfo : rInfos) {
214                 final ComponentName component = rInfo.serviceInfo.getComponentName();
215                 final String packageName = component.getPackageName();
216 
217                 // check signature
218                 try {
219                     PackageInfo pInfo;
220                     pInfo = mPm.getPackageInfo(packageName, PackageManager.GET_SIGNATURES
221                             | PackageManager.MATCH_DEBUG_TRIAGED_MISSING);
222                     if (!isSignatureMatch(pInfo.signatures)) {
223                         Log.w(mTag, packageName + " resolves service " + mAction
224                                 + ", but has wrong signature, ignoring");
225                         continue;
226                     }
227                 } catch (NameNotFoundException e) {
228                     Log.wtf(mTag, e);
229                     continue;
230                 }
231 
232                 // check metadata
233                 int version = Integer.MIN_VALUE;
234                 boolean isMultiuser = false;
235                 if (rInfo.serviceInfo.metaData != null) {
236                     version = rInfo.serviceInfo.metaData.getInt(
237                             EXTRA_SERVICE_VERSION, Integer.MIN_VALUE);
238                     isMultiuser = rInfo.serviceInfo.metaData.getBoolean(EXTRA_SERVICE_IS_MULTIUSER);
239                 }
240 
241                 if (version > bestVersion) {
242                     bestVersion = version;
243                     bestComponent = component;
244                     bestIsMultiuser = isMultiuser;
245                 }
246             }
248             if (D) {
249                 Log.d(mTag, String.format("bindBestPackage for %s : %s found %d, %s", mAction,
250                         (justCheckThisPackage == null ? ""
251                                 : "(" + justCheckThisPackage + ") "), rInfos.size(),
252                         (bestComponent == null ? "no new best component"
253                                 : "new best component: " + bestComponent)));
254             }
255         } else {
256             if (D) Log.d(mTag, "Unable to query intent services for action: " + mAction);
257         }
258 
259         if (bestComponent == null) {
260             Slog.w(mTag, "Odd, no component found for service " + mAction);
261             unbindLocked();
262             return false;
263         }
264 
265         final int userId = bestIsMultiuser ? UserHandle.USER_SYSTEM : mCurrentUserId;
266         final boolean alreadyBound = Objects.equals(bestComponent, mBoundComponent)
267                 && bestVersion == mBoundVersion && userId == mBoundUserId;
268         if (forceRebind || !alreadyBound) {
269             unbindLocked();
270             bindToPackageLocked(bestComponent, bestVersion, userId);
271         }
272         return true;
273     }               

```
在这里又调用了bindServiceAsUser方法，去绑定第三方NLP里的Service，随后就会回调自己的onServiceConnected方法，
因为它本身是个ServiceConnection，在回调方法里会执行mNewServiceWork，它是由LocationProviderProxy提供的一个Runnable对象

- mNewServiceWork是由LocationProviderProxy提供的一个Runnable对象
```
   private Runnable mNewServiceWork = new Runnable() {
 99         @Override
100         public void run() {
101             if (D) Log.d(TAG, "applying state to connected service");
102                                                                                                                                                                                                         
103             boolean enabled;
104             ProviderProperties properties = null;
105             ProviderRequest request;
106             WorkSource source;
107             ILocationProvider service;
108             synchronized (mLock) {
109                 enabled = mEnabled;
110                 request = mRequest;
111                 source = mWorksource;
112                 service = getService();
113             }
114 
115             if (service == null) return;
116 
117             try {
118                 // load properties from provider
119                 properties = service.getProperties();
120                 if (properties == null) {
121                     Log.e(TAG, mServiceWatcher.getBestPackageName() +
122                             " has invalid locatino provider properties");
123                 }
124 
125                 // apply current state to new service
126                 if (enabled) {
127                     service.enable();
128                     if (request != null) {
129                         service.setRequest(request, source);
130                     }
131                 }
132             } catch (RemoteException e) {
133                 Log.w(TAG, e);
134             } catch (Exception e) {
135                 // never let remote service crash system server
136                 Log.e(TAG, "Exception from " + mServiceWatcher.getBestPackageName(), e);
137             }
138 
139             synchronized (mLock) {
140                 mProperties = properties;
141             }
142         }
143     };

```
获取属性信息，把这些属性统一封装在类型为ProviderProperties的对象中，并回调enable方法，如果客户端有请求，
则回调setRequest方法，这里要注意的是这些回调方法的对象是ILocationProvider，而不是NLP提供商。把NLP添加到可用provider之后，又添加了融合定位的provider和GeocoderProvider，GeocoderProvider和NLP的代理过程类似，至此LocationManagerService的初始化流程就算是结束了


# 总结
要想使用NLP完成定位，只能通过和地图资源商进行商务合作或者取得授权，才能够合法地放入网络定位的相关底层应用和分发使用权，否则会被视为侵权使用。openthos应该是没有，这里也就谈不上真假设备切换了！
