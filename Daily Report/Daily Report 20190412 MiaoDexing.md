- 1、混音以track为源，mainBuffer为目标，frameCount为一次混音长度。AudioMixer最多能维护32个track。

- 2、frameworks/av/services/audioflinger/Threads.cpp.cpp
```
AudioFlinger::PlaybackThread::mixer_state AudioFlinger::DirectOutputThread::prepareTracks_l(
    Vector< sp<Track> > *tracksToRemove
)
{
    size_t count = mActiveTracks.size();
    mixer_state mixerStatus = MIXER_IDLE;
    bool doHwPause = false;
    bool doHwResume = false;

    // find out which tracks need to be processed
    for (const sp<Track> &t : mActiveTracks) {
        if (t->isInvalid()) {
            ALOGW("An invalidated track shouldn't be in active list");
            tracksToRemove->add(t);
            continue;
        }


```

- 3 、frameworks/av/services/audioflinger/Threads.cpp.cpp

```
// PlaybackThread::createTrack_l() must be called with AudioFlinger::mLock held
sp<AudioFlinger::PlaybackThread::Track> AudioFlinger::PlaybackThread::createTrack_l(
        const sp<AudioFlinger::Client>& client,
        audio_stream_type_t streamType,
        uint32_t sampleRate,
        audio_format_t format,
        audio_channel_mask_t channelMask,
        size_t *pFrameCount,
        const sp<IMemory>& sharedBuffer,
        audio_session_t sessionId,
        audio_output_flags_t *flags,
        pid_t tid,
        uid_t uid,
        status_t *status,
        audio_port_handle_t portId)
{

```
