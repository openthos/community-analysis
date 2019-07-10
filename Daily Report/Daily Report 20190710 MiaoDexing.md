# SettingsProvider
- SettingsProvider顾名思义是一个提供设置数据共享的Provider，SettingsProvider和Android系统其它Provider有很多不一样的地方，如：

  -  SettingsProvider只接受int、float、string等基本类型的数据；
  -  SettingsProvider由Android系统framework进行了封装，使用更加快捷方便
  -  SettingsProvider的数据由键值对组成
- SettingsProvider有点类似Android的properties系统（Android属性系统）：SystemProperties。SystemProperties除具有SettingsProvider以上的三个特性，SettingsProvider和SystemProperties的不同点在于：

   -   数据保存方式不同：SystemProperties的数据保存属性文件中（/system/build.prop等），开机后会被加载到system properties store；SettingsProvider的数据保存在文件/data/system/users/0/settings_***.xml和数据库settings.db中；
   -   作用范围不同：SystemProperties可以实现跨进程、跨层次调用，即底层的c/c++可以调用，java层也可以调用；SettingProvider只能能在java层（APP）使用；
   -   公开程度不同：SettingProvider有部分功能上层第三方APP可以使用，SystemProperties上层第三方APP不可以使用。
用一句话概括SettingsProvider的作用，SettingsProvider包含全局性、系统级别的用户编好设置。在手机中有一个Settings应用，用户可以在Settings里面做很多设备的设置，这些用户偏好的设置很多就保存在SettingsProvider中。例如，飞行模式。

- 在Android 6.0版本时，SettingsProvider被重构，Android从性能、安全等方面考虑，把SettingsProvider中原本保存在settings.db中的数据，目前全部保存在XML文件中。

## 数据分类
- SettingsProvider对数据进行了分类，分别是Global、System、Secure三种类型，它们的区别如下：

  -   Global：所有的偏好设置对系统的所有用户公开，第三方APP有读没有写的权限；
  -   System：包含各种各样的用户偏好系统设置；
  -   Secure：安全性的用户偏好系统设置，第三方APP有读没有写的权限。

## 分析
- frameworks/base/packages/SettingsProvider/src/com/android/providers/settings/SettingsProvider.java
   -   getSettingsFile()方法获取到一个File对象的实例，如下：
```
private File getSettingsFile(int key) {
    if (isGlobalSettingsKey(key)) {
        final int userId = getUserIdFromKey(key);
        return new File(Environment.getUserSystemDirectory(userId),
                SETTINGS_FILE_GLOBAL);
    } else if (isSystemSettingsKey(key)) {
        final int userId = getUserIdFromKey(key);
        return new File(Environment.getUserSystemDirectory(userId),
                SETTINGS_FILE_SYSTEM);
    } else if (isSecureSettingsKey(key)) {
        final int userId = getUserIdFromKey(key);
        return new File(Environment.getUserSystemDirectory(userId),
                SETTINGS_FILE_SECURE);
    } else {
        throw new IllegalArgumentException("Invalid settings key:" + key);
    }
}
```
- 上面的代码中对Global、System、Secure分别生成一个File对象实例，它们的File对象分别对应的文件是：

   -   /data/system/users/0/settings_global.xml
   -   /data/system/users/0/settings_system.xml
   -   /data/system/users/0/settings_secure.xml


也就是说，Global类型的数据保存在文件settings_global.xml中，System类型的数据保存在文件settings_system.xml中，Secure类型的数据保存在文件settings_secure.xml中。

- frameworks/base/packages/SettingsProvider/src/com/android/providers/settings/SettingsState.java
   -   migrateLegacySettingsLocked()方法执行完毕后，调用systemSettings.persistSyncLocked()，systemSettings是SettingsState的实例，代表的是settings_system.xml所有的设置项，persistSyncLocked()方法就是把systemSettings持有的所有的设置项从内存中固化到文件settings_system.xml中。migrateLegacySettingsForUserLocked()方法中省略的代码，就是和上文的这几个方法一样，把settings_global.xml、settings_secure.xml两个文件中的所有设置项封装到Setting中，被SettingsState持有。也就是说，settings_global.xml、settings_secure.xml、settings_system.xml三个文件的所有设置项间接被SettingsState持有，而SettingsState又被封装到类SettingsProvider.java的变量mSettingsStates中，mSettingsStates是SparseArray”SettingsState”的实例。
   -   https://blog.csdn.net/myfriend0/article/details/59107989
##  基于上述分析做出以下改动：
- persistSyncLocked()方法就是把systemSettings持有的所有的设置项从内存中固化到文件，在migrateLegacySettingsLocked方法中使用globalSettings.persistSyncLocked()固话设置项到文件时，实际调用的是doWriteState()方法。为了不污染原有文件，在此方法中当完成/data/system/users/0/settings_global.xml文件的永久化之后，将其拷贝到指定目录下
- 因settings_global.xml文件属于system组，拷贝后cameraserver仍没有权力访问
   - 所以使用Java NIO方式完成权限更改，例如：
   ```
   private void changeFolderPermission(File dirFile) throws IOException {
    Set<PosixFilePermission> perms = new HashSet<PosixFilePermission>();
    perms.add(PosixFilePermission.OWNER_READ);
    perms.add(PosixFilePermission.OWNER_WRITE);
    perms.add(PosixFilePermission.OWNER_EXECUTE);
    perms.add(PosixFilePermission.GROUP_READ);
    perms.add(PosixFilePermission.GROUP_WRITE);
    perms.add(PosixFilePermission.GROUP_EXECUTE);
    perms.add(PosixFilePermission.OTHERS_READ);
    perms.add(PosixFilePermission.OTHERS_WRITE);
    perms.add(PosixFilePermission.OTHERS_EXECUTE);
    try {
        Path path = Paths.get(dirFile.getAbsolutePath());
        Files.setPosixFilePermissions(path, perms);
    } catch (Exception e) {
        logger.log(Level.SEVERE, "Change folder " + dirFile.getAbsolutePath() + " permission failed.", e);
        }
    }
   ```
   
