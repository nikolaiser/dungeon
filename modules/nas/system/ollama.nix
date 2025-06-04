{ config, ... }:

let
  ollamaUrl = "ollama.${config.nas.baseDomain.private}";
  ollamaUiUrl = "ollama-ui.${config.nas.baseDomain.private}";
in

{

  systemd.tmpfiles.settings."10-ollama-models"."${config.services.ollama.models}".d = {
    user = "nobody";
    group = "nogroup";
    mode = "0777";
  };

  services = {
    ollama = {
      enable = true;
      models = "/nvmeStorage/ollamaModels";
      loadModels = [ "deepseek-r1:32b" ];
      environmentVariables.OLLAMA_ORIGINS = "https://${ollamaUiUrl}";
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      port = 30000;
      hostname = "127.0.0.1";
      ollamaUrl = "https://${ollamaUrl}";
    };

    nginx.virtualHosts = {
      "${ollamaUiUrl}" = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString config.services.nextjs-ollama-llm-ui.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 9000M;
          '';
        };

      };
      "${ollamaUrl}" = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString config.services.ollama.port}";
          proxyWebsockets = true;
          recommendedProxySettings = false;
          extraConfig = ''
            include ${config.services.nginx.defaultMimeTypes};
            proxy_set_header   Host               127.0.0.1:${builtins.toString config.services.ollama.port};
            proxy_set_header   X-Forwarded-Host   $http_host;
            proxy_set_header   X-Forwarded-For    $remote_addr;
            client_max_body_size 9000M;
          '';
        };

      };
    };

  };
}
