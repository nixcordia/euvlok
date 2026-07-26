{
  config,
  lib,
  pkgs,
  ...
}:
{
  _class = "homeManager";
  _file = ./fzf.nix;
  key = toString ./fzf.nix;
  options.hm.fzf.enable = lib.options.mkEnableOption "FZF" // {
    default = true;
  };

  config = lib.modules.mkIf config.hm.fzf.enable {
    programs.fzf = {
      enable = true;
      package = pkgs.unstable.fzf;
    };
  };
}
