{
  dungeon.gaming._.steam.nixos =
    { pkgs, ... }:
    {
      programs = {
        steam = {
          enable = true;
          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = "1";
            };
          };
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
        gamemode.enable = true;
      };
    };
}
