_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./git.nix
    ./ssh.nix
  ];
}
