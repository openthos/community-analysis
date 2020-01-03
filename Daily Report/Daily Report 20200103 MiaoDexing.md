# git   bisect
git bisect 是 Git 提供的一种 二分法 的调试工具，它可以按照我们选定的提交，进行二分分割，快速定位出出错的提交。来帮我们缩小最小改动的代码，从而快速定位问题。
git bisect 其实很简单，主要是基于几个基本命令：
- git bisect start：准备进行 bisect debug
- git bisect good：标记一个提交为 "good"
- git bisect bad：标记一个提交为 “bad”
- git bisect reset：退出 bisect debug 的状态
- git bisect replay：重置到某个状态。
