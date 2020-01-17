# allow_failure

allow_failure被用于当你想允许job失败而不阻塞剩下的CI套件执行的时候，失败的job不会影响到commit状态(pipelines执行完会在commit上标记失败或成功状态，但是不会阻止commit提交)

当allow_failure为true,并且job失败了，pipline将会置绿或者置成功显示，但是你会在commit页面或者job页面看到一条“CI build passed with warnings”的警告信息。
这样用户就能注意到失败并采取其他措施。

# when

when参数是确定该job在失败或者没失败的时候执行不执行的参数。

when支持以下几个值之一:

- on_success 只有在之前场景执行的所有作业成功的时候才执行当前job，这个就是默认值，我们用最小配置的时候他默认就是这个值，所以失败的时候pipeline会停止执行后续任务
- on_failure 只有在之前场景执行的任务中至少有一个失败的时候才执行
- always 不管之前场景阶段的状态，总是执行
- manual ~手动执行job的时候触发（WebUi上点的）。请阅读manual action
