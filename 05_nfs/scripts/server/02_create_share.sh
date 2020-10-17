#!/bin/bash

mkdir -p /srv/nfs_share/upload
chmod 777 /srv/nfs_share/upload

echo "/srv/nfs_share 192.168.11.0/24(rw,sync,no_subtree_check)" >> /etc/exports

#Включаем сервис NFS
systemctl enable nfs-server.service
systemctl start nfs-server.service


