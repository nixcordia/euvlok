{ euvlokInputs }:
{ lib, ... }:
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    (lib.modules.importApply ./os { inherit euvlokInputs; })
    (lib.modules.importApply ./nixpkgs.nix { inherit euvlokInputs; })
    (lib.modules.importApply ./catppuccin { inherit euvlokInputs; })
    (lib.modules.importApply ./sops.nix { inherit euvlokInputs; })
    ./cli
    (lib.modules.importApply ./gui { inherit euvlokInputs; })
    ./languages
    ./shell
    ./terminal
    ./tui
    ./wm
  ];
}
