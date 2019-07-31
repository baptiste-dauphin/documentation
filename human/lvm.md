# Enlarge LVM parition with additional disk

#### see disks
```bash
lsblk
```

#### Run fdisk pour pouvoir gérer les disk 
```bash
fdisk /dev/sdx
```

#### Creation d'une partition de type "Linux LVM" = 8e
```bash
m-n-p- -t -8e - w
```

#### Initialize a disk or PARTITION for use by LVM
```bash
pvcreate /dev/sdxX
```

#### Add physical volumes to a volume group (/dev/sdb1)
```bash
vgdisplay /dev/sdaX
```
```bash
vgextend system-vg /dev/sdbx
```

#### Extend the size of a logical volume
```bash
lvextend -l +100%FREE /dev/vg_data/lv_data
```

#### 
```bash
resize2fs /dev/VG_Name/LV_Name
```
# notice that lvm create a directory with vg name and subfile with lv name
# example :
```bash
resize2fs /dev/HOSTNAME-vg/root
```
```bash
resize2fs /dev/system-vg/root
```


#### to check if the procedure has been succefully succeed don't use 'lsblk' BUT 'df -h' instead
```bash
df -h 
```




# Mount new disk on /data
```bash
mkdir /data
```

#### pvcreate
```bash
pvcreate /dev/sdb
```
```bash
pvdisplay
```

#### vgcreate
```bash
vgcreate vg_NAME /dev/sdb
```
```bash
vgdisplay
```

#### lvcreate
```bash
lvcreate -l +100%FREE -n lv_NAME vg_NAME
```

#### file system create
```bash
mkfs.ext4 /dev/mapper/vg_NAME-lv_NAME
```

#### mount the Logicial Volume in /data
```bash
mount /dev/mapper/vg_NAME-lv_NAME /data
```

#### rendre persistent le mount au demarrage
```bash
vim /etc/fstab
```
copy the first line, and replace with LV path


# Delete partition in a DISK
```bash
cfdisk /dev/sdb
```


# reduce lv size
[Tutorial](https://www.rootusers.com/lvm-resize-how-to-decrease-an-lvm-partition/)
