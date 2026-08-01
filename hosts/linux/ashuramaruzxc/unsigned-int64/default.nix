{
  homeModule,
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
    { sops.defaultSopsFile = ../../../../secrets/ashuramaruzxc_unsigned-int64.yaml; }
    {
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "rosewater";
      };
    }
    {
      euvlok.nixos = {
        gnome.enable = true;
        amd.enable = true;
      };
    }
  ];
}
