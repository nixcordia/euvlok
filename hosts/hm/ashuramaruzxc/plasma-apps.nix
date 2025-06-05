{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (inputs.lightly-source.packages.${config.nixpkgs.hostPlatform.system})
      darkly-qt5
      darkly-qt6
      ;
    inherit (pkgs.kdePackages)
      filelight
      kclock
      merkuro
      kio-gdrive
      kio-zeroconf

      k3b
      kamera
      ktorrent

      discover
      flatpak-kcm
      kcmutils
      packagekit-qt

      accounts-qt
      kaccounts-integration
      kaccounts-providers
      signond

      akonadi
      akonadi-calendar
      akonadi-contacts
      akonadi-search
      calendarsupport
      kcontacts
      kmail
      kmail-account-wizard
      kmailtransport
      knotifications
      korganizer
      kservice
      ;
  };
}
