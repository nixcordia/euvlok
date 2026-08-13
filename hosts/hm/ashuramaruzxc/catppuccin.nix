{ catppuccinGtkModule }:
{ osConfig, ... }:
{
  imports = [ catppuccinGtkModule ];

  catppuccin = {
    inherit (osConfig.catppuccin) enable accent flavor;
    sources.gitui = "${
      fetchTree {
        type = "github";
        owner = "catppuccin";
        repo = "gitui";
        rev = "df2f59f847e047ff119a105afff49238311b2d36";
        narHash = "sha256-DRK/j3899qJW4qP1HKzgEtefz/tTJtwPkKtoIzuoTj0=";
      }
    }/themes";
  };
}
