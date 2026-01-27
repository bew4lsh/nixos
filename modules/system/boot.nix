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

  # Use latest kernel (good hardware support)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Common kernel parameters
  boot.kernelParams = [
    # Quiet boot (remove for debugging)
    "quiet"
    "splash"
    "loglevel=3"
  ];

  # Enable SysRq for emergency debugging
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
