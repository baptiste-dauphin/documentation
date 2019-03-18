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
```
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB_ARCH
```

### generate grub config (update-grub equivalent)
```
grub-mkconfig -o /boot/grub/grub.cfg
```

# package manager
### Pacman apt equivalent
https://wiki.archlinux.org/index.php/Pacman/Rosetta
