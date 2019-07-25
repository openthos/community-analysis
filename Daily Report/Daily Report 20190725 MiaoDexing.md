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
  -  onProviderDisabled：当provider不可用时被触发，比如定位模式切换到了使用使用网络定位时GPSProvider就会回调该方法；

 5、 获取位置信息，调用监听方法，不过在获取位置前先判断一下要调用的provider是否可用；
  ```
    if (mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
     locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 5,10, locationListener);
    }
  ```
