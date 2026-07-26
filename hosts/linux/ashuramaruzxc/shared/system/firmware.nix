{ pkgs, ... }:
{
  _class = "nixos";
  _file = ./firmware.nix;
  key = toString ./firmware.nix;
  hardware = {
    enableRedistributableFirmware = true;
    firmware = builtins.attrValues { inherit (pkgs) linux-firmware; };
  };
  services.fwupd.enable = true;
}
