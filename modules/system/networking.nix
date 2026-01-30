{ config, pkgs, ... }:

{
  # NetworkManager for easy network management
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    # Steam and gaming ports
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    # Steam uses these port ranges
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; }
    ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27100; }
      { from = 4380; to = 4380; }
    ];
  };

  # Enable resolved for DNS
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      FallbackDNS = [
        "1.1.1.1"
        "9.9.9.9"
      ];
    };
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
}
