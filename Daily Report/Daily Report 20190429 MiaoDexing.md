-1 、frameworks/base/media/java/android/media/AudioRecord.java

```
619         String packageName = ActivityThread.currentPackageName();
620         final ContentResolver resolver = ((Context) ActivityThread.
621                     currentActivityThread().getSystemContext()).getContentResolver();
622         int audioState = Settings.Global.getInt(
623                     resolver, packageName + AppOpsManager.OP_RECORD_AUDIO, 0);
624         SystemProperties.set("audio.use_fake", String.valueOf(audioState));
625 
626         // start recording



```
- 2、frameworks/base/media/java/android/media/MediaRecord.java

```
755         String packageName = ActivityThread.currentPackageName();
 756         final ContentResolver resolver = ((Context) ActivityThread.
 757                     currentActivityThread().getSystemContext()).getContentResolver();
 758         int audioState = Settings.Global.getInt(
 759                     resolver, packageName + AppOpsManager.OP_RECORD_AUDIO, 0);
 760         SystemProperties.set("audio.use_fake", String.valueOf(audioState));
 761 
 762         _prepare();

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
