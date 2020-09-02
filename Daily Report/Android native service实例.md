# Android native service 
- 项目结构：位于frameworks\native\services\thinking_test下
- 代码结构说明：
  -  service：native service的主体，即服务的实现部分

  -  server：native service的载体，即启动和注册服务的部分。

  -  client：客户端程序，服务调用封装。

  -  test：测试client
  
---
- service
  -  ThinkingService.h

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

   -   ThinkingService.cpp
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
