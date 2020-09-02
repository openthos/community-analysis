# Android native service 
- 项目结构：位于frameworks\native\services\thinking_test下
- 代码结构说明：
  -  service：native service的主体，即服务的实现部分

  -  server：native service的载体，即启动和注册服务的部分。

  -  client：客户端程序，服务调用封装。

  -  test：测试client
  
---
- service
1. ThinkingService.h

```
    #ifndef THINKING_SERVICE_H
    #define THINKING_SERVICE_H
     
    #include <utils/RefBase.h>
    #include <binder/IInterface.h>
    #include <binder/Parcel.h>
     
    #include <android/log.h>
    #define LOGE(...) __android_log_print(ANDROID_LOG_ERROR  , "ProjectName", __VA_ARGS__)
     
    namespace android{
    	class ThinkingService : public BBinder
    	{
    		private:
    		
    		public:
    		//单例模式
    		static int Instance();
    		ThinkingService();
    		virtual ~ThinkingService();
    		//预定义通信方法，签名写死
    		//参数意义是：通信状态，输入参数，输出参数，执行状态
    		virtual status_t onTransact(uint32_t, const Parcel&, Parcel*, uint32_t);
    	};
    }
     
    #endif
```
2. ThinkingService.cpp
```
    #include <binder/IServiceManager.h>
    #include <binder/IPCThreadState.h>
    #include "ThinkingService.h"
     
    namespace android
    {
    	static pthread_key_t sigbuskey;
    	int ThinkingService::Instance()
    	{
    		LOGE("-----------ThinkingService-->Instance \n");
    		int ret=defaultServiceManager()->addService( String16("thinking.svc"),new ThinkingService());
    		LOGE("-----------ThinkingService-->Instance %d \n",ret);
    		return ret;
    	}
    	
    	ThinkingService::ThinkingService()
    	{
    		LOGE("-----------ThinkingService");
    		pthread_key_create(&sigbuskey,NULL);
    	}
    	
    	ThinkingService::~ThinkingService()
    	{
    		LOGE("-----------~ThinkingService");
    		pthread_key_delete(sigbuskey);
    	}
    	
    	status_t ThinkingService::onTransact(uint32_t code, const Parcel& data, Parcel* reply, uint32_t flags)
    	{
    		switch(code)
    		{
    			case 0:
    			{
    				int a=data.readInt32();
    				int b=data.readInt32();
    				reply->writeInt32(a*b);
    				return NO_ERROR;
    			}
    			default:
    				return BBinder::onTransact(code, data, reply, flags);
    		}
    	}
    }
  ```
---

- server
1. ThinkingServer.cpp
```
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <grp.h>
#include <binder/IPCThreadState.h>
#include <binder/ProcessState.h>
#include <binder/IServiceManager.h>
#include <utils/Log.h>
#include "../service/ThinkingService.h"
 
using namespace android;
 
int main(int arg, char** argv)
{
	printf("ThinkingService start register \n");
	sp<ProcessState> proc(ProcessState::self());
        sp<IServiceManager> sm = defaultServiceManager();
	int ret=ThinkingService::Instance();
	ProcessState::self()->startThreadPool();
	IPCThreadState::self()->joinThreadPool();
	return 0;
}
```

---

- client
1. ThinkingClient.h
```
    #ifndef THINKING_CLIENT_H
    #define THINKING_CLIENT_H
     
    namespace android
    {
    	class ThinkingClient
    	{
    		public:
    		int setData(int a,int b);
    		private:
    		static void getThinkingService();
    	};
    }
     
    #endif
```

2. ThinkingClient.cpp
```
#include <binder/IServiceManager.h>
#include <binder/IPCThreadState.h>
#include "ThinkingClient.h"
 
namespace android
{
	sp<IBinder> binder;
	
	int ThinkingClient::setData(int a,int b)
	{
		getThinkingService();
		Parcel data,reply;
		data.writeInt32(a);
		data.writeInt32(b);
		binder->transact(0, data, &reply);
		int result=reply.readInt32();
		return result;
	}
	
	void ThinkingClient::getThinkingService()
	{
		sp<IServiceManager> sm = defaultServiceManager();
                binder = sm->getService(String16("thinking.svc"));
		if(binder == 0)
			return;
	}
}
```

---

- test
1. test.cpp
```
#include <stdio.h>
#include "../client/ThinkingClient.h"
 
using namespace android;
 
int main(int argc, char** argv)
{
	ThinkingClient client;
	int result=client.setData(1,2);
	printf("result is %d \n",result);
	return 0;
}
```
---

- Android.bp

```
cc_library_shared {                                                                                                                                                                                         
        name: "libThinkingService",

        srcs: [
            "ThinkingService.cpp",
        ],

        shared_libs: [
            "libcutils",
            "libutils",
            "libbinder",
        ],

        cflags: [
            "-Wall",
            "-Werror",
            "-Wunused",
            "-Wunreachable-code",
        ],

}


cc_binary {
    name: "ThinkingServer",
    srcs: ["ThinkingServer.cpp"],
   
    shared_libs: [
        "libutils",
        "libbinder",
        "libThinkingService",
    ], 
}

cc_library_shared {   
    name: "libThinkingClient",
   
    srcs: ["ThinkingClient.cpp"],
   
    shared_libs: [
        "libutils",
        "libbinder",
    ], 
}

cc_binary {   
     name: "ThinkingTest",
     srcs: ["test.cpp"],
     shared_libs: ["libThinkingClient"],
   
}

```
---
- 添加至平台相关mk文件
1、 device/tinghua/openthos/openthos.mk
```
PRODUCT_PACKAGES += \
......
	libThinkingService \
	libThinkingClient \
	ThinkingServer \
	ThinkingTest \
......
```
---
- 测试
将最新的system.img烧写至设备。
1、 打开第一个终端
```
openthos:/ # ThinkingServer &                                                  
[1] 3430
openthos:/ # ThinkingService start register 
-----------ThinkingService-->Instance 
-----------ThinkingService-----------ThinkingService-->Instance 0 

```
2、另一个终端：
```
openthos:/ # ThinkingTest                                            
result is 2 

```
