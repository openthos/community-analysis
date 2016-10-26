mount -t ext4 /dev/block/sda5 /data/ubuntu
mount -t sysfs /proc /data/ubuntu/sys
mount -t proc /proc /data/ubuntu/proc
mount-static --bind /dev /data/ubuntu/dev
swapon /data/ubuntu/android.swap
stop adbd
