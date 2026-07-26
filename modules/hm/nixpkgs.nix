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

  config = lib.mkIf (osConfig != null && osConfig ? nixos) {
    nixpkgs.config.cudaSupport = lib.mkDefault (osConfig.nixos.nvidia.enable or false);
    nixpkgs.config.rocmSupport = lib.mkDefault (osConfig.nixos.amd.enable or false);
  };
}
