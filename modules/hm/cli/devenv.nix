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
  _class = "homeManager";
  _file = ./devenv.nix;
  key = toString ./devenv.nix;
  options.hm.devenv.enable = lib.options.mkEnableOption "devenv" // {
    default = true;
  };

  config = lib.modules.mkIf config.hm.devenv.enable (
    lib.attrsets.optionalAttrs hasDevenvModule {
      programs.devenv.enable = true;
    }
    // lib.attrsets.optionalAttrs (!hasDevenvModule) {
      home.packages = [ pkgs.devenv ];
    }
  );
}
