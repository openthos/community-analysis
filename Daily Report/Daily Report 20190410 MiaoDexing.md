# audio_policy.conf配置文件
- 在AudioPolicyManager创建过程中会通过加载audio_policy.conf配置文件来加载音频设备,Android为每种音频接口定义了对应的硬件抽象层。每种音频接口定义了不同的输入输出，一个接口可以具有多个输入或者输出，每个输入输出可以支持不同的设备，通过读取audio_policy.conf文件可以获取系统支持的音频接口参数，在AudioPolicyManager中会优先加载/vendor/etc/audio_policy.conf配置文件, 如果该配置文件不存在, 则加载/system/etc/audio_policy.conf配置文件。AudioPolicyManager加载完所有音频接口后,就知道了系统支持的所有音频接口参数,可以为音频输出提供决策。
audio_policy.conf同时定义了多个audio接口,每一个audio接口包含若干output和input,而每个output和input又同时支持多种输入输出模式,每种输入输出模式又支持若干种设备. 
- audio_policy.conf配置文件分成两部分，第一部分是解析全局标签，第二部分是解析audio_hw_modules标签，其子标签都表示hardware module，有primary和r_submix两种hardware module都被解析到mHwModules，hardware module的子标签有outputs和inputs,outputs的各个子标签被解析到mHwModules 的 mOutputProfiles，inputs的各个子标签被解析到mHwModules 的 mInputProfiles。
- Audio系统中支持的音频设备接口(Audio Interface)分为三大类，即：
/*frameworks/av/services/audioflinger/AudioFlinger.cpp*/
static const char * const audio_interfaces[] = {
   AUDIO_HARDWARE_MODULE_ID_PRIMARY, //主音频设备，必须存在
   
   AUDIO_HARDWARE_MODULE_ID_A2DP, //蓝牙A2DP音频
   
   AUDIO_HARDWARE_MODULE_ID_USB, //USB音频，早期的版本不支持
   
      };

- 每种音频设备接口由一个对应的so库提供支持。AudioFlinger::loadHwModule(const char *name)/*name就是前面audio_interfaces 数组成员中的字符串*/
  - Step1@ loadHwModule_l. 首先查找mAudioHwDevs是否已经添加了变量name所指示的audio interface，如果是的话直接返回。第一次进入时mAudioHwDevs的size为0，所以还会继续往下执行。
  - Step2@ loadHwModule_l. 加载指定的audiointerface，比如“primary”、“a2dp”或者“usb”。函数load_audio_interface用来加载 设备所需的库文件，然后打开设备并创建一个audio_hw_device_t实例。音频接口设备所对应的库文件名称是有一定格式的，比如a2dp的模块 名可能是audio.a2dp.so或者audio.a2dp.default.so等等。查找路径主要有两个，即：
  
      /** Base path of the hal modules */
  
      #define HAL_LIBRARY_PATH1 "/system/lib/hw"
  
      #define HAL_LIBRARY_PATH2 "/vendor/lib/hw"
  - Step3@ loadHwModule_l，进行初始化操作。其中init_check是为了确定这个audio interface是否已经成功初始化，0是成功，其它值表示失败。接下来如果这个device支持主音量，我们还需要通过 set_master_volume进行设置。在每次操作device前，都要先改变mHardwareStatus的状态值，操作结束后将其复原为 AUDIO_HW_IDLE(根据源码中的注释，这样做是为了方便dump时正确输出内部状态，这里我们就不去深究了)。
  - Step4@ loadHwModule_l. 把加载后的设备添加入mAudioHwDevs键值对中，其中key的值是由nextUniqueId生成的，这样做保证了这个audiointerface拥有全局唯一的id号。
