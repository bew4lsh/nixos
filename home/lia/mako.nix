{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      # General
      font = "Inter 11";
      width = 350;
      height = 150;
      margin = "12";
      padding = "12";
      border-size = 2;
      border-radius = 10;
      icons = true;
      icon-path = "/run/current-system/sw/share/icons/rose-pine-icons";
      max-icon-size = 48;
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      layer = "overlay";
      anchor = "top-right";

      # Rosé Pine colors
      background-color = "#1f1d2e";
      text-color = "#e0def4";
      border-color = "#c4a7e7";
      progress-color = "over #31748f";

      # Urgency
      "[urgency=low]" = {
        border-color = "#6e6a86";
        default-timeout = 3000;
      };

      "[urgency=normal]" = {
        border-color = "#c4a7e7";
      };

      "[urgency=high]" = {
        border-color = "#eb6f92";
        default-timeout = 10000;
      };
    };
  };
}
