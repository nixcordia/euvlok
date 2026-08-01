{
  pkgs,
  lib,
  config,
  ...
}:
let
  paths = import ./paths.nix { inherit lib; };
in
{
  _class = "homeManager";
  _file = ./zsh.nix;
  key = toString ./zsh.nix;
  options.euvlok.home.zsh.enable = lib.options.mkEnableOption "declarative Zsh";

  config = lib.modules.mkIf config.euvlok.home.zsh.enable {
    assertions = [
      {
        message = "You cannot use Home-Manager Zsh on Darwin";
        assertion = pkgs.stdenvNoCC.isLinux;
      }
    ];
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      autocd = true;
      historySubstringSearch.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "colorize"
          "direnv"
          "dotnet"
          "fzf"
          "gitfast"
          "podman"
          "ssh"
          "vscode"
        ];
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
        }
        {
          name = "nix-shell";
          src = pkgs.zsh-nix-shell;
        }
      ];
      initContent = ''
        ${paths.hm.shell.binPaths.zsh}
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
      '';
    };
  };
}
