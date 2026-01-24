{ config, pkgs, ... }:

{
  # Bootloader - systemd-boot for UEFI
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      editor = false;  # Security: prevent kernel cmdline editing
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # Use latest kernel for best AMD RDNA 4 support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters
  boot.kernelParams = [
    # AMD specific
    "amd_pstate=active"     # AMD P-State driver for Zen 4/5
    "iommu=pt"              # IOMMU passthrough mode

    # Performance
    "mitigations=off"       # Disable CPU mitigations for performance (gaming)
                            # Remove if you prefer security over performance

    # Quiet boot (optional, remove for debugging)
    "quiet"
    "splash"
    "loglevel=3"
  ];

  # Enable SysRq for emergency debugging
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  # Plymouth for boot splash (optional, matches Rosé Pine)
  # boot.plymouth = {
  #   enable = true;
  #   theme = "breeze";
  # };
}
