{
  description = "NixOS Configuration";

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
      nixosConfigurations.hypervisor = nixpkgs.lib.nixosSystem {
        system = "aarch-64";
        modules = [
          { nixpkgs.overlays = [ ]; }
          ./configuration.nix
          ./configuration-gui.nix
          ./hardware-configuration.nix

          # to enable remote vscode development
          # https://github.com/nix-community/nixos-vscode-server
          vscode-server.nixosModules.default
          (
            { config, pkgs, ... }:
            {
              services.vscode-server.enable = true;
            }
          )

          ./scripts/ts.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.josh = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
}
