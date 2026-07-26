{ config, lib, ... }:
let
  cfg = config.nixos.networking;
in
{
  _class = "nixos";
  _file = ./networking.nix;
  key = toString ./networking.nix;
  options.nixos.networking = {
    enable = lib.options.mkEnableOption "NetworkManager" // {
      default = true;
    };
    ethernetBond.enable = lib.options.mkEnableOption "the shared bond0 Ethernet profile" // {
      default = true;
    };
  };

  config = lib.modules.mkMerge [
    (lib.modules.mkIf cfg.enable {
      networking.networkmanager.enable = true;
    })
    (lib.modules.mkIf cfg.ethernetBond.enable {
      networking.networkmanager.ensureProfiles.profiles = {
        ethernet = {
          connection = {
            id = "ethernet";
            type = "ethernet";
            master = "bond0";
            slave-type = "bond";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    })
  ];
}
