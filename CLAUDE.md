# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Apply configuration changes (replace HOSTNAME with: adrasteia, laptop, virtualbox, minipc)
sudo nixos-rebuild switch --flake ~/nixos#HOSTNAME

# Test build without applying (dry-run)
nixos-rebuild dry-build --flake ~/nixos#HOSTNAME

# Update flake inputs
nix flake update ~/nixos

# Garbage collection
sudo nix-collect-garbage -d

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Initial install with disko (replace device and host)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko ./hosts/adrasteia/disk-config.nix --arg device '"/dev/nvme0n1"'
```

Shell aliases defined in `home/lia/shell.nix`: `rebuild`, `update`, `garbage`, `generations`, `nixconf`

## Architecture

This is a multi-host NixOS flake configuration with home-manager integration.

### Hosts

| Host | Description |
|------|-------------|
| `adrasteia` | Desktop workstation (AMD Ryzen 9 9950X3D + RX 9070 XT) |
| `laptop` | Laptop configuration |
| `virtualbox` | VirtualBox VM for testing |
| `minipc` | Mini PC / home server (headless) |

### Import Flow

```
flake.nix (mkHost helper)
├── modules/common/default.nix     # Shared config (nix settings, core packages)
├── hosts/<hostname>/
│   ├── default.nix                # Host-specific modules
│   ├── hardware-configuration.nix # Kernel modules (nixos-generate-config)
│   └── disk-config.nix            # Optional: disko partitioning
└── home-manager
    └── home/lia/default.nix       # User config (shared across hosts)
```

### Module Organization

- **Common** (`modules/common/`): Shared across all hosts
  - Nix settings, garbage collection, core packages

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

- **mkHost helper**: DRY host definitions in flake.nix
- **Inputs passed via specialArgs**: Access flake inputs in modules with `{ inputs, ... }:`
- **Hostname available in home-manager**: Use `{ hostname, ... }:` for host-conditional logic (see `home/lia/wallpaper.nix` for example)
- **External Neovim config**: Pulled from `github:bew4lsh/nvim` (non-flake input)
- **Btrfs subvolumes**: `@`, `@home`, `@nix`, `@log`, `@snapshots` with zstd compression
- **Rosé Pine theming**: Colors defined separately in each relevant file (no shared theme module)

### Optional Modules (commented out)

- `sops.nix`: Encrypted secrets management
- `lanzaboote.nix`: Secure Boot support
- `impermanence.nix`: Ephemeral root filesystem

## Adding a New Host

1. Create `hosts/<hostname>/default.nix` with host-specific imports
2. Generate hardware config on target: `nixos-generate-config --show-hardware-config`
3. Add entry to `nixosConfigurations` in `flake.nix`
4. Build with: `sudo nixos-rebuild switch --flake ~/nixos#<hostname>`

## Post-Install Setup

After fresh install, wallpapers require manual setup:
```bash
git clone https://github.com/p4rfait/rose-pine-wallpapers ~/Pictures/rose-pine-wallpapers
```
