.: X220 Configuration :.
========================

OpenBSD
=======

Installation
------------

Remove Ericsson F5521GW for install. Other run out of the box.

Encrypt home
------------

```
dd if=/dev/urandom of=home.img bs=1M count=460800
vnconfig -k vnd0 home.img
disklabel -E vnd0
newfs vnd0a
```

man vnconfig pour ajouter dans fstab :) puis dans rc.local : 

```
echo "Mounting encrypted volumes:"
mount /dev/vnd0c
fsck -p /dev/vnd0a
mount /home
```

NetBSD
======

HSDPA
-----

echo "ucom0:dv=/dev/ttyU1:br#460800:pa=none:dc:" >> /etc/remote

cat /etc/ppp/options 
``` noauth ```

spof$ sudo cat /etc/ppp/peers/bt                                                                                                                                                                                                 
```
# $NetBSD: cosmote3G,v 1.1 2010/08/07 20:47:27 christos Exp $
# Script to connect to Cosmote-3G's service.
# This gets to the point of connected, but never gets to negotiate LCP.
# I see nothing from the modem. It is here for reference.
#
#kdebug 100
#debug 10000
/dev/ttyU1 460800
holdoff 10
noipv6
#-vj
#idle 600
demand
#active-filter-out "icmp or (udp and not udp port route) or (tcp and not tcp port ntp)"
#active-filter-in "icmp or (udp and not udp port route) or (tcp and not tcp port ntp)"
#pass-filter-in "tcp or (udp and not udp port route) or icmp"
#pass-filter-out "tcp or (udp and not udp port route) or icmp"
#netmask 0xffffff00
ipcp-accept-local
lcp-echo-failure 0
lcp-echo-interval 0
mtu 296
defaultroute
crtscts
modem
lock
connect /etc/ppp/peers/bt.chat
noauth
user ""
password ""
usepeerdns
```

cat /etc/ppp/peers/bt.chat                                                                                                                                                                                             
```
#!/bin/sh
#chat -t 100 -v ''      'ATZ' \
#      'OK'             'AT+CPIN=XXXX'

# Although the modem says ok, it takes a few seconds to negotiate the
# pin.
sleep 10

chat -t 100 -v ''       'AT+CGDCONT=1,"IP","a2bouygtel.com"' \
      'OK'              'ATDT*99***1#' \
      TIMEOUT           120 \
      'CONNECT'         '\c'

# 'AT+CPMS?'
# '+CPMS: "ME",0,100,"ME",0,100,"ME",0,100'
# Hardware handshake
#      'OK'             'AT&F &D2 &C1"
# No answer no timeout
#      'OK'             'ATS7=60 S30=0 S0=0"
# Report signal quality.
#      'OK'             'AT+CSQ'
```

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
