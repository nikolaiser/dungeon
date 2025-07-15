{
  pkgs,
  system,
  inputs,
  config,
  osConfig,
  ...
}:

{
  home = {
    username = osConfig.shared.username;
    homeDirectory = "/home/${osConfig.shared.username}";

    packages = with pkgs; [
      firefox
      ungoogled-chromium
      xdg-utils
      fzf
      jq
      ripgrep
      util-linux
      unzip
      age
      libargon2
      wl-clipboard
      xclip
      inputs.agenix.packages.${system}.default
    ];

    sessionVariables = {
      EDITOR = "hx";
    };
  };

  systemd.user.startServices = "sd-switch";
  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    configHome = "/home/${osConfig.shared.username}/.config";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

}
