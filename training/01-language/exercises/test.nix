let
  nixpkgs = import <nixpkgs> { };
in
{
  same = nixpkgs.bashInteractive == nixpkgs.bash;
}
