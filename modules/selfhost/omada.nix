{
  inputs,
  den,
  dungeon,
  ...
}:
{

  # dungeon = {
  #   selfhost.nixos =
  #     {
  #       inputs',
  #       config,
  #       pkgs,
  #       ...
  #     }:
  #
  #     let
  #       omadaUrl = "omada.${config.nas.baseDomain.private}";
  #     in
  #     {
  #
  #       imports = [
  #         "${inputs.nixpkgs-omada}/nixos/modules/services/networking/omada.nix"
  #       ];
  #
  #       services.omada = {
  #         enable = true;
  #         package = pkgs.omada-software-controller;
  #         openFirewall = true;
  #       };
  #
  #       services.nginx.virtualHosts = {
  #         ${omadaUrl} = {
  #           forceSSL = true;
  #           useACMEHost = "${config.nas.baseDomain.private}";
  #           locations."/" = {
  #             proxyPass = "https://127.0.0.1:8043";
  #           };
  #         };
  #       };
  #     };
  #
  # };
}
