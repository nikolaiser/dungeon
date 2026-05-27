{ inputs, ... }:
{
  flake-file.inputs.grabli = {
    url = "git+ssh://forgejo@10.10.163.211:2222/nikolaiser/grabli.git";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  dungeon.selfhost.nixos =
    {
      config,
      pkgs,
      ...
    }:

    let
      grabliUrl = "grabli.${config.nas.baseDomain.private}";
      grabliLibraryDir = "/var/lib/navidrome/music/grabli";
    in
    {
      imports = [ inputs.grabli.nixosModules.default ];

      services.grabli = {
        enable = true;
        package = inputs.grabli.packages.${pkgs.system}.grabli;

        user = "grabli";
        group = "media";

        libraryRoot = grabliLibraryDir;
        bindAddr = "127.0.0.1:8088";
        downloadConcurrency = 2;

        database.createLocally = true;

        navidrome = {
          url = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
          user = "grabli";
          passwordFile = config.age.secrets."grabli-navidrome-pass".path;
        };

        ntfy = {
          topic = "https://ntfy.${config.nas.baseDomain.public}/grabli";
          tokenFile = config.age.secrets."grabli-ntfy-token".path;
        };

        musicbrainz.userAgent = "grabli/0.1 (mail@nikolaiser.com)";

        secretsKeyFile = config.age.secrets."grabli-secrets-key".path;
      };

      services.nginx.virtualHosts.${grabliUrl} = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8088";
          proxyWebsockets = true;
        };
      };
    };
}
