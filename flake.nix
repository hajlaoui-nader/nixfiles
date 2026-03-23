{
  description = "home-manager configuration for linux, mac and raspberry pi";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/c53e5d1c2bfc2b905062022bee7380609f0f5029"; # pinned 2026-03-23
    nixpkgs-stable.url   = "github:NixOS/nixpkgs/50ab793786d9de88ee30ec4e4c24fb4236fc2674"; # nixos-24.11 pinned 2026-03-23

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = inputs@{ self, darwin, nixpkgs-unstable, nixpkgs-stable, home-manager, nixos-hardware }:
  let
    claudeCodeOverlay = import ./overlays/claude-code-overlay.nix;
    postmanOverlay    = import ./overlays/postman-overlay.nix;

    mkUnstable = system: overlays: import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = overlays;
    };
    mkStable = system: overlays: import nixpkgs-stable {
      inherit system;
      overlays = overlays;
    };
  in {

    nixosConfigurations = {
      zeus = nixpkgs-stable.lib.nixosSystem rec {
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
              nixpkgs  = mkStable   system [ claudeCodeOverlay ];
              unstable = mkUnstable system [ claudeCodeOverlay ];
              gitEmail = "hajlaoui.nader@gmail.com";
            };
          }
        ];
      };

      vizzia = nixpkgs-stable.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          unstable = mkUnstable system [];
        };
        modules = [
          ./hosts/vizzia/system.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nader = import ./home/vizzia.nix;
            home-manager.extraSpecialArgs = {
              nixpkgs  = mkStable   system [ claudeCodeOverlay postmanOverlay ];
              unstable = mkUnstable system [ claudeCodeOverlay ];
              gitEmail = "nader.hajlaoui@vizzia.fr";
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
            };
          }
        ];
      };
    };

  };

}
