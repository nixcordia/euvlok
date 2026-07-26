{ euvlokInputs }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  _class = "homeManager";
  _file = ./sops.nix;
  key = toString ./sops.nix;
  imports = [ euvlokInputs.sops-nix-trivial.homeManagerModules.sops ];
  sops.age.keyFile = lib.modules.mkDefault (
    if pkgs.stdenvNoCC.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt"
    else
      "${config.home.homeDirectory}/.config/sops/age/keys.txt"
  );
}
