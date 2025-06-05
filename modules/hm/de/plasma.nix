{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.plasma-manager-trivial.homeManagerModules.plasma-manager ];

  options.hm.de.plasma = {
    enable = lib.mkEnableOption "Plasma Manager";

    theme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "breeze-dark";
      description = "Plasma theme to use";
      example = "breeze";
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Kay/contents/images/1920x1080.png";
      description = "Path to wallpaper image";
    };

    tooltipDelay = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = 5;
      description = "Delay in milliseconds before tooltips appear";
    };

    konsole = {
      enable = lib.mkEnableOption "Konsole" // {
        default = true;
      };

      defaultProfile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "Default";
        description = "Default Konsole profile to use";
        example = "Development";
      };

      font = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "Hack";
          description = "Font name for Konsole";
          example = "JetBrains Mono";
        };

        size = lib.mkOption {
          type = lib.types.ints.between 4 128;
          default = 11;
          description = "Font size for Konsole";
          example = 12;
        };
      };

      colorScheme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default =
          if config.catppuccin.enable then
            let
              flavor = config.catppuccin.flavor;
            in
            "Catppuccin-"
            + (lib.toUpper (lib.strings.substring 0 1 flavor))
            + (lib.strings.substring 1 (lib.strings.stringLength flavor - 1) flavor)
          else
            null;
        description = "Color scheme for Konsole";
        example = "Catppuccin-Mocha";
      };
    };
  };

  config = lib.mkIf config.hm.de.plasma.enable {
    programs.plasma = {
      enable = true;
      workspace = {
        theme = config.hm.de.plasma.theme;
        wallpaper = config.hm.de.plasma.wallpaper;
        tooltipDelay = config.hm.de.plasma.tooltipDelay;
      };
    };

    programs.konsole = lib.mkIf config.hm.de.plasma.konsole.enable {
      enable = true;
      defaultProfile = config.hm.de.plasma.konsole.defaultProfile;

      profiles.${config.hm.de.plasma.konsole.defaultProfile} = {
        font = {
          name = config.hm.de.plasma.konsole.font.name;
          size = config.hm.de.plasma.konsole.font.size;
        };
        colorScheme = config.hm.de.plasma.konsole.colorScheme;
      };
    };

    # Install base KDE packages
    home.packages =
      (builtins.attrValues {
        inherit (pkgs)
          adwaita-icon-theme
          adwaita-qt
          adwaita-qt6
          dconf-editor
          ;
      })
      ++ (builtins.attrValues {
        inherit (pkgs.kdePackages)
          # Core file management
          dolphin
          dolphin-plugins
          kio
          kio-admin
          kio-extras
          kio-fuse

          # Media formats and thumbnails
          kdegraphics-thumbnailers
          kdesdk-thumbnailers
          kimageformats
          qtimageformats
          qtsvg

          # Essential utilities
          ark
          konsole
          ;
      })
      ++ lib.optionals config.catppuccin.enable [
        # Catppuccin theming - integrated into the generic module
        (pkgs.catppuccin-gtk.override {
          accents = [ config.catppuccin.accent ];
          size = "compact";
          tweaks = [ "rimless" ];
          variant = config.catppuccin.flavor;
        })
        (pkgs.catppuccin-kde.override {
          accents = [ config.catppuccin.accent ];
          flavour = [ config.catppuccin.flavor ];
          winDecStyles = [ "classic" ];
        })
      ];
  };
}
