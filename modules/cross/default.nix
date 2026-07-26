{ euvlokInputs }:
{ lib, ... }:
{
  _class = null;
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./nix
    (lib.modules.importApply ./nixpkgs.nix { inherit euvlokInputs; })
    ./packages.nix
  ];
}
