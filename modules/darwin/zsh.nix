{
  pkgs,
  lib,
  config,
  ...
}:
let
  hmConfig = config.home-manager.users.${config.system.primaryUser};
  paths = import ../hm/shell/paths.nix { inherit lib; };

  # Home Manager has already merged the shared and user-specific aliases.
  # Consume that module result instead of reaching back into hosts/ by name.
  shellAliases = hmConfig.programs.zsh.shellAliases;
  shellAliasesStr = lib.trivial.pipe shellAliases [
    (attrs: lib.attrsets.filterAttrs (_: value: builtins.isString value) attrs)
    (
      filteredAttrs:
      lib.generators.toKeyValue {
        mkKeyValue = name: value: "alias ${name}=${lib.strings.escapeShellArg value}";
      } filteredAttrs
    )
  ];

  omzPlugins =
    let
      enablePlugin = n: lib.lists.optionals hmConfig.programs.${n}.enable [ n ];
    in
    [
      "colorize"
      "dotnet"
      "podman"
    ]
    ++ enablePlugin "fzf"
    ++ enablePlugin "ssh"
    ++ enablePlugin "git"
    ++ enablePlugin "direnv"
    ++ enablePlugin "vscode";

  customPlugins = [
    {
      name = "nix-shell";
      src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
    }
  ]
  ++ lib.lists.optionals hmConfig.euvlok.home.fzf.enable [
    {
      name = "fzf-tab";
      src = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";
    }
  ];
  customPluginsStr = lib.trivial.pipe customPlugins [
    (pluginsList: map (p: "source ${p.src}") pluginsList)
    (builtins.concatStringsSep "\n")
  ];

  omzPluginsStr = "plugins=(${lib.strings.concatStringsSep " " omzPlugins})";
in
{
  _class = "darwin";
  _file = ./zsh.nix;
  key = toString ./zsh.nix;
  programs.zsh = {
    enableAutosuggestions = true;
    enableFastSyntaxHighlighting = true;

    interactiveShellInit = lib.strings.concatStringsSep "\n" [
      "# PATH"
      paths.hm.shell.binPaths.zsh

      "# Oh My Zsh"
      omzPluginsStr
      "source ${pkgs.oh-my-zsh}/share/oh-my-zsh/oh-my-zsh.sh"

      "# Aliases"
      shellAliasesStr

      "setopt autocd"

      "# History substring search"
      "source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

      "# Custom plugins"
      customPluginsStr
    ];

    promptInit = lib.modules.mkMerge [
      (lib.strings.optionalString hmConfig.euvlok.home.ghostty.enable ''
        if [[ -r "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration ]]; then
          source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
        fi
      '')
      (lib.strings.optionalString hmConfig.programs.starship.enable ''
        if [[ $TERM != "dumb" ]]; then
          eval "$(starship init zsh)"
        fi
      '')
      (lib.strings.optionalString hmConfig.euvlok.home.yazi.enable ''
        function yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
          yazi "$@" --cwd-file="$tmp"
            if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
      '')
      (lib.strings.optionalString hmConfig.euvlok.home.zoxide.enable ''eval "$(zoxide init zsh)"'')
    ];
  };

  launchd.user.agents."symlink-zsh-config" = {
    script = ''
      ln -sfn "/etc/zprofile" "/Users/${config.system.primaryUser}/.zprofile"
      ln -sfn "/etc/zshenv" "/Users/${config.system.primaryUser}/.zshenv"
      ln -sfn "/etc/zshrc" "/Users/${config.system.primaryUser}/.zshrc"
    '';
    serviceConfig.RunAtLoad = true;
    serviceConfig.StartInterval = 0;
  };
}
