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
      default = { };
      example = {
        LC_MEASUREMENT = "pl_PL.UTF-8";
        LC_TIME = "pl_PL.UTF-8";
      };
      description = ''
        Locale categories that should differ from `defaultLocale`. Unspecified
        categories inherit the default locale through `LANG`.
      '';
    };
  };

  config = lib.modules.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.defaultLocale;
    i18n.extraLocaleSettings = cfg.extraLocaleSettings;
  };
}
