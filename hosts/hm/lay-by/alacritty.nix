{ lib, ... }:
{
  _class = "homeManager";
  _file = ./alacritty.nix;
  key = toString ./alacritty.nix;
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
      };
      terminal = {
        shell = "fish";
      };
      font = {
        size = lib.modules.mkForce 10;
      };
    };
  };
}
