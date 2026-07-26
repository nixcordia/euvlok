{
  _class = "homeManager";
  _file = ./helix.nix;
  key = toString ./helix.nix;
  imports = [ ../shared/helix-vim-keys.nix ];
}
