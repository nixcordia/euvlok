{ pkgs, lib }:
let
  versionMappings = {
    java =
      let
        versions = [
          "8"
          "11"
          "17"
          "21"
          "25"
        ];
      in
      lib.attrsets.genAttrs versions (version: pkgs.unstable."jdk${version}");

    dotnet =
      let
        versions = [
          "8"
          "9"
          "10"
        ];
      in
      lib.attrsets.genAttrs versions (version: pkgs.unstable.dotnetCorePackages."sdk_${version}_0-bin");
  };

  getLatestVersion =
    mapping: lib.lists.last (lib.lists.sort lib.strings.versionOlder (lib.attrsets.attrNames mapping));

  prettierFormatter = parser: {
    external = {
      command = "prettier";
      arguments = [
        "--parser"
        parser
        "--stdin-filepath"
        "{buffer_path}"
      ];
    };
  };

  callLanguage =
    file:
    import file {
      inherit
        pkgs
        lib
        versionMappings
        getLatestVersion
        prettierFormatter
        ;
    };
in
lib.pipe (builtins.readDir ./.) [
  (lib.filterAttrs (
    name: type: type == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name
  ))
  (lib.mapAttrs' (
    name: _type:
    lib.nameValuePair (lib.removeSuffix ".nix" name) (callLanguage (lib.path.append ./. name))
  ))
]
