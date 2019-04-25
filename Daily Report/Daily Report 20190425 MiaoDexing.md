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
## FrameWork层控制
- 音量调节， 在FrameWork层面，通过流类型找到对应的映射别名streamTypeAlias，然后调用根据streamTypeAlias获取音量类型对应的音量信息状态 streamState，streamState类型是VolumeStreamState，它是音量控制的核心。映射后的每种音量都有各自的VolumeStreamState，它保存了一个流类型所有的音量信息。
- 流各自的VolumeStreamState通过observeDevicesForStream_syncVSS去获取对应的device，observeDevicesForStream_syncVSS的获取到的是一个device列表，最终是通过AudioSystem去native获取的。
- setStreamVolumeIndex根据device和流类型来设置，换言之，每种设备的每种流类型的音量是分开的，可以不一样。比如蓝牙耳机的Music音量可以是15，而Speaker的音量可以是5。

## Native层控制
- 在native会将流转换为策略，根据策略选择设备等。
- native声音流的定义：
```
* system/media/audio/include/system/audio-base.h

typedef enum {
    AUDIO_STREAM_DEFAULT = -1, // (-1)
    AUDIO_STREAM_MIN = 0,
    AUDIO_STREAM_VOICE_CALL = 0,
    AUDIO_STREAM_SYSTEM = 1,
    AUDIO_STREAM_RING = 2,
    AUDIO_STREAM_MUSIC = 3,
    AUDIO_STREAM_ALARM = 4,
    AUDIO_STREAM_NOTIFICATION = 5,
    AUDIO_STREAM_BLUETOOTH_SCO = 6,
    AUDIO_STREAM_ENFORCED_AUDIBLE = 7,
    AUDIO_STREAM_DTMF = 8,
    AUDIO_STREAM_TTS = 9,
    AUDIO_STREAM_ACCESSIBILITY = 10,
    AUDIO_STREAM_REROUTING = 11,
    AUDIO_STREAM_PATCH = 12,
    AUDIO_STREAM_PUBLIC_CNT = 11, // (ACCESSIBILITY + 1)
    AUDIO_STREAM_FOR_POLICY_CNT = 12, // PATCH
    AUDIO_STREAM_CNT = 13, // (PATCH + 1)
} audio_stream_type_t;
```
- 策略定义：
```
* frameworks/av/services/audiopolicy/common/include/RoutingStrategy.h

enum routing_strategy {
    STRATEGY_MEDIA,
    STRATEGY_PHONE,
    STRATEGY_SONIFICATION,
    STRATEGY_SONIFICATION_RESPECTFUL,
    STRATEGY_DTMF,
    STRATEGY_ENFORCED_AUDIBLE,
    STRATEGY_TRANSMITTED_THROUGH_SPEAKER,
    STRATEGY_ACCESSIBILITY,
    STRATEGY_REROUTING,
    NUM_STRATEGIES
};
```
- 相互间的对应关系
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/%E5%AF%B9%E5%BA%94%E5%85%B3%E7%B3%BB.png)

