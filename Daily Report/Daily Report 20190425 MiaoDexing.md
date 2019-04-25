# Android中的音量调节调研
## 流的定义
- Android中，音量都是分开控制，各种流定义各种流的音量。在Android8.0中，定义了11种流类型。对每种流类型都定义了最大音量（MAX_STREAM_VOLUME），默认音量（DEFAULT_STREAM_VOLUME）和最小音量（MIN_STREAM_VOLUME）。一个流也可以用另外一个流的音量设置，所以需要一个别名映射。
-  最大音量
```
frameworks/base/services/core/java/com/android/server/audio/AudioService.java

    private static int[] MAX_STREAM_VOLUME = new int[] {
        5,  // STREAM_VOICE_CALL
        7,  // STREAM_SYSTEM
        7,  // STREAM_RING
        15, // STREAM_MUSIC
        7,  // STREAM_ALARM
        7,  // STREAM_NOTIFICATION
        15, // STREAM_BLUETOOTH_SCO
        7,  // STREAM_SYSTEM_ENFORCED
        15, // STREAM_DTMF
        15, // STREAM_TTS
        15  // STREAM_ACCESSIBILITY
    };
```
-  最小音量
```
* frameworks/base/services/core/java/com/android/server/audio/AudioService.java

    private static int[] MIN_STREAM_VOLUME = new int[] {
        1,  // STREAM_VOICE_CALL
        0,  // STREAM_SYSTEM
        0,  // STREAM_RING
        0,  // STREAM_MUSIC
        0,  // STREAM_ALARM
        0,  // STREAM_NOTIFICATION
        0,  // STREAM_BLUETOOTH_SCO
        0,  // STREAM_SYSTEM_ENFORCED
        0,  // STREAM_DTMF
        0,  // STREAM_TTS
        0   // STREAM_ACCESSIBILITY
    };
```
-  默认音量
```
* frameworks/base/media/java/android/media/AudioSystem.java

    public static int[] DEFAULT_STREAM_VOLUME = new int[] {
        4,  // STREAM_VOICE_CALL
        7,  // STREAM_SYSTEM
        5,  // STREAM_RING
        11, // STREAM_MUSIC
        6,  // STREAM_ALARM
        5,  // STREAM_NOTIFICATION
        7,  // STREAM_BLUETOOTH_SCO
        7,  // STREAM_SYSTEM_ENFORCED
        11, // STREAM_DTMF
        11, // STREAM_TTS
        11, // STREAM_ACCESSIBILITY
    };

```
-  别名映射
<br>Android中各种设备的映射不尽相同，Android中定义了3中设备DEFAULT，VOICE，TELEVISION对应的别名映射。（STREAM_VOLUME_ALIAS_VOICE）。
<br>TREAM_VOLUME_ALIAS_VOICE对应能处理能处理Voice的设备，比如电话，请映射如下：
```
* frameworks/base/services/core/java/com/android/server/audio/AudioService.java

    private final int[] STREAM_VOLUME_ALIAS_VOICE = new int[] {
        AudioSystem.STREAM_VOICE_CALL,      // STREAM_VOICE_CALL
        AudioSystem.STREAM_RING,            // STREAM_SYSTEM
        AudioSystem.STREAM_RING,            // STREAM_RING
        AudioSystem.STREAM_MUSIC,           // STREAM_MUSIC
        AudioSystem.STREAM_ALARM,           // STREAM_ALARM
        AudioSystem.STREAM_RING,            // STREAM_NOTIFICATION
        AudioSystem.STREAM_BLUETOOTH_SCO,   // STREAM_BLUETOOTH_SCO
        AudioSystem.STREAM_RING,            // STREAM_SYSTEM_ENFORCED
        AudioSystem.STREAM_RING,            // STREAM_DTMF
        AudioSystem.STREAM_MUSIC,           // STREAM_TTS
        AudioSystem.STREAM_MUSIC            // STREAM_ACCESSIBILITY
    };
```
STREAM_VOLUME_ALIAS_TELEVISION对应电视，机顶盒等。
```
* frameworks/base/services/core/java/com/android/server/audio/AudioService.java

    private final int[] STREAM_VOLUME_ALIAS_TELEVISION = new int[] {
        AudioSystem.STREAM_MUSIC,       // STREAM_VOICE_CALL
        AudioSystem.STREAM_MUSIC,       // STREAM_SYSTEM
        AudioSystem.STREAM_MUSIC,       // STREAM_RING
        AudioSystem.STREAM_MUSIC,       // STREAM_MUSIC
        AudioSystem.STREAM_MUSIC,       // STREAM_ALARM
        AudioSystem.STREAM_MUSIC,       // STREAM_NOTIFICATION
        AudioSystem.STREAM_MUSIC,       // STREAM_BLUETOOTH_SCO
        AudioSystem.STREAM_MUSIC,       // STREAM_SYSTEM_ENFORCED
        AudioSystem.STREAM_MUSIC,       // STREAM_DTMF
        AudioSystem.STREAM_MUSIC,       // STREAM_TTS
        AudioSystem.STREAM_MUSIC        // STREAM_ACCESSIBILITY
    };
```
STREAM_VOLUME_ALIAS_DEFAULT其实和Voice映射是一样的，对应其他的设备，比如平板等。
```
    private final int[] STREAM_VOLUME_ALIAS_DEFAULT = new int[] {
        AudioSystem.STREAM_VOICE_CALL,      // STREAM_VOICE_CALL
        AudioSystem.STREAM_RING,            // STREAM_SYSTEM
        AudioSystem.STREAM_RING,            // STREAM_RING
        AudioSystem.STREAM_MUSIC,           // STREAM_MUSIC
        AudioSystem.STREAM_ALARM,           // STREAM_ALARM
        AudioSystem.STREAM_RING,            // STREAM_NOTIFICATION
        AudioSystem.STREAM_BLUETOOTH_SCO,   // STREAM_BLUETOOTH_SCO
        AudioSystem.STREAM_RING,            // STREAM_SYSTEM_ENFORCED
        AudioSystem.STREAM_RING,            // STREAM_DTMF
        AudioSystem.STREAM_MUSIC,           // STREAM_TTS
        AudioSystem.STREAM_MUSIC            // STREAM_ACCESSIBILITY
    };
```
映射关系如下：
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/%E6%98%A0%E5%B0%84%E5%85%B3%E7%B3%BB.png)
<br>所以在手机设备中，从上表来看，我们能调节的其实就5个音量。当你想调节STREAM_SYSTEM，STREAM_NOTIFICATION等流类型的音量时，实际上是调节了STREAM_RING的音量。当前可控的流类型可以通过下表更直观地显示：<br>

![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/2019-04-25%2016-38-01%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE.png)

