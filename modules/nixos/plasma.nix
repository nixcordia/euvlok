# Plasma is managed by plasma-manager, this module is only for the system services
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nixos.plasma.enable = lib.mkEnableOption "Minimal KDE Plasma system services for plasma-manager";

  config = lib.mkIf config.nixos.plasma.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.defaultSession = "plasma";
      xserver.displayManager.gdm.enable = true;
      gvfs.enable = true;

      # Required for proper integration
      dbus.packages = builtins.attrValues { inherit (pkgs) gcr; };
      udev.packages = builtins.attrValues {
        inherit (pkgs) gnome-settings-daemon;
        inherit (pkgs.gnome2) GConf;
      };
      gnome.gnome-settings-daemon.enable = true;
    };
  };
}
