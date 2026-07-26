{ lib, ... }:
let
  aliases = {
    rebuild = lib.modules.mkForce "nixos-rebuild test --use-remote-sudo --flake $(readlink -f /etc/nixos);nixos-rebuild switch --use-remote-sudo --flake $(readlink -f /etc/nixos)";
    xdg-data-dirs = "echo -e $XDG_DATA_DIRS | tr ':' '\n' | nl | sort";
  };
in
{
  _class = "homeManager";
  _file = ./aliases.nix;
  key = toString ./aliases.nix;
  programs = lib.attrsets.genAttrs [ "bash" "zsh" ] (_: {
    shellAliases = aliases;
  });
}
