_: {
  _class = "homeManager";
  _file = ./systemd-slice.nix;
  key = toString ./systemd-slice.nix;
  systemd.user.slices."no-swap" = {
    Unit = {
      Description = "Disable swap for slice";
    };
    Slice = {
      MemorySwapMax = "0";
      OOMScoreAdjust = "1000";
    };
  };
}
