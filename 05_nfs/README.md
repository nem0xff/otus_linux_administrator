Задание #5
----------

Содержание:

vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall

Сервер
------

При выполнении `vagrant up` будут выполнены по очерди следующие скрипты. После чего вирутальная машина будет перезагружена.

<details>
<summary> <code>01_install_additional_tools.sh</code> - устанавливает <code>nfs-utils</code> </summary>

```
#!/bin/bash

echo "Installing addtion tools"

# Install utils
yum install -y nfs-utils iptables-services
```
</details>

<details>
<summary> <code>02_create_share.sh</code> - создает каталог, добавляет данные в /etc/exports, запускает NFS</summary>

```
#!/bin/bash

mkdir -p /srv/nfs_share/upload
chmod 777 /srv/nfs_share/upload

echo "/srv/nfs_share 192.168.11.0/24(rw,sync,no_subtree_check)" >> /etc/exports

#Включаем сервис NFS
systemctl enable nfs-server.service
systemctl start nfs-server.service
```
</details>

<details>
<summary> <code>03_firewall.sh</code> - включаем сервис firewalld и добавляем правила</summary>

```
# Включаем сервис firewalld
systemctl enable firewalld
systemctl start firewalld
#Добавляем правила
firewall-cmd --permanent --zone=public --add-service=nfs3
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload
```
</details>


Клиент
------

При выполнении `vagrant up` будут выполнены по очерди следующие скрипты. После чего вирутальная машина будет перезагружена.

<details>
<summary><code>01_create_mountpoint.sh</code> - добавляет данные о ресурсе в <code>/etc/fstab</code>, монтирует ресурс </summary>

```
#!/bin/bash

echo "192.168.11.101:/srv/nfs_share /mnt nfs rsize=8192,wsize=8192,timeo=14,intr,udp 0 0" >> /etc/fstab
mount -a
```
</details>


<details>
<summary><code>02_firewall.sh</code> - включаем сервис firewalld и добавляем правила</summary>

```
#Включаем сервис firewalld
systemctl enable firewalld
systemctl start firewalld
#Добавляем правила
firewall-cmd --permanent --zone=public --add-service=nfs3
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload
```
</details>