此目录下的内容是集成到gitlab-ci使用，对应的gitlab project为 http://192.168.0.231:98/root/linux-kernel.git，
当此Project下内核有commit，就会自动编译，自动测试，给出测试结果并发邮件通知；如果提交的commit有问题，则会自动bisect，
给出最后一次good commit 以及 出问题的第一次 bad commit
