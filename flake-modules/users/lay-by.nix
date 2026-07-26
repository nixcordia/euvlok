{
  _class = "flake";
  _file = ./lay-by.nix;
  key = toString ./lay-by.nix;
  euvlok.users.lay-by = {
    nixosHosts.blind-faith.path = ../../hosts/linux/lay-by/hushh;
    homeModules.lay-by = ../../hosts/hm/lay-by;
  };
}
