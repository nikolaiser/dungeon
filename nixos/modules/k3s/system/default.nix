{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.k3s;
  allFlags = nodeIp: [
    #"--flannel-backend=none"
    #"--disable-kube-proxy"
    "--disable=traefik"
    "--disable=servicelb"
    "--disable=local-storage"
    #"--disable-network-policy"
    #"--egress-selector-mode=disabled"
    "--write-kubeconfig-mode 644"
    "--tls-san 10.10.0.50"
    "--tls-san 10.10.0.51"
    "--tls-san 10.10.0.52"
    "--tls-san 10.10.0.53"
    "--cluster-cidr 10.40.0.0/16"
    "--service-cidr 10.45.0.0/16"
    "--cluster-dns 10.45.0.10"
    "--snapshotter=native"
    "--node-label bgp=enabled"
    "--node-ip ${nodeIp} --node-external-ip ${nodeIp}"
  ];

in
{

  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = cfg.init;
    extraFlags = allFlags cfg.ip;
    serverAddr = if cfg.init then "" else "https://10.10.0.51:6443";
  };

  services.rpcbind.enable = true;

  systemd.services.k3s.after = [
    "network-online.service"
    "firewall.service"
    "etc-rancher.mount"
    "var-lib-kubelet.mount"
    "var-lib-rancher-k3s.mount"
    "var-log.mount"
  ];
  systemd.services.k3s.serviceConfig.KillMode = lib.mkForce "control-group";
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2000-05.edu.example.iscsi:${config.networking.hostName}";
  };

  systemd.network.config = {
    networkConfig = {
      ManageForeignRoutes = false;
      ManageForeignRoutingPolicyRules = false;
    };
  };

  # cilium writes its own config to /etc/cni/net.d, so we need to make sure it's writable/empty/whatever
  environment.etc."cni/net.d".enable = false;

  networking.firewall.enable = lib.mkForce false;

}
