{
  inputs,
  hostPlatform ? null,
  unstableSource ? inputs.nixpkgs-unstable-small,
}:
let
  # Keep the package-set layers independently readable even though consumers
  # normally install the composed overlay exported as `overlays.default`
  unstableOverlay = _final: prev: {
    unstable = import unstableSource {
      config = prev.config or { };
      localSystem = if hostPlatform == null then prev.stdenv.hostPlatform else hostPlatform;
    };
  };

  eupkgsOverlay = final: _prev: {
    eupkgs = final.unstable.extend inputs.eupkgs.overlays.default;
  };

  compatibilityOverlay = _final: prev: {
    /**
      nixpkgs @507531
      nix @6065
      nix @15638
    */
    direnv = prev.direnv.overrideAttrs (_: {
      doCheck = false;
    });
  };
in
inputs.nixpkgs.lib.fixedPoints.composeManyExtensions [
  # Establish the independent package sets before overlays that inspect or
  # extend the final package set. This keeps stdenv evaluation acyclic on
  # custom platform bootstraps such as nixos-raspberrypi.
  unstableOverlay
  eupkgsOverlay
  inputs.nix4vscode-trivial.overlays.default
  compatibilityOverlay
]
