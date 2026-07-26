_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    # Niri has to be imported manually by host
    # ./niri
    ./hyprland
  ];
}
