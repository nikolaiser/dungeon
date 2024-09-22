{ lib, ... }:
let
  disklessDir = host: directory: {
    name = "10-nfs-${host}${lib.replaceStrings [ "/" ] [ "-" ] directory}";
    value = {
      "/nvmeStorage/nfs/${host}${directory}" = {
        d = {
          user = "nobody";
          group = "nogroup";
          mode = "0777";
        };
      };

    };
  };

  nfsExport =
    host: directory:
    "/nvmeStorage/nfs/${host}${directory} 10.10.0.48/29(rw,nohide,insecure,no_subtree_check)\n";

  k3sNodes = [
    "sina"
    "maria"
    "rose"
  ];
  k3sDirs = [
    "/var/lib/rancher/k3s"
    "/var/lib/kubelet"
    "/etc/rancher"
  ];

  generateTmpfilesSettings =
    hosts: dirs: lib.concatMap (host: map (dir: disklessDir host dir) dirs) hosts;

  generateNfsExports =
    hosts: dirs: lib.concatMapStrings (host: lib.concatMapStrings (dir: nfsExport host dir) dirs) hosts;

  #flatten = list: lib.concat (map (x: builtins.attrValues x) list);

in
{
  systemd.tmpfiles.settings = builtins.listToAttrs (generateTmpfilesSettings k3sNodes k3sDirs);

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nvmeStorage/nfs         10.10.0.48/29(rw,fsid=0,no_subtree_check)
    ${generateNfsExports k3sNodes k3sDirs}
  '';

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
