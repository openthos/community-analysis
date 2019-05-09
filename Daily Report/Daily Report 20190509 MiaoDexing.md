- 1、
```
PlaybackThread设置mStreamTypes的volume,并唤醒PlaybackThread线程

void AudioFlinger::PlaybackThread::setStreamVolume(audio_stream_type_t stream, float value)
{
    Mutex::Autolock _l(mLock);
    mStreamTypes[stream].volume = value;
    broadcast_l();
}

```
- 2、不同类型的Thread有不同的使用方法，MixerThread是在prepareTracks_l里使用，最后会设置AudioMixer的参数
- 3、最终音量=主音量*流音量
- 4、在系统静音时，只是很简单的设置下列参数为0：

    vl = vr = 0；vlf = vrf = vaf = 0.

    设置AudioMixer的参数

    mAudioMixer->setParameter(name, param,AudioMixer::VOLUME0, &vlf);

    mAudioMixer->setParameter(name, param,AudioMixer::VOLUME1, &vrf);

    所以最后还是通过AudioMixer真正去乘以VOLUME0和VOLUME1来设置音量。
- 5、Android中的流类型与音频管理策略有关，例如：<br>
     音频流的音量管理，调节一个类型的音频流音量，不会影响到其他类型的音频流

     根据流类型选择合适的输出设备；比如插着有线耳机期间，音乐声（STREAM_MUSIC）只会输出到有线耳机，而铃声（STREAM_RING）会同时输出到有线耳机和外放
