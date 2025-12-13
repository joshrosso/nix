{
  description = "Skelly's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations.selene = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ ]; }
          (
            { config, pkgs, ... }:
            {
              # Set the hostname
              networking.hostName = "selene";
            }
          )
          # us default generated config
          ./hardware-configuration.nix
          ./graphics.nix
          ./specific.nix
          ../desktops/configuration.nix
          ../scripts/ts.nix

        ];
      };
    };
}
