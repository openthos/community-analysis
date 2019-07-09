# 发现的问题
- camera开发使用的分别是Java api 和 NDK开发，如果是java api开发，在CameraManager中可以通过settings.global读取xml文件并设置系统属性来完成设备切换
- NDK开发，通过log跟踪，确定每次摄像头打开，都会调用CameraService中的connectHelper方法，因此希望在此方法中解析/data/system/users/0/settings_global.xml
中的信息并通过设置系统属性来完成设备切换

# 再次探索在C++中完成xml解析
- 目前使用的是tinyxml2完成xml解析
  - 第一步：在external/tinyxml2/tinyxml2.h中添加方法QueryStringAttribute
  ```
  int QueryStringAttribute(const char* name, const char** value) const   { const XMLAttribute* a = FindAttribute(name); if (!a) { return XML_NO_ATTRIBUTE;} *value = a->Value(); return XML_SUCCESS; 

  ```
  - 第二步：frameworks/av/services/camera/libcameraservice/Android.mk
  ```
      LOCAL_C_INCLUDES += \
           system/media/private/camera/include \
           frameworks/native/include/media/openmax \
           external/tinyxml2


      LOCAL_SHARED_LIBRARIES:= \
             .......
      
             libtinyxml2 \
      
             .......

  ```
  - 第三步：在frameworks/av/services/camera/libcameraservice/CameraService.cpp中的connectHelper方法添加
  
  ```
   String8 clientName8(clientPackageName);
    String8 key = clientName8 + ".permission.camera";
    tinyxml2::XMLDocument doc; 
    if (doc.LoadFile(SETTINGS) == 0) { 
        tinyxml2::XMLElement* root = doc.FirstChildElement();
        if (root) {
            tinyxml2::XMLElement *dictEle = root->FirstChildElement();
            //if (dictEle) {
             while(dictEle) {
                const char *value = (const char *)malloc(64);
                if (dictEle->QueryStringAttribute("name",&value) == 0) { 
                    ALOGW("mdx------value %s",value);
                    if (strcmp(value,key) == 0) { 
                        dictEle->QueryStringAttribute("value",&value);
                        ALOGW("mdx------key value %s",value);
                        if (strcmp(value,"phy_camera") == 0) { 
                            property_set("persist.camera.use_fake", "phy_camera");
                         } else if (strcmp(value,"vir_camera") == 0) {                                                                                                                                      
                             property_set("persist.camera.use_fake", "vir_camera");
                         }    

                        break;
                    }    
                    dictEle = dictEle->NextSiblingElement();
                }    
            }    
        }    
    } else {
        ALOGE("LoadFile error!!!!");
    }    

  
  ```
