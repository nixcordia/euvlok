{ euvlokInputs }:
{
  lib,
  ...
}:
{
  imports = [ euvlokInputs.sops-nix.nixosModules.sops ];
  sops.age.keyFile = lib.modules.mkDefault "/var/lib/sops/age/keys.txt";
}
