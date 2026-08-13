{ euvlokInputs }:
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  hasDevenvModule = lib.attrsets.hasAttrByPath [ "programs" "devenv" ] options;
in
{
  options.euvlok.home.devenv.enable = lib.options.mkEnableOption "devenv" // {
    default = true;
  };

  config = lib.modules.mkIf config.euvlok.home.devenv.enable (
    lib.attrsets.optionalAttrs hasDevenvModule {
      programs.devenv = {
        enable = true;
        package = euvlokInputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    }
    // lib.attrsets.optionalAttrs (!hasDevenvModule) {
      home.packages = [ pkgs.devenv ];
    }
  );
}
