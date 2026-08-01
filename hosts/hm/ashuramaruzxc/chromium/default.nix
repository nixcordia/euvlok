{
  pkgs,
  lib,
  ...
}:
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  config = lib.modules.mkIf pkgs.stdenvNoCC.isLinux {
    euvlok.home.chromium = {
      enable = true;
      browser = lib.modules.mkDefault "helium-browser";
      extraExtensions = import ./extensions.nix;
    };
  };
}
