{
  pkgs,
  lib,
  config,
  ...
}:
let
  languageDefinitions = import ./catalog { inherit pkgs lib; };
  enabledLanguages = lib.attrsets.filterAttrs (
    name: _: config.euvlok.home.languages.${name}.enable or false
  ) languageDefinitions;
  collectLists =
    selector: lib.lists.flatten (lib.attrsets.mapAttrsToList (_: def: selector def) enabledLanguages);
  mergeAttrs =
    selector:
    lib.attrsets.mergeAttrsList (lib.attrsets.mapAttrsToList (_: def: selector def) enabledLanguages);
in
{
  _class = "homeManager";
  _file = ./helix.nix;
  key = toString ./helix.nix;
  config = lib.modules.mkIf config.euvlok.home.helix.enable {
    programs.helix.languages.language-server = mergeAttrs (def: def.helix.languageServers or { });
    programs.helix.languages.language = collectLists (def: def.helix.languages or [ ]);
  };
}
