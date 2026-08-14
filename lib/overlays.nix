{ inputs }:
{
  mkNixpkgsOverlay =
    {
      hostPlatform ? null,
      stableSource ? inputs.nixpkgs-stable,
      unstableSource ? inputs.nixpkgs-unstable-small,
    }:
    import ../overlay.nix {
      inherit inputs hostPlatform stableSource unstableSource;
    };
}
