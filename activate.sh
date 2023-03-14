#bin/sh
nix build .#homeConfigurations.linuxwork.activationPackage && result/activate
