{
  description = "nini system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

	neovim-release = {
	  url = "github:neovim/neovim?rev=8b98642002d0506d20628683958cb5c97a0dad80";
	  flake = false;
	};

	# Packages not available in home-manager
    purescript-vim.url = "github:purescript-contrib/purescript-vim";
    oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, oil, purescript-vim, neovim-release, ... }:

    let
      pkgs = import nixpkgs {
         inherit system;
         config = { allowUnfree = true; };
      };

      system = "x86_64-linux";
      lib = nixpkgs.lib;

    in {

      homeManagerConfigurations = {
        nini = home-manager.lib.homeManagerConfiguration {

          pkgs = pkgs;

          extraSpecialArgs = {
            inherit system oil purescript-vim neovim-release;
          };

          modules = [
            ./users/nini/home.nix
            ./users/nini/config/tmux/tmux.nix
            {
              home = {
                username = "nini";
                homeDirectory = "/home/nini";
                stateVersion = "23.05";
              };
            }
          ];
        };
      };

      nixosConfigurations.nini = lib.nixosSystem {
          inherit system;

          modules = [
            ./system/configuration.nix
          ];
      };

    };

}
