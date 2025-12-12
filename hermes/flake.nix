{
  description = "Hermes' NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations.skelly = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ ]; }
          (
            { config, pkgs, ... }:
            {
              # Set the hostname
              networking.hostName = "hermes";
            }
          )
          # us default generated config
          ./hardware-configuration.nix
          ./services.nix
          ../servers/configuration.nix
          ../scripts/ts.nix
        ];
      };
    };
}
