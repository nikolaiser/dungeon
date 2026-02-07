{
  dungeon.docker =
    {
      user,
      host,
      ...
    }:
    {
      nixos = {
        virtualisation.docker.enable = true;
        users.users.${user.userName}.extraGroups = [ "docker" ];
      };
    };
}
