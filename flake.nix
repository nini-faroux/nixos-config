{
  description = "nini system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let 
    system = "x86_64-linux";

    
    pkgs = import pkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  
    lib = nixpkgs.lib;

  in { 
    nixosConfigurations = { 
      testbox = lib.nixosSystem { 
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
