{
  config,
  lib,
  pkgs,
  ...
}:

{
  _class = "homeManager";
  _file = ./stylix.nix;
  key = toString ./stylix.nix;
  stylix = {
    enable = true;
    polarity = "dark";
    autoEnable = true;

    targets.hyprlock.enable = false;
    targets.spicetify.enable = true;
    targets.zen-browser.enable = false;
    targets.rofi.enable = false;
    # targets.anki.enable = false;
    # targets.hyprpaper.enable = false;
    targets.vscode.enable = false;

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lay-by/wallpapers/refs/heads/main/starfighter2.png";
      hash = "sha256-eDeJpTVmEt6Ty0HL7KVKe+O6Sgcv8lKX2FlLQwm+v+I";
    };
    # Stylix parses this during module evaluation. Keeping the selected scheme
    # as source data avoids realising the whole base16-schemes package via IFD.
    base16Scheme = ./tokyo-night-terminal-dark.yaml;

    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze-Dark";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font Mono";
      };

      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twitter Color Emoji";
      };

      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
    };
  };

  home.pointerCursor.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    gtk4.theme = lib.modules.mkDefault config.gtk.theme;
  };
}
