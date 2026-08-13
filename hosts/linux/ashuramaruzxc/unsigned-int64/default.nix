{
  homeModule,
  sharedModule,
}:
_: {
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
