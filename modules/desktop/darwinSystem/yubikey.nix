{
  pkgs,
  inputs,
  system,
  ...
}:

{

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

}
