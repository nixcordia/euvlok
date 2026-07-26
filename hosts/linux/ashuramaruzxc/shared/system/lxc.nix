_: {
  _class = "nixos";
  _file = ./lxc.nix;
  key = toString ./lxc.nix;
  virtualisation.lxc.enable = true;
  # virtualisation.lxd = {
  #   enable = true;
  #   recommendedSysctlSettings = true;
  # };
}
