{ config, lib, ... }:
let
  inherit (lib) optionalAttrs;
  inherit (config.nixpkgs.hostPlatform) isLinux;
in
{
  _class = null;
  _file = ./settings.nix;
  key = toString ./settings.nix;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Let remote builders use the same binary caches as the coordinator.
      builders-use-substitutes = true;
      substituters = [
        "https://devenv.cachix.org"
        "https://euvlok.cachix.org"
        "https://eupkgs.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://cache.flox.dev"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "euvlok.cachix.org-1:cmFWCSs7rxPiyE1qfaJn8TY7QaRoGOrzKuNvtGw2gcU="
        "eupkgs.cachix.org-1:V9Y0HdASNNSU9U6EkXhR1j85bZGRtNgW7wSyTiQrwGU="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      ];
    }
    // optionalAttrs isLinux {
      # Do not mix the global registry with the locked per-host registry.
      flake-registry = "";
    };

    # Channels are imperative state; flake inputs are the source of truth.
    channel.enable = false;
  };
}
