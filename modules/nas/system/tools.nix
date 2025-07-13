{ config, ... }:

let
  itToolsUrl = "it-tools.${config.nas.baseDomain.private}";
  swaggerEditorUrl = "swagger-editor.${config.nas.baseDomain.private}";
  stirlingpdfUrl = "pdf.${config.nas.baseDomain.private}";
in
{
  virtualisation.oci-containers.containers = {
    it-tools = {
      image = "corentinth/it-tools:latest";
      autoStart = true;
      ports = [ "9191:80" ];
    };
    swagger-editor = {
      image = "swaggerapi/swagger-editor:latest";
      autoStart = true;
      ports = [ "9192:8080" ];
    };
    stirling-pdf = {
      image = "docker.stirlingpdf.com/stirlingtools/stirling-pdf:latest";
      autoStart = true;
      ports = [ "9193:8080" ];
      environment = {
        LANGS = "en_US";
        DISABLE_PIXEL = "True";
      };
    };
  };

  services.nginx.virtualHosts = {
    ${itToolsUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:9191";
        proxyWebsockets = true;
      };
    };
    ${swaggerEditorUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:9192";
        proxyWebsockets = true;
      };
    };
    ${stirlingpdfUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://localhost:9193";
        proxyWebsockets = true;
      };
    };
  };

}
