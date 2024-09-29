{ lib, config, ... }:

let
  cfg = config.gaming;
in
{

  options.gaming.enable = lib.mkEnableOption "Enable gaming presets";

  config = lib.mkIf cfg.enable {
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

    home-manager.users.${config.username}.imports = [ ./home ];

  };

}
