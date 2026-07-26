_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./aliases.nix
    ./chromium
    ./dconf.nix
    ./firefox
    ./git.nix
    ./helix.nix
    ./nixcord.nix
    ./nushell.nix
    ./ssh.nix
    ./starship.nix
    ./vscode.nix
    ./zed.nix
  ];
}