- 根据流类型，获取到策略后，根据策略获取相关的设备。根据device判断是否需要应用音量，音量是通过checkAndSetVolume来生效的。
如果当前没有任何流处在active，音量设置时是没有生效的。如果这个时候没有生效，后续在startSource时，也会checkAndSetVolume。
- 之后在checkAndSetVolume会计算音量值，计算后的Db值通过setVolume函数设置给output，每个output都是按照流类型来保存的mCurVolume[stream] 然后通过mClientInterface的setStreamVolume接口调用mAudioPolicyService->setStreamVolume(stream, volume, output, delay_ms);   在AudioPolicyService通过AudioCommandThread，传给AudioManager。最终还是通过AudioSystem的接口来完成：
```
status_t AudioSystem::setStreamVolume(audio_stream_type_t stream, float value,
        audio_io_handle_t output)
{
    if (uint32_t(stream) >= AUDIO_STREAM_CNT) return BAD_VALUE;
    const sp<IAudioFlinger>& af = AudioSystem::get_audio_flinger();
    if (af == 0) return PERMISSION_DENIED;
    af->setStreamVolume(stream, value, output);
    return NO_ERROR;
}
```
- AudioFlinger的setStreamVolume函数如下：
```
status_t AudioFlinger::setStreamVolume(audio_stream_type_t stream, float value,
        audio_io_handle_t output)
{
    ALOGI("setStreamVolume: stream %d, value %f, output %d", stream, value, output);
    // 权限
    if (!settingsAllowed()) {
        return PERMISSION_DENIED;
    }

    // 流类型
    status_t status = checkStreamType(stream);
    if (status != NO_ERROR) {
        return status;
    }
    ALOG_ASSERT(stream != AUDIO_STREAM_PATCH, "attempt to change AUDIO_STREAM_PATCH volume");

    AutoMutex lock(mLock);
    Vector<VolumeInterface *> volumeInterfaces;
    //获取volumeInterface
    if (output != AUDIO_IO_HANDLE_NONE) {
        VolumeInterface *volumeInterface = getVolumeInterface_l(output);
        if (volumeInterface == NULL) {
            return BAD_VALUE;
        }
        volumeInterfaces.add(volumeInterface);
    }

    // 保存音量Db值
    mStreamTypes[stream].volume = value;

    if (volumeInterfaces.size() == 0) {
        volumeInterfaces = getAllVolumeInterfaces_l();
    }
    // 设置音量值
    for (size_t i = 0; i < volumeInterfaces.size(); i++) {
        volumeInterfaces[i]->setStreamVolume(stream, value);
    }

    return NO_ERROR;
}
```
- VolumeInterface 主要用以设置音量，PlaybackThread和MmapPlaybackThread实现VolumeInterface具体的接口：
```
class VolumeInterface {
 public:

    virtual ~VolumeInterface() {}

    virtual void        setMasterVolume(float value) = 0;
    virtual void        setMasterMute(bool muted) = 0;
    virtual void        setStreamVolume(audio_stream_type_t stream, float value) = 0;
    virtual void        setStreamMute(audio_stream_type_t stream, bool muted) = 0;
    virtual float       streamVolume(audio_stream_type_t stream) const = 0;

};
```
- PlaybackThread的setStreamVolume函数：
```
void AudioFlinger::PlaybackThread::setStreamVolume(audio_stream_type_t stream, float value)
{
    Mutex::Autolock _l(mLock);
    size_t size = mEffectChains.size();
    mStreamTypes[stream].volume = value;
    for (size_t i = 0; i < size; i++) {
        mEffectChains[i]->setStreamVolume_l(stream, value);
    }
    broadcast_l();
}
```
PlaybackThread将音量值保存下来了，并设置到音效中。

- 对于MixerThread来说，是在这里生效的，音量值最终会被混音，设置到数据流中。
```
AudioFlinger::PlaybackThread::mixer_state AudioFlinger::MixerThread::prepareTracks_l(
        Vector< sp<Track> > *tracksToRemove)
{
... ...
            // compute volume for this track
            uint32_t vl, vr;       // in U8.24 integer format
            float vlf, vrf, vaf;   // in [0.0, 1.0] float format
            // read original volumes with volume control
            float typeVolume = mStreamTypes[track->streamType()].volume;
            float v = masterVolume * typeVolume;

            if (track->isPausing() || mStreamTypes[track->streamType()].mute) {
                vl = vr = 0;
                vlf = vrf = vaf = 0.;
                if (track->isPausing()) {
                    track->setPaused();
                }
            } else {
                sp<AudioTrackServerProxy> proxy = track->mAudioTrackServerProxy;
                gain_minifloat_packed_t vlr = proxy->getVolumeLR();
                vlf = float_from_gain(gain_minifloat_unpack_left(vlr));
                vrf = float_from_gain(gain_minifloat_unpack_right(vlr));
                // track volumes come from shared memory, so can't be trusted and must be clamped
                if (vlf > GAIN_FLOAT_UNITY) {
                    ALOGV("Track left volume out of range: %.3g", vlf);
                    vlf = GAIN_FLOAT_UNITY;
                }
                if (vrf > GAIN_FLOAT_UNITY) {
                    ALOGV("Track right volume out of range: %.3g", vrf);
                    vrf = GAIN_FLOAT_UNITY;
                }
                const float vh = track->getVolumeHandler()->getVolume(
                        track->mAudioTrackServerProxy->framesReleased()).first;
                // now apply the master volume and stream type volume and shaper volume
                vlf *= v * vh;
                vrf *= v * vh;
                // assuming master volume and stream type volume each go up to 1.0,
                // then derive vl and vr as U8.24 versions for the effect chain
                const float scaleto8_24 = MAX_GAIN_INT * MAX_GAIN_INT;
                vl = (uint32_t) (scaleto8_24 * vlf);
                vr = (uint32_t) (scaleto8_24 * vrf);
                // vl and vr are now in U8.24 format
                uint16_t sendLevel = proxy->getSendLevel_U4_12();
                // send level comes from shared memory and so may be corrupt
                if (sendLevel > MAX_GAIN_INT) {
                    ALOGV("Track send level out of range: %04X", sendLevel);
                    sendLevel = MAX_GAIN_INT;
                }
                // vaf is represented as [0.0, 1.0] float by rescaling sendLevel
                vaf = v * sendLevel * (1. / MAX_GAIN_INT);
            }
```
