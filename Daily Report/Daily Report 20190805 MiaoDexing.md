# 相机预览方向适配问题的产生
## 1、 相机的安装方向如何获取？
- Android官方提供orientation这个属性：表示相机采集的图像顺时针旋转orientation度后才能与到设备自然方向一致。
假设设备是竖屏显示。后置相机传感器是横屏安装的。你面向屏幕时，如果后置相机传感器所采集的图像的上边是在设备自然方向的右边，则后置相机的orientation是90。
如果前置相机传感器所采集的图像的上边是在设备自然方向的右边，则前置相机的orientation是270。
这个值，不同的设备有所差异，但大多数都是这样的值。

## Activity设为竖屏时，SurfaceView预览图像为什么是逆时针旋转90度？
- 说明这个问题之前，先介绍下Android手机上几个方向的概念：

  - 屏幕坐标：在Android系统中，屏幕的左上角是坐标系统的原点（0,0）坐标。原点向右延伸是X轴正方向，原点向下延伸是Y轴正方向。

  - 自然方向（natrual orientation）：
每个设备都有一个自然方向，手机和平板的自然方向不同。Android:screenOrientation的默认值unspecified即为自然方向。 
   - 关于orientation的两个常见值是这样定义的： 
landscape（横屏）：the display is wider than it is tall，正常拿着设备的时候，宽比高长，这是平板的自然方向。 
portrait（竖屏）：the display is taller than it is wide，正常拿设备的时候，宽比高短，这是手机的自然方向。

  - 图像传感器（Image Sensor）方向：手机相机的图像数据都是来自于摄像头硬件的图像传感器，这个传感器在被固定到手机
  上后有一个默认的取景方向，坐标原点位于手机横放时的左上角，即与横屏应用的屏幕X方向一致。换句话说，与竖屏应用的屏幕X方向呈90度角。
  - 相机的预览方向：将图像传感器捕获的图像，显示在屏幕上的方向。在默认情况下，与图像传感器方向一致。在相机API中可以
  通过setDisplayOrientation()设置相机预览方向。在默认情况下，这个值为0，与图像传感器方向一致。
  - 下面是Camera.setDisplayOrientation的注释文档：
  ```
    /**
   * Set the clockwise rotation of preview display in degrees. This affects
   * the preview frames and the picture displayed after snapshot. This method
   * is useful for portrait mode applications. Note that preview display of
   * front-facing cameras is flipped horizontally before the rotation, that
   * is, the image is reflected along the central vertical axis of the camera
   * sensor. So the users can see themselves as looking into a mirror.
   *
   * <p>This does not affect the order of byte array passed in {@link
   * PreviewCallback#onPreviewFrame}, JPEG pictures, or recorded videos. This
   * method is not allowed to be called during preview.     
   */

   public native final void setDisplayOrientation(int degrees);
  ```
  注释中的第二段，描述了这个API修改的仅仅是Camera的预览方向而已，并不会影响到PreviewCallback回调、
  生成的JPEG图片和录像文件的方向，这些数据的方向依然会跟图像Sensor的方向一致。<br>
  注意：设置预览方向并不会改变拍出照片的方向
  - 对于横屏（这个activity设置的是横屏显示）来说，由于屏幕方向和预览方向一致，预览图像和看到的实物方向一致。
  - 对于竖屏（这个activity设置的是竖屏显示），屏幕方向和预览方向垂直，所以会出现颠倒90度现象，无论怎么旋转手机，显示在UI预览界面的画面与人眼看到的实物始终成90度（UI预览界面逆时针转了90度）。
    为了得到一致的预览画面，需要将相机的预览方向旋转90（setDisplayOrientation（90）），保持与屏幕方向一致.

## 前置摄像头的镜像效果
- Android相机硬件有个特殊设定，就是对于前置摄像头，

1、在预览图像是真实场景的镜像

2、 拍出的照片和真实场景一样。

  
