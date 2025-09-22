{ pkgs, oil, purescript-vim, ... }:
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

		   own-purescript-vim = prev.vimUtils.buildVimPlugin {
		     name = "purescriptvim";
			 src = purescript-vim;
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
      pipewire
      pavucontrol

      # Video / Images
      simplescreenrecorder
      gscreenshot
      vlc

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
      git
      tmux
      htop
	  eza
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

      # -- Programming languages -- #

      # Haskell
      haskell.compiler.ghc9101
      cabal-install
      stack

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

      # Postgres
      postgresql
    ] ++
    [ nil
    ]
  );

  # Waybar config
  xdg.configFile."waybar/config".source = ./config/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./config/waybar/style.css;

  # Sway config
  wayland.windowManager.sway = {
    enable = true;
      wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1";
        };
      };
    };

    # Remove default swaybar
    config.bars = [];

    extraConfig = ''
      # Set the super key
      set $mod Mod4

      ### ─── Create workspaces and run certain apps on boot ────────────────────

      ## - Browser at workspace 1 - ##
      workspace 1

      # Launch Brave
      exec brave

      # All brave windows to workspace 1 with stacking layout
      for_window [app_id="brave-browser"] move to workspace 1, layout stacking

      ## - Haskell projects at workspace 2 - ##
      workspace 2

      # Launch terminal on ws 2 in haskell dir running tmux
      exec alacritty --working-directory ~/dev/haskell -e tmux new-session -A -s haskell -c ~/dev/haskell

      ## - Dotfiles at workspace 4 -##
      workspace 4

      # Launch terminal on workspace 4 in dotfiles dir running tmux
      exec alacritty --working-directory ~/.dotfiles -e tmux new-session -A -s dotfiles -c ~/.dotfiles

      # --- Htop Scratchpad Setup ---

      # Start htop in its own terminal
      exec alacritty --class htop -e htop
      
      # Send it to the scratchpad and make it floating
      for_window [app_id="htop"] move to scratchpad, floating enable, resize set width 800 height 600, move position center
      
      # Unbind from default
      unbindsym $mod+h

      # Show or hide the htop scratchpad window from anywhere
      bindsym $mod+h [app_id="htop"] scratchpad show

      # --------- #

      # Hide cursor when not moving it
      seat seat0 hide_cursor 10000

      # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      # Volume
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%

      # Keyboard and touchpad
      input "type:keyboard" {
        xkb_layout gb
        xkb_options "ctrl:nocaps"
      }

      input "type:touchpad" {
        tap enabled
      }

      # Waybar
      exec_always waybar

      # --- Wallpaper ---
      output * bg "${./config/image/wallpaper_1.jpg}" fill

      # --- Go to lock page when idle for a while
      exec swayidle -w \
        timeout 300 "swaylock -f -i ${./config/image/wallpaper_1.jpg}" \
        timeout 600 "swaymsg 'output * dpms off'" \
        resume "swaymsg 'output * dpms on'"
    '';
  };

  # Enable FontConfig (needed for jetbrains fonts)
  fonts.fontconfig.enable = true;

  # Have external alacritty config instead of using programs.alcritty
  xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty/alacritty.toml;

  # Style mouse pointer
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };

  # Import external nix configs
  imports = [
      ./config/tmux/tmux.nix
      ./config/zsh/zsh.nix
      ./config/nvim/nvim.nix
      ./config/bat/bat.nix
      ./config/obs-studio/obs-studio.nix
  ];
}
