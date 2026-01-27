# Intel CPU configuration
{ config, pkgs, ... }:

{
  # Intel CPU microcode updates
  hardware.cpu.intel.updateMicrocode = true;

  # Thermal management (Intel-specific)
  services.thermald.enable = true;

  # Power management for laptops
  powerManagement.enable = true;

  # TLP for advanced laptop power management
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy/performance preference
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Turbo boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # USB autosuspend
      USB_AUTOSUSPEND = 1;

      # WiFi power save
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # Disable power-profiles-daemon (conflicts with TLP)
  services.power-profiles-daemon.enable = false;
}
