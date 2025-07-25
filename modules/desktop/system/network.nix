{ pkgs, config, ... }:

{

  networking = {
    hosts = {
      "127.0.0.2" = pkgs.lib.mkForce [ ];
    };
    extraHosts = ''
      127.0.0.1 ${config.networking.hostName}
    '';
  };

  environment.etc.hosts.mode = "0644"; # make it writable for kubefwd

}
