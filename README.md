# NixOS Configuration - adrasteia

A fully declarative NixOS configuration with niri, Rosé Pine theming, and a focus on gaming and development.

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

---

# Initial Setup Guide

## Phase 1: Fresh Install

### Prerequisites

1. Boot the NixOS minimal ISO
2. Connect to the internet
3. Identify your target disk: `lsblk`

### Install NixOS

```bash
# 1. Clone this repo
nix-shell -p git
git clone https://github.com/bew4lsh/nixos.git /tmp/nixos
cd /tmp/nixos

# 2. Partition with disko (replace /dev/nvme0n1 with your disk)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko \
  ./hosts/adrasteia/disk-config.nix \
  --arg device '"/dev/nvme0n1"'

# 3. Generate hardware config
sudo nixos-generate-config --root /mnt --show-hardware-config > /tmp/hw.nix

# 4. Review /tmp/hw.nix and update hosts/adrasteia/hardware-configuration.nix
# Keep only: kernel modules, initrd modules, hardware-specific options
# Remove: filesystem mounts, boot.loader (handled by other modules)

# 5. Install NixOS
sudo nixos-install --flake /tmp/nixos#adrasteia

# 6. Set password
sudo nixos-enter --root /mnt -c 'passwd lia'

# 7. Reboot
reboot
```

---

## Phase 2: Post-Install Configuration

After first boot, log in and run these steps.

### 2.1 Clone Config to Home

```bash
git clone https://github.com/bew4lsh/nixos.git ~/nixos
cd ~/nixos
```

### 2.2 Generate SSH Keys

```bash
# Generate Ed25519 key
ssh-keygen -t ed25519 -C "bew4lsh@gmail.com"

# Start ssh-agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard and add to GitHub
cat ~/.ssh/id_ed25519.pub
# Go to: https://github.com/settings/keys
```

### 2.3 Generate GPG Keys

```bash
# Generate a new GPG key
gpg --full-generate-key
# Choose: (1) RSA and RSA, 4096 bits, no expiration

# List keys to get your key ID
gpg --list-secret-keys --keyid-format LONG

# Export public key for GitHub
gpg --armor --export YOUR_KEY_ID
# Go to: https://github.com/settings/keys

# Configure git to use GPG signing (already set in config, just need key)
git config --global user.signingkey YOUR_KEY_ID
```

### 2.4 Setup Wallpapers

```bash
# Clone Rosé Pine wallpapers
git clone https://github.com/p4rfait/rose-pine-wallpapers ~/Pictures/rose-pine-wallpapers

# Wallpapers will auto-rotate every 30 minutes via wpaperd
```

### 2.5 Authenticate GitHub CLI

```bash
gh auth login
# Choose: GitHub.com → SSH → Yes (use SSH key) → Login with browser
```

### 2.6 Authenticate Claude Code

```bash
claude
# Follow the prompts to authenticate with your Anthropic account
```

---

## Phase 3: Secrets Management (sops-nix)

For API keys and other secrets, use sops-nix.

### 3.1 Generate Age Key

```bash
# Create age key directory
mkdir -p ~/.config/sops/age

# Generate age key
age-keygen -o ~/.config/sops/age/keys.txt

# View your public key (age1...)
cat ~/.config/sops/age/keys.txt | grep "public key"
```

### 3.2 Configure sops

```bash
cd ~/nixos

# Edit .sops.yaml and replace the placeholder with your age public key
nvim .sops.yaml
```

Update the key line:
```yaml
keys:
  - &lia age1your_actual_public_key_here
```

### 3.3 Create Encrypted Secrets

```bash
# Create the secrets file (opens in editor)
sops secrets/secrets.yaml

# Add your secrets:
anthropic-api-key: sk-ant-api03-YOUR-KEY
openai-api-key: sk-YOUR-KEY
tavily-api-key: tvly-YOUR-KEY

# Save and exit - file is automatically encrypted
```

### 3.4 Enable sops Module

Edit `hosts/adrasteia/default.nix` and uncomment the sops line:

```nix
# Change this:
# ../../modules/system/sops.nix

# To this:
../../modules/system/sops.nix
```

### 3.5 Rebuild with Secrets

```bash
sudo nixos-rebuild switch --flake ~/nixos#adrasteia

# API keys are now available as environment variables in new shells
# They're loaded from /run/secrets/ automatically
```

---

## Phase 4: Optional Features

### Enable Secure Boot (lanzaboote)

After first boot:

