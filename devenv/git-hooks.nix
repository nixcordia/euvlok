{ pkgs }:
{
  action-validator.enable = true;
  actionlint.enable = true;
  deadnix = {
    enable = true;
    excludes = [
      "^hosts/hm/ashuramaruzxc/firefox/extensions\\.nix$"
      "^modules/hm/gui/firefox/extensions\\.nix$"
    ];
    settings.noLambdaPatternNames = true;
  };
  nixfmt-rfc-style = {
    enable = true;
    package = pkgs.nixfmt;
  };
  shellcheck.enable = true;
  yamllint = {
    enable = true;
    files = "^\\.github/";
    settings.configuration = ''
      extends: default
      rules:
        document-start: disable
        line-length: disable
        truthy: disable
    '';
  };
  zizmor = {
    enable = true;
    files = "^\\.github/(actions|workflows)/";
  };
}
