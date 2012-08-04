{config, pkgs, ...}:

let
  cfg = config.services.xserver.thinkpad;
in

with pkgs.lib;

{

    options = {
        services.xserver.thinkpad = {
            enable = mkOption {
                default = false;
                type = with types; bool;
                description = ''
                    Trackpoint Wheel Emulation, TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint.
                '';
            };
        };	
    };

    config = mkIf cfg.enable {
        services.xserver.modules = [ pkgs.xorg.xf86inputsynaptics ];

        services.xserver.config =
            ''
Section "InputClass"
    Identifier  "Trackpoint Wheel Emulation"
    MatchProduct    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"
    MatchDevicePath "/dev/input/event*"
    Option      "EmulateWheel"      "true"
    Option      "EmulateWheelButton"    "2"
    Option      "Emulate3Buttons"   "false"
    Option      "XAxisMapping"      "6 7"
    Option      "YAxisMapping"      "4 5"
EndSection
            '';
    };
}
