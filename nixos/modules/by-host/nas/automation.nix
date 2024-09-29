{ config, ... }:

{
  services = {
    mosquitto = {
      enable = true;
      listeners = [
        {
          users.ha = {
            acl = [ "readwrite #" ];
            passwordFile = config.age.secrets."mosquitto-ha-password".path;
          };
        }
      ];
    };

    zigbee2mqtt = {
      enable = true;
      settings = {
        homeassistant = true;
        permit_join = true;
        serial = {
          port = "/dev/serial/by-id/usb-Silicon_Labs_Sonoff_Zigbee_3.0_USB_Dongle_Plus_0001-if00-port0";
        };
        mqtt = {
          server = "mqtt://localhost:1883";
          user = "ha";
          password = "!${config.age.secrets."mosquitto-ha-password.yaml".path} password";
        };
        frontend.port = 8072;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    1883
    8072
  ];
}
