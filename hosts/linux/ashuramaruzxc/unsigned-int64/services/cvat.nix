{ config, ... }:
{
  _class = "nixos";
  _file = ./cvat.nix;
  key = toString ./cvat.nix;
  users.groups = {
    cvat = {
      gid = config.users.users.cvat.uid;
    };
    nginx.members = [ "cvat" ];
  };
  users.users.cvat = {
    isSystemUser = true;
    group = "cvat";
    uid = 8765;
  };
}
