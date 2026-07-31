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
  limineSource = fetchCatppuccinSource "limine";
in
{
  _class = "nixos";
  _file = ./catppuccin.nix;
  key = toString ./catppuccin.nix;

  # Both upstream integrations read generated package outputs during module
  # evaluation. Their repositories already contain the same data, so keep the
  # upstream option logic and replace only the derivation-backed sources.
  catppuccin.sources = {
    limine = lib.modules.mkDefault "${limineSource}/themes";
    palette = lib.modules.mkDefault (fetchCatppuccinSource "palette");
  };
}
