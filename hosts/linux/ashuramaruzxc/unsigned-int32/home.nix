{
  animeCursorsSource,
  catppuccinModule,
  codexDesktopModule,
  codexDesktopPackages,
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
  codexLinuxFeatures = [
    "appshots"
    "directory-only-working-tree-watch"
    "mcp-helper-reaper"
    "node-repl-reaper"
    "persistent-status-panel"
    "remote-control-ui"
    "ui-tweaks"
  ];
  codexDesktopPackage =
    (codexDesktopPackages.${pkgs.stdenv.hostPlatform.system}.codex-desktop.override {
      enableComputerUseUi = true;
      linuxFeatureIds = codexLinuxFeatures ++ [ "remote-mobile-control" ];
    }).overrideAttrs
      (_oldAttrs: {
        # The upstream feature supports archive overrides, but its Nix package
        # does not yet wire them in. Keep npm registry access out of the sandbox.
        CODEX_WATCHBOUND_ARCHIVE = pkgs.fetchurl {
          url = "https://registry.npmjs.org/watchbound/-/watchbound-2.1.1.tgz";
          hash = "sha256-KVZ0IcHv7gQWWNtLUAk/kVWGBNNSF4yy523TMefFVE0=";
        };
        CODEX_WATCHBOUND_NODE_ARCHIVE = pkgs.fetchurl {
          url = "https://registry.npmjs.org/@gadicc/watchbound-node/-/watchbound-node-2.1.1.tgz";
          hash = "sha256-H4JB0Idx+M8A1Q74lTJ4k0ST53Eq533LZBhIfhZ/UoQ=";
        };
        CODEX_WATCHBOUND_NODE_X64_ARCHIVE = pkgs.fetchurl {
          url = "https://registry.npmjs.org/@gadicc/watchbound-node-linux-x64-gnu/-/watchbound-node-linux-x64-gnu-2.1.1.tgz";
          hash = "sha256-CQPJ7sbr4SfLOq57zpLds3XCFQPvVDihMsKKGVF+RMM=";
        };
      });
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
        package = codexDesktopPackage;
        computerUseUi.enable = true;
        remoteMobileControl.enable = true;
        linuxFeatures = codexLinuxFeatures;
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
