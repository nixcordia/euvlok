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

    ethernet.enable = lib.options.mkEnableOption "the shared automatic Ethernet profile" // {
      default = true;
    };

    ethernetBond.enable =
      lib.options.mkEnableOption "enslaving the shared Ethernet profile to bond0"
      // {
        default = false;
      };
  };

  config = lib.modules.mkMerge [
    (lib.modules.mkIf cfg.enable {
      networking.networkmanager.enable = true;
    })

    (lib.modules.mkIf (cfg.enable && cfg.ethernet.enable) {
      networking.networkmanager.ensureProfiles.profiles.ethernet = {
        connection = {
          id = "ethernet";
          type = "ethernet";
        }
        // lib.attrsets.optionalAttrs cfg.ethernetBond.enable {
          master = "bond0";
          slave-type = "bond";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    })

    {
      assertions = [
        {
          assertion = !cfg.ethernetBond.enable || (cfg.enable && cfg.ethernet.enable);
          message = ''
            nixos.networking.ethernetBond.enable requires both
            nixos.networking.enable and nixos.networking.ethernet.enable.
          '';
        }
      ];
    }
  ];
}
