{
  programs.alacritty.enable = true;

  programs.alacritty.settings = {

    font = {
      size = 12;
    };

    env = {
      TERM = "xterm-256color";
    };
  };

  programs.foot = {
    enable = true;
    server.enable = true;
  };
}
