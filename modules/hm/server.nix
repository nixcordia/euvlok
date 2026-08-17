{ euvlokInputs }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ./core.nix {
      inherit euvlokInputs;
      includeNixpkgs = false;
    })
    (lib.modules.importApply ./sops.nix { inherit euvlokInputs; })
    ./cli/direnv.nix
    ./cli/fastfetch
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/nh.nix
    ./cli/ssh.nix
    ./cli/zoxide.nix
    ./shell
    ./tui
  ];
}
