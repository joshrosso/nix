{
  description = "Skelly's NixOS Configuration";

  inputs = {
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      vscode-server,
      ...
    }:
    {
      nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ ]; }
          (
            { config, pkgs, ... }:
            {
              # Set the hostname
              networking.hostName = "artemis";
            }
          )
          ./hardware-configuration.nix
          ../desktops/configuration.nix
          ../desktops/configuration-laptop-linux.nix

          # to enable remote vscode development
          # https://github.com/nix-community/nixos-vscode-server
          vscode-server.nixosModules.default
          (
            { config, pkgs, ... }:
            {
              services.vscode-server.enable = true;
            }
          )

          ../scripts/ts.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.josh = import ../users/josh-gui-linux.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
}
