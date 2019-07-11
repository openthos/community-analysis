# 存在的问题
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
 685         perms.add(PosixFilePermission.OTHERS_WRITE);
 686         perms.add(PosixFilePermission.OTHERS_EXECUTE);
 687         try {
 688             Path path = Paths.get(file.getAbsolutePath());
 689             Files.setPosixFilePermissions(path, perms);
 690         } catch (IOException e) {
 691             Slog.wtf(LOG_TAG,  "Change file " + file.getAbsolutePath() + " permission failed.", e);
 692         }                                                                                                                                                                                              
 693     }


````
