# The what ?

this is a basic flake definitions containing my basic configuration for my:

- home-manager
- linuxwork: linux machine
- homepi: raspberry pi
- darwin: macos

# Before

- Install [Nix](!https://nixos.org/) and then install [home-manager](!https://github.com/nix-community/home-manager). You should be
  able to run the `home-manager` program in a shell.

# The how ?

- linux or rapsberry pi: `nix build .#homeConfigurations.<hostname>.activationPackage`
- macos: ```
  $ nix build .#darwinConfigurations.mbp2023.system
  $ ./result/sw/bin/darwin-rebuild switch --flake .

````

# Dotfiles

## Usage
### hm

```shell
$ home-manager switch
$ home-manager switch --flake .#linuxwork
````

flake activation on linux

```shell
nix build .#homeConfigurations.linux.activationPackage
result/activate
```

update the flake

```shell
$ nix flake update
```

To update home-manager:

```shell
$ nix-channel --update nixpkgs
unpacking channels...
$ nix-env -u home-manager
```

To update home-manager-managed packages:

```shell
$ nix-channel --update nixpkgs
unpacking channels...
$ home-manager switch
```

list all packages

```shell
home-manager packages
```

# after

- copy `nixpkgs/modules/iterm/com.googlecode.iterm2.plist` to `~/Library/Preferences/com.googlecode.iterm2`

# helpers

## install package

```shell
nix-env -iA nixpkgs.<package>
```

## search package

```shell
nix search nixpkgs <package>
```

## Update system

```shell
nix flake update

# Apply the updates
sudo nixos-rebuild switch --flake .#??? <== put output
```

### TODO
