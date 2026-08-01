{ euvlokInputs }:
{
  config,
  lib,
  ...
}:
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    euvlokInputs.catppuccin.homeModules.catppuccin
    ./firefox.nix
  ];

  catppuccin.vscode.profiles.default.enable = lib.modules.mkDefault false;
  catppuccin.autoEnable = lib.modules.mkDefault config.catppuccin.enable;
}
