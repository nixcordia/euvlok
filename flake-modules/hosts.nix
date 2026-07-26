{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    foldlAttrs
    intersectAttrs
    mapAttrs
    mapAttrs'
    mkDefault
    mkOption
    nameValuePair
    optionalAttrs
    types
    ;

  hostSpec = types.submodule {
    options = {
      path = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a Nix expression that returns this host configuration.";
      };

      output = mkOption {
        type = types.nullOr types.nonEmptyStr;
        default = null;
        description = "Attribute to select from the imported path. Defaults to the host name.";
      };

      configuration = mkOption {
        type = types.nullOr (
          types.unique {
            message = "A host may only define one pre-built configuration.";
          } types.attrs
        );
        default = null;
        description = "Pre-built configuration value. Useful for nested flakes or unusual inputs.";
      };
    };
  };

  userType = types.submodule {
    options = {
      nixosHosts = mkOption {
        type = types.attrsOf hostSpec;
        default = { };
        description = "NixOS hosts owned by this contributor.";
      };

      darwinHosts = mkOption {
        type = types.attrsOf hostSpec;
        default = { };
        description = "nix-darwin hosts owned by this contributor.";
      };

      homeModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        description = "Home Manager modules owned by this contributor.";
      };
    };
  };

  mergeUsers =
    attr:
    foldlAttrs (
      result: userName: user:
      let
        entries = user.${attr};
        duplicateNames = builtins.attrNames (intersectAttrs result entries);
      in
      if duplicateNames == [ ] then
        result // entries
      else
        throw "euvlok contributor ${userName} duplicates ${attr}: ${concatStringsSep ", " duplicateNames}"
    ) { } config.euvlok.users;

  mkHost =
    name: spec:
    if spec.configuration != null && spec.path != null then
      throw "euvlok host ${name} defines both `configuration` and `path`; choose one."
    else if spec.configuration != null then
      spec.configuration
    else if spec.path == null then
      throw "euvlok host ${name} must define either `configuration` or `path`."
    else
      let
        imported = import spec.path inputs;
      in
      if spec.output == null then imported else imported.${spec.output};

  nixosConfigurations = mapAttrs mkHost (mergeUsers "nixosHosts");
  darwinConfigurations = mapAttrs mkHost (mergeUsers "darwinHosts");
  homeModules = mapAttrs (
    name: module:
    let
      moduleKey = "${toString ./hosts.nix}#homeModules.${name}";
    in
    {
      _class = "homeManager";
      _file = moduleKey;
      key = moduleKey;

      _module.args.euvlokInputs = mkDefault inputs;
      imports = [ module ];
    }
  ) (mergeUsers "homeModules");

in
{
  _class = "flake";
  _file = ./hosts.nix;
  key = toString ./hosts.nix;
  options.euvlok.users = mkOption {
    type = types.attrsOf userType;
    default = { };
    description = "Contributor-owned host and home configuration registry.";
  };

  config = {
    flake = {
      inherit nixosConfigurations darwinConfigurations homeModules;
    };

    perSystem =
      { pkgs, system, ... }:
      let
        mkEvalCheck =
          kind: name: value:
          nameValuePair "eval-${kind}-${name}" (
            pkgs.runCommand "eval-${kind}-${name}" { } ''
              mkdir "$out"
              printf '%s\n' ${lib.escapeShellArg (builtins.unsafeDiscardStringContext (toString value))} > "$out/drv-path"
            ''
          );
      in
      {
        checks = optionalAttrs (system == "x86_64-linux") (
          mapAttrs' (
            name: value: mkEvalCheck "nixos" name value.config.system.build.toplevel.drvPath
          ) nixosConfigurations
          // mapAttrs' (name: value: mkEvalCheck "darwin" name value.system.drvPath) darwinConfigurations
        );
      };
  };
}
