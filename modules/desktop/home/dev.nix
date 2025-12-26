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
      #(sbt.override { jre = pkgs.temurin-bin-21; })
      (sbt.override { jre = pkgs.temurin-bin-11; })
      scala_3
      scala-cli
      sops
      terraform
      usbutils
      visualvm
      rclone
      just
      visualvm
      nix-output-monitor
      xplr
      lf
      databricks-cli
      databricks-sql-cli
      claude-code
      gradle
      (pnpm_9.override { withNode = false; })
      nodejs_20
      (inputs.brichka.packages."${system}".brichka)
      visidata
    ];

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-11;
  };

}
