{ lib, ... }:
{
  _class = "flake";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = lib.pipe (builtins.readDir ./.) [
    (lib.filterAttrs (
      name: type:
      type == "regular"
      && lib.hasSuffix ".nix" name
      && !lib.elem name [
        "default.nix"
        "flake.nix"
      ]
    ))
    (lib.mapAttrsToList (name: _type: lib.path.append ./. name))
  ];
}
