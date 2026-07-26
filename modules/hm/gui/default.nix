{ euvlokInputs }:
{ lib, ... }:
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./chromium
    (lib.modules.importApply ./firefox { inherit euvlokInputs; })
    ./mpv.nix
    (lib.modules.importApply ./nixcord { inherit euvlokInputs; })
    ./vscode
    ./zed.nix
  ];
}
