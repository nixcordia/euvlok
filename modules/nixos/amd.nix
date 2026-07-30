{
  pkgs,
  lib,
  config,
  ...
}:
{
  _class = "nixos";
  _file = ./amd.nix;
  key = toString ./amd.nix;
  options.nixos.amd.enable = lib.options.mkEnableOption "AMD drivers";

  config = lib.modules.mkMerge [
    (lib.modules.mkIf config.nixos.amd.enable {
      environment.systemPackages = [ pkgs.clinfo ];
      hardware.amdgpu.opencl.enable = true;
      services.lact.enable = true;
      systemd.tmpfiles.settings.rocm =
        let
          rocmEnv = pkgs.symlinkJoin {
            name = "rocm-combined";
            paths = builtins.attrValues {
              inherit (pkgs.rocmPackages) rocblas hipblas clr;
            };
          };
        in
        {
          "/opt/rocm"."L+".argument = toString rocmEnv;
        };
    })
  ];
}
