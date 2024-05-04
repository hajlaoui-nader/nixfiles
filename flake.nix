{
  description = "home-manager configuration for linux, mac and raspberry pi";

  # the nixConfig here only affects the flake itself, not the system configuration!
  #nixConfig = {
  ## override the default substituters
  #substituters = [
  ## cache mirror located in China
  ## status: https://mirror.sjtu.edu.cn/
  #"https://mirror.sjtu.edu.cn/nix-channels/store"
  ## status: https://mirrors.ustc.edu.cn/status/
  ## "https://mirrors.ustc.edu.cn/nix-channels/store"

  #"https://cache.nixos.org"

  ## nix community's cache server
  #"https://nix-community.cachix.org"
  #];
  #trusted-public-keys = [
  ## nix community's cache server public key
  #"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #];
  #};

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-utils, darwin, nixpkgs, home-manager }: {
    nixosConfigurations = {
      zeus = nixpkgs.lib.nixosSystem {
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
              inherit nixpkgs;
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
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./nixpkgs/home-manager/linux.nix
          {
            nix.settings.trusted-users = [ "naderh" ];
          }
        ];
      };

      # nix build .#homeConfigurations.homepi.system
      homepi = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
        modules = [
          ./nixpkgs/home-manager/homepi.nix
          {
            nix.settings.trusted-users = [ "naderh" ];
          }
        ];
      };
    };

    # nix build .#darwinConfigurations.mbp2023.system
    # ./result/sw/bin/darwin-rebuild switch --flake .#mbp2023
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
              inherit nixpkgs;
            };
          }
          {
            nix.settings.trusted-users = [ "naderh" ];
          }
        ];
        inputs = { inherit darwin nixpkgs; };
      };
    };

  };

}
