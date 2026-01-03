{ pkgs, inputs, ... }:
{

  home = {

    file.".config/rift/config.toml".source = ./config/config.toml;
  };

}
