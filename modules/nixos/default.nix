{ euvlokInputs }:
{
  config,
  lib,
  ...
}:
{
  _class = "nixos";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    euvlokInputs.catppuccin-trivial.nixosModules.catppuccin
    (lib.modules.importApply ./catppuccin.nix { inherit euvlokInputs; })
    (lib.modules.importApply ../cross { inherit euvlokInputs; })
    ./amd.nix
    ./audio.nix
    ./boot.nix
    ./cosmic.nix
    ./gnome.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    (lib.modules.importApply ./nvidia.nix { inherit euvlokInputs; })
    ./plasma.nix
    ./security.nix
    ./services.nix
    ./sessionVariables.nix
    (lib.modules.importApply ./sops.nix { inherit euvlokInputs; })
    ./steam.nix
    ./zram.nix
  ];

  catppuccin.autoEnable = lib.modules.mkDefault config.catppuccin.enable;
}
