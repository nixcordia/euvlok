_: {
  programs = {
    zsh.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "nyx" ];
    };
  };
}
