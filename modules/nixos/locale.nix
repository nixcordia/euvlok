{ lib, config, ... }:
let
  cfg = config.nixos.locale;
in
{
  _class = "nixos";
  _file = ./locale.nix;
  key = toString ./locale.nix;
  options.nixos.locale = {
    enable = lib.options.mkEnableOption "locale configuration";
    timeZone = lib.options.mkOption {
      type = lib.types.str;
      example = "Europe/Sofia";
      description = "IANA time zone to assign to `time.timeZone`.";
    };
    defaultLocale = lib.options.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Locale to assign to `i18n.defaultLocale`.";
    };
    extraLocaleSettings = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
      description = "Locale categories to assign to `i18n.extraLocaleSettings`.";
    };
  };

  config = lib.modules.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.defaultLocale;
    i18n.extraLocaleSettings = cfg.extraLocaleSettings;
  };
}
