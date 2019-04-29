- 1、分析audio框架，明确设备打开及其他操作
external/tinyalsa/pcm.c
```
struct pcm *pcm_open(unsigned int card, unsigned int device,
                     unsigned int flags, struct pcm_config *config)
{
    struct pcm *pcm;
    struct snd_pcm_info info;
    struct snd_pcm_hw_params params;
    struct snd_pcm_sw_params sparams;
    char fn[256];
    int rc;

    pcm = calloc(1, sizeof(struct pcm));
    if (!pcm || !config)
        return &bad_pcm; /* TODO: could support default config here */

    pcm->config = *config;

    snprintf(fn, sizeof(fn), "/dev/snd/pcmC%uD%u%c", card, device,
             flags & PCM_IN ? 'c' : 'p');

    pcm->flags = flags;
    pcm->fd = open(fn, O_RDWR|O_NONBLOCK);
    if (pcm->fd < 0) {
        oops(pcm, errno, "cannot open device '%s'", fn);
        return pcm;
    }

。。。。。。
}
```
-2、分析GPS框架，讨论GPS解决方案
