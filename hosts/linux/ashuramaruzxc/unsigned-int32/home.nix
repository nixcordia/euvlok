{
  animeCursorsSource,
  catppuccinModule,
  codexDesktopModule,
  homeManagerModule,
  personalModule,
  sharedModule,
}:
{
  pkgs,
  ...
}:
let
  homePackages = import ../shared/home/packages.nix { inherit pkgs; };
  cursorModule = import ../shared/home/cursor.nix {
    cursorName = "touhou-reimu";
    cursorPackage = animeCursorsSource.packages.${pkgs.stdenvNoCC.hostPlatform.system}.cursors;
    iconPackage = pkgs.unstable.kdePackages.breeze-icons;
  };

  baseImports = [
    { home.stateVersion = "26.11"; }
    catppuccinModule
  ];

  ashuramaruHmConfig = [
    codexDesktopModule
    ../../../hm/ashuramaruzxc/graphics.nix
    ../../../hm/ashuramaruzxc/workstation.nix
    {
      euvlok.home = {
        codex.enable = true;
        firefox.floorp.enable = true;
        nixcord.enable = true;
        vscode.enable = true;
      };

      programs.codexDesktopLinux = {
        enable = true;
        cliPackage = pkgs.unstable.codex;
        computerUseUi.enable = true;
        remoteMobileControl.enable = true;
        linuxFeatures = [
          "appshots"
          "directory-only-working-tree-watch"
          "mcp-helper-reaper"
          "node-repl-reaper"
          "open-target-discovery"
          "persistent-status-panel"
          "remote-control-ui"
          "ui-tweaks"
        ];
        remoteControl = {
          enable = true;
          package = pkgs.unstable.codex;
        };
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
  imports = [ homeManagerModule ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    sharedModules = [
      sharedModule
      personalModule
    ];
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
