{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";

    nixpkgsUnstable.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:hajlaoui-nader/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-utils, darwin, nixpkgs, nixpkgsUnstable
    , home-manager, neovim-flake }: {

      imports = [ neovim-flake.nixosModules.hm ];
      
      homeConfigurations = {

        linuxwork = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./nixpkgs/home-manager/linuxwork.nix ];
          extraSpecialArgs = {
            pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
          };
        };

        # nix build .#homeConfigurations.homepi.system
        homepi = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./nixpkgs/home-manager/homepi.nix ];
          extraSpecialArgs = {
            pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux;
          };
        };

      };

      # nix build .#darwinConfigurations.mbp2023.system
      # ./result/sw/bin/darwin-rebuild switch --flake .
      darwinConfigurations = {
        mbp2023 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./nixpkgs/darwin/mbp2023/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.naderhajlaoui =
                import ./pkgs/home-manager/mbp2023.nix;
              home-manager.extraSpecialArgs = {
                inherit nixpkgs;
                pkgsUnstable =
                  inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin;
              };
            }
          ];
          inputs = { inherit darwin nixpkgs; };
        };
      };

    };

}
