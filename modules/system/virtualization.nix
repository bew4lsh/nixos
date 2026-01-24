{ config, pkgs, ... }:

{
  # Libvirt virtualization
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;

      # Enable TPM emulation (for Windows 11)
      swtpm.enable = true;
    };
  };

  # Enable default network
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # User permissions
  users.users.lia.extraGroups = [ "libvirtd" "kvm" ];

  # Virt-manager GUI
  programs.virt-manager.enable = true;

  # Looking Glass for GPU passthrough (HDMI capture alternative)
  # This allows you to view a GPU-passthrough VM without extra monitor
  environment.systemPackages = with pkgs; [
    # Virtualization tools
    virt-manager
    virt-viewer
    spice-gtk
    win-virtio  # VirtIO drivers ISO for Windows
    swtpm       # TPM emulator

    # Looking Glass client
    looking-glass-client

    # Other useful tools
    libguestfs  # VM image manipulation
    guestfs-tools
  ];

  # Looking Glass shared memory (for IVSHMEM)
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 lia kvm -"
  ];

  # IOMMU for GPU passthrough (enable if doing passthrough)
  # boot.kernelParams = [
  #   "amd_iommu=on"
  #   "iommu=pt"
  #   "video=efifb:off"  # Disable EFI framebuffer on passthrough GPU
  # ];

  # Kernel modules for passthrough
  # boot.kernelModules = [ "vfio-pci" ];

  # Bind GPU to vfio-pci (uncomment and set your GPU IDs)
  # boot.extraModprobeConfig = ''
  #   options vfio-pci ids=XXXX:XXXX,XXXX:XXXX
  # '';
}

# GPU PASSTHROUGH GUIDE:
#
# 1. Identify your GPU's IOMMU group:
#    for d in /sys/kernel/iommu_groups/*/devices/*; do
#      n=$(basename $(dirname $(dirname $d)));
#      echo "IOMMU Group $n: $(lspci -nns $(basename $d))";
#    done
#
# 2. Note the PCI IDs (e.g., 1002:744c,1002:ab30)
#
# 3. Add to boot.extraModprobeConfig:
#    options vfio-pci ids=1002:744c,1002:ab30
#
# 4. Enable iommu and vfio kernel params above
#
# 5. Rebuild and reboot
#
# 6. Create VM in virt-manager with:
#    - Add Hardware > PCI Host Device > Your GPU
#    - Add Looking Glass IVSHMEM device
#
# LOOKING GLASS SETUP:
#
# 1. Install Looking Glass Host in Windows VM
#    https://looking-glass.io/downloads
#
# 2. Run looking-glass-client from Linux:
#    looking-glass-client -F
#
# This lets you use the VM's GPU output without a second monitor
