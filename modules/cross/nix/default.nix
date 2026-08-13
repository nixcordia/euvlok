{
  euvlokInputs,
  isDarwin,
}:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ./build-parallelism.nix { inherit isDarwin; })
    (lib.modules.importApply ./registry.nix { inherit euvlokInputs isDarwin; })
    (lib.modules.importApply ./settings.nix { inherit isDarwin; })
  ];
}
