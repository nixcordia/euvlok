{ lib, config, ... }:
let
  paths = import ./paths.nix { inherit lib; };
in
{
  options.euvlok.home.bash.enable = lib.options.mkEnableOption "Bash" // {
    default = true;
  };

  config = lib.modules.mkIf config.euvlok.home.bash.enable {
    programs.bash = {
      enable = true;
      enableVteIntegration = true;
      initExtra = ''
        ${paths.hm.shell.binPaths.bash}
      '';
    };
  };
}
