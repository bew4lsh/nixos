# NixOS CI Fixes (2026-01-24)

Package renames and deprecations in nixpkgs:

- `virtualisation.libvirtd.qemu.ovmf` submodule removed
  - Deleted the ovmf block; OVMF is now available by default

- `vaapiVdpau` renamed
  - Changed to `libva-vdpau-driver`

- `amdvlk` deprecated by AMD
  - Removed; RADV is now the default Vulkan driver

- `vulkan-loader` unavailable in `pkgs.driversi686Linux`
  - Removed `extraPackages32`; handled automatically by `enable32Bit = true`

- `glxinfo` renamed
  - Changed to `mesa-demos`

- `python3Packages.poetry` missing
  - Changed to `poetry` (now a top-level package)

- `nerdfonts.override` syntax removed
  - Changed to `nerd-fonts.jetbrains-mono`

- `noto-fonts-emoji` renamed
  - Changed to `noto-fonts-color-emoji`

- `win-virtio` renamed
  - Changed to `virtio-win`
