# 重要的概念
- AudioPolicyService 与 AudioFlinger 是 Android 音频系统的两大基本服务。前者是音频系统策略的制定者，负责音频设备切换的策略抉择、音量调节策略等；后者是音频系统策略的执行者，负责音频流设备的管理及音频流数据的处理传输，所以 AudioFlinger 也被认为是 Android 音频系统的引擎。
  - AudioResampler.cpp：重采样处理类，可进行采样率转换和声道转换；由录制线程 AudioFlinger::RecordThread 直接使用
  - AudioMixer.cpp：混音处理类，包括重采样、音量调节、声道转换等，其中的重采样复用了 AudioResampler；由回放线程 AudioFlinger::MixerThread 直接使用
  - Tracks.cpp：音频流管理类，可控制音频流的状态，如 start、stop、pause
  - Threads.cpp：回放线程和录制线程类；回放线程从 FIFO 读取回放数据并混音处理，然后写数据到输出流设备；录制线程从输入流设备读取录音数据并重采样处理，然后写数据到 FIFO
 - AudioFlinger.cpp：AudioFlinger 对外提供的服务接口
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/AudioFlinger.png)
 - AudioFlinger 回放录制线程
   - ThreadBase：PlaybackThread 和 RecordThread 的基类
   - RecordThread：录制线程类，由 ThreadBase 派生
   - PlaybackThread：回放线程基类，同由 ThreadBase 派生
   - MixerThread：混音回放线程类，由 PlaybackThread 派生，负责处理标识为 AUDIO_OUTPUT_FLAG_PRIMARY、AUDIO_OUTPUT_FLAG_FAST、AUDIO_OUTPUT_FLAG_DEEP_BUFFER 的音频流，MixerThread 可以把多个音轨的数据混音后再输出
   - DirectOutputThread：直输回放线程类，由 PlaybackThread 派生，负责处理标识为 AUDIO_OUTPUT_FLAG_DIRECT 的音频流，这种音频流数据不需要软件混音，直接输出到音频设备即可
   - DuplicatingThread：复制回放线程类，由 MixerThread 派生，负责复制音频流数据到其他输出设备，使用场景如主声卡设备、蓝牙耳机设备、USB 声卡设备同时输出
   - OffloadThread：硬解回放线程类，由 DirectOutputThread 派生，负责处理标识为 AUDIO_OUTPUT_FLAG_COMPRESS_OFFLOAD 的音频流，这种音频流未经软件解码的（一般是 MP3、AAC 等格式的数据），需要输出到硬件解码器，由硬件解码器解码成 PCM 数据

# 基本思路是根据packageName或者PID找到对应的Track，删除此Track，或者将输出buffer置空
