{
  osConfig,
  config,
  ...
}:

{
  home = {
    stateVersion = "25.05";
    file = {
      youtubeApiKeys = {
        source = config.lib.file.mkOutOfStoreSymlink osConfig.age.secrets.kodiYoutubeApiKeys.path;
        target = ".kodi/userdata/addon_data/plugin.video.youtube/api_keys.json";
      };

    };

  };

}
