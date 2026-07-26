{ lib, ... }:
let
  binDirs = [
    ".bun"
    ".npm"
    ".local"
    ".cargo"
    ".go"
    "go"
    ".yarn"
    ".deno"
    ".ghcup"
    ".local/share/pnpm"
  ];
  binPaths = map (dir: "$HOME/${dir}/bin") binDirs;
  bashPathStr = lib.strings.concatStringsSep ":" binPaths;
in
{
  hm.shell.binPaths = {
    raw = binPaths;
    bash = "export PATH=\"${bashPathStr}:$PATH\"";
    zsh = "export PATH=\"${bashPathStr}:$PATH\"";
  };
}
