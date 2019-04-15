# 基本概念
- AudioPolicyService 与 AudioFlinger 是 Android 音频系统的两大基本服务。前者是音频系统策略的制定者，负责音频设备切换的策略抉择、音量调节策略等；后者是音频系统策略的执行者，负责音频流设备的管理及音频流数据的处理传输，所以 AudioFlinger 也被认为是 Android 音频系统的引擎。
  - AudioResampler.cpp：重采样处理类，可进行采样率转换和声道转换；由录制线程 AudioFlinger::RecordThread 直接使用
  - AudioMixer.cpp：混音处理类，包括重采样、音量调节、声道转换等，其中的重采样复用了 AudioResampler；由回放线程 AudioFlinger::MixerThread 直接使用
  - Tracks.cpp：音频流管理类，可控制音频流的状态，如 start、stop、pause
  - Threads.cpp：回放线程和录制线程类；回放线程从 FIFO 读取回放数据并混音处理，然后写数据到输出流设备；录制线程从输入流设备读取录音数据并重采样处理，然后写数据到 FIFO
  - AudioFlinger.cpp：AudioFlinger 对外提供的服务接口
![blockchain](https://github.com/openthos/community-analysis/blob/master/Daily%20Report/audio.png)
