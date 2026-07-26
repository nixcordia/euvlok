_: {
  _class = "nixos";
  _file = ./settings.nix;
  key = toString ./settings.nix;
  services = {
    fstrim.enable = true;
    fstrim.interval = "weekly";
    gvfs.enable = true;
  };
  nix.settings.trusted-users = [
    "@wheel"
    "ashuramaru"
  ];
}
