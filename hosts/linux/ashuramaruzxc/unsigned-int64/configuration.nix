{
  pkgs,
  lib,
  ...
}:
{
  _class = "nixos";
  _file = ./configuration.nix;
  key = toString ./configuration.nix;
  imports = [
    ../shared/system/android.nix
    ../shared/system/containers.nix
    ../shared/system/firmware.nix
    ../shared/system/fonts.nix
    ../shared/system/hyperv.nix
    ../shared/system/lxc.nix
    ../shared/system/nix-credentials.nix
    ../shared/system/settings.nix
    ./hardware-configuration.nix
    ./services/default.nix
    ./settings.nix
    ./users.nix
    ./wireguard.nix
  ];

  security = {
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };

  programs = {
    gnupg.dirmngr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
  virtualisation.oci-containers.containers.byparr = {
    image = "ghcr.io/thephaseless/byparr:latest";
    autoStart = true;
    environment = {
      HOST = "172.16.31.1";
      PORT = "8191";
    };
  };
  nixpkgs.config.permittedInsecurePackages = [
    "mbedtls-2.28.10"
  ];

  environment.shells = builtins.attrValues { inherit (pkgs) zsh bash fish; };

  nixos.locale = {
    enable = true;
    timeZone = "Europe/Berlin";
  };

  services.avahi.enable = lib.modules.mkForce false;
  services.displayManager.gdm.autoSuspend = false;

  # This must describe the installation, not follow the current nixpkgs
  # release. Keep it aligned with this host's Home Manager state version.
  system.stateVersion = "26.05";
}
