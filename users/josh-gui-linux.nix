{ pkgs, ... }:

{

  home.username = "josh";

  imports = [
    ./josh-base.nix
  ];

  services.blueman-applet.enable = true;

  home.packages = with pkgs; [
    # debugging access points & wireless connections
    iw
    television
    claude-code
    pciutils
    claude-code
    vlc
    jackett
    mullvad-vpn
    keychain
    wl-clipboard
    anytype
    lutris
    protontricks
    jumpapp
    zoom-us
    signal-desktop
    spotify
    obs-studio
    drawio
    google-chrome
    slack
    wineWowPackages.unstable
    winetricks
    firefox
    gimp
    _1password-gui
    xbindkeys
    xbindkeys-config
    virt-manager
    pavucontrol
    vscode
    arandr
    discord
    xclip
  ];

  systemd.user.services.sxhkd = {
    Unit = {
      Description = "sxhkd hotkey daemon";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sxhkd}/bin/sxhkd";
      KillMode = "process";
      Environment = "PATH=/home/josh/.nix-profile/bin:/run/current-system/sw/bin:/etc/profiles/per-user/josh/bin";
    };
  };

  # hotkey bindings
  services.sxhkd = {
    enable = true;
    keybindings = {
      # note that if using google-chrome-stable, this will not launch but will bring window to front.
      # there is something strange with how google-chrome-stable names its process that breaks jumapp.
      # when running jumpapp google-chrome-stable, a new instance of chrome always opens.
      "super + shift + k" = "jumpapp chrome";
      "super + shift + j" = "jumpapp alacritty";
      "super + shift + m" = "jumpapp drawio";
      "super + shift + u" = "jumpapp slack";
      "super + shift + h" = "jumpapp Zathura";
      "super + space" = "dmenu_run -fn 'FiraCode Nerd Font Mono-16' -l 5";
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [
        "qemu:///system"
        "qemu+ssh://root@192.168.2.1/system?keyfile=/home/josh/.ssh/homelab&sshauth=privkey&no_verify=1"
        "qemu+ssh://root@192.168.1.170/system?keyfile=/home/josh/.ssh/homelab&sshauth=privkey&no_verify=1"
      ];
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      # light mode
      /*
        import = [
          "~/.config/alacritty/themes/themes/alabaster.yaml"
        ];
      */
      general.import = [ "~/.config/alacritty/themes/themes/catppuccin_macchiato.yaml" ];
      terminal.shell.program = "/etc/profiles/per-user/josh/bin/tmux";
      window.startup_mode = "Fullscreen";
      keyboard.bindings = [
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
        {
          key = "V";
          mods = "Command";
          chars = "\\u0002%";
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
      env = {
        TERM = "xterm-256color";
      };
    };
  };

  programs.tmux = {
    extraConfig = ''
      # ensure vi-copy puts into system clipboard via xclip 
      #  (https://unix.stackexchange.com/questions/131011/use-system-clipboard-in-vi-copy-mode-in-tmux)
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"
      set -g default-terminal "xterm-256color"
      set-option -sa terminal-overrides ",xterm*:Tc"
    '';
  };

  programs.bash = {
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      eval $(keychain -q --eval ''${HOME}/.ssh/*.pem)
    '';
  };
}
