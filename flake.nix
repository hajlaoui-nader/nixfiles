{
  description = "home-manager configuration for linux, mac and raspberry pi";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/7c43f080a7f28b2774f3b3f43234ca11661bf334"; # contains ghostty

    home-manager-stable = {
      url = "github:nix-community/home-manager/2f7739d01080feb4549524e8f6927669b61c6ee3";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      # if you want to change darwin to use stable change the following, now darwin follows nixpkgs-unstable
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

  };

  outputs = inputs@{ self, flake-utils, darwin, nixpkgs-unstable, nixpkgs-stable, home-manager-stable, home-manager-unstable, nixos-hardware }: {


    nixosConfigurations = {
      zeus = nixpkgs-stable.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/nixos/zeus.nix
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zeus =
              import ./nixpkgs/home-manager/zeus.nix;
            home-manager.extraSpecialArgs = {
              nixpkgs = import nixpkgs-stable {
                inherit system;
              };
              unstable = import nixpkgs-unstable {
                inherit system;
              };
              gitEmail = "hajlaoui.nader@gmail.com";
            };
          }
        ];
      };

      vizzia = nixpkgs-stable.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/nixos/vizzia/vizzia.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nader =
              import ./nixpkgs/home-manager/vizzia.nix;
            home-manager.extraSpecialArgs = {
              nixpkgs = import nixpkgs-stable {
                inherit system;
              };
              unstable = import nixpkgs-unstable {
                inherit system;
              };
              gitEmail = "nader.hajlaoui@vizzia.fr";
            };
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
      mbp2023 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/darwin/mbp2023/configuration.nix
          home-manager-unstable.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.naderh = import ./nixpkgs/home-manager/mbp2023.nix;
            home-manager.extraSpecialArgs = {
              # put here the variables that you want to pass to the home-manager configuration such as pkgs unstable
              unstable = import nixpkgs-unstable {
                inherit system;
              };
              gitEmail = "hajlaoui.nader@gmail.com";
            };
          }
        ];
      };
    };

  };

}

