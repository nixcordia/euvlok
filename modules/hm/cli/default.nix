{ euvlokInputs }:
{ lib, ... }:
{
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
