{
  lib,
  config,
  ...
}:
{

  options.euvlok.nixos.cosmic.enable = lib.options.mkEnableOption "COSMIC";

  config = lib.modules.mkIf config.euvlok.nixos.cosmic.enable {
    euvlok.nixos.gui.enable = lib.modules.mkDefault true;

    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
    };
  };
}
