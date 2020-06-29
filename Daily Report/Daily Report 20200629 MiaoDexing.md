# android 10.0 Launcher3 去掉抽屉式,显示所有 app
## 修改思路
1、增加全局控制变量 sys.launcher3.is_full_app，用来动态切换

2、增加两套布局，对应有抽屉和无抽屉

3、去除 allAppsButton

4、将 AllAppsContainerView 中的图标加载到 Workspace

5、新安装的 app 自动添加图标到 Workspace

6、替换 Workspace 图标长按删除选项为取消

7、屏蔽上拉显示抽屉页面手势

8、修改页面指示线为圆点
## 代码
### 1、增加全局控制变量 sys.launcher3.is_full_app
1) 在 LauncherAppState 中增加静态方法 isDisableAllApps(), 通过修改 Settings 中自定义的值 sys.launcher3.is_full_app
- packages\apps\Launcher3\src\com\android\launcher3\LauncherAppState. java
```
private static  Context mContext;
 
public static boolean isDisableAllApps() {
        if (mContext != null) {
            return Settings.System.getInt(mContext.getContentResolver(), 
                "sys.launcher3.is_full_app", 0) == 1;
        }
        return true;
    }

```
2）AndroidManifest-common.xml 中增加权限
- packages\apps\Launcher3\AndroidManifest-common.xml
```
<uses-permission android:name="android.permission.WRITE_SETTINGS" />
```

3） 在 SettingsActivity 中增加 SwitchPreference 用以动态修改 sys.launcher3.is_full_app，
在内部类 LauncherSettingsFragment 中重写 onPreferenceTreeClick() 用以监听 SwitchPreference 点击
- packages\apps\Launcher3\src\com\android\launcher3\SettingsActivity.java
```
/**
     * This fragment shows the launcher preferences.
     */
    public static class LauncherSettingsFragment extends PreferenceFragment {
    
    .....
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
 
    ....
 
            //读取保存的值，初始化 SwitchPreference 的初始状态，是否选中
            int isFull = Settings.System.getInt(getActivity().getContentResolver(), 
                "sys.launcher3.is_full_app", 0);
            Log.d("Launcher3", "sys.launcher3.is_full_app="+isFull);
            SwitchPreference fullSwitch = (SwitchPreference) findPreference("pref_is_full_app");
            fullSwitch.setChecked(isFull==1);
     }
 
 
    
    //add for change is_full_app value
    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
            boolean result = true;
            final String key = preference.getKey();
 
             if ("pref_is_full_app".equals(key)) {
                boolean checked = ((SwitchPreference) preference).isChecked();
 
                Settings.System.putInt(getActivity().getContentResolver(), "sys.launcher3.is_full_app",
                        checked ? 1 : 0);
 
                Log.e("Launcher3", "SwitchPreference checked="+checked);
 
                // Value has changed
                ProgressDialog.show(getActivity(),
                        null /* title */,
                        getActivity().getString(R.string.full_app_override_progress),
                        true /* indeterminate */,
                        false /* cancelable */);
                new LooperExecutor(LauncherModel.getWorkerLooper()).execute(
                        new OverrideApplyHandler(getActivity()));
                
            }
            return result;
        }
 
}

```
点击 SwitchPreference 后需要保存 sys.launcher3.is_full_app 新值，同时清除 Launcher3 的缓存，延时启动并结束当前进程

清除缓存方法 clearApplicationUserData 在 Launcher3 中编译报错，所以通过发送广播到 Setting 中进行真正的清缓存操作
```
 //add for change is_full_app value
    private static class OverrideApplyHandler implements Runnable {
 
        private final Context mContext;
 
        private OverrideApplyHandler(Context context) {
            mContext = context;
        }
 
        @Override
        public void run() {
            // Clear the icon cache.
            LauncherAppState.getInstance(mContext).getIconCache().clear();
 
            // Wait for it
            try {
                Thread.sleep(1000);
            } catch (Exception e) {
                Log.e("Launcher3", "Error waiting", e);
            }
 
            // Schedule an alarm before we kill ourself.
            Intent homeIntent = new Intent(Intent.ACTION_MAIN)
                    .addCategory(Intent.CATEGORY_HOME)
                    .setPackage(mContext.getPackageName())
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            PendingIntent pi = PendingIntent.getActivity(mContext, 42,
                    homeIntent, PendingIntent.FLAG_CANCEL_CURRENT | PendingIntent.FLAG_ONE_SHOT);
            mContext.getSystemService(AlarmManager.class).setExact(
                    AlarmManager.ELAPSED_REALTIME, SystemClock.elapsedRealtime() + 50, pi);
 
            //clear data will kill process
            Intent intent = new Intent("com.android.action.CLEAR_APP_DATA");
            intent.putExtra("pkgName", "com.android.launcher3");
            intent.addFlags(0x01000000);
            mContext.sendBroadcast(intent);
            Log.i("Launcher3", "Clearing user data com.android.launcher3");
 
            // Kill process
            android.os.Process.killProcess(android.os.Process.myPid());
        }
    }

```
4） SettingsActivity 对应的 xml 文件修改 launcher_preferences
- packages\apps\Launcher3\res\xml\launcher_preferences.xml
```
<SwitchPreference
        android:key="pref_is_full_app"
        android:title="@string/is_full_app_title"
        android:summary="@string/is_full_app_desc"
        android:defaultValue="false"
        android:persistent="true" />
对应的 string 文件就不贴了，自己增加下就行
```
### 增加两套布局，对应有抽屉和无抽屉
加载布局文件对应的 xml 为packages\apps\Launcher3\res\xml\device_profiles.xml

Launcher3 通过获取 minWidthDps 和 minHeightDps 来确定加载哪一个 profile，我的平板分辨率是 1280*800 的，增加两个 profile 节点
```
<profile
        launcher:name="Tablet"
        launcher:minWidthDps="376"
        launcher:minHeightDps="586"
        launcher:numRows="4"
        launcher:numColumns="5"
        launcher:numFolderRows="4"
        launcher:numFolderColumns="5"
        launcher:iconSize="50"
        launcher:iconTextSize="11"
        launcher:numHotseatIcons="5"
        launcher:defaultLayoutId="@xml/default_workspace_tb_5x6"
        />
 
    <profile
        launcher:name="Tablet_no_all_app"
        launcher:minWidthDps="380"
        launcher:minHeightDps="590"
        launcher:numRows="4"
        launcher:numColumns="5"
        launcher:numFolderRows="4"
        launcher:numFolderColumns="5"
        launcher:iconSize="50"
        launcher:iconTextSize="11"
        launcher:numHotseatIcons="4"
        launcher:defaultLayoutId="@xml/default_workspace_tb_5x6_no_all_app"
        />


```

对应的你需要在 xml 文件下增加 4 个文件，分别是 default_workspace_tb_5x6.xml dw_hotseat_tb.xml default_workspace_tb_5x6_no_all_app.xml dw_hotseat_tb_no_all_app.xml

这样的好处是你可以自定义不同的布局文件加载内容，上面的配置含义简单说一下，分别是最小宽度、最小高度、布局的行和列、文件夹中布局行和列、图标大小、图标文字大小、HotSeat 个数，加载的布局文件

