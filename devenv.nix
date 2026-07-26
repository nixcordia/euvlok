{ pkgs, ... }:
{
  name = "euvlok development shell";

  languages = {
    nix.enable = true;
    shell.enable = true;
  };

  packages = builtins.attrValues {
    inherit (pkgs)
      git
      jujutsu
      nix-index
      nix-prefetch-github
      nix-prefetch-scripts
      ;
  };

  git-hooks = {
    excludes = [ ".devenv" ];
    hooks = import ./devenv/git-hooks.nix { inherit pkgs; };
  };

  treefmt = {
    enable = true;
    config.programs.nixfmt.enable = true;
  };
}
