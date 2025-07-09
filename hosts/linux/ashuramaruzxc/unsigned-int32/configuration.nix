{
  inputs,
  pkgs,
  lib,
  config,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ../../../hm/ashuramaruzxc/fonts.nix
    ../shared/android.nix
    ../shared/containers.nix
    ../shared/firmware.nix
    ../shared/hyperv.nix
    ../shared/lxc.nix
    ../shared/plasma.nix
    ../shared/settings.nix
    ../shared/fh.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./samba.nix
    ./users.nix
  ];

  environment.localBinInPath = true;
  environment.sessionVariables = {
    XDG_DATA_HOME = "\${HOME}/.local/share";
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_DATA_DIRS = [ "\${HOME}/.local/share/.icons" ];
  };

  hardware = {
    gpgSmartcards.enable = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      settings.General = {
        ControllerMode = "bredr";
        AutoEnable = true;
        Experimental = true;
      };
    };
    opentabletdriver = {
      enable = true;
      package = pkgsUnstable.opentabletdriver;
      daemon.enable = true;
    };
  };

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
    hardware.bolt.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.model = "evdev";
    };
    udev = {
      packages = builtins.attrValues {
        inherit (pkgs)
          libwacom
          via # qmk/via
          yubikey-personalization
          ;
        inherit (pkgsUnstable) opentabletdriver;
      };
      extraRules = ''
        # XP-Pen CT1060
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0644"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0932", MODE="0644"
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0644"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", MODE="0644"
        SUBSYSTEM=="input", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="5201", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # Wacom PTH-460
        KERNEL=="hidraw*", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="03dc", MODE="0777", TAG+="uaccess", TAG+="udev-acl"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="03dc", MODE="0777", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
    printing = {
      enable = true;
      drivers = builtins.attrValues { inherit (pkgs) gutenprintBin; };
      browsing = true;
    };
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns4 = true;
      openFirewall = true;
    };
    lvm.boot.thin.enable = true;
    pcscd.enable = true;
    xserver.wacom.enable = true;
  };

  programs.zsh.enable = true;

  security = {
    polkit = {
      enable = true;
      adminIdentities = [ "unix-group:wheel" ];
    };
    pam = {
      services = {
        login = {
          sshAgentAuth = true;
          u2fAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
        };
        su = {
          sshAgentAuth = true;
          u2fAuth = true;
        };
        sudo = {
          sshAgentAuth = true;
          u2fAuth = true;
        };
        sshd = {
          sshAgentAuth = true;
          u2fAuth = true;
          enableGnomeKeyring = true;
          enableKwallet = true;
          googleOsLoginAuthentication = true;
          googleOsLoginAccountVerification = true;
          googleAuthenticator.enable = true;
        };
      };
      # u2f = {
      # enable = true;
      # settings = {
      # cue = true;
      # };
      # control = "required";
      # };
    };
  };

  programs = {
    gnupg.dirmngr.enable = true;
    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
    };
    android-development = {
      enable = true;
      users = [ "${config.users.users.ashuramaru.name}" ];
      waydroid.enable = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    gphoto2.enable = true;
  };

  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        # yubico
        yubioath-flutter

        apfsprogs
        fcitx5-gtk
        gpgme
        ;
      inherit (pkgs.kdePackages) bluedevil;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "pl_PL.UTF-8/UTF-8"
      "all"
    ];
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        waylandFrontend = true;
        addons = builtins.attrValues {
          inherit (pkgs) fcitx5-gtk fcitx5-mozc;
        };
      };
    };
  };
  fonts.fontconfig.defaultFonts = {
    monospace = [ "Hack Nerd Font Mono" ];
    sansSerif = [ "Noto Nerd Font" ];
    serif = [ "Noto Nerd Font" ];
    emoji = [ "Twitter Color Emoji" ];
  };
  virtualisation.oci-containers.containers.FlareSolverr = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    autoStart = true;
    ports = [ "127.0.0.1:8191:8191" ];
    environment = {
      LOG_LEVEL = "info";
      LOG_HTML = "false";
      CAPTCHA_SOLVER = "hcaptcha-solver";
      TZ = "${config.time.timeZone}";
    };
  };

  # flatpak
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "resolve-symlinks"
          "x-gvfs-hide"
        ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths =
          builtins.attrValues {
            inherit (pkgs.kdePackages) breeze;
            inherit (inputs.anime-cursors-source.packages.${config.nixpkgs.hostPlatform.system}) cursors;
          }
          ++ lib.optionalAttrs config.catppuccin.enable builtins.attrValues {
            catppuccin-gtk = pkgs.catppuccin-gtk.override {
              accents = [ config.catppuccin.accent ];
              size = "standard";
              tweaks = config.home-manager.users.ashuramaru.catppuccin.gtk.tweaks;
              variant = config.catppuccin.flavor;
            };
          };
        pathsToLink = [ "/share/icons" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };

  sops.secrets.gh_token = { };
  sops.secrets.netrc_creds = { };

  nix.settings.access-tokens = config.sops.secrets.gh_token.path;
  nix.settings.netrc-file = config.sops.secrets.netrc_creds.path;

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";

  system.stateVersion = config.system.nixos.release;
}
