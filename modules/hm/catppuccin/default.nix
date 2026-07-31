{ euvlokInputs }:
{ lib, ... }:
let
  sourceLocks = builtins.fromJSON (
    builtins.readFile (euvlokInputs.catppuccin + /pkgs/sources.json)
  );
  fetchCatppuccinSource =
    repo:
    let
      lock = sourceLocks.${repo};
    in
    fetchTree {
      type = "github";
      owner = "catppuccin";
      inherit repo;
      inherit (lock) rev;
      narHash = lock.hash;
    };
  paletteSource = fetchCatppuccinSource "palette";
  gituiSource = fetchCatppuccinSource "gitui";
  starshipSource = fetchCatppuccinSource "starship";
in
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;

  imports = [
    (lib.modules.importApply ./firefox.nix { inherit paletteSource; })
    ./zen-browser.nix
  ];

  # These integrations read theme files during evaluation. Substitute
  # evaluator-native sources for catppuccin/nix's fetchFromGitHub derivations.
  catppuccin.sources = {
    gitui = lib.modules.mkDefault "${gituiSource}/themes";
    starship = lib.modules.mkDefault "${starshipSource}/themes";
  };
}
