{
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    filterAttrs
    isType
    mapAttrs
    mapAttrsToList
    mkForce
    ;

  flakeInputs = filterAttrs (_: isType "flake") inputs;
  nixPathEntries = mapAttrsToList (name: _: "${name}=flake:${name}") flakeInputs;
  registry = mapAttrs (_: flake: mkForce { inherit flake; }) flakeInputs;
in
{
  _class = null;
  _file = ./registry.nix;
  key = toString ./registry.nix;
  nix = {
    # Force only the locked input names, not the whole registry
    # This preserves deterministic input lookups while allowing hosts to add
    # unrelated entries
    inherit registry;
    settings.nix-path = nixPathEntries;
    nixPath = nixPathEntries;
  };
}
