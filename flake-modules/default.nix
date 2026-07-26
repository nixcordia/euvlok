{
  flake-parts-lib,
  inputs,
  ...
}:
let
  overlaysModule = flake-parts-lib.importApply ./overlays.nix {
    inherit inputs;
  };
  modulesModule = flake-parts-lib.importApply ./modules.nix {
    inherit inputs;
  };
  # Keep the project module importable as `flakeModules.default` as well as
  # using it to build this flake. Its own flake-parts extensions are included
  # so consumers do not have to rediscover those implementation details. Use
  # importApply for modules that need provider-owned inputs; otherwise an
  # importing flake would have to duplicate euvlok's private input names.
  euvlokModule = {
    _class = "flake";
    _file = "${toString ./default.nix}#flakeModules.default";
    key = "${toString ./default.nix}#flakeModules.default";

    imports = [
      inputs.flake-parts.flakeModules.modules
      inputs.home-manager.flakeModules.default
      inputs.nix-darwin.flakeModules.default
      ./hosts.nix
      modulesModule
      overlaysModule
    ];
  };
in
{
  _class = "flake";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.flake-parts.flakeModules.partitions
    inputs.flake-parts.flakeModules.touchup
    euvlokModule
  ];

  # Keep contributor-owned inputs out of the main entry path. Host outputs
  # opt into those inputs.
  partitionedAttrs = {
    darwinConfigurations = "users";
    homeModules = "users";
    nixosConfigurations = "users";
  };

  partitions = {
    users = {
      extraInputsFlake = ./users;
      module.imports = [ ./users/default.nix ];
    };

  };

  # `flake.modules` is the typed source of truth. The conventional
  # nixosModules/darwinModules/homeModules aliases are the public interface.
  touchup.attr = {
    homeConfigurations.enable = false;
    modules.enable = false;
  };

  flake.flakeModules.default = euvlokModule;
}
