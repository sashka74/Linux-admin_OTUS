# NFS,FUSE

## Задание

- vagrant up должен поднимать 2 виртуалки: сервер и клиент
- на сервер должна быть расшарена директория
- на клиента директория должна автоматически монтироваться при старте (fstab или autofs)
- в шаре должна быть папка upload с правами на запись

__*требования для NFS: NFSv3 по UDP, включенный firewall*__

__* *Настроить аутентификацию через KERBEROS*__

## Решение

__Устанавливаем необходимый пакет на сервер и клиента__

`yum install -y nfs-utils`

__Создаем дерикторию с вложенной папкой "upload"__

```
 mkdir -p /home/share
 mkdir -p /home/share/upload
```
__Вносим данные директории для монтирования на сервере в файл `/etc/exports`__

`echo "/home/share 192.168.1.161(rw,no_root_squash)" >> /etc/exports`

__Включаем и добавляем в автозагрузку службу `nfs-server` на сервере__
```
systemctl start nfs-server
systemctl enable nfs-server
```
__Изменяем версию и протокол в файле `/etc/nfs.conf` на сервере и перезапускаем службу__
```
sed -i -r 's/# vers3=y/ vers3=y/' /etc/nfs.conf
sed -i -r 's/# tcp=y/ udp=y/' /etc/nfs.conf
service nfs-server restart
```
__Включаем и добавляем в автозагрузку службу `firewalld` на сервере__
```
service firewalld start
systemctl enable firewalld
```
__Добавляем правила в firewall и перезапускаем службу на сервере__
```
firewall-cmd --permanent --zone=public --add-port=2049/udp
firewall-cmd --permanent --zone=public --add-port=111/udp
firewall-cmd --permanent --zone=public --add-port=49631/udp
firewall-cmd --permanent --zone=public --add-port=20048/udp
firewall-cmd --permanent --zone=public --add-port=36526/udp
firewall-cmd --reload
```
__Создаем директорию на клиенте и монтируем папку с NFS сервера__
```
mkdir -p /home/share
mount -o vers=3,proto=udp 192.168.1.160:/home/share /home/share
```
__Добавляем запись в fstab для автоматического монтирования при старте__
```
echo "192.168.1.160:/home/share /home/share nfs nfsvers=3,udp,rsize=32768,wsize=32768 0 0" >> /etc/fstab
```
