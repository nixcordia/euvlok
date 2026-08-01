{
  catppuccinModule,
  homeManagerModule,
  personalModule,
  sharedModule,
}:
_:
let
  baseImports = [
    { home.stateVersion = "26.05"; }
    catppuccinModule
  ];

  rootHmConfig = {
    euvlok.home = {
      bash.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      helix.enable = true;
      nh.enable = true;
      zsh.enable = true;
    };
  };

  commonHmConfig = [
    {
      euvlok.home = {
        fastfetch.enable = true;
        ghostty.enable = true;
        helix.enable = true;
        nh.enable = true;
        vscode.enable = true;
        yazi.enable = true;
      };
    }
  ];

  globalImports = [
    ../shared/home/aliases.nix
    { sops.defaultSopsFile = ../../../../secrets/ashuramaruzxc_unsigned-int64.yaml; }
  ];
in
{
  _class = "nixos";
  _file = ./home.nix;
  key = toString ./home.nix;
  imports = [ homeManagerModule ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    sharedModules = [
      sharedModule
      personalModule
    ];
  };

  home-manager.users.root = {
    imports = baseImports ++ globalImports ++ [ rootHmConfig ] ++ commonHmConfig;
  };

  home-manager.users.ashuramaru = {
    imports = baseImports ++ globalImports ++ commonHmConfig;
  };

  home-manager.users.fumono = {
    imports = baseImports ++ globalImports ++ commonHmConfig;
  };

  home-manager.users.minecraft = {
    imports = baseImports ++ globalImports ++ commonHmConfig;
  };
}
