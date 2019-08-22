- 在LINUX系统中，每个设备文件都是文件。音频设备也是一样，它的设备文件被放在/dev/snd目录下，我们来看下这些设备文件：
```
ls /dev/snd -l
crw-rw----+ 1 root audio 116,  2 5月  19 21:24 controlC0
crw-rw----+ 1 root audio 116,  4 6月   6 19:31 pcmC0D0c
crw-rw----+ 1 root audio 116,  3 6月  11 11:53 pcmC0D0p
crw-rw----+ 1 root audio 116,  1 5月  19 21:24 seq
crw-rw----+ 1 root audio 116, 33 5月  19 21:24 timer
```
(1)controlC0: 音频控制设备文件，例如通道选择，混音，麦克风的控制等
(2)pcmC0D0c: 声卡0设备0的录音设备，c表示capter；

(3)pcmC0D0p: 声卡0设备0的播音设备，p表示play；

(4)seq: 音序器设备；

(5)timer:定时器设备。

-  snd_minor
```
struct snd_minor {
	int type;			/* SNDRV_DEVICE_TYPE_XXX */
	int card;			/* card number */
	int device;			/* device number */
	const struct file_operations *f_ops;	/* file operations */
	void *private_data;		/* private data for f_ops->open */
	struct device *dev;		/* device for sysfs */
	struct snd_card *card_ptr;	/* assigned card instance */
}
```

-  cat /proc/asound/cards
```
linux@ubuntu:/proc/asound$ cat cards 
 0 [PCH            ]: HDA-Intel - HDA Intel PCH
                      HDA Intel PCH at 0xa1310000 irq 144
 1 [Audio          ]: USB-Audio - USB Audio
                      Generic USB Audio at usb-0000:00:14.0-8.4, high speed
 2 [Dummy          ]: Dummy - Dummy
                      Dummy 1

```
