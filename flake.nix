{
  description = "nini system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

	# Packages not available in home-manager
    purescript-vim.url = "github:purescript-contrib/purescript-vim";
    oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, oil, purescript-vim }:

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
            inherit system oil purescript-vim;
          };

          modules = [
            ./users/nini/home.nix
            ./users/nini/config/tmux/tmux.nix
            {
              home = {
                username = "nini";
                homeDirectory = "/home/nini";
                stateVersion = "25.11";
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
