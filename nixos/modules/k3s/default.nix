{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.k3s;
  allFlags = nodeIp: [
    "--flannel-backend=none"
    "--disable-kube-proxy"
    "--disable=traefik"
    "--disable=servicelb"
    "--disable=local-storage"
    "--disable-network-policy"
    "--egress-selector-mode=disabled"
    "--write-kubeconfig-mode 644"
    "--tls-san 10.10.0.50"
    "--tls-san 10.10.0.51"
    "--tls-san 10.10.0.52"
    "--tls-san 10.10.0.53"
    "--cluster-cidr 10.40.0.0/16"
    "--service-cidr 10.45.0.0/16"
    "--cluster-dns 10.45.0.10"
    "--snapshotter=native"
    "--node-ip ${nodeIp} --node-external-ip ${nodeIp}"
  ];

in
{

  options.k3s = {
    enable = lib.mkEnableOption "Enable kodi support";
    init = lib.mkEnableOption "Init server";
    ip = lib.mkOption {
      description = "Node IP";
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
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

    networking.firewall = {
      allowedTCPPorts = [
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
        2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
        10250
        197 # BGP
        3784 # BFD
      ];
      allowedUDPPorts = [
        51820
        51821
        8472
        3784 # BFD
      ];

      #extraCommands = ''
      #  iptables -A INPUT -i cni+ -j ACCEPT
      #'';
      trustedInterfaces = [ "cni+" ];
    };

  };

}