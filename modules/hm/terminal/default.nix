_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./ghostty.nix
    ./kitty.nix
  ];
}
