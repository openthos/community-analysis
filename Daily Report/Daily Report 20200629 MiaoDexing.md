# android 9.0 Launcher3 去掉抽屉式,显示所有 app
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
1） 加载布局文件对应的 xml 为packages\apps\Launcher3\res\xml\device_profiles.xml

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

2） 在 InvariantDeviceProfile() 判断是否需要加载 Tablet_no_all_app profile

- packages\apps\Launcher3\src\com\android\launcher3\InvariantDeviceProfile.java
```
public InvariantDeviceProfile(Context context) {
 
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        DisplayMetrics dm = new DisplayMetrics();
        display.getMetrics(dm);
 
        Point smallestSize = new Point();
        Point largestSize = new Point();
        display.getCurrentSizeRange(smallestSize, largestSize);
 
        // This guarantees that width < height
        minWidthDps = Utilities.dpiFromPx(Math.min(smallestSize.x, smallestSize.y), dm);
        minHeightDps = Utilities.dpiFromPx(Math.min(largestSize.x, largestSize.y), dm);
        Log.i("Launcher3.profiles", "orignalminWidthDps="+minWidthDps + "  orignalminHeightDps="+minHeightDps);
        
        //add for load no_all_app xml
        if (LauncherAppState.isDisableAllApps()) {
            Log.e("Launcher3.profiles", "load no all app profiles");
            //对应 device_profiles.xml 中 Tablet_no_all_app 的值
            minWidthDps = 380.0f;
            minHeightDps = 590.0f;
        }
        .....
}
```
### 去除 allAppsButton
1） 将 resetLayout() 中 FeatureFlags.NO_ALL_APPS_ICON 替换为 LauncherAppState.isDisableAllApps()
- packages\apps\Launcher3\src\com\android\launcher3\Hotseat.java

```
void resetLayout(boolean hasVerticalHotseat) {
        mContent.removeAllViewsInLayout();
        mHasVerticalHotseat = hasVerticalHotseat;
        InvariantDeviceProfile idp = mLauncher.getDeviceProfile().inv;
        if (hasVerticalHotseat) {
            mContent.setGridSize(1, idp.numHotseatIcons);
        } else {
            mContent.setGridSize(idp.numHotseatIcons, 1);
        }
 
        //if (!FeatureFlags.NO_ALL_APPS_ICON) {
        /// add for check is need allappbutton
        if (!LauncherAppState.isDisableAllApps()) {
            // Add the Apps button
            Context context = getContext();
            DeviceProfile grid = mLauncher.getDeviceProfile();
 
        ...
}

```
### 将 AllAppsContainerView 中的图标加载到 Workspace
run() 中增加判断，添加 verifyApplications(), 修改 InstallShortcutReceiver 中 PendingInstallShortcutInfo 为 public
- packages\apps\Launcher3\src\com\android\launcher3\model\LoaderTask.java
```

public void run() {
        synchronized (this) {
            // Skip fast if we are already stopped.
            if (mStopped) {
                return;
            }
        }
        ....
 
        // second step
        TraceHelper.partitionSection(TAG, "step 2.1: loading all apps");
        loadAllApps();
 
        //add for load all app on workspace
        if (LauncherAppState.isDisableAllApps()) {
            android.util.Log.e("Launcher3", "verifyApplications()");
            verifyApplications();
        }
 
        ....
}
 
 //add for load all app on workspace
private void verifyApplications() {
        final Context context = mApp.getContext();
        ArrayList<Pair<ItemInfo, Object>> installQueue = new ArrayList<>();
        final List<UserHandle> profiles = mUserManager.getUserProfiles();
        for (UserHandle user : profiles) {
            final List<LauncherActivityInfo> apps = mLauncherApps.getActivityList(null, user);
            ArrayList<InstallShortcutReceiver.PendingInstallShortcutInfo> added = new ArrayList<InstallShortcutReceiver.PendingInstallShortcutInfo>();
            synchronized (this) {
                for (LauncherActivityInfo app : apps) {
                    InstallShortcutReceiver.PendingInstallShortcutInfo pendingInstallShortcutInfo = new InstallShortcutReceiver.PendingInstallShortcutInfo(app, context);
                    added.add(pendingInstallShortcutInfo);
                    installQueue.add(pendingInstallShortcutInfo.getItemInfo());
                }
            }
            if (!added.isEmpty()) {
                mApp.getModel().addAndBindAddedWorkspaceItems(installQueue);
            }
        }
    }


```
注释 run() 中的 return
- packages\apps\Launcher3\src\com\android\launcher3\model\BaseModelUpdateTask.java
```
@Override
    public final void run() {
        if (!mModel.isModelLoaded()) {
            if (DEBUG_TASKS) {
                Log.d(TAG, "Ignoring model task since loader is pending=" + this);
            }
            // Loader has not yet run.
            //annotaion for load all app on workspace
            // return;
        }
        execute(mApp, mDataModel, mAllAppsList);
    }

```

