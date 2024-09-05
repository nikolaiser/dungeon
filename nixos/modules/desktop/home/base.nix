{
  pkgs,
  system,
  inputs,
  config,
  osConfig,
  ...
}:

let

  themeFile = config.lib.stylix.colors { templateRepo = config.lib.stylix.templates.base16-vim; };

in

{
  home = {
    username = osConfig.username;
    homeDirectory = "/home/${osConfig.username}";

    packages = with pkgs; [
      firefox
      brave
      xdg-utils
      bat # cat alternative
      bottom # alternative to htop
      eza # better ls
      fd # better find
      fzf
      jq
      micro # nano alternative
      procs # ps replacement
      ripgrep
      dig
      util-linux
      neofetch
      unzip
      gron # make json greppable
      #delta # syntax highlighting for git, diff and grep
      age
      libargon2
      wireguard-tools
      (nerdfonts.override {
        fonts = [
          "Iosevka"
          "JetBrainsMono"
        ];
      })
      yubikey-manager-qt
      yubioath-flutter
      wl-clipboard
      inputs.agenix.packages.${system}.default
      ladybird
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  systemd.user.startServices = "sd-switch";
  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    configHome = "/home/${osConfig.username}/.config";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

}
