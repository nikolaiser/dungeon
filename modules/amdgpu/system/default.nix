{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver = {
    videoDrivers = [ "modesetting" ];
  };

  hardware = {
    amdgpu = {
      opencl.enable = true;
    };
    graphics = {
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
}
