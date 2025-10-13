# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, ... }:

{
  # boot in a mode that optimzes for battery over performance.
  # namely, disable GPU and other tweaks.
  specialisation = {
    battery-saver.configuration = {
      services.tlp.enable = true;
      system.nixos.tags = [ "battery-saver" ];
      services.xserver.videoDrivers = lib.mkForce [ ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
        prime.sync.enable = lib.mkForce false;
      };
    };
  };

}
