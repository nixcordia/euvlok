{
  description = "EUVlok Communal Dotfiles";

  nixConfig = {
    extra-substituters = [ "https://catppuccin.cachix.org" ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };

  inputs = {
    # --- Shared ---
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    eupkgs.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    eupkgs.url = "github:euvlok/pkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";

    # --- Trivial ---
    catppuccin-gtk.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    catppuccin-gtk.url = "github:catppuccin/nix/06f0ea19334bcc8112e6d671fd53e61f9e3ad63a";
    catppuccin-trivial.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    catppuccin-trivial.url = "github:catppuccin/nix";
    nix4vscode-trivial.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    nix4vscode-trivial.inputs.systems.follows = "flake-utils/systems";
    nix4vscode-trivial.url = "github:nix-community/nix4vscode";
    nixcord-trivial.inputs.flake-compat.follows = "";
    nixcord-trivial.inputs.flake-parts.follows = "flake-parts";
    nixcord-trivial.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    nixcord-trivial.url = "github:FlameFlag/nixcord";
    nvidia-patch-trivial.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    nvidia-patch-trivial.inputs.utils.follows = "flake-utils";
    nvidia-patch-trivial.url = "github:icewind1991/nvidia-patch-nixos";
    sops-nix-trivial.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    sops-nix-trivial.url = "github:Mic92/sops-nix";
    zen-browser-trivial.inputs.home-manager.follows = "home-manager";
    zen-browser-trivial.inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    zen-browser-trivial.url = "github:0xc000022070/zen-browser-flake";

    # Infra / Shared / Core Inputs
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils"; # ONLY Exists to override inputs (NOT TO BE USED)
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./flake-modules;
}
