# NixOS Configuration - adrasteia

A fully declarative NixOS configuration with niri, Rosé Pine theming, and a focus on gaming.

## System Overview

| Component | Choice |
|-----------|--------|
| CPU | AMD Ryzen 9 9950X3D |
| GPU | AMD RX 9070 XT (RDNA 4) |
| Compositor | niri (scrolling Wayland) |
| Display Manager | greetd + tuigreet |
| Theme | Rosé Pine |
| Shell | bash + starship |
| Terminal | wezterm |
| Editor | Neovim |
| Browser | Firefox |
| Gaming | Steam + Proton |

## Monitor Layout

```
        ┌─────────────────┐
        │   DP-2 (1080p)  │
        │      (top)      │
        └─────────────────┘
┌──────────────────────────┐  ┌────────┐
│        DP-1 (1440p)      │  │DP-3    │
│         (center)         │  │1440p   │
│                          │  │portrait│
└──────────────────────────┘  └────────┘
```

## Installation

### Prerequisites

1. Boot the NixOS minimal ISO
2. Connect to the internet
3. Identify your target disk: `lsblk`

### Install Steps

```bash
# 1. Clone this repo
nix-shell -p git
git clone https://github.com/YOUR_USERNAME/nixos.git /tmp/nixos
cd /tmp/nixos

# 2. Partition with disko (replace /dev/nvme0n1 with your disk)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko \
  ./hosts/adrasteia/disk-config.nix \
  --arg device '"/dev/nvme0n1"'

# 3. Generate hardware config
sudo nixos-generate-config --root /mnt --show-hardware-config > /tmp/hw.nix

# 4. Copy hardware config and edit it
# Look at /tmp/hw.nix and update hosts/adrasteia/hardware-configuration.nix
# Remove filesystem and boot.* sections (handled by disk-config.nix and boot.nix)

# 5. Install NixOS
sudo nixos-install --flake /tmp/nixos#adrasteia

# 6. Set password
sudo nixos-enter --root /mnt -c 'passwd lia'

# 7. Reboot
reboot
```

### Post-Install

After first boot:

```bash
# Clone your config to home directory
git clone https://github.com/YOUR_USERNAME/nixos.git ~/nixos

# Rebuild anytime you make changes
sudo nixos-rebuild switch --flake ~/nixos#adrasteia

# Update flake inputs
nix flake update ~/nixos

# Garbage collection
sudo nix-collect-garbage -d
```

## Keybindings

### General

| Key | Action |
|-----|--------|
| `Mod+Return` | Open terminal (wezterm) |
| `Mod+D` | Open launcher (fuzzel) |
| `Mod+Shift+Q` | Close window |
| `Mod+Shift+E` | Quit niri |
| `Print` | Screenshot region |
| `Mod+Print` | Screenshot screen |
| `Mod+V` | Clipboard history |
| `Mod+Shift+P` | Power menu |

### Navigation

| Key | Action |
|-----|--------|
| `Mod+H/J/K/L` | Focus left/down/up/right |
| `Mod+Shift+H/J/K/L` | Move window |
| `Mod+Ctrl+H/J/K/L` | Focus monitor |
| `Mod+Ctrl+Shift+H/J/K/L` | Move to monitor |
| `Mod+1-9` | Focus workspace |
| `Mod+Shift+1-9` | Move to workspace |
| `Mod+Tab` | Previous workspace |

### Window Management

| Key | Action |
|-----|--------|
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Fullscreen |
| `Mod+R` | Cycle preset widths |
| `Mod+-/=` | Adjust column width |
| `Mod+Shift+-/=` | Adjust window height |
| `Mod+C` | Center column |
| `Mod+,` | Consume window into column |
| `Mod+.` | Expel window from column |

### Media

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute toggle |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioPrev/Next` | Previous/next track |

## Directory Structure

```
nixos/
├── flake.nix                 # Flake configuration
├── hosts/
│   └── adrasteia/
│       ├── default.nix       # Host configuration
│       ├── hardware-configuration.nix
│       └── disk-config.nix   # Disko partitioning
├── modules/
│   ├── hardware/
│   │   ├── amd-cpu.nix
│   │   └── amd-gpu.nix
│   ├── desktop/
│   │   ├── greetd.nix
│   │   └── niri.nix
│   ├── programs/
│   │   └── gaming.nix
│   └── system/
│       ├── boot.nix
│       ├── networking.nix
│       ├── audio.nix
│       └── locale.nix
└── home/
    └── lia/
        ├── default.nix       # Home-manager entry point
        ├── niri.nix          # niri config
        ├── waybar.nix
        ├── fuzzel.nix
        ├── mako.nix
        ├── wezterm.nix
        ├── neovim.nix
        ├── firefox.nix
        ├── shell.nix         # bash, starship, zellij, yazi
        ├── gtk.nix           # GTK/Qt theming
        └── packages.nix      # User packages
```

## Customization

### Monitor Configuration

Edit `home/lia/niri.nix` and modify the `output` sections:

```kdl
output "DP-1" {
    mode "2560x1440@60.000"
    position x=1440 y=360
    scale 1.0
}
```

Find your monitor names with: `niri msg outputs`

### Adding Packages

- System packages: `hosts/adrasteia/default.nix`
- User packages: `home/lia/packages.nix`
- Gaming packages: `modules/programs/gaming.nix`

### Changing Theme Colors

Rosé Pine colors are defined in several files. For a consistent change, update:
- `home/lia/niri.nix`
- `home/lia/waybar.nix`
- `home/lia/fuzzel.nix`
- `home/lia/mako.nix`
- `home/lia/wezterm.nix`
- `home/lia/shell.nix` (starship, fzf, zellij)

## Notes

### Dual Boot with Windows

This config assumes Windows is on a separate disk. If Windows is on the same disk:
1. Do not use disko - partition manually
2. Mount the Windows ESP to `/boot`
3. Update `hosts/adrasteia/hardware-configuration.nix` manually

### RDNA 4 GPU

The AMD 9070 XT requires the latest kernel and Mesa. This config uses `linuxPackages_latest`. If you encounter issues:
- Check kernel version: `uname -r`
- Ensure Mesa is up to date: `glxinfo | grep "OpenGL version"`

### Neovim

The included Neovim config is minimal. Consider using a distribution like:
- [LazyVim](https://www.lazyvim.org/)
- [AstroNvim](https://astronvim.com/)
- [NvChad](https://nvchad.com/)

Or create your own config in `~/.config/nvim/`.
