{ config, pkgs, inputs, ... }:

# sops-nix for managing secrets declaratively
# Secrets are encrypted in the repo and decrypted at activation time

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Default sops file for this host
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Use age for encryption (simpler than GPG)
    age = {
      # This will be generated on first boot
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;

      # SSH host key can also be used
      # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # Secrets defined here will be decrypted to /run/secrets/<name>
    secrets = {
      # API Keys - accessible by user lia
      "anthropic-api-key" = {
        owner = "lia";
        mode = "0400";
      };
      "openai-api-key" = {
        owner = "lia";
        mode = "0400";
      };
      "tavily-api-key" = {
        owner = "lia";
        mode = "0400";
      };

      # Other secrets (uncomment as needed)
      # "tailscale-auth-key" = {
      #   owner = "root";
      # };
      # "user-password" = {
      #   neededForUsers = true;
      # };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}

# SETUP INSTRUCTIONS:
#
# 1. Generate an age key:
#    mkdir -p ~/.config/sops/age
#    age-keygen -o ~/.config/sops/age/keys.txt
#
# 2. Create .sops.yaml in repo root:
#    keys:
#      - &admin age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#    creation_rules:
#      - path_regex: secrets/.*\.yaml$
#        key_groups:
#          - age:
#              - *admin
#
# 3. Create secrets/secrets.yaml:
#    sops secrets/secrets.yaml
#    (This opens your editor, add key: value pairs)
#
# 4. To edit secrets later:
#    sops secrets/secrets.yaml
#
# 5. Access in config:
#    config.sops.secrets."secret-name".path
