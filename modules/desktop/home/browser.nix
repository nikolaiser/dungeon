{
  pkgs,
  inputs,
  system,
  config,
  osConfig ? null,
  ...
}:

{

  stylix.targets.librewolf.profileNames = [ "default" ];

  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;

    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.donottrackheader.enabled" = true;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearSiteData.cache" = false;
      "privacy.clearSiteData.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
      "browser.toolbars.bookmarks.visibility" = "newtab";
    };

    profiles.default = {
      extensions = {
        packages = with inputs.nur.legacyPackages."${system}".repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
        ];
      };

      search = {
        default = "ddg";
        privateDefault = "ddg";

        force = true;
        engines = {

          youtube = {
            urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
            definedAliases = [
              "@youtube"
              "@yt"
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/f/fd/YouTube_full-color_icon_%282024%29.svg";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          github = {
            urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
            definedAliases = [
              "@github"
              "@gh"
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          grep = {
            urls = [ { template = "https://grep.app/search?q={searchTerms}"; } ];
            definedAliases = [
              "@grep"
              "@gr"
            ];
            icon = "https://grep.app/apple-icon.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          nixpkgs = {
            urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
            definedAliases = [
              "@nixpkgs"
              "@np"
            ];
            icon = "https://nixos.org/logo/nixos-logo-only-hires.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          nixos = {
            urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
            definedAliases = [
              "@nixos"
              "@no"
            ];
            icon = "https://nixos.org/logo/nixos-logo-only-hires.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          noogle = {
            urls = [ { template = "https://noogle.dev/q?term=%22{searchTerms}%22"; } ];
            definedAliases = [
              "@noogle"
              "@nog"
            ];
            icon = "https://noogle.dev/favicon.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          homemanager = {
            urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
            definedAliases = [
              "@homemanager"
              "@hm"
            ];
            icon = "https://nixos.org/logo/nixos-logo-only-hires.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          darwin = {
            urls = [ { template = "https://https://options.nix-darwin.uz/?query={searchTerms}"; } ];
            definedAliases = [
              "@darwin"
              "@nd"
            ];
            icon = "https://nixos.org/logo/nixos-logo-only-hires.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          archwiki = {
            urls = [ { template = "https://wiki.archlinux.org/index.php?search={searchTerms}"; } ];
            definedAliases = [
              "@archwiki"
              "@aw"
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/1/13/Arch_Linux_%22Crystal%22_icon.svg";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          googlemaps = {
            urls = [ { template = "https://www.google.com/maps/search/{searchTerms}"; } ];
            definedAliases = [
              "@gmaps"
              "@gm"
            ];
            icon = "https://upload.wikimedia.org/wikipedia/commons/a/aa/Google_Maps_icon_%282020%29.svg";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
          reddit = {
            urls = [ { template = "https://www.reddit.com/search/?q={searchTerms}"; } ];
            definedAliases = [
              "@reddit"
              "@rd"
            ];
            icon = "https://upload.wikimedia.org/wikipedia/en/b/bd/Reddit_Logo_Icon.svg";
            updateInterval = 7 * 24 * 60 * 60 * 1000;
          };
        };
        order = [
          "ddg"
          "youtube"
          "github"
          "grep"
          "nixpkgs"
          "nixos"
          "noogle"
          "homemanager"
          "darwin"
          "archwiki"
          "googlemaps"
          "reddit"
        ];
      };
    };
  };
}
