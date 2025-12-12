{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ============================================
  # [HOST_CONFIG]
  # ============================================
  # retrieve list with `timedatectl list-timezones`
  time.timeZone = "America/Denver";
  programs.dconf.enable = true;
  environment.variables.EDITOR = "nvim";
  programs.ssh.startAgent = true;

  # ============================================
  # [SERVICES]
  # ============================================
  services = {
    tailscale.enable = true;
    logrotate.checkConfig = false;
    openssh.enable = true;
    vsftpd = {
      enable = true;
      localRoot = "/home/josh/Documents/ftp";
      localUsers = true; # Allow local users
      writeEnable = true; # Allow local users to upload
      userlist = [ "josh" ]; # Path to a file listing allowed users
    };
  };

  # ============================================
  # [PACKAGES]
  # ============================================
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fzf
    clang
    ffmpeg_7-full
    gcc
    git
    gnumake
    inetutils
    mqtt-exporter
    neovim
    nmap
    openssl
    qpwgraph
    ripgrep
    tmux
    vault-bin
    virt-manager
  ];

  # ============================================
  # [USERS]
  # ============================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVyzpM8KL8OWXwC2Lcpe49zMdDGqQ8EQiygJSXmWqtGLw9We29/EAA5se7tvUzjgcTWZN/FFWl59Ba4QYJlRREPSuBy1M1urErR0elrfSNf1ORVNKINlWydDW57wg2/OW9hId1cvjaCha4GCt6gc+0ohRBG3wKBALUMMRcsvmOdRvHrKcIt5FIYdrl5vtKhxW5sj+uBZOjznj5ocAcwQ1u/EC7hzSucVrSdXT2ZCOapHBB6HVbxituQ5FQJn4OcW4sOdZPP0nbNlpX52IzlfBYO8JI4nx3d2qvBx4QRyrd8eRk/6B6U7iVATDuQgTyWcrmYtsi8ljmTcFM0xdiYA+3"
    ];
    # packages = with pkgs; [
    # placeholder for user specific packages
    # ];
  };

  # ============================================
  # [SYSTEMD]
  # ============================================
  virtualisation.libvirtd = {
    enable = true;
  };
  virtualisation.docker.enable = true;
  # disable these units by default
  # ref: https://discourse.nixos.org/t/disable-a-systemd-service-while-having-it-in-nixoss-conf/12732/3
  systemd.services.docker.wantedBy = lib.mkForce [ ];
  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];

  # ============================================
  # [NETWORKING_AND_SECURITY]
  # ============================================
  networking.firewall.enable = false;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # ============================================
  # [NIXOS_OS_SETTINGS]
  # ============================================
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # https://github.com/NixOS/nix/issues/11728
  nix.settings.download-buffer-size = 524288000;

  # ============================================
  # [TODOS]
  # ============================================
  # REFACTOR THIS TO WORK WITH SAMBA
  # TODO: Enable this always, but have samba.target-related services disabled
  /*
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "0.0.0.0/0";
          #"hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/mnt/Shares/Public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "josh";
          "force group" = "wheel";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  */
}
