_: {
  _class = "homeManager";
  _file = ./taskwarrior.nix;
  key = toString ./taskwarrior.nix;
  programs.taskwarrior = {
    enable = true;
    colorTheme = "light-256";
  };
}
