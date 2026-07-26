{ lib, paletteSource }:
{
  accent,
  flavor,
}:
let
  palette = builtins.fromJSON (builtins.readFile (paletteSource + /palette.json));
  colors = lib.attrsets.mapAttrs (_: color: color.rgb) palette.${flavor}.colors;
  accentColor = colors.${accent};
in
{
  colors = {
    toolbar = colors.base;
    toolbar_text = colors.text;
    frame = colors.crust;
    tab_background_text = colors.text;
    toolbar_field = colors.mantle;
    toolbar_field_text = colors.text;
    tab_line = accentColor;
    popup = colors.base;
    popup_text = colors.text;
    button_background_active = colors.overlay0;
    frame_inactive = colors.crust;
    icons_attention = accentColor;
    icons = accentColor;
    ntp_background = colors.crust;
    ntp_text = colors.text;
    popup_border = accentColor;
    popup_highlight_text = colors.text;
    popup_highlight = colors.overlay0;
    sidebar_border = accentColor;
    sidebar_highlight_text = colors.crust;
    sidebar_highlight = accentColor;
    sidebar_text = colors.text;
    sidebar = colors.base;
    tab_background_separator = accentColor;
    tab_loading = accentColor;
    tab_selected = colors.base;
    tab_text = colors.text;
    toolbar_bottom_separator = colors.base;
    toolbar_field_border_focus = accentColor;
    toolbar_field_border = colors.base;
    toolbar_field_focus = colors.base;
    toolbar_field_highlight_text = colors.base;
    toolbar_field_highlight = accentColor;
    toolbar_field_separator = accentColor;
    toolbar_vertical_separator = accentColor;
  };

  images = {
    additional_backgrounds = [ "./bg-000.svg" ];
    custom_backgrounds = [ ];
  };

  title = "Catppuccin ${flavor} ${accent}";
}
