{
  inputs,
  ...
}:
let
  baseImports = [
    { home.stateVersion = "26.05"; }
    ../../../hm/ashuramaruzxc/catppuccin.nix
  ];

  rootHmConfig = {
    hm = {
      bash.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      helix.enable = true;
      nh.enable = true;
      zsh.enable = true;
    };
  };

  commonHmConfig = [
    inputs.self.homeModules.default
    inputs.self.homeModules.ashuramaruzxc
    {
      hm = {
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
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs; };
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
