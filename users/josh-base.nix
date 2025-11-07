{
  config,
  pkgs,
  lib,
  ...
}:

{

  # TODO please change the username & home directory to your own
  # TODO: should set this in flake.
  home.stateVersion = "24.11";
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # temp blocking out due to build issues
    # https://github.com/nixos/nixpkgs/issues/450617
    #awscli2
    nerd-fonts.fira-code
    nil
    gh
    nixfmt
    starship
    crane
    jq
    wget
    kubectx
    kind
    gopls
    kubectl
    kustomize
    go
    rustc
    cargo
    rust-bindgen-unwrapped
    htop
    unzip
    tree
    gnupg
    google-cloud-sdk
    fzf
    keychain
    terraform
    spotify
    terraform
    git
    sipcalc
    ripgrep
    fluxcd
    jira-cli-go
    oras
    yq-go
    vault
    ## prob should be pulled into gui
    tmuxPlugins.catppuccin
    ## prob should be pulled into gui
    alacritty-theme
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs; [
      vimPlugins.catppuccin-nvim
      vimPlugins.telescope-nvim
      vimPlugins.vim-fugitive
      vimPlugins.vim-rhubarb
      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-eunuch
      vimPlugins.vim-gitgutter
      vimPlugins.vim-nix
      vimPlugins.typescript-vim
      vimPlugins.vim-monokai-pro
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-web-devicons
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      vimPlugins.cmp-cmdline
      vimPlugins.nvim-cmp
      vimPlugins.cmp-vsnip
      vimPlugins.vim-vsnip
      vimPlugins.trouble-nvim
      vimPlugins.neo-tree-nvim
      vimPlugins.lsp-format-nvim
      vimPlugins.copilot-vim
      vimPlugins.outline-nvim
    ];

    extraLuaConfig = (builtins.readFile ./vim.lua);
  };

  programs.git = {
    enable = true;
    userName = "joshrosso";
    userEmail = "joshrosso@gmail.com";
    signing = {
      key = "B076918EE70E30CF98B2EB4AD5CD572310881E88";
      signByDefault = false;
    };
    extraConfig = {
      push.default = "current";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$kubernetes"
        "$aws"
        "$line_break"
        "$character"
      ];
      add_newline = false;
      aws = {
        disabled = false;
        format = "'[$symbol($profile )(\($region\) )]($style)'";
      };
      gcloud.disabled = true;
      kubernetes = {
        disabled = false;
        format = "in [\\[$context | (\($namespace\))\\]]($style)";
        style = "bold white";
      };
    };
  };

  #  programs.ssh = {
  #    enable = true;
  #    matchBlocks = {
  #      "h1" = {
  #        user = "root";
  #        identityFile = "~/.ssh/homelab";
  #      };
  #      "h2" = {
  #        user = "root";
  #        identityFile = "~/.ssh/homelab";
  #      };
  #      "fenix" = {
  #        user = "josh";
  #        identityFile = "~/.ssh/joshrosso.pem";
  #      };
  #      "github.com" = {
  #        user = "joshrosso";
  #        identityFile = "~/.ssh/joshrosso.pem";
  #      };
  #      "192.168.*" = {
  #        user = "josh";
  #        identityFile = "~/.ssh/joshrosso.pem";
  #      };
  #    };
  #  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    #
    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      g = "git";
      v = "nvim";
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    historyLimit = 100000;
    terminal = "tmux-256color";
    mouse = true;
    extraConfig = ''
      set -g status-bg black
      set -g status-fg white
    '';
  };

}
