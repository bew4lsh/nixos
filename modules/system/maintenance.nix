{ config, pkgs, ... }:

{
  # Firmware updates via fwupd
  services.fwupd.enable = true;

  # Automatic SSD TRIM (weekly)
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # zram - compressed swap in RAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;  # Use up to 50% of RAM for compressed swap
  };

  # Useful commands:
  # fwupdmgr refresh        - Refresh firmware metadata
  # fwupdmgr get-updates    - Check for updates
  # fwupdmgr update         - Install updates
  # zramctl                 - View zram status
  # systemctl status fstrim.timer - Check TRIM timer
}
