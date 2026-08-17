_:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.euvlok.home.devenv.enable = lib.options.mkEnableOption "devenv" // {
    default = true;
  };

  config = lib.modules.mkIf config.euvlok.home.devenv.enable {
    programs.devenv = {
      enable = true;
      # The flake-native package evaluates devenv's generated Cargo.nix and
      # several independent package sets. Keep the same release while using
      # the much cheaper Nixpkgs buildRustPackage expression.
      package = pkgs.callPackage ../../../packages/devenv.nix { };
    };
  };
}
