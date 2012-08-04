{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.xserver.thinkpad; in

{

  options = {

    services.xserver.thinkpad = {

      enable = mkOption {
        default = false;
        example = true;
        description = "Trackpoint Wheel Emulation support.";
      };

      dev = mkOption {
        default = null;
        example = "/dev/input/event0";
        description =
          ''
	TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint
          '';
      };

      emulateWheel = mkOption {
	default = true;
      }

      emulateWheelButton = mkOption {
	default = "2";
      }

      emulate3Buttons = mkOption {
	default = false;
      }

      xAxisMapping = mkOption {
	default = "6 7";
      }

      yAxisMapping = mkOption {
	default = "4 5";
      }


  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xorg.xf86inputsynaptics ];

    services.xserver.config =
      ''
        # Automatically enable the synaptics driver for all touchpads.
        Section "InputClass"
          Identifier "Trackpoint Wheel Emulation"
          ${optionalString (cfg.dev != null) ''MatchDevicePath "${cfg.dev}"''}
          ${cfg.additionalOptions}
        EndSection
      '';

  };

  };
 
  };

}
