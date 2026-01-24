{ config, pkgs, ... }:

{
  # Plymouth boot splash
  boot.plymouth = {
    enable = true;

    # Theme - using adi1090x themes or default
    # For custom Rosé Pine theme, see below
    theme = "bgrt";  # BGRT shows manufacturer logo

    # Or use a spinner theme
    # theme = "spinner";

    # Theme packages
    # themePackages = with pkgs; [
    #   # adi1090x-plymouth-themes
    # ];
  };

  # Silent boot for cleaner plymouth experience
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  # Disable startup messages
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Theme package for custom themes
  environment.systemPackages = with pkgs; [
    plymouth
  ];
}

# CUSTOM ROSÉ PINE PLYMOUTH THEME:
#
# To create a custom Rosé Pine theme, you'll need to:
#
# 1. Create a plymouth theme directory in your config
# 2. Add these files:
#    - your-theme.plymouth
#    - your-theme.script
#    - background image
#    - spinner animation
#
# Example overlay for custom theme:
#
# nixpkgs.overlays = [(final: prev: {
#   rose-pine-plymouth = prev.stdenv.mkDerivation {
#     name = "rose-pine-plymouth";
#     src = ./themes/plymouth/rose-pine;
#     installPhase = ''
#       mkdir -p $out/share/plymouth/themes/rose-pine
#       cp -r * $out/share/plymouth/themes/rose-pine/
#     '';
#   };
# })];
#
# Then add to themePackages and set theme = "rose-pine";
