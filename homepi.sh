#bin/sh
nix build .#homeConfigurations.homepi.activationPackage && result/activate
