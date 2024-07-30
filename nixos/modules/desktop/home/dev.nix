{ pkgs, pkgs-unstable, ... }:

{

  home.packages =
    with pkgs;

    [
      _1password
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
      pkgs-unstable.kubefwd
      kubelogin-oidc
      kubernetes-helm
      lua
      manix # nix documentation search
      mongodb-tools
      mongosh
      nix-du
      nix-init
      nodejs-slim
      nvd
      pciutils
      pkgs-unstable.cargo
      postgresql_16
      pulumi
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
    ];

}
