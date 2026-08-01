{
  lib,
  config,
  ...
}:
{
  _class = "homeManager";
  _file = ./base.nix;
  key = toString ./base.nix;
  options.euvlok.home.nixcord.basePlugins.enable =
    lib.options.mkEnableOption "shared Nixcord plugin set"
    // {
      default = config.euvlok.home.nixcord.enable;
    };

  config = lib.modules.mkIf config.euvlok.home.nixcord.basePlugins.enable {
    programs.nixcord.config.plugins = {
      alwaysExpandRoles.enable = true;
      betterGifPicker.enable = true;
      biggerStreamPreview.enable = true;
      disableCallIdle.enable = true;
      dontRoundMyTimestamps.enable = true;
      fixCodeblockGap.enable = true;
      forceOwnerCrown.enable = true;
      serverInfo.enable = true;
      themeAttributes.enable = true;
      unlockedAvatarZoom.enable = true;
      vencordToolbox.enable = true;
      viewIcons.enable = true;
      messageLogger = {
        enable = true;
        collapseDeleted = true;
        ignoreSelf = true;
        ignoreBots = true;
      };
    };
  };
}
