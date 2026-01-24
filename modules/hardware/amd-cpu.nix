{ config, pkgs, ... }:

{
  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = true;

  # AMD P-State driver (enabled via kernel params in boot.nix)
  # This provides better power/performance scaling for Zen 4/5

  # Thermal management
  services.thermald.enable = false;  # Intel only

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";  # Gaming system, always performance
  };

  # For laptops, you might want:
  # services.power-profiles-daemon.enable = true;
  # Or for more control:
  # services.tlp.enable = true;
}
