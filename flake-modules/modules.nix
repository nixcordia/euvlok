{ inputs }:
{ lib, ... }:
let
  applyEuvlokInputsWith =
    module: args: lib.modules.importApply module ({ euvlokInputs = inputs; } // args);
  applyEuvlokInputs = module: applyEuvlokInputsWith module { };

  mkDesktopModule = module: {
    imports = [
      ../modules/nixos/services.nix
      module
    ];
  };

  moduleCatalogs = {
    nixos = import ./modules/nixos.nix {
      inherit applyEuvlokInputs mkDesktopModule;
    };
    darwin = import ./modules/darwin.nix {
      inherit applyEuvlokInputs;
    };
    homeManager = import ./modules/home-manager.nix {
      inherit applyEuvlokInputs applyEuvlokInputsWith;
    };
  };
in
{
  _class = "flake";
  _file = ./modules.nix;
  key = toString ./modules.nix;
  config.flake = {
    # Feed raw modules to each output. flake-parts, Home Manager, and the
    # flake.modules extension add their own source/class wrapper where needed.
    modules = moduleCatalogs;

    # Conventional aliases for external consumers and internal hosts/**/*.nix.
    nixosModules = moduleCatalogs.nixos;
    darwinModules = moduleCatalogs.darwin;
    homeModules = moduleCatalogs.homeManager;
  };
}
