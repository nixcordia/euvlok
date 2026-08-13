{ paletteSource }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  webFileIcons = import ./web-file-icons.nix { inherit lib pkgs; };

  theme = import ./firefox-theme.nix { inherit lib paletteSource; } {
    inherit (config.catppuccin) accent flavor;
  };

  browserProfile = {
    extensions = {
      packages = [ webFileIcons ];
      settings."FirefoxColor@mozilla.com" = {
        force = true;
        settings = {
          firstRunDone = true;
          inherit theme;
        };
      };
    };
  };
in
{

  config = lib.modules.mkIf config.catppuccin.enable {
    # catppuccin/nix imports generated themes.json during evaluation. Keep its
    # other integrations, but provide the browser theme from pure palette data.
    catppuccin = {
      firefox.enable = false;
      floorp.enable = false;
      librewolf.enable = false;
    };

    programs = {
      firefox.profiles.default = browserProfile;
      floorp.profiles.default = browserProfile;
      librewolf.profiles.default = browserProfile;
    };
  };
}
