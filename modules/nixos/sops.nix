{ euvlokInputs }:
{
  lib,
  ...
}:
{
  _class = "nixos";
  _file = ./sops.nix;
  key = toString ./sops.nix;
  imports = [ euvlokInputs.sops-nix.nixosModules.sops ];
  sops.age.keyFile = lib.modules.mkDefault "/var/lib/sops/age/keys.txt";
}
