{ pkgs, lib, ... }: {

    brews = [
      # todo: determine how to use nixpkg instead
      #       when i tried this, python interpreter did not
      #       work.
      "ansible"
    ];
    # While I'd prefer to use nix packages, the spotlight integration is rough
    # and the solutions are hacky[0].
    # [0]: https://github.com/nix-community/home-manager/issues/1341
    casks = [ 
      "rectangle" 
      "discord" 
      "notion" 
      "notion-calendar"
      "firefox" 
      "spotify" 
      "drawio" 
      "chatgpt" 
      "goland"
      "signal"
      # blacks out menu bar (hiding camera notch)
      "topnotch"
      "logitech-g-hub"
      "nordvpn"
    ];
  };

  system.defaults.dock.autohide = true;

  # hotkey bindings
  services.skhd = {
    enable = true;
    skhdConfig = lib.concatLines [
      "cmd + shift - k : open /Applications/Google\\ Chrome.app"
      "cmd + shift - h : open /Applications/Visual\\ Studio\\ Code.app"
      "cmd + shift - j : open /Applications/Alacritty.app"
      "cmd + shift - u : open /Applications/Slack.app"
      "cmd + shift - n : open /Applications/Notion.app"
      "cmd + shift - d : open /Applications/draw.io.app"
    ];
  };


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    ripgrep
    dig
    tmux
    openssl
    watch
  ];

  users.users."joshua.rosso" = {
    home = "/Users/joshua.rosso";
    shell = pkgs.bashInteractive;
  };

  environment.variables.EDITOR = "nvim";

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
