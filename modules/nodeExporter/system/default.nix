_:

{
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      openFirewall = true;
    };
  };
}
