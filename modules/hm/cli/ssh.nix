{
  lib,
  pkgs,
  config,
  ...
}:
{
  _class = "homeManager";
  _file = ./ssh.nix;
  key = toString ./ssh.nix;
  options.euvlok.home.ssh.enable = lib.options.mkEnableOption "SSH" // {
    default = true;
  };

  config = lib.modules.mkIf config.euvlok.home.ssh.enable {
    programs.ssh = {
      enable = true;
      package = pkgs.openssh_hpn;
      enableDefaultConfig = false;
      settings."*" = {
        AddKeysToAgent = "yes";
      };
    };
  };
}
