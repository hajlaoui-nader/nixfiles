{
  description = "home-manager configuration for linux, mac and raspberry pi";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, flake-utils, darwin, nixpkgs-unstable, nixpkgs-23_11, home-manager }: {
    
     
    nixosConfigurations = {
      zeus = nixpkgs-unstable.lib.nixosSystem rec {
        
        system = "x86_64-linux";
        modules = [
          ./nixpkgs/nixos/zeus.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zeus =
              import ./nixpkgs/home-manager/zeus.nix;
            home-manager.extraSpecialArgs = {
                nixpkgs = nixpkgs-23_11 {
                  inherit system;
                };
            };
          }
          {
            nix.settings.trusted-users = [ "zeus" ];
          }
        ];
      };
    };
	
    homeConfigurations = {
      linux = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
        modules = [
          ./nixpkgs/home-manager/linux.nix
          {
            nix.settings.trusted-users = [ "naderh" ];
          }
        ];
      };

      homepi = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs-unstable.legacyPackages.aarch64-linux;
        modules = [
          ./nixpkgs/home-manager/homepi.nix
          {
            nix.settings.trusted-users = [ "naderh" ];
          }
        ];
      };
    };

    darwinConfigurations = {
      mbp2023 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nixpkgs/darwin/mbp2023/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.naderh =
              import ./nixpkgs/home-manager/mbp2023.nix;
            home-manager.extraSpecialArgs = {
              inherit nixpkgs-unstable;
            };
          }
          {
            nix.settings.trusted-users = [ "naderh" ];
          }
        ];
        inputs = { inherit darwin nixpkgs-unstable; };
      };
    };

  };

}

