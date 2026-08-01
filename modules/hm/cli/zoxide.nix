{ lib, config, ... }:
{
  _class = "homeManager";
  _file = ./zoxide.nix;
  key = toString ./zoxide.nix;
  options.euvlok.home.zoxide.enable = lib.options.mkEnableOption "Zoxide" // {
    default = true;
  };

  config = lib.modules.mkIf config.euvlok.home.zoxide.enable { programs.zoxide.enable = true; };
}
