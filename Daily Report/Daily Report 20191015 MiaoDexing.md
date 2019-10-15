# LocationManager
- 该类提供了访问地理位置的服务，可以获取上一次最新的地理位置信息，也可以注册监听事件来周期性的获得设备更新的地理位置信息。在获取地理位置信息时我们必须了解一下两个知识点：
  -  provider
  -  LocationListener
#  provider
- 位置信息的提供者，android系统一般提供三种方式来获取地理位置信息。分别如下：
  -  GPS_PROVIDER：通过gps来获取地理位置的经纬度信息，优点：获取地理位置信息精确度高，缺点：只能在户外使用，获取经纬度信息耗时，耗电。
  -  NETWORK_PROVIDER：通过移动网络的基站或者WiFi来获得地理位置，优点：只要有网络，获取速度快，在室内室外都可以使用。缺点：精确度不高。
  -  PASSIVE_PROVIDER：被动的接收更新的地理位置信息，而不用自己主动请求地理位置。
-  LocationManager类中提供了以下几种方法来获得地理位置提供者。
```
public List<String> getAllProviders();     返回当前设备所有地理位置提供者。

public List<String> getProviders(boolean enabledOnly);  当参数为true时，返回的时当前设备可使用的位置提供者；
当参数为false时和上面那个方法一样，返回所有的位置提供者。

public String getBestProvider(Criteria criteria, boolean enabledOnly);  返回当前设备最符合指定条件的位置提供者，
第一个参数criteria用于指定条件，第二个参数表示是否返回当前设备可用的位置提供者。

public List<String> getProviders(Criteria criteria, boolean enabledOnly);  返回当前符合条件的所有可用的provider。

```
也就是说，访问地理位置的服务，获取地理位置信息都是来自于某个符合条件的provider，每个provider又提供了三种方式来获取地理位置信息。

#  LocationListener
-  LocationManager类中提供了如下方法来获得最新一次更新的地理位置信息。
```
public Location getLastKnownLocation(String provider);   传入相应的 location provider来获得当前地理位置信息。代码示例如下：

LocationManager mLocationManager = (LocationManager)mContext.getSystemService(Context.LOCATION_SERVICE);
mLocationManager.getLastKnownLocation(LocationManager.PASSIVE_PROVIDER);

```
getLastKnownLocation()方法只能一次性的获得当前最新的地理位置，但是它不能实时的监听地理位置的变化情况。Android给开发者提供了一个接口监听类LocationListener来实时监听当前设备的地理位置变化情况。
-  LocationListener用于监听当地理位置有改变时来接收通知的接口类。在使用该监听之前您必须要用LocationManager类中的如下方法来注册该监听事件。
```
public void requestLocationUpdates(String provider, long minTime, float minDistance,
            LocationListener listener)
  以上注册监听方法，参数一：位置提供者；参数二：位置更新最短时间（单位ms）；参数三：位置更新最短距离（单位m）；
  参数四：LocationListener监听器对象。         
```
