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
      arduino
      argocd
      cilium-cli
      colordiff
      dyff
      gh
      hubble
      jetbrains.idea-community
      kconf
      kubectl
      kubectx
      kubeswitch
      kubefwd
      kubelogin-oidc
      (pkgs.wrapHelm pkgs.kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [ helm-secrets ];
      })
      lua
      manix # nix documentation search
      mongodb-tools
      mongosh
      nix-du
      #nix-init
      nodejs-slim
      nvd
      pciutils
      cargo
      postgresql_16
      #pulumi-bin
      robo3t
      rustfmt
      (sbt.override { jre = pkgs.temurin-bin-21; })
      scala_3
      scala-cli
      screen
      sops
      terraform
      usbutils
      visualvm
      rclone
      just
      nixos-generators
      nixos-anywhere
      inputs.kent.packages.${system}.default
      nix-output-monitor
      zig
      visualvm
      # gradle
      # (pkgs.writeShellScriptBin "h2Shell" ''
      #   ${pkgs.temurin-bin-21}/bin/java -cp "${pkgs.h2}/share/java/h2-2.3.232.jar:$H2DRIVERS:$CLASSPATH" org.h2.tools.Shell "$@"
      # '')
    ];

}
