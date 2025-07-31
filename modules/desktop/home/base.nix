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

    username = osConfig.shared.username;
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
    if system == "aarch64-darwin" then
      {
        homeDirectory = "/Users/${osConfig.shared.username}";

      }
    else
      {
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
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

}