### 新安装的 app 自动添加图标到 Workspace
execute() 中增加判断，添加 updateToWorkSpace()
- packages\apps\Launcher3\src\com\android\launcher3\model\PackageUpdatedTask.java
```

public void execute(LauncherAppState app, BgDataModel dataModel, AllAppsList appsList) {
 
    ....
 
     final ArrayList<AppInfo> addedOrModified = new ArrayList<>();
    addedOrModified.addAll(appsList.added);
        
    //add for load new install app on workspace 
    if (LauncherAppState.isDisableAllApps()) {
        android.util.Log.e("cczLauncher3", "updateToWorkSpace()");
        updateToWorkSpace(context, app, appsList);
    }
    
    ...
}
 
//add for load new install app on workspace
public void updateToWorkSpace(Context context, LauncherAppState app , AllAppsList appsList){
         ArrayList<Pair<ItemInfo, Object>> installQueue = new ArrayList<>();
        final List<UserHandle> profiles = UserManagerCompat.getInstance(context).getUserProfiles();
        ArrayList<InstallShortcutReceiver.PendingInstallShortcutInfo> added 
        = new ArrayList<InstallShortcutReceiver.PendingInstallShortcutInfo>();
        
        for (UserHandle user : profiles) {
            final List<LauncherActivityInfo> apps = LauncherAppsCompat.getInstance(context).getActivityList(null, user);
            synchronized (this) {
                for (LauncherActivityInfo info : apps) {
                    for (AppInfo appInfo : appsList.added) {
                        if(info.getComponentName().equals(appInfo.componentName)){
                            InstallShortcutReceiver.PendingInstallShortcutInfo mPendingInstallShortcutInfo 
                            =  new InstallShortcutReceiver.PendingInstallShortcutInfo(info,context);
                            added.add(mPendingInstallShortcutInfo);
                            installQueue.add(mPendingInstallShortcutInfo.getItemInfo());
                        }
                    }
                }
}
        }
        if (!added.isEmpty()) {
            app.getModel().addAndBindAddedWorkspaceItems(installQueue);
        }
    }
```

### 替换 Workspace 图标长按删除选项为取消

在 setTextBasedOnDragSource() 、setControlTypeBasedOnDragSource()、onAccessibilityDrop() 中分别增加判断是否需要删除图标
- packages\apps\Launcher3\src\com\android\launcher3\DeleteDropTarget.java
```
private void setTextBasedOnDragSource(ItemInfo item) {
        if (!TextUtils.isEmpty(mText)) {
            mText = getResources().getString(item.id != ItemInfo.NO_ID
                    ? R.string.remove_drop_target_label
                    : android.R.string.cancel);
            //add for hide deletedroptarget
            if (LauncherAppState.isDisableAllApps()) {
                android.util.Log.e("Launcher3", "hide delete drop target");
                mText = getResources().getString(isCanDrop(item)
                            ? R.string.remove_drop_target_label
                            : android.R.string.cancel);
            }
 
            requestLayout();
        }
    }
 
    private void setControlTypeBasedOnDragSource(ItemInfo item) {
        mControlType = item.id != ItemInfo.NO_ID ? ControlType.REMOVE_TARGET
                : ControlType.CANCEL_TARGET;
 
        //add for hide deletedroptarget [S]
        if (LauncherAppState.isDisableAllApps()) {
            mControlType = isCanDrop(item) ? ControlType.REMOVE_TARGET
                : ControlType.CANCEL_TARGET;
        }        
    }
 
public void onAccessibilityDrop(View view, ItemInfo item) {
        // Remove the item from launcher and the db, we can ignore the containerInfo in this call
        // because we already remove the drag view from the folder (if the drag originated from
        // a folder) in Folder.beginDrag()
        //add if juge is need remove item from workspace
        if (!LauncherAppState.isDisableAllApps() || isCanDrop(item)) {
            mLauncher.removeItem(view, item, true /* deleteFromDb */);
            mLauncher.getWorkspace().stripEmptyScreens();
            mLauncher.getDragLayer()
                    .announceForAccessibility(getContext().getString(R.string.item_removed));
        }
}
 
private boolean isCanDrop(ItemInfo item){
        return !(item.itemType == LauncherSettings.Favorites.ITEM_TYPE_APPLICATION ||
                item.itemType == LauncherSettings.Favorites.ITEM_TYPE_FOLDER);
}
```

drop() 中增加判断，取消当前拖拽操作
- packages\apps\Launcher3\src\com\android\launcher3\dragndrop\DragController.java
```
private void drop(DropTarget dropTarget, Runnable flingAnimation) {
    ....
 
    boolean accepted = false;
        if (dropTarget != null) {
            dropTarget.onDragExit(mDragObject);
            if (dropTarget.acceptDrop(mDragObject)) {
                if (flingAnimation != null) {
                    flingAnimation.run();
                } else {
                    dropTarget.onDrop(mDragObject, mOptions);
                }
                accepted = true;
 
                //add for cancel canceldroptarget handle
                if (LauncherAppState.isDisableAllApps() && dropTarget instanceof DeleteDropTarget &&
                        isNeedCancelDrag(mDragObject.dragInfo)) {
                    cancelDrag();
                }
            }
        }
        ...
}
 
private boolean isNeedCancelDrag(ItemInfo item){
        return (item.itemType == LauncherSettings.Favorites.ITEM_TYPE_APPLICATION ||
                item.itemType == LauncherSettings.Favorites.ITEM_TYPE_FOLDER);
 }

```

