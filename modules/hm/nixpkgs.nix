{ euvlokInputs }:
{
  lib,
  osConfig ? null,
  ...
}:
{
  imports = [
    (lib.modules.importApply ../cross/nixpkgs.nix { inherit euvlokInputs; })
  ];

  config = lib.modules.mkIf (osConfig != null && osConfig ? nixos) {
    nixpkgs.config.cudaSupport = lib.modules.mkDefault (osConfig.euvlok.nixos.nvidia.enable or false);
    nixpkgs.config.rocmSupport = lib.modules.mkDefault (osConfig.euvlok.nixos.amd.enable or false);
  };
}
