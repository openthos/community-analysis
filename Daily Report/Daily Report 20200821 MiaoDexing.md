# git commit -m与-am的区别
要了解git commit -m与git commit -am的区别，首先要明白它们的定义

　　字面解释的话，git commit -m用于提交暂存区的文件，git commit -am用于提交跟踪过的文件

　　[注意]git commit -am可以写成git commit -a -m，但不能写成git commit -m -a
  
工作目录下面的所有文件都不外乎这两种状态：已跟踪(tracked)或未跟踪(untracked)。已跟踪的文件是指本来就被纳入版本控制管理的文件，
在上次快照中有它们的记录，工作一段时间后，它们的状态可能是未更新(unmodified)，已修改(modified)或者已放入暂存区(staged)

（https://www.cnblogs.com/smile-fanyin/p/10827438.html）

# Calling startActivity() from outside of an Activity  context requires the FLAG_ACTIVITY_NEW_TASK flag. Is this really what you want?

- 错误分析：

Context中有一个startActivity方法，Activity继承自Context，重载了startActivity方法。如果使用Activity的startActivity方法，不会有任何限制，而如果使用Context的startActivity方法的話，就需要开启一个新的的task，遇到这个异常，是因为使用了Context的startActivity方法。解决办法是，加一个flag。
代码：
intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
这样就可以在新的task里面启动这个Activity了。

