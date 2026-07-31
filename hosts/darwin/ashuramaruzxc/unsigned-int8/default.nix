inputs:
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = { inherit inputs; };
  modules = [
    inputs.self.darwinModules.default
    inputs.self.darwinModules.zsh
    ./brew.nix
    ./configuration.nix
    ./home.nix
    ./system.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = "ashuramaru";
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core-source;
          "homebrew/homebrew-cask" = inputs.homebrew-cask-source;
          "cfergeau/homebrew-crc" = inputs.homebrew-crc-source;
        };
        autoMigrate = true;
      };
    }
  ];
}
