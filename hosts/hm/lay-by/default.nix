_: {
  _class = "homeManager";
  _file = ./default.nix;
  key = toString ./default.nix;
  imports = [
    ./git.nix
    ./hyprland
    ./stylix.nix
    ./alacritty.nix
    ./kdeconnect.nix
    ./nixcord.nix
    ./systemd-slice.nix
    ./rofi.nix
    ./ssh.nix
  ];
}
