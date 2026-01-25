{ config, pkgs, ... }:

{
  # AMD GPU - AMDGPU driver with RDNA 4 support
  # The 9070 XT (RDNA 4) requires latest kernel and Mesa

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For Steam/Wine

    extraPackages = with pkgs; [
      # Vulkan
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools

      # VA-API for hardware video acceleration
      libvdpau-va-gl
      libva-vdpau-driver

      # AMD specific
      rocmPackages.clr.icd  # OpenCL
    ];
  };

  # Environment variables for AMD
  environment.variables = {
    # Use RADV (Mesa) Vulkan driver by default - better for gaming
    AMD_VULKAN_ICD = "RADV";

    # VA-API driver
    LIBVA_DRIVER_NAME = "radeonsi";

    # VDPAU driver
    VDPAU_DRIVER = "radeonsi";
  };

  # Video acceleration verification tools
  environment.systemPackages = with pkgs; [
    libva-utils      # vainfo
    vdpauinfo
    vulkan-tools     # vulkaninfo
    mesa-demos       # glxinfo
    clinfo
    radeontop        # GPU monitoring
  ];

  # Additional kernel modules for AMDGPU
  boot.initrd.kernelModules = [ "amdgpu" ];

  # AMD GPU specific kernel parameters (added in boot.nix)
  # Some optional tweaks:
  boot.kernelParams = [
    # Enable GPU reset on hang (useful for debugging)
    # "amdgpu.gpu_recovery=1"

    # Force enable HDMI audio
    # "amdgpu.audio=1"
  ];
}
