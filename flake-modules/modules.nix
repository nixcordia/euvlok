{ inputs }:
{ config, lib, ... }:
let
  # Public modules should carry euvlok's implementation dependencies with them
  # Consumer `inputs` remain available separately for host-specific
  # configuration and the Nix registry
  mkEuvlokModule =
    moduleClass: name: module:
    let
      moduleKey = "${toString ./modules.nix}#flake.modules.${moduleClass}.${name}";
    in
    {
      _class = moduleClass;
      _file = moduleKey;
      key = moduleKey;

      imports = [ module ];
    };

  mkEuvlokModules = moduleClass: lib.attrsets.mapAttrs (name: mkEuvlokModule moduleClass name);

  applyEuvlokInputs = module: lib.modules.importApply module { euvlokInputs = inputs; };

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
      inherit applyEuvlokInputs;
    };
  };
in
{
  _class = "flake";
  _file = ./modules.nix;
  key = toString ./modules.nix;
  config.flake = {
    modules = {
      nixos = mkEuvlokModules "nixos" moduleCatalogs.nixos;
      darwin = mkEuvlokModules "darwin" moduleCatalogs.darwin;
      homeManager = mkEuvlokModules "homeManager" moduleCatalogs.homeManager;
    };

    # Conventional aliases for external consumers and internal hosts/**/*.nix.
    nixosModules = config.flake.modules.nixos;
    darwinModules = config.flake.modules.darwin;
    homeModules = config.flake.modules.homeManager;
  };
}
