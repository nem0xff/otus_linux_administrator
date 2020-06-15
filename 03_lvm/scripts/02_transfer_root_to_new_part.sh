#!/bin/bash

#Get 10G disk
diskForTransfer=/dev/`lsblk | grep 10G | head -c 3`

#Create new partition for temp root filesystem
pvcreate $diskForTransfer
vgcreate temp_rootfs $diskForTransfer
lvcreate -n temp_rootfs -l +100%FREE /dev/temp_rootfs

#Mount new partition
mkfs.xfs /dev/temp_rootfs/temp_rootfs
mount /dev/temp_rootfs/temp_rootfs /mnt/

#Doing dump root filesystem
xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt

#Making new partition bootable
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt /bin/bash << "EOF"
grub2-mkconfig -o /boot/grub2/grub.cfg
sed -i 's!VolGroup00/LogVol00!temp_rootfs/temp_rootfs!' /boot/grub2/grub.cfg
EOF
