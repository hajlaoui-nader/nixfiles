{
  description = "home-manager configuration for linux, mac and raspberry pi";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/4ea98378ec0cfebcecb3eff00dd4c9635ccc695f"; # pinned 2026-03-23

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs@{ self, darwin, nixpkgs-unstable, home-manager, ... }:
  let
    claudeCodeOverlay = import ./overlays/claude-code-overlay.nix;

    mkUnstable = system: overlays: import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = overlays;
    };
in {

    nixosConfigurations = {
      zeus = nixpkgs-unstable.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/zeus/system.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zeus = import ./home/zeus.nix;
            home-manager.extraSpecialArgs = {
              unstable = mkUnstable system [ claudeCodeOverlay ];
              gitEmail = "hajlaoui.nader@gmail.com";
            };
          }
        ];
      };

    };

    darwinConfigurations = {
      mbp2023 = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/mbp2023/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.naderh = import ./home/mbp2023.nix;
            home-manager.extraSpecialArgs = {
              unstable = mkUnstable system [ claudeCodeOverlay ];
              gitEmail = "hajlaoui.nader@gmail.com";
              inherit inputs;
            };
          }
        ];
      };
    };

  };

}
