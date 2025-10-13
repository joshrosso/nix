{
  config,
  lib,
  pkgs,
  ...
}:

{

  services.vsftpd = {
    enable = true;
    localRoot = "/home/josh/Documents/ftp";
    localUsers = true; # Allow local users
    writeEnable = true; # Allow local users to upload
    userlist = [ "josh" ]; # Path to a file listing allowed users
  };

  # https://github.com/NixOS/nix/issues/11728
  nix.settings.download-buffer-size = 524288000;

  # kernel setting to support OBS virtual cam (https://nixos.wiki/wiki/OBS_Studio)
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1disk
  '';

  networking.networkmanager.enable = true;

  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;
  services.tailscale.enable = true;
  services.blueman.enable = true;

  services.logrotate.checkConfig = false;

  services.samba.nsswins = true;
  services.samba.enable = true;
  # retrieve list with `timedatectl list-timezones`
  time.timeZone = "America/Denver";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      # supporting A2DP (bluetooth) sink.
      # setting this was required to make my Bose QC35's connect.
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
      # settings such as ControllerMode can go here.
      # note: setting this to bredr broke wireless mice for some reason.
    };
  };
  #hardware.bluetooth.enable = true;
  #hardware.pulseaudio.enable = false;
  #nixpkgs.config.pulseaudio = true;

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  services.desktopManager = {
    plasma6.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      # If you want to use a custom theme, uncomment the line below and set the path to your theme
      # theme = "/path/to/your/theme";
      # If you want to use a custom configuration, uncomment the line below and set the path to your config
      # configurationFile = "/path/to/your/config";
    };
  };

  # custom udev rules
  #   * rules are added to /etc/udev/rules.d/99-local.rules
  #   * rule below is for disabling autosuspend on bluetooth mouse.
  #     * relates to solution at https://unix.stackexchange.com/questions/596610/bluetooth-mouse-sleeps-after-a-few-seconds-idle-when-there-is-no-other-mouse-con
  #     * future bt mice may not require this change.
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087",
  #   ATTR{idProduct}=="0026", ATTR{power/autosuspend}="-1"
  # '';

  services.keyd = {
    enable = true;
    keyboards.main.settings = {
      main = {
        "capslock" = "overload(control, esc)";
      };
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.xserver = {
    layout = "us"; # or your layout
    # swaps the windows and alt key for keyboards that can't customize this at the HW level
    xkbOptions = "altwin:swap_alt_win";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "docker"
    ];
    packages = with pkgs; [
      dig
      git
      tmux
    ];
  };

  programs.dconf.enable = true;

  environment.sessionVariables = {
    # ensuring this is set ensures apps whether x11, wayland, or tty is in use.
    # the biggest culprit for issues is/was zoom-us.
    #    XDG_SESSION_TYPE = "x11";
  };

  environment.variables.EDITOR = "nvim";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    qpwgraph
    vault-bin
    git
    gnumake
    gcc
    st
    mangohud
    dxvk
    clang
    ripgrep
    openssl
    dmenu
    virt-manager
    nvtopPackages.full
  ];

  # ============================================
  # [SYSTEMD]
  # ============================================
  virtualisation.libvirtd = {
    enable = true;
  };
  virtualisation.docker.enable = true;

  # ============================================
  # [SYSTEMD]
  # ============================================
  # disable these units by default
  # ref: https://discourse.nixos.org/t/disable-a-systemd-service-while-having-it-in-nixoss-conf/12732/3
  systemd.services.docker.wantedBy = lib.mkForce [ ];
  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];

  # ============================================
  # [PROGRAMS]
  # ============================================
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.ssh.startAgent = true;
  services.cloudflare-warp.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Tell Xorg to use the nvidia driver
  # You may not want to do this if using nvidia offload to
  # save GPU
  #  services.xserver.videoDrivers = [ "nvidia" ];
  #  hardware.nvidia.open = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Did you read the comment?
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
