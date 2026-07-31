{ euvlokInputs }:
{
  lib,
  ...
}:
{
  _class = "darwin";
  _file = ./sops.nix;
  key = toString ./sops.nix;
  imports = [ euvlokInputs.sops-nix.darwinModules.sops ];
  sops = {
    age.keyFile = lib.modules.mkDefault "/var/lib/sops/age/keys.txt";
    age.sshKeyPaths = lib.modules.mkDefault [ ];
  };
}
