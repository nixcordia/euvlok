{ euvlokInputs }:
{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  inherit (lib) mkOption types;
  hostPlatform = lib.attrByPath [ "nixpkgs" "hostPlatform" "system" ] (
    if osConfig == null then null else osConfig.nixpkgs.hostPlatform.system
  ) config;
in
{
  _class = null;
  _file = ./nixpkgs.nix;
  key = toString ./nixpkgs.nix;
  options.euvlok.nixpkgs.unstableSource = mkOption {
    type = types.path;
    default = euvlokInputs.nixpkgs-unstable-small;
    description = "Top-level Nixpkgs store path imported as pkgs.unstable.";
  };

  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (import ../../overlay.nix {
        inherit hostPlatform;
        inputs = euvlokInputs;
        unstableSource = config.euvlok.nixpkgs.unstableSource;
      })
    ];
  };
}
