{
  homeModule,
  homebrewModule,
  homebrewTaps,
  sharedModules,
}:
_: {
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
