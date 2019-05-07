- 1、（三）Audio子系统之AudioRecord.startRecording <br>  https://www.cnblogs.com/pngcui/p/10016563.html
- 2、 startRecording最终是通过pcm_open函数打开输入设备的节点，而pcm_open函数的实现在external/tinyalsa下的pcm.c文件中
- 3、函数实现：
```
 875 struct pcm *pcm_open(unsigned int card, unsigned int device,                                                                                            
 876                      unsigned int flags, struct pcm_config *config)
 877 {
 878     struct pcm *pcm;
 879     struct snd_pcm_info info;
 880     struct snd_pcm_hw_params params;
 881     struct snd_pcm_sw_params sparams;
 882     char fn[256];
 883     int rc;
 884 
 885     pcm = calloc(1, sizeof(struct pcm));
 886     if (!pcm || !config)
 887         return &bad_pcm; /* TODO: could support default config here */
 888 
 889     pcm->config = *config;
 890 
 891     snprintf(fn, sizeof(fn), "/dev/snd/pcmC%uD%u%c", card, device,
 892              flags & PCM_IN ? 'c' : 'p');
 893 
 894     pcm->flags = flags;
 895     pcm->fd = open(fn, O_RDWR|O_NONBLOCK);

```
- 4、snd-dummy 设备信息在/proc/asound/Dummy，设备节点在/dev/snd下
- 5、Android中的PCM设备介绍 https://www.cnblogs.com/chenzhizhong/p/6604405.html
  -  那些以pcm打头的设备就是提供播放或录音的设备即要探讨的PCM设备，其他的设备提供效果、合成等功能。
音频设备的命名规则为 [device type]C[card index]D[device index][capture/playback]，即名字中含有4部分的信息：
   -   device type
设备类型，通常只有compr/hw/pcm这3种。从上图可以看到声卡会管理很多设备，PCM设备只是其中的一种设备。
   -   card index
声卡的id，代表第几块声卡。通常都是0，代表第一块声卡。手机上通常都只有一块声卡。
   -   device index
设备的id，代表这个设备是声卡上的第几个设备。设备的ID只和驱动中配置的DAI link的次序有关。如果驱动没有改变，那么这些ID就是固定的。
   -   capture/playback
只有PCM设备才有这部分，只有c和p两种。c代表capture，说明这是一个提供录音的设备，p代表palyback，说明这是一个提供播放的设备。
   -   系统会在/proc/asound/pcm文件中列出所有的音频设备的信息，如果是肉眼查看，/proc/asound/pcm中的信息会更直观一些.
 - 发送Android系统下多应用分别控制音量的可行性分析邮件
