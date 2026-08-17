{
  euvlokInputs,
  includeNixpkgs,
}:
{ lib, ... }:
{
  imports = [
    # Do not put nixpkgs' upstream Nix ahead of Determinate Nix on PATH.
    euvlokInputs.determinate.homeManagerModules.default
    (lib.modules.importApply ./os { inherit euvlokInputs; })
  ]
  ++ lib.lists.optional includeNixpkgs (
    lib.modules.importApply ./nixpkgs.nix { inherit euvlokInputs; }
  )
  ++ [
    (lib.modules.importApply ./catppuccin { inherit euvlokInputs; })
    (lib.modules.importApply ./sops.nix { inherit euvlokInputs; })
    (lib.modules.importApply ./cli { inherit euvlokInputs; })
    (lib.modules.importApply ./gui { inherit euvlokInputs; })
    ./languages
    ./shell
    ./terminal
    ./tui
    ./wm
  ];

  # Home Manager's NixOS/nix-darwin integration injects the system package at
  # the same priority as Determinate's module sets null. Prefer the externally
  # managed Determinate installation explicitly.
  nix.package = lib.modules.mkForce null;
  manual.manpages.enable = lib.modules.mkDefault false;
}
