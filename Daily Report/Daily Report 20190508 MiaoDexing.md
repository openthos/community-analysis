# HAL层中准确识别虚拟摄像头
- 1、查看camera的pid和vid
```
cd /sys/class/video4linux/video0/device/input/
ls
//注意，这里不同的camera是不一样的，我这里是ls后显示input10
cd input10
cat name 得到的是VGA WebCam
cd id
cat vendor
//cat后得到0804，如果是需要pid的话就cat product
```
此处是笔记本自带的物理摄像头

- 2、虚拟摄像头信息在/sys/class/video4linux/video2
cat name 得到 vivid000-vid-cap
- 3、实现在HAL层准确知道虚拟camera
```
        FILE *fp;
 65     char buffer[2];
 66     char devices[12]="/dev/video";
 67     char value[PROPERTY_VALUE_MAX];
 68 
 69     fp=popen("cat /sys/class/video4linux/video*/name | grep -n vivid | head -1 | cut -f 1 -d :", "r");
 70     fgets(buffer,sizeof(buffer),fp);
 71     buffer[0] -= 1;
 72     strcat(devices,buffer);
 73     property_get(CAMERA_USE_FAKE, value, "phy_camera");
 74     if(strcmp(value,"vir_camera") == 0){
 75         if ((fd = open(devices, O_RDWR)) == -1) {
 76             ALOGE("ERROR opening V4L interface %s: %s", devices, strerror(errno));
 77             return -1;
 78         }
 79     }else if(strcmp(value,"phy_camera") == 0){
 80         if ((fd = open(device, O_RDWR)) == -1) {
 81             ALOGE("ERROR opening V4L interface %s: %s", device, strerror(errno));
 82             return -1;
 83         }
 84     }
 85                   
```
