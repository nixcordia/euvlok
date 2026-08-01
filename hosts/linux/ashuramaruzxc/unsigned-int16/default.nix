{
  diskoModule,
  flatpakModule,
  homeModule,
  raspberryPiModules,
  sharedModule,
}:
_: {
  _class = "nixos";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    sharedModule
    ./configuration.nix
    homeModule
    diskoModule
  ]
  ++ raspberryPiModules
  ++ [
    { sops.defaultSopsFile = ../../../../secrets/ashuramaruzxc_unsigned-int16.yaml; }
    {
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "flamingo";
      };
    }
    flatpakModule
    {
      services.flatpak = {
        enable = true;
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
        };
      };
    }
    { euvlok.nixos.plasma.enable = true; }
  ];
}
