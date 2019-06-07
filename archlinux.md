# File system
## EFI
### fs creation
```
mkfs.fat -F32 /dev/sdb5
```

### fstab
```
/dev/sdb5 /efi vfat rw,relatime 0 2
```


# Grub

### install grub executable
```
pacman -S grub
```

### install grub directory
##### your grub name will be "GRUB_ARCH"
```
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB_ARCH
```

### generate grub config (update-grub equivalent)
```
grub-mkconfig -o /boot/grub/grub.cfg
```

# package manager
#### full system upgrade
```
pacman -Syu
```

#### Query installed/local packages by regex
sudo pacman -Qsq pulseaudio

### Pacman apt equivalent
https://wiki.archlinux.org/index.php/Pacman/Rosetta
### My packages
```
sudo pacman -S pulseaudio tree xf86-video-intel mesa-dri opencl-nvidia sudo polkit lxsession kernel headers git gdm terminator keepass firefox
```

# Wi-Fi
#### With gdm (gnome desktop manager)
You have just have to use the service NetworkManager, which it way much more simple than other wireless connection manager (like wicd, netctl).
NetworkManager will allow you to graphically setup once your wifi settings and autodiscover SSID.
```
systemctl start NetworkManager
# and enable it at boot, by default no wifi connection manager is enable on archlinux
systemctl enable NetworkManager
```
Then, fill in your infos in your graphical wifi settings
