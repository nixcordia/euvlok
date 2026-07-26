{ euvlokInputs }:
{ lib, ... }:
let
  paletteLock =
    (builtins.fromJSON (builtins.readFile (euvlokInputs.catppuccin-trivial + /pkgs/sources.json)))
    .palette;

  paletteSource = builtins.fetchTree {
    type = "github";
    owner = "catppuccin";
    repo = "palette";
    inherit (paletteLock) rev;
    narHash = paletteLock.hash;
  };
in
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;

  imports = [
    (lib.modules.importApply ./firefox.nix { inherit paletteSource; })
    ./zen-browser.nix
  ];
}
