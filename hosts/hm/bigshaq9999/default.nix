_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./git.nix
    ./ghostty.nix
    ./helix.nix
    ./mpv.nix
    ./nixcord.nix
    ./ssh.nix
    ./starship.nix
    ../shared/nixcord.nix
    ../shared/vscode.nix
  ];
}
