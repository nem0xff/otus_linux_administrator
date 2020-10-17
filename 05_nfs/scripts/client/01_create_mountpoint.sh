#!/bin/bash

echo "192.168.11.101:/srv/nfs_share /mnt nfs rsize=8192,wsize=8192,timeo=14,intr,udp 0 0" >> /etc/fstab
mount -a
