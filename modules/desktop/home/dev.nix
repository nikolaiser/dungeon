{
  pkgs,
  inputs,
  system,
  ...
}:

{

  home.packages =
    with pkgs;

    [
      _1password-cli
      dyff
      gh
      kconf
      kubectl
      kubectx
      kubefwd
      kubelogin-oidc
      (pkgs.wrapHelm pkgs.kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [ helm-secrets ];
      })
      lua
      mongosh
      pciutils
      cargo
      postgresql_16
      (sbt.override { jre = pkgs.temurin-bin-21; })
      scala_3
      scala-cli
      sops
      terraform
      usbutils
      visualvm
      rclone
      just
      inputs.kent.packages.${system}.default
      visualvm
      nix-output-monitor
    ];

}
