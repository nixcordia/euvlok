{
  description = "EUVlok contributor-owned flake inputs";

  inputs = {
    # Ashuramaruzxc
    anime-cursors-source.inputs.devenv.follows = "users-devenv";
    anime-cursors-source.inputs.flake-parts.follows = "users-flake-parts";
    anime-cursors-source.inputs.nixpkgs-python.inputs.flake-compat.follows = "";
    anime-cursors-source.inputs.mk-shell-bin.follows = "users-mk-shell-bin";
    anime-cursors-source.inputs.nix2container.follows = "users-nix2container";
    anime-cursors-source.inputs.pre-commit-hooks.follows = "users-pre-commit-hooks";
    anime-cursors-source.url = "github:ashuramaruzxc/anime-cursors";
    disko-rpi.inputs.nixpkgs.follows = "users-nixpkgs";
    disko-rpi.url = "github:nvmd/disko/gpt-attrs";
    flatpak-declerative.url = "github:in-a-dil-emma/declarative-flatpak";
    home-manager-rpi.inputs.nixpkgs.follows = "users-nixpkgs";
    home-manager-rpi.url = "github:nix-community/home-manager/release-26.05";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixos-raspberrypi.inputs.flake-compat.follows = "";
    nixos-raspberrypi.inputs.nixpkgs.follows = "users-nixpkgs";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
    homebrew-core-source = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask-source = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-crc-source = {
      url = "github:cfergeau/homebrew-crc";
      flake = false;
    };

    # Lay-by
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    spicetify-nix.inputs.nixpkgs.follows = "users-nixpkgs-unstable-small";
    spicetify-nix.inputs.systems.follows = "users-flake-utils/systems";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix.inputs.flake-parts.follows = "users-flake-parts";
    stylix.inputs.nixpkgs.follows = "users-nixpkgs-unstable-small";
    stylix.inputs.systems.follows = "users-flake-utils/systems";
    stylix.url = "github:danth/stylix";

    # Support inputs needed by contributor-owned sources.
    users-devenv.inputs.cachix.inputs.flake-compat.follows = "";
    users-devenv.inputs.crate2nix.follows = "";
    users-devenv.inputs.flake-compat.follows = "";
    users-devenv.inputs.flake-parts.follows = "users-flake-parts";
    users-devenv.inputs.nixd.follows = "";
    users-devenv.inputs.nixpkgs.follows = "users-nixpkgs-unstable-small";
    users-devenv.url = "github:cachix/devenv";
    users-flake-parts.url = "github:hercules-ci/flake-parts";
    users-flake-utils.url = "github:numtide/flake-utils";
    users-mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    users-nix2container.inputs.nixpkgs.follows = "users-nixpkgs-unstable-small";
    users-nix2container.url = "github:nlewo/nix2container";
    users-nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    users-nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    users-pre-commit-hooks.inputs.flake-compat.follows = "";
    users-pre-commit-hooks.inputs.nixpkgs.follows = "users-nixpkgs-unstable-small";
    users-pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = _: { };
}
