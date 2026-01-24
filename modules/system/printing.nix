{ config, pkgs, ... }:

{
  # CUPS printing system
  services.printing = {
    enable = true;

    # Additional drivers
    drivers = with pkgs; [
      gutenprint        # Many printers
      gutenprintBin
      hplip             # HP printers
      # brlaser         # Brother laser printers
      # samsung-unified-linux-driver  # Samsung printers
      # epson-escpr     # Epson printers
    ];

    # Web interface
    browsing = true;
    defaultShared = false;
  };

  # Avahi for network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;

    publish = {
      enable = true;
      userServices = true;
    };
  };

  # Scanner support
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      sane-airscan  # Driverless scanning
      # hplipWithPlugin  # HP scanners
    ];
  };

  # Add user to scanner group
  users.users.lia.extraGroups = [ "scanner" "lp" ];

  # GUI tools
  environment.systemPackages = with pkgs; [
    system-config-printer  # CUPS GUI
    simple-scan            # Scanner app
  ];
}

# USAGE:
#
# Add a printer:
#   1. Open system-config-printer or go to http://localhost:631
#   2. Add Printer -> Select your printer
#   3. Install required drivers if prompted
#
# Network printers should be auto-discovered via Avahi
#
# For HP printers with special features:
#   hp-setup -i
