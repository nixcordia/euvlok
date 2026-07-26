{ inputs }:
{ ... }:
let
  euvlokLib = import ../lib { inherit inputs; };
in
{
  _class = "flake";
  _file = ./overlays.nix;
  key = toString ./overlays.nix;
  flake = {
    lib = euvlokLib;

    overlays.default = euvlokLib.overlays.mkNixpkgsOverlay { };
  };
}
