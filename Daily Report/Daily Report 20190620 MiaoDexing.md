- Sttings.Global.putInt(resolver, packageName + AppOpsManager.OP_CAMERA, 0);
- /data/system/users/0，该目录的settings_global.xml，settings_secure.xml和settings_system.xml三个xml文件就是SettingsProvider中的数据文件
- frameworks/base/core/java/android/provider/Settings.java
-
```
 2224          /**
 2225          * Look up a name in the database.
 2226          * @param resolver to access the database with
 2227          * @param name to look up in the table
 2228          * @return the corresponding value, or null if not present
 2229          */
 2230         public static String getString(ContentResolver resolver, String name) {
 2231             return getStringForUser(resolver, name, UserHandle.myUserId());
 2232         }
 ```

- 
```
 2297         /**
 2298          * Convenience function for retrieving a single system settings value
 2299          * as an integer.  Note that internally setting values are always
 2300          * stored as strings; this function converts the string to an integer
 2301          * for you.  The default value will be returned if the setting is
 2302          * not defined or not an integer.
 2303          *
 2304          * @param cr The ContentResolver to access.
 2305          * @param name The name of the setting to retrieve.
 2306          * @param def Value to return if the setting is not defined.
 2307          *
 2308          * @return The setting's current value, or 'def' if it is not defined
 2309          * or not a valid integer.
 2310          */
 2311         public static int getInt(ContentResolver cr, String name, int def) {
 2312             return getIntForUser(cr, name, def, UserHandle.myUserId());
 2313         }


```
