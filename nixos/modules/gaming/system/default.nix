{ pkgs, ... }:
{
  services.flatpak = {
    enable = true;
    update.onActivation = true;
    uninstallUnmanaged = true;

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
        appId = "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08";
        origin = "flathub";
      }
      {
        appId = "com.valvesoftware.Steam.CompatibilityTool.Proton-GE";
        origin = "flathub";
      }
      {
        appId = "net.lutris.Lutris";
        origin = "flathub";
      }
      {
        appId = "com.usebottles.bottles";
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

  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ];

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        jdk17
      ];
    })
    wineWowPackages.waylandFull
    winetricks
    # (lutris.override {
    #   extraLibraries = pkgs: [
    #     # List library dependencies here
    #   ];
    #
    #   extraPkgs = pkgs: [
    #     # List package dependencies here
    #     pkgs.wineWowPackages.waylandFull
    #     pkgs.winetricks
    #     pkgs.libnghttp2
    #
    #   ];
    # })
  ];

  programs.gamemode.enable = true;
}
