{
  description = "nini system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, oil }:

    let
      pkgs = import nixpkgs {
         inherit system;
         config = { allowUnfree = true; };
      };

      system = "x86_64-linux";
      lib = nixpkgs.lib;

    in {

      homeManagerConfigurations.nini = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;

        extraSpecialArgs = {
          inherit system oil;
        };

        modules = [
          ./users/nini/home.nix
          {
            home = {
              username = "nini";
              homeDirectory = "/home/nini";
              stateVersion = "25.11";
            };
          }
        ];
      };

      nixosConfigurations.nini = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };

    };
}
