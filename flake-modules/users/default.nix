{ lib, ... }:
{
  _class = "flake";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = lib.trivial.pipe (builtins.readDir ./.) [
    (lib.attrsets.filterAttrs (
      name: type:
      type == "regular"
      && lib.strings.hasSuffix ".nix" name
      && !lib.lists.elem name [
        "default.nix"
        "flake.nix"
      ]
    ))
    (lib.attrsets.mapAttrsToList (name: _type: lib.path.append ./. name))
  ];
}
