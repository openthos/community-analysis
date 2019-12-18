- Ensure the following 9P options are enabled in the kernel configuration. 
```
    CONFIG_NET_9P=y
    CONFIG_NET_9P_VIRTIO=y
    CONFIG_NET_9P_DEBUG=y (Optional)
    CONFIG_9P_FS=y
    CONFIG_9P_FS_POSIX_ACL=y
    CONFIG_PCI=y
    CONFIG_VIRTIO_PCI=y
```

- and these PCI and virtio options: 
```
    CONFIG_PCI=y
    CONFIG_VIRTIO_PCI=y
    CONFIG_PCI_HOST_GENERIC=y (only needed for the QEMU Arm 'virt' board)
```

- Start the Guest OS 
```
qemu-system-x86_64  -m 2G -append "root=/dev/sda rw rdinit=/sbin/init console=ttyS0" -serial stdio -kernel bzImage -hda ./rootfs_4G_01.ext4 \
-fsdev local,id=test_dev,path=/home/guest/9p_setup/shared,security_model=none -device virtio-9p-pci,fsdev=test_dev,mount_tag=test_mount

```

- Mounting shared folder

Mount the shared folder on guest using 
```
    mount -t 9p -o trans=virtio test_mount /tmp/shared/ -oversion=9p2000.L,posixacl,cache=loose
```

test_mount 与 Start the Guest OS中的mount_tag 一致！
