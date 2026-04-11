{
  dungeon.selfhost.nixos =
    { config, pkgs, ... }:

    let
      ollamaUrl = "ollama.${config.nas.baseDomain.private}";
      openWebuiUrl = "chat.${config.nas.baseDomain.private}";
      openWebuiPort = 11435;
    in
    {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        host = "127.0.0.1";
        port = 11434;
        rocmOverrideGfx = "11.0.0";
        loadModels = [
          "qwen3:32b"
          "qwen3.5:35b"
          "qwen2.5-coder:32b"
          "glm-4.7-flash"
        ];
        environmentVariables = {
          OLLAMA_ORIGINS = "*";
          OLLAMA_MAX_LOADED_MODELS = "1";
        };
      };

      virtualisation.oci-containers.containers.open-webui = {
        image = "ghcr.io/open-webui/open-webui:dev";
        ports = [ "127.0.0.1:${toString openWebuiPort}:8080" ];
        volumes = [ "/var/lib/private/open-webui/data:/app/backend/data" ];
        environment = {
          OLLAMA_BASE_URL = "https://${ollamaUrl}";
          WEB_LOADER_ENGINE = "playwright";
        };
      };

      services.nginx.virtualHosts = {
        "${ollamaUrl}" = {
          forceSSL = true;
          useACMEHost = "${config.nas.baseDomain.private}";
          locations."/" = {
            proxyPass = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
            proxyWebsockets = true;

            recommendedProxySettings = false;
            extraConfig = ''
              include ${config.services.nginx.defaultMimeTypes};
              proxy_set_header   Host               ${config.services.ollama.host}:${builtins.toString config.services.ollama.port};
              proxy_set_header   X-Forwarded-Host   $http_host;
              proxy_set_header   X-Forwarded-For    $remote_addr;
              client_max_body_size 9000M;
            '';
          };
        };
        "${openWebuiUrl}" = {
          forceSSL = true;
          useACMEHost = "${config.nas.baseDomain.private}";
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString openWebuiPort}";
            proxyWebsockets = true;
          };
        };
      };
    };
}
