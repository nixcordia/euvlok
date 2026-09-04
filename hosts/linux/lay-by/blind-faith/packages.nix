{ zenBrowserPackage }:
{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # Base System
      wget
      git
      libsecret
      ffmpeg
      hyprpolkitagent

      # Desktop
      wayland-protocols
      wayland-utils
      wl-clipboard
      wlroots
      xdg-utils

      # Development
      meson
      gcc
      glibc
      jq
      cachix
      bc
      ninja

      # QEMU
      #qemu
      #quickemu
      #virt-manager

      # Security
      wireshark

      # Recording
      gpu-screen-recorder
      gpu-screen-recorder-gtk

      ;
    # Theme stuff
    inherit (pkgs.unstable.kdePackages)
      breeze
      breeze-gtk
      breeze-icons
      ;
    inherit (pkgs) seahorse;
    zen-browser = zenBrowserPackage;
  };
}
