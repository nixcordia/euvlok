{ euvlokInputs }:
{ lib, ... }:
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    (lib.modules.importApply ./chromium { inherit euvlokInputs; })
    (lib.modules.importApply ./firefox { inherit euvlokInputs; })
    ./mpv.nix
    (lib.modules.importApply ./nixcord { inherit euvlokInputs; })
    ./vscode
    ./zed.nix
  ];
}
