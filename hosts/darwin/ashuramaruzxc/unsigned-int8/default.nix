{
  homeModule,
  homebrewModule,
  homebrewTaps,
  sharedModules,
}:
_: {
  _class = "darwin";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = sharedModules ++ [
    ./brew.nix
    ./configuration.nix
    homeModule
    ./system.nix
    homebrewModule
    {
      nix-homebrew = {
        enable = true;
        user = "ashuramaru";
        taps = homebrewTaps;
        autoMigrate = true;
      };
    }
  ];
}
