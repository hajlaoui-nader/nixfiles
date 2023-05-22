# The what ?
this is a basic flake definitions containing my basic configuration for my:
- home-manager
- linuxwork: linux machine
- homepi: raspberry pi
- darwin: macos

# Before
- Install [Nix][nix] and then install [home-manager][home-manager]. You should be
able to run the `home-manager` program in a shell.

# The how ?
- linux or rapsberry pi: `nix build .#homeConfigurations.<hostname>.activationPackage`
- macos: ```
$ nix build .#darwinConfigurations.mbp2023.system
$ ./result/sw/bin/darwin-rebuild switch --flake .
```

# Dotfiles

## Usage

Install [Nix][nix] and then install [home-manager][home-manager]. You should be
able to run the `home-manager` program in a shell.

Next, clone this repository to `~/.config/nixpkgs`.

```shell
$ git clone git@github.com:hajlaoui-nader/nix-dotfiles.git ~/.config/nixpkgs
```

This will place the [`home.nix`](home.nix) file in the location home-manager
expects. The home-manager profile can then be built and activated:

```shell
$ home-manager switch
$ home-manager switch --flake .#linuxwork
```

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
# after
- copy `nixpkgs/modules/iterm/com.googlecode.iterm2.plist` to `~/Library/Preferences/com.googlecode.iterm2`


### TODO
- nvim: fix fold nvim-ufo
- nvim: add terraform support
- nvim: add specific tree-sitter grammars
