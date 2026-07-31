{ euvlokInputs }:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.hm.chromium;

  chromiumFeatures = [
    "ForceEnableWebGpuInterop"
    "ReduceOpsTaskSplitting"
    "TouchpadOverscrollHistoryNavigation"
    "VaapiVideoDecoder"
    "VaapiVideoEncoder"
  ]
  ++ lib.lists.optionals (cfg.browser == "helium-browser") [
    "BrowsingTopics"
    "InterestGroupStorage"
  ];

  chromiumDisabledFeatures = lib.lists.optionals (cfg.browser == "helium-browser") [
    "ExtensionManifestV2Unsupported"
    "ExtensionManifestV2Disabled"
  ];

  browserPackages = {
    chromium = pkgs.chromium.override { enableWideVine = true; };
    helium-browser = pkgs.eupkgs.helium-browser;
    inherit (pkgs)
      brave
      google-chrome
      ungoogled-chromium
      ;
  };

  browserPackage = browserPackages.${cfg.browser};

  browserExecutables = {
    brave = "brave";
    chromium = "chromium";
    google-chrome = "google-chrome-stable";
    helium-browser = "helium-browser";
    ungoogled-chromium = "chromium";
  };
  browserExecutable = browserExecutables.${cfg.browser};

  browserPaths = {
    brave = "BraveSoftware/Brave-Browser";
    chromium = "chromium";
    google-chrome = "google-chrome";
    helium-browser = "net.imput.helium";
    ungoogled-chromium = "chromium";
  };
  browserPath = browserPaths.${cfg.browser};
  browserRuntimeRoot = "${config.xdg.cacheHome}/browser";
  browserBinDir = "${config.xdg.dataHome}/browser/bin";

  extensionCatalog = lib.attrsets.zipAttrsWith (_: builtins.concatLists) [
    (import ./extensions.nix { inherit config lib; })
    cfg.extraExtensions
  ];

  # Helium bundles uBlock Origin and supports Kagi natively.
  heliumExtensionIds = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "cdglnehniifkbagbbombnjghhcihifij"
  ];
  managedExtensions = lib.attrsets.mapAttrs (
    _: extensions:
    builtins.filter (
      extension: cfg.browser != "helium-browser" || !(builtins.elem extension.id heliumExtensionIds)
    ) extensions
  ) extensionCatalog;
in
{
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  options.hm.chromium = {
    enable = lib.options.mkEnableOption "Chromium-based browsers";

    browser = lib.options.mkOption {
      type = lib.types.enum (lib.attrsets.attrNames browserPackages);
      default = "ungoogled-chromium";
      description = "The browser package to use.";
    };

    extraExtensions = lib.options.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
      description = "Extra 4evy/browser extension catalog entries to append to the base catalog.";
      example = lib.literalExpression ''
        {
          chrome_store = [
            {
              id = "nngceckbapebfimnlniiiahkandclblb";
              name = "Bitwarden";
            }
          ];
        }
      '';
    };

    configureOnActivation = lib.options.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install and update extensions with 4evy/browser during Home Manager activation.";
    };
  };

  imports = [ euvlokInputs.browser-trivial.homeModules.default ];

  config = lib.modules.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenvNoCC.isLinux;
        message = "hm.chromium is only available on Linux";
      }
    ];
    programs.chromium = {
      enable = true;
      package = browserPackage;
      dictionaries = builtins.attrValues {
        inherit (pkgs.hunspellDictsChromium) en_US de_DE fr_FR;
      };

      # 4evy/browser is the single extension installer.
      extensions = lib.modules.mkForce [ ];

      commandLineArgs = [
        # Debug
        "--enable-logging=stderr"
        "--enable-features=${lib.strings.concatStringsSep "," chromiumFeatures}"
      ]
      ++ lib.lists.optionals (chromiumDisabledFeatures != [ ]) [
        "--disable-features=${lib.strings.concatStringsSep "," chromiumDisabledFeatures}"
      ]
      ++ lib.lists.optionals pkgs.stdenvNoCC.isLinux [
        "--ignore-gpu-blocklist"

        # Wayland
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    };

    programs.browser = {
      enable = true;
      settings = {
        browser = {
          name = cfg.browser;
          executable_name = browserExecutable;
          flags = config.programs.chromium.commandLineArgs;

          linux = {
            app_dir = "${config.home.profileDirectory}/bin";
            launcher_name = browserExecutable;
          };

          paths.linux = {
            profile_dir = "\${config_home}/${browserPath}/Default";
            external_extension_dirs = [ "\${config_home}/${browserPath}/External Extensions" ];
          };
        };

        extensions = managedExtensions;
      };
    };

    home.sessionPath = lib.lists.optional cfg.configureOnActivation browserBinDir;

    home.activation.configureChromium = lib.modules.mkIf cfg.configureOnActivation (
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run ${lib.getExe config.programs.browser.package} configure \
          --config ${config.programs.browser.configFile} \
          --mode linux \
          --root ${lib.escapeShellArg browserRuntimeRoot} \
          --bin-dir ${lib.escapeShellArg browserBinDir} \
          --no-apply-settings
      ''
    );
  };
}
