{ lib, config, ... }:
{
  _class = "homeManager";
  _file = ./direnv.nix;
  key = toString ./direnv.nix;
  options.hm.direnv.enable = lib.options.mkEnableOption "Direnv" // {
    default = true;
  };

  config = lib.modules.mkIf config.hm.direnv.enable {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
