{ pkgs, ... }:
let
  monospace = {
    package = pkgs.nerd-fonts.iosevka;
    name = "Iosevka Nerd Font Mono";
  };
in
{
  _class = "nixos";
  _file = ./stylix.nix;
  key = toString ./stylix.nix;

  stylix = {
    enable = true;
    polarity = "dark";
    # The system module owns overlays and Home Manager integration only. Keep
    # machine-level theming opt-in so existing boot/display behavior is stable.
    autoEnable = false;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lay-by/wallpapers/refs/heads/main/starfighter2.png";
      hash = "sha256-eDeJpTVmEt6Ty0HL7KVKe+O6Sgcv8lKX2FlLQwm+v+I";
    };
    base16Scheme = ../../../hm/lay-by/tokyo-night-terminal-dark.yaml;
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze-Dark";
      size = 24;
    };
    fonts = {
      inherit monospace;
      serif = monospace;
      sansSerif = monospace;
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twitter Color Emoji";
      };
    };
  };
}
