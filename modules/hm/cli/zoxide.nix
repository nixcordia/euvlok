{ lib, config, ... }:
{
  _class = "homeManager";
  _file = ./zoxide.nix;
  key = toString ./zoxide.nix;
  options.hm.zoxide.enable = lib.options.mkEnableOption "Zoxide" // {
    default = true;
  };

  config = lib.modules.mkIf config.hm.zoxide.enable { programs.zoxide.enable = true; };
}
