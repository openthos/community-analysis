# 解决文件拷贝后仍无法操作的问题
- 在frameworks/base/packages/SettingsProvider/src/com/android/providers/settings/SettingsState.java的doWriteState()方法中完成文件拷贝和权限更改
```
 644         if (wroteState) {                                                                                                                                                                              
 645             synchronized (mLock) {
 646                 //changeFilePermission(new File("/data/misc/camera/settings_global.xml"));
 647                 copyFile(mStatePersistFile,new File(DATA));
 648                 changeFilePermission(new File(DATA));
 649                 addHistoricalOperationLocked(HISTORICAL_OPERATION_PERSIST, null);
 650             }
 651         }


 655    static void copyFile(File sourceFile,File targetFile) {
 656         byte[] b = new byte[1024];
 657         int len;
 658         BufferedInputStream inBuff = null;
 659         BufferedOutputStream outBuff = null;
 660 
 661         try{
 662             inBuff=new BufferedInputStream(new FileInputStream(sourceFile));
 663             outBuff=new BufferedOutputStream(new FileOutputStream(targetFile));  
 664             while ((len =inBuff.read(b)) != -1) {
 665                 outBuff.write(b, 0, len);
 666             }
 667             outBuff.flush();
 668 
 669             inBuff.close();
 670             outBuff.close();
 671         } catch (IOException e) {
 672             Slog.wtf(LOG_TAG, "Failed to copy settings file!", e);
 673         }
 674     }
 675 
 676     static void changeFilePermission(File file){
 677         Set<PosixFilePermission> perms = new HashSet<PosixFilePermission>();
 678         perms.add(PosixFilePermission.OWNER_READ);
 679         perms.add(PosixFilePermission.OWNER_WRITE);
 680         perms.add(PosixFilePermission.OWNER_EXECUTE);
 681         perms.add(PosixFilePermission.GROUP_READ);
 682         perms.add(PosixFilePermission.GROUP_WRITE);
 683         perms.add(PosixFilePermission.GROUP_EXECUTE);
 684         perms.add(PosixFilePermission.OTHERS_READ);

 687         try {
 688             Path path = Paths.get(file.getAbsolutePath());
 689             Files.setPosixFilePermissions(path, perms);
 690         } catch (IOException e) {
 691             Slog.wtf(LOG_TAG,  "Change file " + file.getAbsolutePath() + " permission failed.", e);
 692         }                                                                                                                                                                                              
 693     }


````

- device/generic/common/init.x86.rc
```
 20 on post-fs-data
 21     mkdir /data/misc/wifi 0770 wifi wifi
 22     mkdir /data/misc/wifi/sockets 0770 wifi wifi
 23     mkdir /data/misc/wifi/wpa_supplicant 0770 wifi wifi
 24     mkdir /data/misc/dhcp 0770 dhcp dhcp
 25     mkdir /data/system 0775 system system
 26     mkdir /data/misc/camera  0775 system  cameraserver           
```
- CameraService.cpp

```
1284 template<class CALLBACK, class CLIENT>
1285 Status CameraService::connectHelper(const sp<CALLBACK>& cameraCb, const String8& cameraId,
1286         int halVersion, const String16& clientPackageName, int clientUid, int clientPid,
1287         apiLevel effectiveApiLevel, bool legacyMode, bool shimUpdateOnly,
1288         /*out*/sp<CLIENT>& device) {
1289     binder::Status ret = binder::Status::ok();
1290 
1291     String8 clientName8(clientPackageName);
1292     String8 key = clientName8 + ".permission.camera";
1293 
1294     tinyxml2::XMLDocument doc;
1295     if (doc.LoadFile(SETTINGS) == 0) {
1296         ALOGW("mdx tinyxml2------LoadFile");                                                                                                                                                           
1297         tinyxml2::XMLElement* root = doc.FirstChildElement();
1298         if (root) {             
1299             ALOGW("mdx tinyxml2------root");
1300             tinyxml2::XMLElement *dictEle = root->FirstChildElement();
1301              while(dictEle) {   
1302                 const char *value = (const char *)malloc(64);
1303                 if (dictEle->QueryStringAttribute("name",&value) == 0) {
1304                         ALOGW("mdx tinyxml2------name %s",value);
1305                     if (strcmp(value,key) == 0) {
1306                         dictEle->QueryStringAttribute("value",&value);
1307                         ALOGW("mdx tinyxml2------value %s",value);
1308                         if (strcmp(value,"phy_camera") == 0) {
1309                             property_set(USE_FAKE, "phy_camera");
1310                          } else if (strcmp(value,"vir_camera") == 0) {
1311                              property_set(USE_FAKE, "vir_camera");
1312                          }   
1313                          
1314                         break;
1315                     }   
1316                     dictEle = dictEle->NextSiblingElement();
1317                 }   
1318             }   
1319         }   
1320     } else {
1321         ALOGE("LoadFile error!!!!");
1322     } 

```
