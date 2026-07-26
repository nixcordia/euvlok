{ inputs }:
{
  overlays = import ./overlays.nix { inherit inputs; };
}
