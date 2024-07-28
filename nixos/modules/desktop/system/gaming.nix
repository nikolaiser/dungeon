{

  services.flatpak = {
    enable = true;

    packages = [
      {
        appId = "com.valvesoftware.Steam";
        origin = "flathub";
      }
      {
        appId = "com.heroicgameslauncher.hgl";
        origin = "flathub";
      }
      {
        appId = "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08";
        origin = "flathub";
      }
    ];

    overrides = {
      "com.heroicgameslauncher.hgl".Context = {
        filesystems = [
          "/nix:ro" # Expose NixOS managed software
          "/run/current-system/sw/bin:ro" # Expose NixOS managed software
        ];
      };
    };

  };

  programs.gamemode.enable = true;


}
