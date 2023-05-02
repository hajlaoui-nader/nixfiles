#bin/sh
nix build .#homeConfigurations.linux.activationPackage && result/activate
