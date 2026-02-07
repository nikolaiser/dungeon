{ inputs, dungeon, ... }:

{

  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak";

  dungeon.flatpak = {

    nixos = {

      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      services.flatpak = {
        enable = true;
        update.onActivation = true;
        uninstallUnmanaged = true;
      };
    };
    homeManager = {
      stylix.targets.gtk.flatpakSupport.enable = false;

      home.file.".profile".text = # bash
        ''
          export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
        '';
    };
  };
}
