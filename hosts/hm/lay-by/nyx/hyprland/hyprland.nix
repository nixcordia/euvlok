{ lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,1366x768@60,0x0,1"
      ",preferred,auto,1"
    ];

    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
      "HYPRCURSOR_THEME,Breeze-Dark"
    ];

    exec-once = [
      "waybar"
      "hyprctl setcursor Breeze-Dark 24"
      "wlsunset -S 7:00 -s 21:00"
      "systemctl --user start hyprpolkitagent"
      "keepassxc --minimized"
    ];

    general = {
      gaps_in = 1;
      gaps_out = 2;
      border_size = 1;
      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    decoration = {
      rounding = 5;
      active_opacity = 0.9;
      inactive_opacity = 0.9;
      blur = {
        enabled = true;
        size = 4;
        passes = 1;
        ignore_opacity = true;
        new_optimizations = true;
      };
    };

    animations = {
      enabled = true;
      bezier = "nyxEase, 0.05, 0.9, 0.05, 1.05";
      animation = [
        "windows, 1, 2, nyxEase"
        "windowsOut, 1, 2, default, popin 80%"
        "border, 1, 2, default"
        "fade, 1, 2, default"
        "workspaces, 1, 2, default"
      ];
    };

    "$mainMod" = "SUPER";
    "$terminal" = "alacritty";
    "$fileManager" = "thunar";

    bind = [
      "$mainMod, Space, exec, rofi -show drun"
      "CTRL ALT, T, exec, $terminal"
      "ALT, 1, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, S, togglefloating,"
      "$mainMod, P, pseudo,"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "CTRL ALT, L, exec, hyprlock"
      ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
      "CTRL, Print, exec, wl-paste | swappy -f -"
      "$mainMod, F, fullscreen"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    windowrule = lib.modules.mkForce [
      {
        name = "nyx-suppress-maximize";
        "match:class" = ".*";
        suppress_event = "maximize";
      }
    ];

    layerrule = [
      {
        name = "nyx-waybar-blur";
        "match:namespace" = "waybar";
        blur = true;
      }
    ];

    input = {
      follow_mouse = 2;
      touchpad = {
        natural_scroll = false;
        tap-to-click = true;
      };
    };
  };
}
