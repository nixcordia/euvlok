{
  inputs,
  pkgs,
  ...
}:
let
  homePackages = import ../shared/home/packages.nix { inherit pkgs; };
  cursorModule = import ../shared/home/cursor.nix {
    cursorName = "touhou-reimu";
    cursorPackage = inputs.anime-cursors-source.packages.${pkgs.stdenvNoCC.hostPlatform.system}.cursors;
    iconPackage = pkgs.unstable.kdePackages.breeze-icons;
  };

  baseImports = [
    { home.stateVersion = "26.11"; }
    ../../../hm/ashuramaruzxc/catppuccin.nix
  ];

  ashuramaruHmConfig = [
    inputs.self.homeModules.default
    inputs.self.homeModules.ashuramaruzxc
    ../../../hm/ashuramaruzxc/graphics.nix
    ../../../hm/ashuramaruzxc/chromium
    ../../../hm/ashuramaruzxc/workstation.nix
    # ../../../hm/ashuramaruzxc/flatpak.nix
    {
      hm = {
        codex.enable = true;
        firefox.floorp.enable = true;
        nixcord.enable = true;
        nushell.enable = true;
        vscode.enable = true;
      };
    }
  ];

  allPackages =
    homePackages.mkPackages [
      "important"
      "multimedia"
      "productivity"
      "social"
      "networking"
      "audio"
      "gaming"
      "development"
      "jetbrains"
      "nemo"
    ]
    ++ [
      pkgs.unstable.piper

      # until euroffice is statble
      # pkgs.unstable.softmaker-office-nx
    ];
in
{
  _class = "nixos";
  _file = ./home.nix;
  key = toString ./home.nix;
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs; };
  };

  home-manager.users.ashuramaru = {
    imports =
      baseImports
      ++ [
        { sops.defaultSopsFile = ../../../../secrets/ashuramaruzxc_unsigned-int32.yaml; }
      ]
      ++ ashuramaruHmConfig
      ++ [
        { home.packages = allPackages; }
        cursorModule
        {
          services.protonmail-bridge.enable = true;
          programs = {
            rbw = {
              enable = true;
              settings = {
                email = "ashuramaru@tenjin-dk.com";
                base_url = "https://bitwarden.tenjin-dk.com";
                lock_timeout = 600;
                pinentry = pkgs.pinentry-qt;
              };
            };
            ghostty.settings = {
              window-height = 40;
              window-width = 140;
            };
            btop.enable = true;
            direnv.nix-direnv.package = pkgs.unstable.nix-direnv;
          };
        }
      ];
  };
}
