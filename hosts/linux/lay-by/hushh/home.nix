{
  inputs,
  pkgs,
  ...
}:
{
  _class = "nixos";
  _file = ./home.nix;
  key = toString ./home.nix;
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };

  home-manager.users.hushh =
    { lib, ... }:
    {
      imports = [
        {
          home.stateVersion = "25.05";
          home.sessionVariables = {
            DEFAULT_BROWSER = "${inputs.zen-browser-trivial.packages.x86_64-linux.default}/bin/zen";
            SHELL = "fish";
            TERM = "alacritty";
          };
        }
      ]
      ++ [
        inputs.stylix-trivial.homeModules.stylix
      ]
      ++ [
        {
          programs.mangohud.enable = true;
          programs.mangohud.settings = {
            fps_limit = 200;
            no_display = true;
          };
          fonts.fontconfig.enable = true;
          home.pointerCursor.enable = true;
          xsession.numlock.enable = true;
        }
      ]
      ++ [
        ./home-packages.nix
        inputs.self.homeModules.default
        inputs.self.homeModules.lay-by
        {
          euvlok.nixpkgs.unstableSource = inputs.nixpkgs-unstable;
          home.shell.enableShellIntegration = true;
          programs.codex.settings = lib.modules.mkForce { };
          hm = {
            codex.enable = true;
            fastfetch.enable = true;
            firefox.zen-browser.enable = true;
            bash.enable = true;
            fish.enable = true;
            helix.enable = true;
            hyprland.enable = true;
            mpv.enable = true;
            #vscode.enable = true; # This is a massive pain in the ass if you change your vscode config json frequently. Just going to manage it normally instead of declaratively.
            nixcord.enable = true;
          };
        }
      ]
      ++ [
        inputs.spicetify-nix-trivial.homeManagerModules.default
        {
          programs.spicetify.enable = true;
          programs.spicetify.enabledExtensions = builtins.attrValues {
            inherit
              (inputs.spicetify-nix-trivial.legacyPackages.${pkgs.stdenvNoCC.hostPlatform.system}.extensions)
              adblock
              beautifulLyrics # Apple Music like Lyrics
              copyLyrics
              fullAlbumDate
              popupLyrics # Popup window with the current song's lyrics scrolling across it
              shuffle # Shuffle properly, using Fisher-Yates with zero bias
              ;
          };
        }
      ]
      ++ [
      ];
    };
}
