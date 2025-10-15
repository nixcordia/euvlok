{
  inputs,
  pkgsUnstable,
  eulib,
  ...
}:
{
  imports = [ inputs.home-manager-sm-idk.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgsUnstable eulib; };
  };

  home-manager.users.bruno =
    { pkgs, osConfig, ... }:
    {
      imports = [
        ./packages.nix
        {
          home.stateVersion = "25.05";
          programs.zed-editor.package = pkgs.zed-editor_git;

        }
      ]
      ++ [
        inputs.self.homeModules.default
        inputs.self.homeConfigurations.sm-idk
        ../../../../modules/hm/wm/niri
        {
          hm = {
            git.enable = true;
            chromium.enable = true;
            zed-editor.enable = true;
            ghostty.enable = true;
            bash.enable = true;
            nixcord.enable = true;
            niri.enable = true;
            firefox.zen-browser.enable = true;
          };
        }
      ]
      ++ [
        inputs.catppuccin-trivial.homeModules.catppuccin
        { catppuccin = { inherit (osConfig.catppuccin) enable accent flavor; }; }
      ];
    };
}
