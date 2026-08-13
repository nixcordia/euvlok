{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./extensions.nix ];

  options.euvlok.home.vscode.enable = lib.options.mkEnableOption "VSCode";

  config = lib.modules.mkIf config.euvlok.home.vscode.enable {
    programs.vscode = {
      enable = true;
      package =
        if pkgs.unstable.stdenvNoCC.isLinux then
          (pkgs.unstable.vscode.override {
            commandLineArgs = "--wayland-text-input-version=3 --enable-wayland-ime";
          })
        else
          pkgs.unstable.vscode;
    };
  };
}
