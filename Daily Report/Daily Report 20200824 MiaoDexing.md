# Android 跳转WIFI设置页面的方式及优缺点
## 方式一：显示Intent
```
Intent i = new Intent();

if (Build.VERSION.SDK_INT >= 11) { //Honeycomb

    i.setClassName("com.android.settings", "com.android.settings.Settings$WifiSettingsActivity");

} else {//other versions
     i.setClassName("com.android.settings", "com.android.settings.wifi.WifiSettings");

}

startActivity(i);
```
### 优点：
不会被劫持，可以直接跳转到系统的wifi设置页面。

### 缺点：
需要适配，不同厂商的不同版本的设备都可能存在差异，比如vivo,oppo,gionee,容易导致crash。

## 方式二：隐式Intent
```
Intent i = new Intent();

i = new Intent(Settings.ACTION_WIFI_SETTINGS);

startActivity(i);
```
### 优点：
无需适配。（暂未发现例外）

### 缺点：
可能会被wifi相关的app劫持。

### 建议
如果没有避免intent劫持的硬性要求的话，最好还是使用隐式intent，这样可以最大程度的避免crash的产生；如果一定要用显式intent的话，首先要尽可能多的在不同厂商不同版本的机型上进行测试，并且强烈建议对crash进行捕获，因为总会有适配不到的机型。特别需要注意的是，即使ComponentName componentName = intent.resolveActivity(getPackageManager()); 中的componentName ！= null，在startActivity（intent）时，依然可能出现crash。
