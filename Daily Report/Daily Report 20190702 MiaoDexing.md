# Android 8.0 property 分析
- property_set 可以设置系统属性，在Android系统中（system/core/init/property_service.cpp）调用了start_property_service方法启动了一个属性服务。
```
void start_property_service() {
    property_set("ro.property_service.version", "2");

    property_set_fd = CreateSocket(PROP_SERVICE_NAME, SOCK_STREAM | SOCK_CLOEXEC | SOCK_NONBLOCK,
                                   false, 0666, 0, 0, nullptr, sehandle);
    if (property_set_fd == -1) {
        PLOG(ERROR) << "start_property_service socket creation failed";
        exit(1);
    }

    listen(property_set_fd, 8);

    register_epoll_handler(property_set_fd, handle_property_set_fd);
}

```
因为属性设定涉及到一些权限的问题，不是所有进程都可以随意修改任何的系统属性，Android 将属性的设置统一交由 init 进程管理，其他进程不能直接修改属性，
而只能通知 init 进程来修改，而在这过程中，init 进程可以进行权限检测控制，决定是否允许修改。
- 无论是控制命令还是常规属性设置操作之前，都要进行权限检测，使用getpeercon 获取的进程安全上下文分别调用 check_control_mac_perms 和 check_mac_perms 判断进程有没有对应的权限进行操作。
