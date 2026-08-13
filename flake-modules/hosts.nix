{
  providerInputs,
  supportedSystems,
}:
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    filterAttrs
    genAttrs
    mapAttrs
    mkDefault
    mkOption
    types
    ;

  hostType = types.submodule (
    { name, ... }:
    {
      options = {
        owner = mkOption {
          type = types.nonEmptyStr;
          description = "Contributor responsible for ${name}.";
        };

        class = mkOption {
          type = types.enum [
            "nixos"
            "darwin"
          ];
          description = "Module class and configuration output used by ${name}.";
        };

        system = mkOption {
          type = types.enum supportedSystems;
          description = "Nix platform evaluated for ${name}.";
        };

        runner = mkOption {
          type = types.nonEmptyStr;
          description = "Native GitHub Actions runner used to build ${name}.";
        };

        modules = mkOption {
          type = types.listOf types.deferredModule;
          description = "Complete module graph for ${name}.";
        };

        builder = mkOption {
          type = types.nullOr (types.functionTo types.raw);
          default = null;
          description = "Optional replacement for nixosSystem/darwinSystem.";
        };
      };
    }
  );

  hostSpecs = config.euvlok.hosts;
  nixosSpecs = filterAttrs (_: host: host.class == "nixos") hostSpecs;
  darwinSpecs = filterAttrs (_: host: host.class == "darwin") hostSpecs;

  mkConfiguration =
    name: host:
    let
      builder =
        if host.builder != null then
          host.builder
        else if host.class == "nixos" then
          providerInputs.nixpkgs.lib.nixosSystem
        else
          providerInputs.nix-darwin.lib.darwinSystem;

      configuration = builder {
        modules = host.modules ++ [
          {
            _file = "${toString ./hosts.nix}#euvlok.hosts.${name}.system";
            nixpkgs.hostPlatform = mkDefault host.system;
          }
        ];
      };

      actualSystem = configuration.pkgs.stdenv.hostPlatform.system;
    in
    if actualSystem == host.system then
      configuration
    else
      throw "euvlok host ${name} declares ${host.system} but evaluates with ${actualSystem}";

  nixosConfigurations = mapAttrs mkConfiguration nixosSpecs;
  darwinConfigurations = mapAttrs mkConfiguration darwinSpecs;

  hostMetadata = mapAttrs (name: host: {
    inherit name;
    inherit (host)
      class
      owner
      runner
      system
      ;
  }) hostSpecs;

  hostChecks =
    mapAttrs (_: host: host.config.system.build.toplevel.drvPath) nixosConfigurations
    // mapAttrs (_: host: host.system.drvPath) darwinConfigurations;

  hostChecksBySystem = genAttrs supportedSystems (
    system: filterAttrs (name: _: hostSpecs.${name}.system == system) hostChecks
  );
in
{

  options.euvlok.hosts = mkOption {
    type = types.attrsOf hostType;
    default = { };
    description = "Typed inventory of all NixOS and nix-darwin machines.";
  };

  config.flake = {
    inherit
      darwinConfigurations
      hostChecks
      hostChecksBySystem
      hostMetadata
      nixosConfigurations
      ;
  };
}
