# Apple T2 chip support (MacBook Pro 2018-2020)
# Provides: keyboard, trackpad, Touch Bar, audio, SSD, etc.
{ config, pkgs, lib, ... }:

{
  # T2 Linux kernel with Apple hardware patches
  # This provides drivers for keyboard, trackpad, Touch Bar, audio
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Apple BCE (keyboard/trackpad) and audio modules
  boot.kernelModules = [
    "apple-bce"    # Keyboard, trackpad, Touch Bar
  ];

  # Firmware for T2 (WiFi, audio)
  hardware.firmware = [
    pkgs.linux-firmware
  ];

  # NOTE: Broadcom WiFi on T2 Macs is problematic
  # Options:
  # 1. Use USB WiFi adapter (recommended)
  # 2. Extract firmware from macOS (complex, see t2linux wiki)
  # 3. Use ethernet/thunderbolt adapter

  # For USB WiFi adapters (common chipsets)
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   rtl8821cu  # Realtek adapters
  # ];

  # Keyboard/trackpad settings
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";  # Two-finger = right click
      accelProfile = "adaptive";
    };
  };

  # Fan control (optional, Macs run hot)
  # services.mbpfan.enable = true;

  # Suspend/resume fixes
  boot.kernelParams = [
    # Fix suspend issues on T2 Macs
    "intel_iommu=on"
    "iommu=pt"
  ];

  # SSD is NVMe behind T2 - should work out of box
  # Enable TRIM
  services.fstrim.enable = true;
}
