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
 4711         /**
 4712          * Store a name/value pair into the database.
 4713          * @param resolver to access the database with
 4714          * @param name to store
 4715          * @param value to associate with the name
 4716          * @return true if the value was set, false on database errors
 4717          */
 4718         public static boolean putString(ContentResolver resolver, String name, String value) {                                                                                                        
 4719             return putStringForUser(resolver, name, value, UserHandle.myUserId());
 4720         }

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
-
```
4935         /**
 4936          * Convenience function for updating a single settings value as an
 4937          * integer. This will either create a new entry in the table if the
 4938          * given name does not exist, or modify the value of the existing row
 4939          * with that name.  Note that internally setting values are always
 4940          * stored as strings, so this function converts the given value to a
 4941          * string before storing it.
 4942          *
 4943          * @param cr The ContentResolver to access.
 4944          * @param name The name of the setting to modify.
 4945          * @param value The new value for the setting.
 4946          * @return true if the value was set, false on database errors
 4947          */
 4948         public static boolean putInt(ContentResolver cr, String name, int value) {                                                                                                                    
 4949             return putIntForUser(cr, name, value, UserHandle.myUserId());
 4950         }

```
