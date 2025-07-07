{ config, pkgs, ... }:

let
  paperlessUrl = "paperless.${config.nas.baseDomain.private}";
  paperlessDataDir = "/nvmeStorage/paperless";
  paperlessMediaDir = "/paperless";
in
{
  services = {
    paperless = {
      enable = true;
      package = (
        # TODO: Remove affter https://github.com/NixOS/nixpkgs/pull/42220 is merged
        pkgs.paperless-ngx.overrideAttrs {
          disabledTests = [
            # FileNotFoundError(2, 'No such file or directory'): /build/tmp...
            "test_script_with_output"
            "test_script_exit_non_zero"
            "testDocumentPageCountMigrated"
            # AssertionError: 10 != 4 (timezone/time issue)
            # Due to getting local time from modification date in test_consumer.py
            "testNormalOperation"
            # Something broken with new Tesseract and inline RTL/LTR overrides?
            "test_rtl_language_detection"
            # django.core.exceptions.FieldDoesNotExist: Document has no field named 'transaction_id'
            "test_convert"
            # Favicon tests fail due to static file handling in the test environment
            "test_favicon_view"
            "test_favicon_view_missing_file"
          ];
        }
      );
      dataDir = paperlessDataDir;
      mediaDir = paperlessMediaDir;
      port = 28981;
      settings = {
        PAPERLESS_URL = "https://${paperlessUrl}";
        PAPERLESS_OCR_LANGUAGE = "eng+deu+rus";
        PAPERLESS_TIME_ZONE = "Europe/Berlin";
      };
    };

    nginx.virtualHosts = {
      ${paperlessUrl} = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 1000M;
          '';
        };
      };
    };
  };

  systemd.tmpfiles.settings = {
    "10-paperlessData" = {
      "${paperlessDataDir}" = {
        d = {
          user = config.services.paperless.user;
          group = config.services.paperless.user;
          mode = "0750";
        };
      };
    };
    "10-paperlessMedia" = {
      "${paperlessMediaDir}" = {
        d = {
          user = config.services.paperless.user;
          group = config.services.paperless.user;
          mode = "0750";
        };
      };
    };
  };
}
