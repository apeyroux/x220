# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  require =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./thinkpad.nix
      #<nixos/modules/programs/virtualbox.nix>
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      # filesystem.
      # "xfs" "ata_piix"
      "dm_crypt" "sha256_generic" "sha1_generic" "cbc" "aes_x86_64" "aes_generic" "xts" "tun" "virtio" "kvm-intel" "ppp" "ppp_generic" "pppoe"
      #"tun" "virtio" "kvm-intel"
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Luks
  boot.initrd.luks.devices =  [ { device = "/dev/sda5"; name = "spof"; preLVM = true; } ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "spof.j4.pe"; 
    wireless.enable = true;
    #interfaceMonitor.enable = false;
    useDHCP = true; 
    #wicd.enable = true;
    wireless.userControlled.enable = true;
    wireless.interfaces = ["wlan0"];
  };

  powerManagement.enable = true;
  services.acpid.enable = true;
  #services.acpid.lidEventCommands = ["/nix/store/232chk6k12f1l7xg4rsbf0j3gbbl92zn-system-path/sbin/pm-suspend"];
  services.acpid.lidEventCommands = "pm-suspend";

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.
  fileSystems =
    [ 
      { mountPoint = "/boot";
         device = "/dev/disk/by-label/boot";
      }

      { mountPoint = "/"; # where you want to mount the device
        device = "/dev/disk/by-label/rootfs";  # the device
        fsType = "ext4";      # the type of the partition
      }
    ];

  # List swap partitions activated at boot time.
  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  # Select internationalisation properties.
  i18n = {
    #consoleFont = "lat9w-16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  environment.systemPackages =
    with pkgs;
    [ vim screen mosh xpra wvdial sudo i3 
      #i3
      #gitAndTools.gitFull
      #gitAndTools.gitAnnex
      #subversion
      #pkgs.haskellPlatform
      #pkgs.haskellPackages.xmonad
      #pkgs.haskellPackages.xmonadExtras
      #pkgs.firefoxWrapper
      #pkgs.chromeWrapper
      #chromeWrapper
      #lynx links w3m wget
      #wvdial
      #sudo 
      #gnupg
    ];

  ##
  # wvdial 
  ##
  environment.wvdial = {
	dialerDefaults = ''
		Init1 = AT+CFUN=6
		Init3 = ATZ
		Init4 = AT+CGDCONT=1,"IP","ebouygtel.com"
		Modem Type = Analog Modem
		ISDN = 0
		Phone = *99#
		New PPPD = yes
		Modem = /dev/ttyACM1
		Username = \'\'
		Password = \'\'
		Baud = 460800
		Stupid Mode = 1
	'';
  };



  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # libvirt
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.enableKVM = true;
  services.dbus.enable = true; # pour virt-manager
  services.dbus.packages = [ pkgs.gnome.GConf ]; # https://nixos.org/wiki/Solve_GConf_errors_when_running_GNOME_applications

  # Enable the X11 windowing system.
  services.xserver = {
  	enable = true;
  	layout = "fr";
  	xkbOptions = "eurosign:e";
  	synaptics.enable = true;
        thinkpad.enable = true;
  	#windowManager.xmonad.enable = true;  
  	windowManager.i3.enable = true;
  	windowManager.default       = "i3"; # sets it as default
  	#desktopManager.default      = "i3";  
        #displayManager.slim.enable = false;
	displayManager.slim.autoLogin = true;
	#displayManager.slim.defaultUser = 'ja';
  	autorun = true;
  };
 
}
