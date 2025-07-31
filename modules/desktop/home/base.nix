{
  pkgs,
  system,
  inputs,
  config,
  osConfig ? null,
  ...
}:

{
  home = {

    packages = with pkgs; [
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
      # inputs.agenix.packages.${system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  }
  // (
    if builtins.isNull osConfig then
      { }
    else
      {
        username = osConfig.shared.username;
        homeDirectory = "/home/${osConfig.shared.username}";
      }
  );

  programs = {
    gpg.scdaemonSettings = {
      reader-port = "Yubico Yubi";
      disable-ccid = true;
    };
  };

  systemd.user.startServices = "sd-switch";
  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
  }
  // (
    if builtins.isNull osConfig then
      { }
    else
      {
        configHome = "/home/${osConfig.shared.username}/.config";
      }
  );

  nixpkgs.config = {
    allowUnfree = true;
  };

}
