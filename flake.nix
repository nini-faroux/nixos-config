{
  description = "nini system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
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
         inherit system pkgs;
         username = "nini";
         stateVersion = "21.11";
         homeDirectory = "/home/nini";
         configuration = { 
            imports = [
               ./users/nini/home.nix
	             ./users/nini/config/tmux.nix
	             ./users/nini/config/neovim.nix
            ];
         }; 
      };
    };

    nixosConfigurations = { 
      nini = lib.nixosSystem { 
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
