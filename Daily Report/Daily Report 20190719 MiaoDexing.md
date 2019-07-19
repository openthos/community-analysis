# PROTECTION_NORMAL类权限
- 当用户安装或更新应用时，系统将授予应用所请求的属于 PROTECTION_NORMAL 的所有权限（安装时授权的一类基本权限）。这类权限包括：

android.permission.ACCESS LOCATIONEXTRA_COMMANDS <br>
android.permission.ACCESS NETWORKSTATE <br>
android.permission.ACCESS NOTIFICATIONPOLICY <br>
android.permission.ACCESS WIFISTATE <br>
android.permission.ACCESS WIMAXSTATE <br>
android.permission.BLUETOOTH <br>
android.permission.BLUETOOTH_ADMIN <br>
android.permission.BROADCAST_STICKY <br>
android.permission.CHANGE NETWORKSTATE <br>
android.permission.CHANGE WIFIMULTICAST_STATE <br>
android.permission.CHANGE WIFISTATE <br>
android.permission.CHANGE WIMAXSTATE <br>
android.permission.DISABLE_KEYGUARD <br>
android.permission.EXPAND STATUSBAR <br>
android.permission.FLASHLIGHT <br>
android.permission.GET_ACCOUNTS <br>
android.permission.GET PACKAGESIZE <br>
android.permission.INTERNET <br>
android.permission.KILL BACKGROUNDPROCESSES <br>
android.permission.MODIFY AUDIOSETTINGS <br>
android.permission.NFC <br>
android.permission.READ SYNCSETTINGS <br>
android.permission.READ SYNCSTATS <br>
android.permission.RECEIVE BOOTCOMPLETED <br>
android.permission.REORDER_TASKS <br>
android.permission.REQUEST INSTALLPACKAGES <br>
android.permission.SET TIMEZONE <br>
android.permission.SET_WALLPAPER <br>
android.permission.SET WALLPAPERHINTS <br>
android.permission.SUBSCRIBED FEEDSREAD <br>
android.permission.TRANSMIT_IR <br>
android.permission.USE_FINGERPRINT <br>
android.permission.VIBRATE <br>
android.permission.WAKE_LOCK <br>
android.permission.WRITE SYNCSETTINGS <br>
com.android.alarm.permission.SET_ALARM <br>
com.android.launcher.permission.INSTALL_SHORTCUT <br>
com.android.launcher.permission.UNINSTALL_SHORTCUT <br>

这类权限只需要在AndroidManifest.xml中简单声明这些权限就好，安装时就授权。不需要每次使用时都检查权限，而且用户不能取消以上授权。

# 权限控制组

Permission Group|Permissions
---|---|
CALENDAR| · READ_CALENDAR <br>  · WRITE_CALENDAR
CAMERA| · CAMERA
CONTACTS|· READ_CONTACTS <br>· WRITE_CONTACTS <br>· GET_ACCOUNTS
LOCATION | 	· ACCESS_FINE_LOCATION <br>· ACCESS_COARSE_LOCATION
MICROPHONE | 	· RECORD_AUDIO
PHONE |· READ_PHONE_STATE <br> · CALL_PHONE <br> · READ_CALL_LOG <br> · WRITE_CALL_LOG <br> · ADD_VOICEMAIL <br> · USE_SIP <br> · PROCESS_OUTGOING_CALLS
SENSORS |    BODY_SENSORS
SMS | · SEND_SMS <br> · RECEIVE_SMS <br> · READ_SMS <br> · RECEIVE_WAP_PUSH <br> · RECEIVE_MMS
STORAGE | · READ_EXTERNAL_STORAGE <br> · WRITE_EXTERNAL_STORAGE
