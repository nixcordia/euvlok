{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.euvlok.home.codex;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;

  codexConfigDir =
    if config.home.preferXdgDirectories then
      "${lib.strings.removePrefix config.home.homeDirectory config.xdg.configHome}/codex"
    else
      ".codex";

  codexShellAliases = {
    cx = "command codex --sandbox danger-full-access --ask-for-approval never";
  };

  codexSettings = {
    model = "gpt-5.6-sol";
    model_reasoning_effort = "high";
    approval_policy = "never";
    default_permissions = "unrestricted";
    web_search = "live";

    permissions.unrestricted = {
      description = "Unrestricted access without the desktop Full access warning";
      filesystem = {
        ":root" = "write";
      };
      network = {
        enabled = true;
        allow_local_binding = true;
        dangerously_allow_all_unix_sockets = true;
      };
    };

    tui = {
      notification_condition = lib.modules.mkDefault "always";
      show_tooltips = false;
      terminal_resize_reflow_max_rows = 0;
      keymap.global = {
        open_external_editor = "ctrl-x";
      }
      // lib.attrsets.optionalAttrs isDarwin {
        open_transcript = "ctrl-t";
      };
    }
    // lib.attrsets.optionalAttrs config.catppuccin.enable {
      theme = lib.modules.mkDefault "catppuccin-frappe-pink";
    };
  };
in
{
  options.euvlok.home.codex.enable = lib.options.mkEnableOption "Codex";

  config = lib.modules.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.codex-acp
      pkgs.unstable.opencode
    ];

    programs.codex = {
      enable = true;
      package = pkgs.unstable.codex;
      settings = codexSettings;
    };

    programs.bash.shellAliases = codexShellAliases;
    programs.zsh.shellAliases = codexShellAliases;

    home.file = lib.attrsets.optionalAttrs config.catppuccin.enable {
      "${codexConfigDir}/themes/catppuccin-frappe-pink.tmTheme".source = ./catppuccin-frappe-pink.tmTheme;
    };
  };
}
