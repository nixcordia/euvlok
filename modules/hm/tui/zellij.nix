{ lib, config, ... }:
{
  _class = "homeManager";
  _file = ./zellij.nix;
  key = toString ./zellij.nix;
  options.hm.zellij.enable = lib.options.mkEnableOption "Zellij";

  config = lib.modules.mkIf config.hm.zellij.enable {
    programs.zellij.enable = true;
  };
}
