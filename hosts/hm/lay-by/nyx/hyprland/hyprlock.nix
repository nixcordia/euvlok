{ pkgs, ... }:
let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/lay-by/wallpapers/00fb754880396b15a536964499bcce25208fae48/starfighter2.png";
    hash = "sha256-eDeJpTVmEt6Ty0HL7KVKe+O6Sgcv8lKX2FlLQwm+v+I";
  };
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        immediate_render = true;
        hide_cursor = true;
        no_fade_in = true;
      };

      background = [ { path = toString wallpaper; } ];

      input-field = [
        {
          size = "200, 50";
          position = "0, 0";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password";
          shadow_passes = 2;
        }
      ];
    };
  };
}
