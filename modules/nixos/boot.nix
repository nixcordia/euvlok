{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.euvlok.nixos.boot;
  bootCountingSupported = lib.attrsets.hasAttrByPath [
    "boot"
    "loader"
    "systemd-boot"
    "bootCounting"
    "enable"
  ] options;
in
{
  _class = "nixos";
  _file = ./boot.nix;
  key = toString ./boot.nix;
  options.euvlok.nixos.boot.systemd-boot.enable =
    lib.options.mkEnableOption "systemd-boot with EFI"
    // {
      default = false;
    };

  config = lib.modules.mkIf cfg.systemd-boot.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        # Keep rollback entries bounded without exposing an interactive
        # kernel command editor.
        configurationLimit = lib.modules.mkDefault 10;
        editor = lib.modules.mkDefault false;
      }
      # bootCounting is newer than the release branch used by the Raspberry
      # Pi host. Enable it when the evaluating Nixpkgs provides the option.
      // lib.attrsets.optionalAttrs bootCountingSupported {
        bootCounting.enable = lib.modules.mkDefault true;
      };
    };
  };
}
