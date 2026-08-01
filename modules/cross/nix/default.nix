{
  euvlokInputs,
  isDarwin,
}:
{ lib, ... }:
{
  _class = null;
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    (lib.modules.importApply ./build-parallelism.nix { inherit isDarwin; })
    (lib.modules.importApply ./registry.nix { inherit euvlokInputs isDarwin; })
    (lib.modules.importApply ./settings.nix { inherit isDarwin; })
  ];
}
