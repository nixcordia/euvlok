_: {
  _class = "nixos";
  _file = ./ollama.nix;
  key = toString ./ollama.nix;
  services.ollama = {
    enable = true;
  };
}
