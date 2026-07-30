{ isDarwin }:
{
  config,
  lib,
  ...
}:
let
  cfg = config.euvlok.nix.buildParallelism;
  settings = {
    cores = lib.modules.mkDefault cfg.cores;
    max-jobs = lib.modules.mkDefault cfg.maxJobs;
  };
in
{
  _class = null;
  _file = ./build-parallelism.nix;
  key = toString ./build-parallelism.nix;

  options.euvlok.nix.buildParallelism = {
    maxJobs = lib.options.mkOption {
      type = lib.types.either lib.types.ints.positive (lib.types.enum [ "auto" ]);
      default = "auto";
      description = "Maximum number of builds Nix may execute concurrently.";
    };

    cores = lib.options.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
      description = "CPU cores available to each build; zero lets Nix use all cores.";
    };
  };

  config =
    if isDarwin then { determinateNix.customSettings = settings; } else { nix.settings = settings; };
}
