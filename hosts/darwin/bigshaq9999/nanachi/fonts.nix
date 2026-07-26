{ pkgs, ... }:
{
  _class = "darwin";
  _file = ./fonts.nix;
  key = toString ./fonts.nix;
  fonts.packages = builtins.attrValues {
    inherit (pkgs.nerd-fonts)
      jetbrains-mono
      monaspace
      noto
      hack
      ;
  };
}
