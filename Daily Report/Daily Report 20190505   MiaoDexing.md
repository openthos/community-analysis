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
