# ZFS

## 1.Определить алгоритм с наилучшим сжатием 

- определить какие алгоритмы сжатия поддерживает zfs (gzip gzip-N, zle lzjb, lz4) 
- создать 4 файловых системы на каждой применить свой алгоритм сжатия 

Для сжатия использовать либо текстовый файл либо группу файлов:
скачать файл “Война и мир” и расположить на файловой системе
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8
либо скачать файл ядра распаковать и расположить на файловой системе 

## Выполнение

__#Добавляем официальный репозиторий OpenZFS, согласно версии ОС,в нашем случае centos8__

`yum install http://download.zfsonlinux.org/epel/zfs-release.el8_0.noarch.rpm`

__#Чтобы использовать репозиторий на основе kABI редактируем файл *zfs.repo*__ 
```
# /etc/yum.repos.d/zfs.repo
[zfs]
enabled=1
```
_~~enabled=1~~_\
_enabled=0_
```
[zfs-kmod]
enabled=0
```
_~~enabled=0~~_\
_enabled=1_

__#Устанавливаем zfs__
```
yum install zfs 
```
__#Перезагружаем систему__
```
reboot
```
__#Включаем модуль ядра zfs__
```
modprobe zfs
``` 
__#Создаем pool зеркало из двух дисков__
```
zpool create storage mirror /dev/sdb /dev/sdc
```
## 2.Определить настройки pool’a

- Загрузить архив с файлами локально и распаковать.\
https://drive.google.com/open?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg 
- С помощью команды zfs import собрать pool ZFS.
#### Командами zfs определить настройки:
- размер хранилища
- тип pool
- значение recordsize
- какое сжатие используется
- какая контрольная сумма используется 


## 3.Найти сообщение от преподавателей

- Скопировать файл из удаленной директории.\
https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing 
- Восстановить его локально. zfs receive\
Найти зашифрованное сообщение в файле secret_message

Файл был получен командой
zfs send otus/storage@task2 > otus_task2.file
