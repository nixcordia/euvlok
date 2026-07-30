{ ... }:
{
  _class = "nixos";
  _file = ./nix-credentials.nix;
  key = toString ./nix-credentials.nix;
  # sops.secrets.gh_token = {
  #   mode = "0440";
  #   group = "users";
  # };
  # sops.secrets.netrc_creds = {
  #   mode = "0440";
  #   group = "users";
  # };

  # nix.extraOptions = ''
  #   !include ${config.sops.secrets.gh_token.path}
  # '';
  #  nix.settings.netrc-file = config.sops.secrets.netrc_creds.path;

  # Determinate Nixd owns automatic garbage collection. Keeping a second
  # nix-gc timer would race its free-space-aware collector.
}
