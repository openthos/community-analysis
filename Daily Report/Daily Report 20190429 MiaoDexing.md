-1 、frameworks/base/media/java/android/media/AudioRecord.java

```
import android.os.SystemProperties;
import android.provider.Settings;
import android.content.Context;
import android.content.ContentResolver;


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
 987         String packageName = ActivityThread.currentPackageName();
 988         String  audio = SystemProperties.get(packageName + ".permission.record_audio","phy_audio");
 989         Log.w(TAG, "mdx--------audio " + audio);
 990         SystemProperties.set("audio.use_fake", audio);                                                                                                                                                        
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
import android.provider.Settings;
import android.content.Context;
import android.content.ContentResolver;


969         String packageName = ActivityThread.currentPackageName();
 970         String  audio = SystemProperties.get(packageName + ".permission.record_audio","phy_audio"); 
 971         Log.w(TAG, "mdx--------audio " + audio);
 972         SystemProperties.set("audio.use_fake", audio);

 _prepare();

```

- 3、 hardware/libaudio/audio_hw.c
```
162 static short UNSET_BUFFER[1024] = {0};

511     buffer->frame_count = (buffer->frame_count > in->frames_in) ?
512                                 in->frames_in : buffer->frame_count;
513     buffer->i16 = property_get_bool("audio.use_fake", 0) ? UNSET_BUFFER :
514                   in->buffer + (in->pcm_config->period_size - in->frames_in);
515 
516     return in->read_status;


```
