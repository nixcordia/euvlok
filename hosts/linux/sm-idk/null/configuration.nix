{
  pkgs,
  pkgsUnstable,
  ...
}:

{
  # Imports
  imports = [
    ./home.nix
    ./hardware-configuration.nix
  ];
  system.stateVersion = "25.05";
  # Bootloader
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot = {
    supportedFilesystems = [ "ntfs" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  # Hardware
  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
  };
  powerManagement.enable = true;
  services.fstrim.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "bruno" ];
  virtualisation.libvirtd.enable = true;

  # User
  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno";
    extraGroups = [
      "dialout"
      "wheel"
      "video"
      "networkmanager"
      "libvirtd"
    ];
  };

  # Services
  services = {
    udev.packages = with pkgs; [ game-devices-udev-rules ];
    power-profiles-daemon.enable = true;

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  networking = {
    hostName = "null";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.scx.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
    package = pkgsUnstable.tailscale;
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "enp34s0";
      WIFI_IFACE = "wlo1";
      SSID = "null";
      PASSPHRASE = "GWIKPACK";
      DHCP_DNS = "1.1.1.1";
    };
  };
}
