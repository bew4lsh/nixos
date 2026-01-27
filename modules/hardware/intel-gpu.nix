# Intel integrated graphics (Iris Plus, UHD, etc.)
{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      # Intel media driver (newer, for Broadwell+)
      intel-media-driver  # iHD driver
      # Legacy driver (for older Intel)
      # intel-vaapi-driver  # i965 driver

      # Vulkan
      vulkan-loader

      # Video acceleration
      libvdpau-va-gl
    ];
  };

  # Environment variables for Intel
  environment.variables = {
    # Use iHD driver for VA-API (modern Intel)
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Verification tools
  environment.systemPackages = with pkgs; [
    libva-utils      # vainfo
    vulkan-tools     # vulkaninfo
    intel-gpu-tools  # intel_gpu_top
  ];
}
