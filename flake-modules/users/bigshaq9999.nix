{
  config,
  inputs,
  lib,
  ...
}:
{
  _class = "flake";
  _file = ./bigshaq9999.nix;
  key = toString ./bigshaq9999.nix;

  euvlok.hosts.faputa = {
    owner = "bigshaq9999";
    class = "darwin";
    system = "aarch64-darwin";
    runner = "macos-latest";
    modules = [
      (lib.modules.importApply ../../hosts/darwin/bigshaq9999/faputa {
        sharedModules = [
          config.flake.darwinModules.default
          config.flake.darwinModules.zsh
        ];
        homeModule = lib.modules.importApply ../../hosts/darwin/bigshaq9999/faputa/home.nix {
          homeManagerModule = inputs.home-manager.darwinModules.home-manager;
          personalModule = ../../hosts/hm/bigshaq9999;
          sharedModule = config.flake.homeModules.integrated;
        };
      })
    ];
  };
}
