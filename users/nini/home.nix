{ pkgs, oil, ... }:
{
  home.username = "nini";
  home.homeDirectory = "/home/nini";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  nixpkgs = {
     overlays = [
       (final: prev: {
         vimPlugins = prev.vimPlugins // {

           own-oil = prev.vimUtils.buildVimPlugin {
             name = "nvimtree";
             src = oil;
           };

         };
       })
     ];
  };

  # Installed programs
  home.packages = with pkgs; ([
    # browsers
	brave
    google-chrome
    
    # networking
    networkmanager
    inetutils
    protobuf
	postman
    ngrok

    # docker
    docker
    docker-compose

    # nix specific
    nix-prefetch-git
    cachix
    direnv

    # Audio
	pulseaudio
    pamixer
    pavucontrol
    pipewire

    # Screencast capture
    grim
    # ^ Screenshot tool
    slurp
    # ^ Region selection for screenshots / screencasts

    # Portals for apps (Chrome etc.) to capture screen
    xdg-desktop-portal

    # Wayland screen recorder
    wf-recorder

    # Video player
    vlc

    # Screenshots
    simplescreenrecorder
    gscreenshot

    # Reading
    kdePackages.okular
    litemdview
    mdbook

    # Terminal / general progs
	alacritty
    nerd-fonts.jetbrains-mono
    pciutils
    ripgrep
    killall
    lsof
    git
    tmux
    htop
	eza
    tree
    zip
    unzip
	jq
    fd

    # Sway specific
    swayidle
    swaylock

    # Waybar and related
    waybar
    nwg-bar
    fuzzel

    # -- Programming languages -- #

    # Haskell
    haskell.compiler.ghc912
    cabal-install
    stack
    hlint

    # Python
    python3

    # C
    llvmPackages.libclang
    gnumake
    glib
    gcc

    # Assembly
	nasm
	gdb

    # JavaScript
    nodejs
    yarn

    # Rust
    rustup

    # Prolog
    swi-prolog

    # Postgres
    postgresql
    ] ++
    [ nil
    ]
  );

  # Waybar config
  xdg.configFile."waybar/config".source = ./config/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./config/waybar/style.css;

  # Enable FontConfig (needed for jetbrains fonts)
  fonts.fontconfig.enable = true;

  # Have external alacritty config instead of using programs.alcritty
  xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty/alacritty.toml;

  # Import external nix configs
  imports = [
    # Main sway, screen lock, and mouse pointer configs
    ./config/sway/sway.nix
    ./config/swaylock/swaylock.nix
    ./config/pointer-cursor/cursor.nix

    # tmux
    ./config/tmux/tmux.nix

    # ZSH
    ./config/zsh/zsh.nix

    # Nvim
    ./config/nvim/nvim.nix

    # ghci
    ./config/ghci/ghci.nix

    # Fuzzel (app launch and active browser tabs script)
    ./config/fuzzel/fuzzel.nix
    ./config/fuzzel/fuzzel-script.nix

    # bat config
    ./config/bat/bat.nix

    # obs studio config
    ./config/obs-studio/obs-studio.nix
  ];
}
