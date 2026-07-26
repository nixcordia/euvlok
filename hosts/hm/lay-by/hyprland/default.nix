_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./dunst.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./waybar.nix
  ];
}
