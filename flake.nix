{
  description = "home-manager configuration for linux, mac and raspberry pi";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/af51545ec9a44eadf3fe3547610a5cdd882bc34e";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/2f7739d01080feb4549524e8f6927669b61c6ee3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      # if you want to change darwin to use stable change the following, now darwin follows nixpkgs-unstable
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, flake-utils, darwin, nixpkgs-unstable, nixpkgs-24_05, home-manager-stable, home-manager-unstable }: {


    nixosConfigurations = {
      zeus = nixpkgs-24_05.lib.nixosSystem rec {

        system = "x86_64-linux";
        modules = [
          ./machines/nixos/zeus.nix
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zeus =
              import ./nixpkgs/home-manager/zeus.nix;
            home-manager.extraSpecialArgs = {
              nixpkgs = nixpkgs-24_05 {
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
      mbp2023 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = [
          ./machines/darwin/mbp2023/configuration.nix
          home-manager-unstable.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.naderh =
              import ./nixpkgs/home-manager/mbp2023.nix;
            home-manager.extraSpecialArgs =
              {
                # put here the variables that you want to pass to the home-manager configuration such as pkgs unstable
                unstable = import nixpkgs-unstable
                  {
                    inherit system;
                  };
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

