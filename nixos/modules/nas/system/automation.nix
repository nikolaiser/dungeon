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

    home-assistant = {
      enable = true;
      config = null;
      configDir = "/nvmeStorage/homeassistant";
      extraPackages =
        python3Packages: with python3Packages; [
          pyatv
          paho-mqtt
        ];

    };

    nginx.virtualHosts = {
      "homeassistant.${config.nas.baseDomain.private}" = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8123";
          proxyWebsockets = true;
        };
      };
    };

  };

}
