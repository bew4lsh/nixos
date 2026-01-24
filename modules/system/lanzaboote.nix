{ config, pkgs, inputs, lib, ... }:

# Lanzaboote for Secure Boot support
# This replaces systemd-boot with a signed bootloader

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Lanzaboote configuration
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # Disable systemd-boot when using lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Tools for managing Secure Boot
  environment.systemPackages = with pkgs; [
    sbctl  # Secure Boot key management
  ];
}

# SETUP INSTRUCTIONS:
#
# Secure Boot setup must be done AFTER first boot with Secure Boot disabled.
#
# 1. First, install NixOS normally with Secure Boot OFF in BIOS
#
# 2. After boot, create Secure Boot keys:
#    sudo sbctl create-keys
#
# 3. Rebuild with lanzaboote enabled:
#    sudo nixos-rebuild switch --flake .#adrasteia
#
# 4. Verify all files are signed:
#    sudo sbctl verify
#
# 5. Reboot into BIOS and:
#    - Enable Secure Boot
#    - Set to "Setup Mode" (clears Microsoft keys)
#
# 6. Boot NixOS and enroll keys:
#    sudo sbctl enroll-keys --microsoft
#    (--microsoft includes MS keys for dual boot with Windows)
#
# 7. Reboot - Secure Boot should now work!
#
# IMPORTANT: Keep lanzaboote.nix DISABLED until you've completed first boot.
# To enable, add this to hosts/adrasteia/default.nix imports after setup.
