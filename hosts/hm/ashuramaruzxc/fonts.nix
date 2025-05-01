{ pkgs, ... }:
{
  fonts.packages = builtins.attrValues {
    inherit (pkgs)
      anonymousPro
      cascadia-code
      font-awesome
      ipafont
      liberation_ttf
      migmix
      monocraft
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      powerline-symbols
      recursive
      roboto
      roboto-mono
      source-code-pro
      source-han-sans
      terminus_font
      ubuntu_font_family
      wqy_zenhei
      ;
    mplus = pkgs.mplus-outline-fonts.githubRelease;
    inherit (pkgs.nerd-fonts)
      agave
      fira-code
      hack
      inconsolata
      inconsolata-lgc
      iosevka
      iosevka-term
      jetbrains-mono
      meslo-lg
      monaspace
      noto
      recursive-mono
      ubuntu
      ubuntu-mono
      ubuntu-sans
      zed-mono
      ;
  };
}
# // lib.optionalAttrs config.nixpkgs.hostPlatform.isLinux { fonts.fontDir.enable = true; }
