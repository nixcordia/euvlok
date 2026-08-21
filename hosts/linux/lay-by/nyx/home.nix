{
  homeManagerModule,
  personalModule,
  sharedModule,
  spicetify,
  zenBrowserPackage,
}:
{
  pkgs,
  ...
}:
{
  imports = [ homeManagerModule ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    sharedModules = [
      sharedModule
      personalModule
    ];
  };

  home-manager.users.hushh =
    { lib, ... }:
    {
      imports = [
        {
          home.stateVersion = "26.05";
          home.sessionVariables = {
            DEFAULT_BROWSER = "${zenBrowserPackage}/bin/zen";
            SHELL = "fish";
            TERM = "alacritty";
          };
          fonts.fontconfig.enable = true;
          home.pointerCursor.enable = true;
        }
        ./home-packages.nix
        {
          home.shell.enableShellIntegration = true;
          programs.codex.settings = lib.modules.mkForce { };
          euvlok.home = {
            codex.enable = true;
            fastfetch.enable = true;
            firefox.zen-browser.enable = true;
            bash.enable = true;
            fish.enable = true;
            helix.enable = true;
            hyprland.enable = true;
            mpv.enable = true;
            nixcord.enable = true;
          };
        }
        spicetify.homeManagerModules.default
        {
          programs.spicetify.enable = true;
          programs.spicetify.enabledExtensions = builtins.attrValues {
            inherit (spicetify.legacyPackages.${pkgs.stdenvNoCC.hostPlatform.system}.extensions)
              adblock
              beautifulLyrics
              copyLyrics
              fullAlbumDate
              popupLyrics
              shuffle
              ;
          };
        }
      ];
    };
}
