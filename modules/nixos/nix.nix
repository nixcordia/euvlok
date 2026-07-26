_: {
  _class = "nixos";
  _file = ./nix.nix;
  key = toString ./nix.nix;

  # Determinate's module redirects the NixOS-generated configuration to the
  # supported /etc/nix/nix.custom.conf include.
  determinate.enable = true;

  nix = {
    # Determinate Nix implements both settings. Lazy trees avoid unnecessary
    # source copies, while eval-cores enables parallel evaluation for commands
    # such as nix flake check, nix flake show, and nix eval --json.
    settings = {
      eval-cores = 0;
      lazy-trees = true;
    };

    # Determinate Nix 3.21 makes store optimisation multi-threaded. Running it
    # periodically avoids imposing the cost on every build.
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "70%";
    MemoryMax = "85%";
    MemorySwapMax = "50%";
  };
}
