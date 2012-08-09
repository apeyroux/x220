X220 Configuration
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
lvcreate -L20G -n lv_luks-home vg_x220
```

```
cryptsetup luksFormat -c aes-xts-plain -s 512 /dev/mapper/vg_x220-lv_luks-home
```

```
cryptsetup luksOpen /dev/mapper/vg_x220-lv_luks-home  luks-home
```

```
root@spof:~# mkfs.btrfs -L luks-home /dev/mapper/luks-home 

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label luks-home on /dev/mapper/luks-home
        nodesize 4096 leafsize 4096 sectorsize 4096 size 20.00GB
Btrfs Btrfs v0.19
root@spof:~# ls /dev/disk/by-label/
boot  home  luks-home  rootfs  swap
```

WARNING!
========
Cette action écrasera définitivement les données sur /dev/mapper/vg_x220-lv_luks--home.

Are you sure? (Type uppercase yes): YES
Saisissez la phrase secrète LUKS : 
Verify passphrase: 

wvdial 
------

Pour abo 3G

xmonad
------

Xorg
----

Integration de synaptics 
