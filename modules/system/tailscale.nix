{ config, pkgs, ... }:

{
  # Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";  # Enable subnet routing as client
    # useRoutingFeatures = "server";  # If this machine should be an exit node
  };

  # Open firewall for Tailscale
  networking.firewall = {
    # Allow Tailscale traffic
    trustedInterfaces = [ "tailscale0" ];
    # Allow incoming connections from Tailscale network
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Tailscale CLI and GUI
  environment.systemPackages = with pkgs; [
    tailscale
    trayscale  # System tray app for Tailscale
  ];

  # Enable IP forwarding if you want to use this as a subnet router
  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = 1;
  #   "net.ipv6.conf.all.forwarding" = 1;
  # };
}
