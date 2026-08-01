_: {
  _class = "homeManager";
  _file = ./workstation.nix;
  key = toString ./workstation.nix;

  euvlok.home = {
    fastfetch.enable = true;
    firefox = {
      zen-browser.enable = true;
      defaultSearchEngine = "kagi";
    };
    ghostty.enable = true;
    helix.enable = true;
    mpv.enable = true;
    nh.enable = true;
    zed-editor.enable = true;
    zsh.enable = true;
    languages = {
      cpp.enable = true;
      csharp = {
        enable = true;
        version = "10";
      };
      go.enable = true;
      haskell.enable = true;
      java = {
        enable = true;
        version = "25";
      };
      javascript.enable = true;
      kotlin.enable = true;
      lisp.enable = true;
      lua.enable = true;
      python.enable = true;
      ruby.enable = true;
      rust.enable = true;
      scala.enable = true;
    };
  };
}
