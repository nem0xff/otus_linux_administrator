#!/usr/bin/env bash
# -*- coding: utf-8 -*-

lvremove /dev/VolGroup00/LogVol00 -y

lvcreate -n LogVol00 -L 8G VolGroup00 -y

mkfs.xfs /dev/VolGroup00/LogVol00

mount /dev/VolGroup00/LogVol00 /mnt/

xfsdump -J - /dev/temp_rootfs/temp_rootfs | xfsrestore -J - /mnt

for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt /bin/bash << "EOF"
grub2-mkconfig -o /boot/grub2/grub.cfg
sed -i 's!temp_rootfs/temp_rootfs!VolGroup00/LogVol00!' /boot/grub2/grub.cfg
EOF