_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./aliases.nix
    ./bash.nix
    ./fish.nix
    ./nushell
    ./zsh.nix
  ];
}
