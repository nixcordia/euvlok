{ ... }:
{
  _class = "darwin";
  _file = ./system.nix;
  key = toString ./system.nix;
  system = {
    keyboard.enableKeyMapping = true;
    defaults.dock = {
      tilesize = 44;
    };
    stateVersion = 5;
  };
}
