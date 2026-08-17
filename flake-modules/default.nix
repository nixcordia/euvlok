{
  flake-parts-lib,
  inputs,
  ...
}:
let
  # Keep this list explicit: these are the systems with contributor hosts or
  # development support in this repository.
  supportedSystems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  overlaysModule = flake-parts-lib.importApply ./overlays.nix {
    inherit inputs supportedSystems;
  };
  modulesModule = flake-parts-lib.importApply ./modules.nix {
    inherit inputs;
  };
  hostsModule = flake-parts-lib.importApply ./hosts.nix {
    providerInputs = inputs;
    inherit supportedSystems;
  };
  testsModule = flake-parts-lib.importApply ./tests.nix {
    providerInputs = inputs;
  };
  # Keep the project module importable as `flakeModules.default` as well as
  # using it to build this flake. Its own flake-parts extensions are included
  # so consumers do not have to rediscover those implementation details. Use
  # importApply for modules that need provider-owned inputs; otherwise an
  # importing flake would have to duplicate euvlok's private input names.
  euvlokModule = {
    imports = [
      inputs.flake-parts.flakeModules.modules
      inputs.home-manager.flakeModules.default
      inputs.nix-darwin.flakeModules.default
      hostsModule
      modulesModule
      overlaysModule
      testsModule
    ];
  };
in
{
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.flake-parts.flakeModules.partitions
    inputs.flake-parts.flakeModules.touchup
    euvlokModule
  ];

  systems = supportedSystems;

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };

  # Keep contributor-owned inputs out of the main entry path. Host outputs
  # and their evaluation checks opt into those inputs.
  partitionedAttrs = {
    darwinConfigurations = "users";
    hostChecks = "users";
    hostChecksBySystem = "users";
    hostMetadata = "users";
    nixosBuilds = "users";
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
    flakeModule.enable = false;
    homeConfigurations.enable = false;
    modules.enable = false;
  };

  flake.flakeModules.default = euvlokModule;
}
