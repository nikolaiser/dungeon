{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    mos
  ];

  system.defaults = {
    NSGlobalDomain."com.apple.swipescrolldirection" = true;
  };
}
