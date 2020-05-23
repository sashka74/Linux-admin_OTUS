# ZFS

## 1.Определить алгоритм с наилучшим сжатием 

- определить какие алгоритмы сжатия поддерживает zfs (gzip gzip-N, zle lzjb, lz4) 
- создать 4 файловых системы на каждой применить свой алгоритм сжатия 

Для сжатия использовать либо текстовый файл либо группу файлов:
скачать файл “Война и мир” и расположить на файловой системе
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8
либо скачать файл ядра распаковать и расположить на файловой системе 

## Выполнение

__Добавляем официальный репозиторий OpenZFS, согласно версии ОС,в нашем случае centos8__

`#yum install http://download.zfsonlinux.org/epel/zfs-release.el8_0.noarch.rpm`

__Чтобы использовать репозиторий на основе kABI редактируем файл *zfs.repo*__ 
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

__Устанавливаем zfs__
```
#yum install zfs 
```
__Перезагружаем систему__
```
#reboot
```
__Включаем модуль ядра zfs__
```
#modprobe zfs
``` 
__Создаем pool "storage" тип-mirror из двух дисков__
```
#zpool create storage mirror /dev/sdb /dev/sdc
```
__Проверяем созданный pool__
```
#zpool list


NAME    |  SIZE | ALLOC | FREE  | CKPOINT | EXPANDSZ | FRAG | CAP | DEDUP | HEALTH | ALTROOT\
--------|-------|-------|-------|---------|----------|------|-----|-------|--------|---------
storage | 4.50G |  93K  | 4.50G |    -    |    -     |  0%  |  0% | 1.00x | ONLINE |   -
```
__Создаем файловые системы__
```
#zfs create storage/number1
#zfs create storage/number2
#zfs create storage/number3
#zfs create storage/number4
```
__Проверяем файловые системы, которые мы создали__
```
#zfs list

NAME            | USED | AVAIL |  REFER  | MOUNTPOINT
----------------|------|-------|---------|-----------------
storage         | 196K | 4.36G |   28K   |  /storage
storage/number1 |  24K | 4.36G |   24K   |  /storage/number1
storage/number2 |  24K | 4.36G |   24K   |  /storage/number2
storage/number3 |  24K | 4.36G |   24K   |  /storage/number3
storage/number4 |  24K | 4.36G |   24K   |  /storage/number4
```
__Прменяем ~~одинаковые~~ разные алгоритмы сжатия к файловым системам number1-4__
```
#zfs set compression=lzjb storage/number1
#zfs set compression=gzip-9 storage/number2
#zfs set compression=zle storage/number3
#zfs set compression=lz4 storage/number4
```
__Проверяем применились ли алгоритмы сжатия к файловым системам__
```
#zfs get compression

NAME            | PROPERTY     | VALUE    | SOURCE
--------------- |--------------|----------|---------
storage         |  compression | off      | default
storage/number1 |  compression | lzjb     | local
storage/number2 |  compression | gzip-9   | local
storage/number3 |  compression | zle      | local
storage/number4 |  compression | lz4      | local
```
__Скачиваем архив ядра и распаковываем на файловые системы number1-4__
```
#wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.13.tar.xz

#tar -xf linux-5.6.13.tar.xz -C /storage/number1
#tar -xf linux-5.6.13.tar.xz -C /storage/number2
#tar -xf linux-5.6.13.tar.xz -C /storage/number3
#tar -xf linux-5.6.13.tar.xz -C /storage/number4
```
__Проверяем степень сжатия разных алгоритмов на файловых системах__
```
#zfs get compression,compressratio

NAME            | PROPERTY      |  VALUE  |  SOURCE
----------------|---------------|---------|----------
storage         | compression   | off     |  default
storage         | compressratio | 2.07x   |  -
storage/number1 | compression   | lzjb    |  local
storage/number1 | compressratio | 2.41x   |  -
storage/number2 | compression   | gzip-9  |  local
storage/number2 | compressratio | 4.33x   |  -
storage/number3 | compression   | zle     |  local
storage/number3 | compressratio | 1.08x   |  -
storage/number4 | compression   | lz4     |  local
storage/number4 | compressratio | 2.79x   |  -
```
__Вывод: *Наибольшей степени сжатия данных`(4.33x)`, среди используемых алгоритмов, удалось добиться применив gzip-9*.__

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

## Выполнение


## 3.Найти сообщение от преподавателей

- Скопировать файл из удаленной директории.\
https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing 
- Восстановить его локально. zfs receive\
Найти зашифрованное сообщение в файле secret_message

Файл был получен командой
zfs send otus/storage@task2 > otus_task2.file
