{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenvNoCC) isLinux;
in
{
  imports = [
    ./keybindings.nix
    ./settings.nix
  ];

  options.euvlok.home.yazi.enable = lib.options.mkEnableOption "Yazi";

  config = lib.modules.mkIf config.euvlok.home.yazi.enable {
    home.packages =
      (builtins.attrValues { inherit (pkgs) mediainfo exiftool; })
      ++ lib.lists.optionals isLinux [
        pkgs.wl-clipboard
        pkgs.xclip
      ];
    programs.yazi = {
      enable = true;
      package = pkgs.unstable.yazi;
      shellWrapperName = "yy";
      plugins =
        let
          pluginsRepo = pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "plugins";
            rev = "8f1d9711bcd0e48af1fcb4153c16d24da76e732d";
            hash = "sha256-7vsqHvdNimH/YVWegfAo7DfJ+InDr3a1aNU0f+gjcdw=";
          };
        in
        {
          diff = "${pluginsRepo}/diff.yazi";
          full-border = "${pluginsRepo}/full-border.yazi";
          smart-enter = "${pluginsRepo}/smart-enter.yazi";
          smart-paste = "${pluginsRepo}/smart-paste.yazi";
          system-clipboard = ./system-clipboard.yazi;
          types = "${pluginsRepo}/types.yazi";
        }
        // lib.attrsets.optionalAttrs config.programs.git.enable { git = "${pluginsRepo}/git.yazi"; }
        // lib.attrsets.optionalAttrs config.programs.starship.enable {
          starship = pkgs.fetchFromGitHub {
            owner = "Rolv-Apneseth";
            repo = "starship.yazi";
            rev = "a63550b2f91f0553cc545fd8081a03810bc41bc0";
            hash = "sha256-PYeR6fiWDbUMpJbTFSkM57FzmCbsB4W4IXXe25wLncg=";
          };
        };
      initLua = ''
        local function setup_plugin(name, opts)
          local ok, plugin = pcall(require, name)
          if ok and type(plugin.setup) == "function" then
            if opts == nil then
              plugin:setup()
            else
              plugin:setup(opts)
            end
          end
        end

        setup_plugin("full-border")
        ${lib.strings.optionalString config.programs.git.enable ''setup_plugin("git", { order = 1500 })''}
        ${lib.strings.optionalString config.programs.starship.enable ''setup_plugin("starship")''}
      '';
    };
  };
}
