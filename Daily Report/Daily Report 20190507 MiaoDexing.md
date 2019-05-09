# 使用虚拟audio驱动完成权限管理
- 1、frameworks/base/media/java/android/media/AudioRecord.java
```
import android.os.SystemProperties;



 973     //---------------------------------------------------------
 974     // Transport control methods
 975     //--------------------
 976     /**
 977      * Starts recording from the AudioRecord instance.
 978      * @throws IllegalStateException
 979      */
 980     public void startRecording()
 981     throws IllegalStateException {
 982         if (mState != STATE_INITIALIZED) {
 983             throw new IllegalStateException("startRecording() called on an "
 984                     + "uninitialized AudioRecord.");
 985         }
 986 
         SystemProperties.set("audio.use_fake", SystemProperties.get(ActivityThread.currentPackageName() + ".permission.record_audio","phy_audio"));                                                                                                                                                       
 991 
 992         // start recording
 993         synchronized(mRecordingStateLock) {
 994             if (native_start(MediaSyncEvent.SYNC_EVENT_NONE, 0) == SUCCESS) {
 995                 handleFullVolumeRec(true);
 996                 mRecordingState = RECORDSTATE_RECORDING;
 997             }
 998         }
 999     }
```
- 2、frameworks/base/media/java/android/media/MediaRecord.java
```
import android.os.SystemProperties;



 SystemProperties.set("audio.use_fake", SystemProperties.get(ActivityThread.currentPackageName() + ".permission.record_audio","phy_audio"));

             _prepare();
 ```
 - 3、frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
 ```
 3866         if (!permissions.isEmpty()) {                                                                                                                                                                 
 3867             String flag = SystemProperties.get(p.packageName + ".permission.record_audio", "phy_audio");
 3868             if (flag.equals("vir_audio")) {
 3869                 permissions.remove("android.permission.RECORD_AUDIO");
 3870             }
 3871         }

 5691             if(name.contains("RECORD_AUDIO")) {
 5692                 SystemProperties.set(packageName + ".permission.record_audio", "phy_audio");
 5693             }

 5820             if (name.contains("android.permission.RECORD_AUDIO")) {
 5821                 SystemProperties.set(packageName + ".permission.record_audio", "vir_audio");
 5822                 return;
 5823             }

 6120             if (name.contains("android.permission.RECORD_AUDIO")) {
 6121                 String flags = SystemProperties.get(packageName+".permission.record_audio", "phy_audio");
 6122                 if (flags.equals("vir_audio")) return;
 6123             }

```

- 4、hardware/libaudio/audio_hw.c
 ```
 254     struct pcm *pcm = NULL;
 255     char value[PROPERTY_VALUE_MAX];
 256     property_get("audio.use_fake", value,NULL);
 257     if(strcmp(value,"vir_audio") == 0){
 258         pcm = pcm_open(1, 0, flags, config);
 259     }else{
 260         pcm = pcm_open(info->card, info->device, flags, config);
 261     }

 ```
 
