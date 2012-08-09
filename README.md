220 Configuration
==================

NixOS
-----

http://nixos.org/

* [Intégration du trackpad du X220](https://github.com/j4/x220/blob/master/nixos/thinkpad.nix) dans le Xorg de NixOS.
* Installation de luks,btrfs - chmod 0755 sur les subvol

Nixpkgs  
-------

http://nixos.org/nixpkgs/

Luks | LVM
----------

```
fdisk /dev/sda
```

Create 2 partitions (boot and luks) sda1 == boot, sda2 == luks
Init de luks

```

```

Init de LVM dans Luks

```
cryptsetup luksFormat -c aes-xts-plain -s 512 /dev/sda2
cryptsetup luksOpen /dev/sda2 rootfs
```

```
pvcreate /dev/mapper/rootfs
vgcreate /dev/mapper/rootfs vg_x220
lvcreate -L50G -n lv_luks-home vg_x220
lvcreate -L20G -n lv_luks-rootfs vg_x220
```

Init de btrfs

```
mkfs.btrfs -Lhome /dev/mapper/vg_x220-lv_luks-home
mkfs.btrfs -Lrootfs /dev/mapper/vg_x220-lv_luks-rootfs
mount /dev/mapper/vg_x220-lv_luks-home /mnt
cd /mnt
btrfs subvol create home
btrfs subvol create snap
cd / && umount /mnt
mount /dev/mapper/vg_x220-lv_luks-rootfs /mnt
cd /mnt
btrfs subvol create rootfs
btrfs subvol create snap
```

```
mount -ossd,compress=lzo,subvol=rootfs /dev/disk/by-label/rootfs /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount -ossd,compress=lzo,subvol=home /dev/disk/by-label/home /mnt/home
nixos-option -i
```

Copy my config file (configuration.nix, thinkpad.nix hardware.nix) in /mnt/etc/nixos/

```
nix-install
```

wvdial 
------

Pour abo 3G

xmonad
------

Xorg
----

Integration de synaptics 