```bash
# Generate Secure Boot keys
sudo sbctl create-keys

# Verify keys created
sudo sbctl verify

# Uncomment lanzaboote.nix in hosts/adrasteia/default.nix
# Rebuild and reboot
sudo nixos-rebuild switch --flake ~/nixos#adrasteia
reboot

# Enroll keys in firmware
sudo sbctl enroll-keys --microsoft
```

### Enable Impermanence (Ephemeral Root)

This wipes root on every boot, keeping only declared paths.

```bash
# Create persist subvolume (during install or from live USB)
sudo btrfs subvolume create /mnt/@persist

# Uncomment impermanence.nix in hosts/adrasteia/default.nix
# Review the persistence paths in the module
# Rebuild
```

---

## Daily Usage

### Aliases

| Alias | Command |
|-------|---------|
| `rebuild` | `sudo nixos-rebuild switch --flake ~/nixos#adrasteia` |
| `update` | `nix flake update ~/nixos` |
| `garbage` | `sudo nix-collect-garbage -d` |
| `generations` | List system generations |
| `nixconf` | Open config in nvim |

### Shell Functions

| Function | Description |
|----------|-------------|
| `mkcd <dir>` | Create directory and cd into it |
| `extract <file>` | Extract any archive format |
| `rgi <pattern>` | Interactive ripgrep with fzf |

### Keybindings

#### General

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (wezterm) |
| `Mod+D` | Launcher (fuzzel) |
| `Mod+Shift+Q` | Close window |
| `Mod+Shift+E` | Quit niri |
| `Print` | Screenshot region |
| `Mod+V` | Clipboard history |

#### Navigation

| Key | Action |
|-----|--------|
| `Mod+H/J/K/L` | Focus left/down/up/right |
| `Mod+Shift+H/J/K/L` | Move window |
| `Mod+1-9` | Focus workspace |
| `Mod+Shift+1-9` | Move to workspace |

#### Window Management

| Key | Action |
|-----|--------|
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Fullscreen |
| `Mod+R` | Cycle preset widths |
| `Mod+C` | Center column |

---

## Directory Structure

```
nixos/
├── flake.nix                 # Flake entry point
├── .sops.yaml                # Sops configuration
├── secrets/
│   └── secrets.yaml          # Encrypted secrets
├── hosts/
│   └── adrasteia/
│       ├── default.nix       # Host configuration
│       ├── hardware-configuration.nix
│       └── disk-config.nix   # Disko partitioning
├── modules/
│   ├── hardware/             # CPU, GPU drivers
│   ├── desktop/              # niri, greetd
│   ├── programs/             # gaming
│   └── system/               # boot, network, audio, sops
└── home/lia/                 # Home-manager modules
    ├── shell.nix             # bash, starship, functions
    ├── packages.nix          # user packages
    ├── development.nix       # dev tools
    └── ...
```

---

## Customization

### Adding Packages

- **System packages**: `hosts/adrasteia/default.nix`
- **User packages**: `home/lia/packages.nix`
- **Dev tools**: `home/lia/development.nix`
- **Gaming**: `modules/programs/gaming.nix`

### Monitor Configuration

Edit `home/lia/niri.nix`:

```kdl
output "DP-1" {
    mode "2560x1440@60.000"
    position x=1440 y=360
    scale 1.0
}
```

Find monitor names: `niri msg outputs`

### Theme Colors

Rosé Pine colors are in multiple files. Update these for consistency:
- `home/lia/niri.nix`
- `home/lia/waybar.nix`
- `home/lia/fuzzel.nix`
- `home/lia/mako.nix`
- `home/lia/wezterm.nix`
- `home/lia/shell.nix`
- `home/lia/glow.nix`

---

## Troubleshooting

### RDNA 4 GPU Issues

This config uses `linuxPackages_latest` for AMD 9070 XT support.

```bash
# Check kernel version
uname -r

# Check Mesa/OpenGL
glxinfo | grep "OpenGL version"

# Check Vulkan
vulkaninfo | grep "GPU"
```

### Secrets Not Loading

```bash
# Check if secrets are decrypted
ls -la /run/secrets/

# Check sops key
cat ~/.config/sops/age/keys.txt

# Re-encrypt secrets if needed
sops updatekeys secrets/secrets.yaml
```

### Dual Boot with Windows

If Windows is on the same disk:
1. Do not use disko - partition manually
2. Mount Windows ESP to `/boot`
3. Update `hardware-configuration.nix` manually

---

## Credits

- [NixOS](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [niri](https://github.com/YaLTeR/niri)
- [Rosé Pine](https://rosepinetheme.com/)
- [Rosé Pine Wallpapers](https://github.com/p4rfait/rose-pine-wallpapers)
