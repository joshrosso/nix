{ pkgs, ... }:

let

  bye = pkgs.writeShellScriptBin "cya" ''
    systemctl hibernate
  '';

in { environment.systemPackages = [ bye ]; }
