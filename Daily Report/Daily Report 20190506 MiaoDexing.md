# 关于不同应用分别设置各自音量的可行性探讨
- 1、在Android8.1系统中，播放声音可以使用 MediaPlayer 和 AudioTrack，两者都提供 Java API 给应用开发者使用。两者的差别在于：MediaPlayer 可以播放多种格式的音源，如 mp3、flac、wma、ogg、wav 等，而 AudioTrack 只能播放解码后的 PCM 数据流。但实际上MediaPlayer 在 Native 层会创建对应的音频解码器和一个 AudioTrack，解码后的数据交由 AudioTrack 输出。
- 2、AudioFlinger 音频流管理由 AudioFlinger::PlaybackThread::Track 实现，Track 与 AudioTrack 是一对一的关系，一个 AudioTrack 创建后，那么 AudioFlinger 会创建一个 Track 与之对应；PlaybackThread 与 AudioTrack/Track 是一对多的关系，一个 PlaybackThread 可以挂着多个 Track。具体来说：AudioTrack 创建后，AudioPolicyManager 根据 AudioTrack 的输出标识和流类型，找到对应的输出流设备和 PlaybackThread（如果没有找到的话，则系统会打开对应的输出流设备并新建一个 PlaybackThread），然后创建一个 Track 并挂到这个 PlaybackThread 下面。
- 3、PlaybackThread 有两个私有成员向量与此强相关：
  -  mTracks：该 PlaybackThread 创建的所有 Track 均添加保存到这个向量中
  -  mActiveTracks：只有需要播放（设置了 ACTIVE 状态）的 Track 会添加到这个向量中；PlaybackThread 会从该向量上找到所有设置了 ACTIVE 状态的 Track，把这些 Track 数据混音后写到输出流设备<br>
- 4、AudioFlinger::PlaybackThread::Track：音频流管理类，创建一块匿名共享内存用于 AudioTrack 与 AudioFlinger 之间的数据交换，
同时实现 start()、stop()、pause() 等音频流常用控制手段；多个 Track 对象可能都注册到同一个 PlaybackThread 中（尤其对于 MixerThread 而言，一个 MixerThread 往往挂着多个 Track 对象），这多个 Track 对象都会添加到 PlaybackThread.mTracks 向量中统一管理
  也就是说，当音乐播放时，根据流类型，创建多个Track，混音时，将这些Track挂到MixerThread下，而在MixerThread是统一设置音量的
 - 5、AudioTrack：Android 音频系统对外提供的一个 API 类，负责音频流数据输出；每个音频流对应着一个 AudioTrack 实例，
 不同输出标识的 AudioTrack 会匹配到不同的 AudioFlinger::PlaybackThread；
 AudioTrack 与 AudioFlinger::PlaybackThread 之间通过 FIFO 来交换音频数据，AudioTrack 是 FIFO 生产者，AudioFlinger::PlaybackThread 是 FIFO 消费者
# 思考：
- 在Android中，流类型相同，那么device唯一，而且多个音频源都是由一个混音线程完成混音输出，而在混音线程中设置了音量，所以想在混音线程中分别设置每个音频源的音量是不可能的
- 既然所有同类型的音频流是由一个混音线程来完成混音输出，如果想做到各个应用的音量设置互不影响，那么单纯依靠一个混音线程是不可能的，那就需要每个音频源各自对应一个线程？
- 如果采用上述方案，但是声卡只有一个，如何解决设备占用？采用分时？
- 而在Windows 8 系统中是可以分别设置每个应用的音量的，个人觉得是windows是一个分时操作系统，每个应用应该是分时操作一块声卡

-  AudioTrack 与 AudioFlinger::PlaybackThread 之间通过 FIFO 来交换音频数据，AudioTrack 是 FIFO 生产者，AudioFlinger::PlaybackThread 是 FIFO 消费者
，如何解决生产者与消费者的问题？
- 另外，音量的调节是依赖AudioManager中的setStreamVolume方法，此方法原型有三个参数，如果要实现各个应用的音量分别控制，那么此方法必须重写，需要在底层知道是哪一个应用在调节音量。
## 目前市面上还没有哪一款Android系统实现此功能，这确实是一个创新，但是事有两面性，为什么没有人做，是没有市场需求还是难度较大？
