_: {
  _class = null;
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./build-parallelism.nix
    ./registry.nix
    ./settings.nix
  ];
}
