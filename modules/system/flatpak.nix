{ config, pkgs, ... }:

{
  # Flatpak for apps not in nixpkgs
  services.flatpak.enable = true;

  # XDG portal for Flatpak (already enabled in niri.nix, but ensure it's here too)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Allow Flatpak apps to access fonts and themes
  fonts.fontDir.enable = true;

  # Flathub will be added post-install (can't do declaratively)
  # Run after first boot:
  #   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  environment.systemPackages = with pkgs; [
    flatpak
    gnome-software  # Flatpak GUI store (optional)
  ];

  # Ensure Flatpak apps can access system themes
  # This creates a bind mount so Flatpak apps see GTK themes
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems."/usr/share/themes" = {
    device = "/run/current-system/sw/share/themes";
    fsType = "fuse.bindfs";
    options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  };
  fileSystems."/usr/share/icons" = {
    device = "/run/current-system/sw/share/icons";
    fsType = "fuse.bindfs";
    options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  };
}

# SETUP:
#
# After first boot:
#   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#
# Install apps:
#   flatpak install flathub com.example.App
#
# List installed:
#   flatpak list
#
# Update all:
#   flatpak update
#
# COMMON FLATPAK APPS:
#   - com.discordapp.Discord
#   - com.spotify.Client
#   - md.obsidian.Obsidian
#   - org.mozilla.Thunderbird
#   - com.github.tchx84.Flatseal (manage permissions)
