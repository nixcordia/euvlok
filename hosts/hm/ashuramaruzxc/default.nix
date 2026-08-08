_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./aliases.nix
    ./chromium
    ./codex.nix
    ./dconf.nix
    ./firefox
    ./git.nix
    ./helix.nix
    ../shared/nixcord.nix
    ./ssh.nix
    ./starship.nix
    ../shared/vscode.nix
    ./zed.nix
  ];
}
