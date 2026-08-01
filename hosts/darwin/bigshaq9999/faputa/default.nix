{
  homeModule,
  sharedModules,
}:
_: {
  _class = "darwin";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = sharedModules ++ [
    ./configuration.nix
    homeModule
    ./system.nix
    ./fonts.nix
    ./brew.nix
    { services.tailscale.enable = true; }
  ];
}
