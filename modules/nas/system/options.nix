{ lib, ... }:
{
  baseDomain = {

    public = lib.mkOption {
      description = "Base domain for services that are open to the internet";
      type = lib.types.str;
      default = "";
    };

    private = lib.mkOption {
      description = "Base domain for services that are open to the LAN only";
      type = lib.types.str;
      default = "";
    };

  };

}
