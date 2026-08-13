{ euvlokInputs }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.euvlok.home.devenv.enable = lib.options.mkEnableOption "devenv" // {
    default = true;
  };

  config = lib.modules.mkIf config.euvlok.home.devenv.enable {
    programs.devenv = {
      enable = true;
      package = euvlokInputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
