{ euvlokInputs }:
{
  lib,
  osConfig ? null,
  ...
}:
{
  _class = "homeManager";
  _file = ./nixpkgs.nix;
  key = toString ./nixpkgs.nix;
  imports = [
    (lib.modules.importApply ../cross/nixpkgs.nix { inherit euvlokInputs; })
  ];

  config = lib.modules.mkIf (osConfig != null && osConfig ? nixos) {
    nixpkgs.config.cudaSupport = lib.modules.mkDefault (osConfig.euvlok.nixos.nvidia.enable or false);
    nixpkgs.config.rocmSupport = lib.modules.mkDefault (osConfig.euvlok.nixos.amd.enable or false);
  };
}
