- 1、frameworks/av/services/audioflinger/Threads.cpp
```
// prepareTracks_l() must be called with ThreadBase::mLock held
AudioFlinger::PlaybackThread::mixer_state AudioFlinger::MixerThread::prepareTracks_l(
        Vector< sp<Track> > *tracksToRemove)
{
......
            //分别设置左右声道音量
            mAudioMixer->setParameter(name, param, AudioMixer::VOLUME0, &vlf);
            mAudioMixer->setParameter(name, param, AudioMixer::VOLUME1, &vrf);
......



```
- 2、与刘晓旭一起研究camera在FrameWork层如何将权限设置与HAL关联
- 3、开会讨论权限管理解决方案
