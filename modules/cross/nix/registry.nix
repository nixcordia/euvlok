{
  euvlokInputs,
  isDarwin,
}:
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mapAttrs
    mkDefault
    mkOption
    types
    ;

  registry = mapAttrs (_: flake: mkDefault { inherit flake; }) config.euvlok.nix.registryInputs;
  nixPathEntries = [ "nixpkgs=flake:nixpkgs" ];
in
{
  _class = null;
  _file = ./registry.nix;
  key = toString ./registry.nix;

  options.euvlok.nix.registryInputs = mkOption {
    type = types.attrsOf (types.addCheck types.raw (lib.isType "flake"));
    default = {
      nixpkgs = euvlokInputs.nixpkgs;
    };
    description = "Locked flake inputs exposed through the system Nix registry.";
  };

  config = lib.modules.mkMerge [
    {
      assertions = [
        {
          assertion = config.euvlok.nix.registryInputs ? nixpkgs;
          message = "euvlok.nix.registryInputs must contain nixpkgs for NIX_PATH.";
        }
      ];
    }
    (
      if isDarwin then
        {
          determinateNix = {
            inherit registry;
            customSettings.nix-path = nixPathEntries;
          };
        }
      else
        {
          nix = {
            # Lock only the explicitly selected inputs while preserving
            # unrelated host registry entries.
            inherit registry;
            settings.nix-path = nixPathEntries;
            nixPath = nixPathEntries;
          };
        }
    )
  ];
}
