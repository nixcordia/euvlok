{ euvlokInputs, isDarwin }:
{ lib, ... }:
{
  _class = null;
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    (lib.modules.importApply ./nix { inherit euvlokInputs isDarwin; })
    (lib.modules.importApply ./nixpkgs.nix { inherit euvlokInputs; })
    ./packages.nix
  ];
}
