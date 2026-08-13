{ euvlokInputs }:
{
  config,
  lib,
  ...
}:
{
  imports = [
    euvlokInputs.catppuccin.homeModules.catppuccin
    ./firefox.nix
  ];

  catppuccin.vscode.profiles.default.enable = lib.modules.mkDefault false;
  catppuccin.autoEnable = lib.modules.mkDefault config.catppuccin.enable;
}
