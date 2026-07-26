{ euvlokInputs }:
{ lib, ... }:
{
  _class = "darwin";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    (lib.modules.importApply ../cross { inherit euvlokInputs; })
    ./nix.nix
    (lib.modules.importApply ./sops.nix { inherit euvlokInputs; })
    ./system.nix
  ];
}
