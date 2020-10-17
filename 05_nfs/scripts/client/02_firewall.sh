#Включаем сервис firewalld
systemctl enable firewalld
systemctl start firewalld
#Добавляем правила
firewall-cmd --permanent --zone=public --add-service=nfs3
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload

