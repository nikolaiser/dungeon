_: {

  systemd.tmpfiles.settings = {

    "10-nfs-k3s" = {
      "/nvmeStorage/nfs/k3s" = {
        d = {
          user = "nobody";
          group = "nogroup";
          mode = "0777";
        };
      };

    };
    "10-hdd-k3s" = {
      "/hddStorage/nfs/k3s" = {
        d = {
          user = "nobody";
          group = "nogroup";
          mode = "0777";
        };
      };

    };
    "10-nfs-crashes" = {
      "/nvmeStorage/nfs/crashes" = {
        d = {
          user = "nobody";
          group = "nogroup";
          mode = "0777";
        };
      };

    };

  };

  services.nfs.server.enable = true;

  services.nfs.server.exports = ''
    /nvmeStorage/nfs/k3s 10.10.0.0/16(rw,nohide,insecure,no_subtree_check,no_root_squash,async)
    /hddStorage/nfs/k3s 10.10.0.0/16(rw,nohide,insecure,no_subtree_check,no_root_squash,async)
    /nvmeStorage/nfs/crashes 10.10.0.0/16(rw,nohide,insecure,no_subtree_check,no_root_squash,async)
  '';

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
