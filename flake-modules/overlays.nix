{
  inputs,
  supportedSystems,
}:
_:
let
  euvlokLib = import ../lib { inherit inputs; };
in
{
  flake = {
    lib = euvlokLib // {
      inherit supportedSystems;
    };

    overlays.default = euvlokLib.overlays.mkNixpkgsOverlay { };
  };
}
