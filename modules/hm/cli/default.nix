_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./codex
    ./devenv.nix
    ./direnv.nix
    ./fastfetch
    ./fzf.nix
    ./git.nix
    ./jujutsu.nix
    ./nh.nix
    ./ssh.nix
    ./zoxide.nix
  ];
}
