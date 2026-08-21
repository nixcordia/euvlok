{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
      systemd.enable = true;
      verbose = false;
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 3;
    plymouth = {
      enable = true;
      theme = "lone";
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ "lone" ];
        })
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f6053852-9eb1-4efb-a669-6ce86d4df177";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/D1AB-4DDB";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [ ];
  networking.useDHCP = lib.modules.mkDefault true;
  nixpkgs.hostPlatform = lib.modules.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.modules.mkDefault config.hardware.enableRedistributableFirmware;
}
