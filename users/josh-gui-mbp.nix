{ lib, pkgs, ... }:

{

  imports = [
    ./josh-base.nix
  ];

  home.username = "joshua.rosso";

  home.packages = with pkgs; [
    gnused
  ];

  programs.bash = {
    bashrcExtra = ''
      # prefer nix PATHs in system's $PATH
      export NEW_PATH=$(echo $PATH | sed 's|/etc/profiles/per-user/joshua.rosso/bin:||g')
      export NEW_PATH=$(echo $NEW_PATH | sed 's|/run/current-system/sw/bin:||g')
      export NEW_PATH=$(echo $NEW_PATH | sed 's|/nix/var/nix/profiles/default/bin:||g')
      export PATH=/etc/profiles/per-user/joshua.rosso/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$NEW_PATH
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      # light mode
      /*
        import = [
          "~/.config/alacritty/themes/themes/alabaster.yaml"
        ];
      */
      import = [ "${pkgs.alacritty-theme}/share/alacritty-theme/catppuccin.toml" ];
      keyboard.bindings = [
        # ensure alt left arrow and right arrow move between words rather than
        # typing 3D; 3E;
        # ref: https://github.com/alacritty/alacritty/issues/474#issuecomment-2137353585
        {
          key = "Left";
          mods = "Alt";
          chars = "\\u001bB";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "\\u001bF";
        }
        {
          key = "Key1";
          mods = "Command";
          chars = "\\u00021";
        }
        {
          key = "Key2";
          mods = "Command";
          chars = "\\u00022";
        }
        {
          key = "Key3";
          mods = "Command";
          chars = "\\u00023";
        }
        {
          key = "Key4";
          mods = "Command";
          chars = "\\u00024";
        }
        {
          key = "Key5";
          mods = "Command";
          chars = "\\u00025";
        }
        {
          key = "Key6";
          mods = "Command";
          chars = "\\u00026";
        }
        {
          key = "Key7";
          mods = "Command";
          chars = "\\u00027";
        }
        {
          key = "Key8";
          mods = "Command";
          chars = "\\u00028";
        }
        {
          key = "Key9";
          mods = "Command";
          chars = "\\u00029";
        }
        {
          key = "T";
          mods = "Command";
          chars = "\\u0002c";
        }
        {
          key = "W";
          mods = "Command";
          chars = "exit\\n";
        }
        {
          key = "F";
          mods = "Command";
          chars = "ts\\n";
        }
      ];
      font = {
        size = 10;
        offset = {
          y = 4;
        };
        normal = {
          family = "FiraCode Nerd Font";
        };
      };
      shell = {
        program = "/etc/profiles/per-user/joshua.rosso/bin/bash";
      };
    };
  };

  programs.tmux = {
    extraConfig = ''
      run ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g default-shell "/etc/profiles/per-user/joshua.rosso/bin/bash"
    '';
  };

}
