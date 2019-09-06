# ContentProvider启动流程分析（一）
-  作为安卓设计的四大组件之一，是跨进程共享数据的一把利器，所谓跨进程共享数据，通俗理解就是，应用程序A可以访问操作应用程序B共享出来的数据，这些共享出来的数据一般都有其对应的URI（统一资源标识符），那么就涉及到两个过程：<br>

 1、提供数据内容的过程：
   -    A应用（比如系统联系人，日历）如果希望共享自己的数据内容（比如联系人列表，日历信息），就需要通过子类重写ContentProvider六个方法来实现，ContentProvider的六个方法的共性特征是，都接受一个URI参数，通过解析URI参数匹配相应的数据内容并将其返回；
   -   当一个跨进程访问数据的请求（包含RUI参数）发出后，系统首先会校验URI权限（authority），权限校验通过后，把这个访问请求传递到对应进程（具体来说是一个应用程序）的ContentProvider组件，ContetnProvider接收到URI参数后，会解析URI路径（path），然后根据路径解析结果，提供相应的数据内容并将其返回；
   -    此过程在A应用程序内部实现，当A应用程序封装好了ContentProvider实现类，需要在Mainfest清单文件中进行注册，至此，A应用程序所在的进程已经提供了访问自己所在进程数据的接口，B应用程序只需要根据数据内容的URI，发出访问请求即可；<br>

 2、发出访问数据请求的过程：
   -   B应用程序如果希望跨进程访问A应用程序共享出来的数据，需要调用Context#getContentResolver()#query()|update()|insert()|delete()，无非就是对数据内容进行增删改查操作，涉及到一个类ContentResolver，具体调用的是ContentResolver的增删改查方法；与SQLite数据库的增删改查不同，ContentResolver的增删改查方法需要接受一个URI参数，这个URI参数就是希望访问的数据内容的URI；
   -   此过程在B应用程序内部实现，通过在B进程访问A进程的私有数据，完成跨进程共享数据的过程！
```
在packages/providers/ContactsProvider/中的AndroidManifest.xml文件中我们可以知道，此处为联系人所对应的provider，其他应用访问联系人皆是向其发送请求
```
