{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.gpu;

  amdConfig = {

    boot.initrd.kernelModules = [ "amdgpu" ];

    services.xserver = {
      videoDrivers = [ "modesetting" ];
    };

    hardware = {
      amdgpu = {
        opencl.enable = true;
        amdvlk = {
          enable = true;
          support32Bit.enable = true;
        };
      };
      graphics = {
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
  };

  intelIrisConfig = {
    boot.kernelParams = [ "i915.force_probe=46a6" ];
  };
in
{

  options.gpu = {
    enable = lib.mkEnableOption "Enable gpu support";
    model = lib.mkOption {
      description = "Either intel-iris or amd";
      type = lib.types.str;
      default = "";
    };

  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (cfg.model == "amd") amdConfig)
      (lib.mkIf (cfg.model == "intel-iris") intelIrisConfig)
    ]
  );

}
