{
  description = "home-manager configuration for linux, mac and raspberry pi";

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
       ]; 
      };
     };

      homeConfigurations = {
        linux = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          modules = [ 
            ./nixpkgs/home-manager/linux.nix 
          ];
        };

        # nix build .#homeConfigurations.homepi.system
        homepi = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./nixpkgs/home-manager/homepi.nix ];
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
          ];
          inputs = { inherit darwin nixpkgs; };
        };
      };

    };

}
