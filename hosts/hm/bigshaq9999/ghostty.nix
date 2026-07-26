_: {
  _class = "homeManager";
  _file = ./ghostty.nix;
  key = toString ./ghostty.nix;
  programs.ghostty.settings = {
    font-size = 16;
  };
}
