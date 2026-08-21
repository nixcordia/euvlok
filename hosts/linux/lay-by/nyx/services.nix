_: {
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = false;
      };
    };

    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 5;
    };

    fwupd.enable = true;
    thermald.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;

    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
    };

    gvfs.enable = true;
    tumbler.enable = true;
    dbus.enable = true;
    ratbagd.enable = true;
    blueman.enable = true;
  };
}
