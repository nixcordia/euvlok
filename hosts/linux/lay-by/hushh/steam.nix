{ lib, pkgs, ... }:
{
  _class = "nixos";
  _file = ./steam.nix;
  key = toString ./steam.nix;
  nixpkgs.config.packageOverrides.steam = pkgs.steam.override {
    extraPkgs = lib.attrsets.attrValues {
      inherit (pkgs.xorg)
        libXcursor
        libXi
        libXinerama
        libXScrnSaver
        ;

      inherit (pkgs)
        libkrb5
        libpng
        libpulseaudio
        libvorbis
        gtk3
        gtk3-x11
        keyutils
        libgdiplus
        mono
        zlib
        ;

      inherit (pkgs.stdenv.cc.cc) lib;
    };
  };
}
