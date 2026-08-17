{ languageDefinitions }:
{
  lib,
  config,
  ...
}:
let
  enabledLanguages = lib.attrsets.filterAttrs (
    name: _: config.euvlok.home.languages.${name}.enable or false
  ) languageDefinitions;
  collectPackageLists = lib.attrsets.mapAttrsToList (
    name: def:
    let
      langCfg = config.euvlok.home.languages.${name};
      versionedPackage = if (def ? versionMap) then [ def.versionMap.${langCfg.version} ] else [ ];
    in
    (def.packages or [ ]) ++ versionedPackage ++ langCfg.extraPackages
  ) enabledLanguages;
  collectLists = selector: lib.lists.concatMap selector (lib.attrsets.attrValues enabledLanguages);
  mergeAttrs = selector: lib.attrsets.concatMapAttrs (_: selector) enabledLanguages;
in
{
  config = lib.modules.mkIf config.euvlok.home.zed-editor.enable {
    programs.zed-editor.extensions =
      lib.lists.optional config.programs.fish.enable "fish"
      ++ collectLists (def: def.zed.extensions or [ ]);

    programs.zed-editor.extraPackages = lib.lists.flatten collectPackageLists;
    programs.zed-editor.userSettings.languages = mergeAttrs (def: def.zed.languages or { });
    programs.zed-editor.userSettings.lsp = mergeAttrs (def: def.zed.lsp or { });
  };
}
