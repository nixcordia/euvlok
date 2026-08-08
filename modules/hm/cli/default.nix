{ euvlokInputs }:
{ lib, ... }:
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./codex
    (lib.modules.importApply ./devenv.nix { inherit euvlokInputs; })
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