### 屏蔽上拉显示抽屉页面手势

canInterceptTouch() 中增加判断是否直接拦截
- packages\apps\Launcher3\quickstep\src\com\android\launcher3\uioverrides\OverviewToAllAppsTouchController.java
```
@Override
    protected boolean canInterceptTouch(MotionEvent ev) {
        //add for forbidden workspace drag change GradientView alph
        if (LauncherAppState.isDisableAllApps()){
            android.util.Log.e("Launcher3", "canInterceptTouch()");
            return false;
        }  
 
        if (mCurrentAnimation != null) {
            // If we are already animating from a previous state, we can intercept.
            return true;
        }
        if (AbstractFloatingView.getTopOpenView(mLauncher) != null) {
            return false;
        }
        if (mLauncher.isInState(ALL_APPS)) {
            // In all-apps only listen if the container cannot scroll itself
            return mLauncher.getAppsView().shouldContainerScroll(ev);
        } else if (mLauncher.isInState(NORMAL)) {
            return true;
        } else if (mLauncher.isInState(OVERVIEW)) {
            RecentsView rv = mLauncher.getOverviewPanel();
            return ev.getY() > (rv.getBottom() - rv.getPaddingBottom());
        } else {
            return false;
        }
    }
```

### 修改页面指示线为圆点
WorkspacePageIndicator 改为 PageIndicatorDots
- packages\apps\Launcher3\res\layout\launcher.xml

```
<com.android.launcher3.pageindicators.PageIndicatorDots
            android:id="@+id/page_indicator"
            android:layout_width="match_parent"
            android:layout_height="4dp"
            android:layout_gravity="bottom|center_horizontal"
            android:theme="@style/HomeScreenElementTheme" />


```

增加 PageIndicatorDots 继承 Insettable，复写setInsets(), 调整圆点的位置
- packages\apps\Launcher3\src\com\android\launcher3\pageindicators\PageIndicatorDots.java
```
public class PageIndicatorDots extends View implements PageIndicator, Insettable {
 
// add for change WorkspacePageIndicator line to dot
    @Override
    public void setInsets(Rect insets) {
        DeviceProfile grid = mLauncher.getDeviceProfile();
        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) getLayoutParams();
 
        if (grid.isVerticalBarLayout()) {
            Rect padding = grid.workspacePadding;
            lp.leftMargin = padding.left + grid.workspaceCellPaddingXPx;
            lp.rightMargin = padding.right + grid.workspaceCellPaddingXPx;
            lp.bottomMargin = padding.bottom;
        } else {
            lp.leftMargin = lp.rightMargin = 0;
            lp.gravity = Gravity.CENTER_HORIZONTAL | Gravity.BOTTOM;
            lp.bottomMargin = grid.hotseatBarSizePx + insets.bottom;
        }
        setLayoutParams(lp);
    }
 
    @Override
    public void setScroll(int currentScroll, int totalScroll) {
        if (mNumPages > 1) {
            if (mIsRtl) {
                currentScroll = totalScroll - currentScroll;
            }
            int scrollPerPage = totalScroll / (mNumPages - 1);
 
            // add for change WorkspacePageIndicator line to dot
            if (scrollPerPage == 0) {
                return;
            }
            int pageToLeft = currentScroll / scrollPerPage;
            int pageToLeftScroll = pageToLeft * scrollPerPage;
            int pageToRightScroll = pageToLeftScroll + scrollPerPage;
 
        ...
 
}

```

注释 setShouldAutoHide()，避免长按 workSpace 时发生崩溃
- packages\apps\Launcher3\src\com\android\launcher3\states\SpringLoadedState.java
```
@Override
    public void onStateEnabled(Launcher launcher) {
        Workspace ws = launcher.getWorkspace();
        ws.showPageIndicatorAtCurrentScroll();
        //annotaion for WorkspacePageIndicator line to dot
        // ws.getPageIndicator().setShouldAutoHide(false);
 
        // Prevent any Un/InstallShortcutReceivers from updating the db while we are
        // in spring loaded mode
        InstallShortcutReceiver.enableInstallQueue(InstallShortcutReceiver.FLAG_DRAG_AND_DROP);
        launcher.getRotationHelper().setCurrentStateRequest(REQUEST_LOCK);
    }
 
    @Override
    public void onStateDisabled(final Launcher launcher) {
        //annotaion for WorkspacePageIndicator line to dot
        // launcher.getWorkspace().getPageIndicator().setShouldAutoHide(true);
 
        // Re-enable any Un/InstallShortcutReceiver and now process any queued items
        InstallShortcutReceiver.disableAndFlushInstallQueue(
                InstallShortcutReceiver.FLAG_DRAG_AND_DROP, launcher);
    }


```
