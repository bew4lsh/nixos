# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake ~/nixos#adrasteia

# Update flake inputs
nix flake update ~/nixos

# Garbage collection
sudo nix-collect-garbage -d

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Initial install with disko (replace device)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko ./hosts/adrasteia/disk-config.nix --arg device '"/dev/nvme0n1"'
```

Shell aliases defined in `home/lia/shell.nix`: `rebuild`, `update`, `garbage`, `generations`, `nixconf`

## Architecture

This is a NixOS flake configuration for a single host `adrasteia` with home-manager integration.

### Import Flow

```
flake.nix
├── hosts/adrasteia/default.nix    # Host entry point
│   ├── hardware-configuration.nix  # Kernel modules (auto-generated)
│   ├── disk-config.nix             # Disko btrfs partitioning
│   └── modules/*                   # All system modules
└── home-manager
    └── home/lia/default.nix        # User config entry point
        └── home/lia/*.nix          # All user modules
```

### Module Organization

- **System modules** (`modules/`): Use NixOS options (`services.*`, `boot.*`, `programs.*`)
  - `hardware/`: AMD CPU/GPU drivers, microcode, power management
  - `desktop/`: niri compositor, greetd display manager
  - `system/`: boot, networking, audio (PipeWire), locale, snapshots (btrbk)
  - `programs/`: gaming (Steam, Proton, GameMode)

- **User modules** (`home/lia/`): Use home-manager options (`programs.*`, `home.*`)
  - Desktop: niri.nix (KDL config), waybar.nix, fuzzel.nix, mako.nix
  - Terminal: wezterm.nix (Lua config), shell.nix (bash, starship, zellij, yazi)
  - Apps: firefox.nix, neovim.nix, packages.nix

### Key Patterns

- **Inputs passed via specialArgs**: Access flake inputs in modules with `{ inputs, ... }:`
- **External Neovim config**: Pulled from `github:bew4lsh/nvim` (non-flake input)
- **Btrfs subvolumes**: `@`, `@home`, `@nix`, `@log`, `@snapshots` with zstd compression
- **Rosé Pine theming**: Colors defined separately in each relevant file (niri, waybar, fuzzel, mako, wezterm, shell)

### Optional Modules (commented out)

- `sops.nix`: Encrypted secrets management
- `lanzaboote.nix`: Secure Boot support
- `impermanence.nix`: Ephemeral root filesystem

## Hardware

- AMD Ryzen 9 9950X3D + RX 9070 XT (RDNA 4)
- Uses `linuxPackages_latest` for RDNA 4 support
- Triple monitor setup configured in `home/lia/niri.nix`
