{ config, pkgs, system, oil, purescript-vim, neovim-release, ... }:

{
  home.username = "nini";
  home.homeDirectory = "/home/nini";

  home.stateVersion = "23.05";

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

  home.packages = with pkgs; ([
      cachix
      google-chrome
      git
      tmux
      ripgrep
      docker
      docker-compose
      glib
      fd
      networkmanager
      htop
      nodejs
      gcc
      gnumake
      python3
      direnv
      ngrok
      inetutils
      postgresql
      rustup
      llvmPackages.libclang
      protobuf
      cabal-install
      stack
      yarn
      docker
      haskell.compiler.ghc8107
      haskellPackages.fourmolu
      haskellPackages.hlint
      haskellPackages.haskell-language-server
      haskellPackages.implicit-hie
      haskellPackages.hie-bios
      mdbook
      gscreenshot
      simplescreenrecorder
      vlc
      pamixer
      pipewire
      nix-prefetch-git
      okular
      litemdview
      pciutils
      zip
      unzip
	  pulseaudio
	  alacritty
	  (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ] ++
    [ nil
    ]);

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
      ];
      theme = "agnoster";
    };
    plugins = [
      { 
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "caa749d030d22168445c4cb97befd406d2828db0";
          sha256 = "YV9lpJ0X2vN9uIdroDWEize+cp9HoKegS3sZiSpNk50=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner= "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
    ];
    localVariables = {
      EDITOR = "vim";
    };

    shellAliases = {
      # cabal
      cb = "cabal build";
      ct = "cabal test";
      # spago
      sb = "spago build";
      st = "spago test";
      stp = "spago test --main Test.Plutip";
      # rust
      crb = "cargo build";
      crt = "cargo test";
      crn = "cargo new";
      # make
      mrb = "make run-build";
      mrd = "make run-dev-dashboard";
      mf = "make format";
      # nix
      nd = "nix develop -c zsh";
      # nvim
      nv = "nvim";
      # git
      gs = "git status";
      ga = "git add";
      # ls
      ls = "ls -l";
    };
  };

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };
      font = {
        normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrains Mono Nerd Font";
          style = "regular";
        };
        size = 14.00;
      };
      colors = {
        primary = {
          background = "#1d1f21";
          foreground = "#c5c8c6";
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
	wrapperFeatures.gtk = true;
	config = rec {
	  modifier = "Mod4";
	  terminal = "alacritty";
	  output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1";
	    };
	  };
	};
	extraConfig = ''
	  # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      # Volume
	  bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%

	  input "type:keyboard" {
		xkb_layout gb
	    xkb_options "ctrl:nocaps"
	  }
	'';
  };

  programs.neovim =
    let
       toLua = str: "lua << EOF\n${str}\nEOF\n";
       toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in 
    {
      enable = true;
   
      viAlias = true;
      vimAlias = true; vimdiffAlias = true; extraLuaConfig = ''
        ${builtins.readFile ./config/nvim/lua/options.lua}
      '';

      extraPackages = with pkgs; [
		luajitPackages.lua-lsp
	    lua-language-server
		nodePackages.purescript-language-server
		rnix-lsp
	  ];

      plugins = with pkgs.vimPlugins; [
	    {
	      plugin = nvim-lspconfig;
	      config = toLuaFile ./config/nvim/lua/plugin/lsp.lua;
	    }

	    cmp_luasnip
	    luasnip

        cmp-nvim-lsp
        neodev-nvim

        nvim-cmp 
        {
          plugin = nvim-cmp;
          config = toLuaFile ./config/nvim/lua/plugin/cmp.lua;
        }

	    {
	      plugin = telescope-nvim;
	      config = toLuaFile ./config/nvim/lua/plugin/telescope.lua;
	    }

		{
		  plugin = pkgs.vimPlugins.own-oil;
		  config = toLuaFile ./config/nvim/lua/plugin/oil.lua;
		}

		own-purescript-vim
     ];
    };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less - FR";
    };
  };

  imports = [
      ./config/tmux/tmux.nix
  ];
}
