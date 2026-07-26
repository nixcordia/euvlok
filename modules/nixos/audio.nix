{ config, lib, ... }:
{
  _class = "nixos";
  _file = ./audio.nix;
  key = toString ./audio.nix;
  options.nixos.audio.enable = lib.options.mkEnableOption "the shared PipeWire audio stack" // {
    default = true;
  };

  config = lib.modules.mkIf config.nixos.audio.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      audio.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
