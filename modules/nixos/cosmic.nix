{
  lib,
  config,
  ...
}:
{
  _class = "nixos";
  _file = ./cosmic.nix;
  key = toString ./cosmic.nix;

  options.nixos.cosmic.enable = lib.options.mkEnableOption "COSMIC";

  config = lib.modules.mkIf config.nixos.cosmic.enable {
    nixos.gui.enable = lib.modules.mkDefault true;

    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
    };
  };
}
