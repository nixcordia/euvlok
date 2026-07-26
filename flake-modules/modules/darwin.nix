{ applyEuvlokInputs }:
{
  default = applyEuvlokInputs ../../modules/darwin;
  nix = ../../modules/darwin/nix.nix;
  sops = applyEuvlokInputs ../../modules/darwin/sops.nix;
  system = ../../modules/darwin/system.nix;
  zsh = ../../modules/darwin/zsh.nix;
}
