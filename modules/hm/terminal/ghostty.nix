{
  pkgs,
  lib,
  eulib,
  config,
  osConfig,
  ...
}:
let
  inherit (osConfig.nixpkgs.hostPlatform) isDarwin;
  inherit (eulib) mkSuper mkSuperShift;

  superKey = if isDarwin then "super" else "ctrl";

  # Source: https://vt100.net/docs/vt100-ug/chapter3.html
  # Converter: https://www.rapidtables.com/convert/number/hex-to-octal.html
  ctrl =
    let
      x = "\\x";
    in
    {
      # SOH (Function Mnemonic) = 001 (Octal Code Transmitted) -> "\x01" (string literal)
      SOH = "${x}01"; # Start of heading
      ENQ = "${x}05"; # Enquiry
      ESC = "${x}1b"; # Escape

      # "2 ↓" Key on Physical Keypad Keyboard
      WORD_BACK = "${x}62"; # b
      # "6 →" Key on Physical Keypad Keyboard
      WORD_FORWARD = "${x}66"; # f
    };

  mkKeybindings = {
    cursor = [
      (mkSuper "left" "text:${ctrl.SOH}")
      (mkSuper "right" "text:${ctrl.ENQ}")

      "alt+left=text:${ctrl.ESC}${ctrl.WORD_BACK}"
      "alt+right=text:${ctrl.ESC}${ctrl.WORD_FORWARD}"
    ];

    screen = [ (mkSuper "g" "write_screen_file:open") ];

    font = [
      (mkSuper "0" "reset_font_size")

      (mkSuper "equal" "increase_font_size:1")
      "${superKey}+shift+equal=increase_font_size:1"

      (mkSuper "minus" "decrease_font_size:1")
      "${superKey}+shift+minus=decrease_font_size:1"
    ];

    clipboard = [ (mkSuperShift "v" "paste_from_clipboard") ];

    misc = [
      (mkSuper "a" "select_all")
      (mkSuper "," "reload_config")
    ];
  };
in
{
  options.hm.ghostty.enable = lib.mkEnableOption "Ghostty";

  config = lib.mkIf config.hm.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = if isDarwin then null else pkgs.ghostty;
      settings = lib.optionalAttrs isDarwin { macos-option-as-alt = true; } // {
        adjust-underline-position = 4;
        clipboard-paste-protection = false;
        confirm-close-surface = false;
        cursor-style-blink = false;
        keybind = lib.flatten (lib.attrValues mkKeybindings);
        quit-after-last-window-closed = true;
        scrollback-limit = 10 * 10000000;
      };
    };
  };
}
