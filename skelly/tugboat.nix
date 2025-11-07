{ lib, pkgs, config, ... }:

{
  networking.hostName = "tugboat";

  # kernel setting to support OBS virtual cam (https://nixos.wiki/wiki/OBS_Studio)
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
