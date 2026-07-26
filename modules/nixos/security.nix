{ config, lib, ... }:
{
  _class = "nixos";
  _file = ./security.nix;
  key = toString ./security.nix;
  options.nixos.security.enable = lib.options.mkEnableOption "the shared security policy" // {
    default = true;
  };

  config = lib.modules.mkIf config.nixos.security.enable {
    security = {
      rtkit.enable = config.services.xserver.enable;
      polkit.enable = true;
      sudo.enable = false;
      sudo-rs.enable = true;
      sudo-rs.execWheelOnly = true;
    };
  };
}
