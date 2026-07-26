{ inputs }:
{
  mkNixpkgsOverlay =
    {
      hostPlatform ? null,
      unstableSource ? inputs.nixpkgs-unstable-small,
    }:
    import ../overlay.nix {
      inherit inputs hostPlatform unstableSource;
    };
}
