{ config, pkgs, ... }:

{
  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = true;

  # AMD-specific kernel parameters
  boot.kernelParams = [
    "amd_pstate=active"     # AMD P-State driver for Zen 4/5
    "iommu=pt"              # IOMMU passthrough mode

    # Performance (gaming desktop)
    "mitigations=off"       # Disable CPU mitigations for performance
                            # Remove if you prefer security over performance
  ];

  # Thermal management
  services.thermald.enable = false;  # Intel only

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";  # Gaming system, always performance
  };
}
