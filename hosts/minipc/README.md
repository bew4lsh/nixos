# Mini PC / Home Server Setup

Headless home server configuration with Docker, Tailscale, and container management.

## Initial Installation

1. Boot NixOS installer USB
2. Connect to network (ethernet recommended)
3. Clone config and run disko:
   ```bash
   git clone https://github.com/bew4lsh/nixos /tmp/nixos && cd /tmp/nixos
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
     --mode disko ./hosts/minipc/disk-config.nix
   ```
4. Install NixOS:
   ```bash
   sudo nixos-install --flake .#minipc
   ```
5. Reboot and remove USB

## Post-Install Setup

### Tailscale
```bash
sudo tailscale up
```
Follow the auth URL to connect to your tailnet.

### Docker directories
Create required directories for Dockge:
```bash
sudo mkdir -p /opt/dockge /opt/stacks
```

### Access services
| Service | URL | Description |
|---------|-----|-------------|
| Dockge | http://minipc:5001 | Docker Compose management UI |

Access via Tailscale: `http://<tailscale-ip>:5001`

## Services

### Watchtower
Automatically updates Docker containers every Saturday at 4am.
- Cleans up old images after update
- Updates stopped containers too

### Dockge
Web UI for managing Docker Compose stacks.
- Stacks directory: `/opt/stacks`
- Data directory: `/opt/dockge`

To add a new stack, create a directory in `/opt/stacks/<stack-name>/` with a `compose.yaml` file, or use the Dockge web UI.

## Maintenance

```bash
# Rebuild after config changes
sudo nixos-rebuild switch --flake ~/nixos#minipc

# Check Tailscale status
tailscale status

# View Docker containers
docker ps -a
lazydocker  # TUI

# View Watchtower logs
docker logs watchtower
```

## Hardware

TODO: Update `hardware-configuration.nix` and enable appropriate CPU module:
- Intel: uncomment `../../modules/hardware/intel-cpu.nix`
- AMD: use `../../modules/hardware/amd-cpu.nix`
