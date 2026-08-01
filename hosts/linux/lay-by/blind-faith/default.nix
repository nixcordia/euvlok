{
  configurationModule,
  homeModule,
  sharedModule,
  stylixModule,
  unstableSource,
}:
_: {
  _class = "nixos";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    sharedModule
    configurationModule
    homeModule
    stylixModule
    ./stylix.nix
    {
      euvlok.nixpkgs.unstableSource = unstableSource;
      euvlok.nixos = {
        gui.enable = true;
        nvidia.enable = true;
        steam.enable = true;
      };
    }
  ];
}
