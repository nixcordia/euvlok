_: {
  _class = "homeManager";
  _file = ./kdeconnect.nix;
  key = toString ./kdeconnect.nix;
  services.kdeconnect = {
    enable = true;
  };
}
